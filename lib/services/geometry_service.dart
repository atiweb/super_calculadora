import 'dart:math' as math;
import '../utils/app_locale.dart';
import '../models/calc_exception.dart';
import '../models/fraction.dart';
import '../models/surd.dart';
import '../models/point.dart';

/// Clasificación de un triángulo por la igualdad de sus lados.
enum TriangleSides { equilateral, isosceles, scalene }

/// Clasificación de un triángulo por su mayor ángulo.
enum TriangleAngles { right, acute, obtuse }

/// Clasificación de un triángulo por lados y por ángulos.
///
/// Se usan enumeraciones (no texto) para que la capa de UI elija el idioma.
class TriangleType {
  final TriangleSides bySides;
  final TriangleAngles byAngles;

  const TriangleType(this.bySides, this.byAngles);

  @override
  String toString() => '${bySides.name}, ${byAngles.name}';

  @override
  bool operator ==(Object other) =>
      other is TriangleType &&
      bySides == other.bySides &&
      byAngles == other.byAngles;

  @override
  int get hashCode => Object.hash(bySides, byAngles);
}

/// Un triángulo heroniano: lados enteros y área entera.
class HeronianTriangle {
  final BigInt a;
  final BigInt b;
  final BigInt c;
  final BigInt area;

  const HeronianTriangle(this.a, this.b, this.c, this.area);

  @override
  String toString() => '($a, $b, $c) área=$area';
}

/// Herramientas de geometría para entrenamiento de olimpiada.
///
/// Donde es posible los resultados son exactos: el área de Herón se devuelve
/// como [Surd], los cosenos de los ángulos como [Fraction], y las áreas por
/// coordenadas (shoelace) como [Fraction].
class GeometryService {
  // ── Validez y clasificación ────────────────────────────────────────────

  /// Verdadero si tres longitudes positivas forman un triángulo
  /// (desigualdad triangular estricta).
  static bool isValidTriangle(BigInt a, BigInt b, BigInt c) {
    if (a <= BigInt.zero || b <= BigInt.zero || c <= BigInt.zero) return false;
    return a + b > c && a + c > b && b + c > a;
  }

  /// Clasifica el triángulo por lados y por ángulos.
  static TriangleType triangleType(BigInt a, BigInt b, BigInt c) {
    if (!isValidTriangle(a, b, c)) {
      throw CalcException(CalcError.invalidTriangle);
    }

    // Por lados
    final TriangleSides bySides;
    if (a == b && b == c) {
      bySides = TriangleSides.equilateral;
    } else if (a == b || b == c || a == c) {
      bySides = TriangleSides.isosceles;
    } else {
      bySides = TriangleSides.scalene;
    }

    // Por ángulos: comparar el cuadrado del lado mayor con la suma de los otros
    final sides = [a, b, c]..sort();
    final BigInt x = sides[0], y = sides[1], z = sides[2]; // z es el mayor
    final BigInt diff = x * x + y * y - z * z;
    final TriangleAngles byAngles;
    if (diff == BigInt.zero) {
      byAngles = TriangleAngles.right;
    } else if (diff > BigInt.zero) {
      byAngles = TriangleAngles.acute;
    } else {
      byAngles = TriangleAngles.obtuse;
    }

    return TriangleType(bySides, byAngles);
  }

  // ── Área ──────────────────────────────────────────────────────────────

  /// Producto de Herón: 16·Área² = (a+b+c)(−a+b+c)(a−b+c)(a+b−c).
  static BigInt _heronProduct(BigInt a, BigInt b, BigInt c) =>
      (a + b + c) * (-a + b + c) * (a - b + c) * (a + b - c);

  /// Área exacta por la fórmula de Herón, como radical: Área = √P / 4.
  static Surd heronArea(BigInt a, BigInt b, BigInt c) {
    if (!isValidTriangle(a, b, c)) {
      throw CalcException(CalcError.invalidTriangle);
    }
    final BigInt p = _heronProduct(a, b, c);
    // √P / 4 = (1/4)·√P
    return Surd(Fraction(BigInt.one, BigInt.from(4)), p);
  }

  /// Área aproximada (double) para lados reales arbitrarios.
  /// Devuelve [double.nan] si los lados no forman un triángulo válido.
  static double heronAreaApprox(double a, double b, double c) {
    if (a <= 0 || b <= 0 || c <= 0) return double.nan;
    if (a + b <= c || a + c <= b || b + c <= a) return double.nan;
    final double s = (a + b + c) / 2;
    final double product = s * (s - a) * (s - b) * (s - c);
    if (product < 0) return double.nan;
    return math.sqrt(product);
  }

  /// Verdadero si el triángulo es heroniano (lados enteros, área entera).
  static bool isHeronian(BigInt a, BigInt b, BigInt c) {
    if (!isValidTriangle(a, b, c)) return false;
    final BigInt p = _heronProduct(a, b, c);
    final BigInt root = _integerSqrt(p);
    if (root * root != p) return false; // √P no entero ⇒ área irracional
    // Área = √P / 4 ⇒ entera sólo si 4 | √P
    return root % BigInt.from(4) == BigInt.zero;
  }

  // ── Radios ──────────────────────────────────────────────────────────────

  /// Radio circunscrito exacto: R = abc / (4·Área) = abc / √P  → (abc/P)·√P.
  static Surd circumradius(BigInt a, BigInt b, BigInt c) {
    if (!isValidTriangle(a, b, c)) {
      throw CalcException(CalcError.invalidTriangle);
    }
    final BigInt p = _heronProduct(a, b, c);
    return Surd(Fraction(a * b * c, p), p);
  }

  /// Radio inscrito exacto: r = Área / s = √P / (2(a+b+c)).
  static Surd inradius(BigInt a, BigInt b, BigInt c) {
    if (!isValidTriangle(a, b, c)) {
      throw CalcException(CalcError.invalidTriangle);
    }
    final BigInt p = _heronProduct(a, b, c);
    return Surd(Fraction(BigInt.one, BigInt.two * (a + b + c)), p);
  }

  // ── Trigonometría ────────────────────────────────────────────────────────

  /// Coseno (exacto) del ángulo opuesto al lado [opposite], entre los lados
  /// [side1] y [side2]:  cos = (s1² + s2² − op²) / (2·s1·s2).
  static Fraction cosineOfAngle(BigInt opposite, BigInt side1, BigInt side2) {
    final BigInt num = side1 * side1 + side2 * side2 - opposite * opposite;
    final BigInt den = BigInt.two * side1 * side2;
    return Fraction(num, den);
  }

  /// Ángulo (en grados, aproximado) opuesto al lado [opposite].
  static double angleDegrees(BigInt opposite, BigInt side1, BigInt side2) {
    final double cos = cosineOfAngle(opposite, side1, side2).toDouble();
    return math.acos(cos.clamp(-1.0, 1.0)) * 180 / math.pi;
  }

  /// Ley de senos: dado un lado y su ángulo opuesto, halla el lado opuesto a
  /// otro ángulo conocido.  ladoBuscado = ladoConocido · sin(áng) / sin(ángConocido).
  static double sideFromLawOfSines(
      double knownSide, double knownAngleDeg, double wantedAngleDeg) {
    final double k = knownSide / math.sin(knownAngleDeg * math.pi / 180);
    return k * math.sin(wantedAngleDeg * math.pi / 180);
  }

  // ── Geometría analítica ──────────────────────────────────────────────────

  /// Área de un polígono simple por la fórmula del cordón (shoelace), exacta.
  /// Los vértices deben ir en orden (horario o antihorario).
  static Fraction shoelaceArea(List<Point> vertices) {
    if (vertices.length < 3) {
      throw CalcException(CalcError.needAtLeast3Vertices);
    }
    Fraction sum = Fraction.zero;
    for (int i = 0; i < vertices.length; i++) {
      final Point p = vertices[i];
      final Point q = vertices[(i + 1) % vertices.length];
      sum = sum + (p.x * q.y - q.x * p.y);
    }
    return (sum * Fraction(BigInt.one, BigInt.two)).abs();
  }

  /// Teorema de Pick para un polígono simple con vértices enteros:
  /// A = I + B/2 − 1, donde B son los puntos reticulares de la frontera
  /// (Σ mcd(|Δx|, |Δy|) por arista) e I los interiores.
  /// Devuelve (área exacta, B, I).
  static ({Fraction area, BigInt boundary, BigInt interior}) pickAnalysis(
      List<Point> vertices) {
    if (vertices.length < 3) {
      throw CalcException(CalcError.needAtLeast3Vertices);
    }
    for (final v in vertices) {
      if (!v.x.isInteger || !v.y.isInteger) {
        throw CalcException(CalcError.integerCoordinatesRequired);
      }
    }
    final Fraction area = shoelaceArea(vertices);

    BigInt boundary = BigInt.zero;
    for (int i = 0; i < vertices.length; i++) {
      final Point p = vertices[i];
      final Point q = vertices[(i + 1) % vertices.length];
      final BigInt dx = (q.x.numerator - p.x.numerator).abs();
      final BigInt dy = (q.y.numerator - p.y.numerator).abs();
      boundary += dx.gcd(dy);
    }

    // I = A − B/2 + 1
    final Fraction interiorF = area -
        Fraction(boundary, BigInt.two) +
        Fraction.one;
    return (area: area, boundary: boundary, interior: interiorF.truncate());
  }

  /// Centros del triángulo dado por coordenadas racionales.
  ///
  /// Baricentro G, circuncentro O y ortocentro H son exactos ([Point] con
  /// fracciones); el incentro involucra √ y se devuelve aproximado.
  /// G, O y H son colineales (recta de Euler) con H = 3G − 2O.
  static ({
    Point centroid,
    Point circumcenter,
    Point orthocenter,
    double incenterX,
    double incenterY,
  }) triangleCenters(Point a, Point b, Point c) {
    final Fraction three = Fraction.fromInt(3);

    // Doble del área con signo (shoelace); 0 ⇒ colineales.
    final Fraction cross = (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y);
    if (cross.isZero) {
      throw CalcException(CalcError.collinearPoints);
    }

    final Point centroid = Point(
      (a.x + b.x + c.x) / three,
      (a.y + b.y + c.y) / three,
    );

    // Circuncentro: sistema lineal de las mediatrices (Cramer 2×2 exacto).
    //   2(bx−ax)·Ox + 2(by−ay)·Oy = |b|² − |a|²
    //   2(cx−ax)·Ox + 2(cy−ay)·Oy = |c|² − |a|²
    final Fraction a11 = (b.x - a.x) * Fraction.fromInt(2);
    final Fraction a12 = (b.y - a.y) * Fraction.fromInt(2);
    final Fraction a21 = (c.x - a.x) * Fraction.fromInt(2);
    final Fraction a22 = (c.y - a.y) * Fraction.fromInt(2);
    final Fraction r1 =
        b.x * b.x + b.y * b.y - a.x * a.x - a.y * a.y;
    final Fraction r2 =
        c.x * c.x + c.y * c.y - a.x * a.x - a.y * a.y;
    final Fraction det = a11 * a22 - a12 * a21; // = 4·cross ≠ 0
    final Point circumcenter = Point(
      (r1 * a22 - r2 * a12) / det,
      (a11 * r2 - a21 * r1) / det,
    );

    // Ortocentro por la identidad de Euler: H = A + B + C − 2O.
    final Fraction two = Fraction.fromInt(2);
    final Point orthocenter = Point(
      a.x + b.x + c.x - two * circumcenter.x,
      a.y + b.y + c.y - two * circumcenter.y,
    );

    // Incentro = (a·A + b·B + c·C)/(a+b+c) con a=|BC|, b=|CA|, c=|AB|.
    final double la = b.distanceTo(c);
    final double lb = a.distanceTo(c);
    final double lc = a.distanceTo(b);
    final double per = la + lb + lc;
    final double ix =
        (la * a.x.toDouble() + lb * b.x.toDouble() + lc * c.x.toDouble()) / per;
    final double iy =
        (la * a.y.toDouble() + lb * b.y.toDouble() + lc * c.y.toDouble()) / per;

    return (
      centroid: centroid,
      circumcenter: circumcenter,
      orthocenter: orthocenter,
      incenterX: ix,
      incenterY: iy,
    );
  }

  // ── Ternas pitagóricas ───────────────────────────────────────────────────

  /// Ternas pitagóricas primitivas con hipotenusa ≤ [maxHypotenuse].
  /// Usa la fórmula de Euclides: a=m²−n², b=2mn, c=m²+n²
  /// con m>n>0, mcd(m,n)=1 y m,n de distinta paridad.
  static List<List<BigInt>> primitivePythagoreanTriples(int maxHypotenuse) {
    final List<List<BigInt>> triples = [];
    for (int m = 2; m * m <= maxHypotenuse; m++) {
      for (int n = 1; n < m; n++) {
        if ((m - n).isOdd && _gcdInt(m, n) == 1) {
          final int c = m * m + n * n;
          if (c > maxHypotenuse) continue;
          final int a = m * m - n * n;
          final int b = 2 * m * n;
          final int lo = math.min(a, b);
          final int hi = math.max(a, b);
          triples.add([BigInt.from(lo), BigInt.from(hi), BigInt.from(c)]);
        }
      }
    }
    triples.sort((t1, t2) => t1[2].compareTo(t2[2]));
    return triples;
  }

  /// Todas las ternas pitagóricas (primitivas y sus múltiplos) con
  /// hipotenusa ≤ [maxHypotenuse].
  static List<List<BigInt>> allPythagoreanTriples(int maxHypotenuse) {
    final List<List<BigInt>> result = [];
    for (final prim in primitivePythagoreanTriples(maxHypotenuse)) {
      int k = 1;
      while (true) {
        final BigInt c = prim[2] * BigInt.from(k);
        if (c > BigInt.from(maxHypotenuse)) break;
        result.add([prim[0] * BigInt.from(k), prim[1] * BigInt.from(k), c]);
        k++;
      }
    }
    result.sort((t1, t2) {
      final cmp = t1[2].compareTo(t2[2]);
      return cmp != 0 ? cmp : t1[0].compareTo(t2[0]);
    });
    return result;
  }

  /// Triángulos heronianos con todos los lados ≤ [maxSide] (a ≤ b ≤ c).
  static List<HeronianTriangle> heronianTriangles(int maxSide) {
    final List<HeronianTriangle> result = [];
    for (int a = 1; a <= maxSide; a++) {
      for (int b = a; b <= maxSide; b++) {
        for (int c = b; c <= maxSide; c++) {
          final ba = BigInt.from(a), bb = BigInt.from(b), bc = BigInt.from(c);
          if (!isValidTriangle(ba, bb, bc)) continue;
          if (!isHeronian(ba, bb, bc)) continue;
          final BigInt p = _heronProduct(ba, bb, bc);
          final BigInt area = _integerSqrt(p) ~/ BigInt.from(4);
          result.add(HeronianTriangle(ba, bb, bc, area));
        }
      }
    }
    return result;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static int _gcdInt(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  /// Raíz cuadrada entera (piso) de un BigInt no negativo.
  static BigInt _integerSqrt(BigInt n) {
    if (n < BigInt.zero) throw ArgumentError(trLocale('Raíz de número negativo', 'Root of a negative number'));
    if (n < BigInt.two) return n;
    BigInt x = n;
    BigInt y = (x + BigInt.one) >> 1;
    while (y < x) {
      x = y;
      y = (x + n ~/ x) >> 1;
    }
    return x;
  }
}
