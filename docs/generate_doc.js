const fs = require("fs");
const path = require("path");
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  Header, Footer, AlignmentType, LevelFormat,
  HeadingLevel, BorderStyle, WidthType, ShadingType,
  PageNumber, PageBreak
} = require("docx");

// ── Constants ──────────────────────────────────────────────────────────
const BLUE = "2E5090";
const LIGHT_BLUE = "D6E4F0";
const MED_BLUE = "B4C7E0";
const WHITE = "FFFFFF";
const FONT = "Arial";
const PAGE_W = 12240; // US Letter width DXA
const PAGE_H = 15840;
const MARGIN = 1440;  // 1 inch
const CONTENT_W = PAGE_W - 2 * MARGIN; // 9360

const border = { style: BorderStyle.SINGLE, size: 1, color: "AAAAAA" };
const borders = { top: border, bottom: border, left: border, right: border };
const cellMargins = { top: 60, bottom: 60, left: 100, right: 100 };

// ── Helpers ────────────────────────────────────────────────────────────
function h1(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_1,
    spacing: { before: 360, after: 200 },
    children: [new TextRun({ text, bold: true, size: 32, font: FONT, color: BLUE })],
  });
}
function h2(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_2,
    spacing: { before: 280, after: 160 },
    children: [new TextRun({ text, bold: true, size: 26, font: FONT, color: BLUE })],
  });
}
function h3(text) {
  return new Paragraph({
    heading: HeadingLevel.HEADING_3,
    spacing: { before: 200, after: 120 },
    children: [new TextRun({ text, bold: true, size: 22, font: FONT, color: "3A6AAF" })],
  });
}
function p(text, opts = {}) {
  const runs = Array.isArray(text) ? text : [new TextRun({ text, font: FONT, size: 21, ...opts })];
  return new Paragraph({ spacing: { after: 100 }, children: runs });
}
function pRuns(runs) {
  return new Paragraph({ spacing: { after: 100 }, children: runs });
}
function bold(text) { return new TextRun({ text, bold: true, font: FONT, size: 21 }); }
function normal(text) { return new TextRun({ text, font: FONT, size: 21 }); }
function italic(text) { return new TextRun({ text, italics: true, font: FONT, size: 21 }); }
function blankLine() { return new Paragraph({ spacing: { after: 60 }, children: [] }); }

function bullet(text, ref = "bullets", level = 0) {
  const runs = Array.isArray(text) ? text : [new TextRun({ text, font: FONT, size: 21 })];
  return new Paragraph({
    numbering: { reference: ref, level },
    spacing: { after: 60 },
    children: runs,
  });
}

function headerCell(text, width) {
  return new TableCell({
    borders,
    width: { size: width, type: WidthType.DXA },
    shading: { fill: BLUE, type: ShadingType.CLEAR },
    margins: cellMargins,
    children: [new Paragraph({
      children: [new TextRun({ text, bold: true, font: FONT, size: 20, color: WHITE })]
    })],
  });
}
function cell(text, width, opts = {}) {
  const runs = Array.isArray(text)
    ? text
    : [new TextRun({ text, font: FONT, size: 20, ...opts })];
  return new TableCell({
    borders,
    width: { size: width, type: WidthType.DXA },
    shading: opts.shade ? { fill: LIGHT_BLUE, type: ShadingType.CLEAR } : undefined,
    margins: cellMargins,
    children: [new Paragraph({ children: runs })],
    verticalAlign: opts.vAlign,
  });
}
function makeTable(colWidths, headerTexts, rows) {
  const totalW = colWidths.reduce((a, b) => a + b, 0);
  return new Table({
    width: { size: totalW, type: WidthType.DXA },
    columnWidths: colWidths,
    rows: [
      new TableRow({ children: headerTexts.map((t, i) => headerCell(t, colWidths[i])) }),
      ...rows.map((row, ri) =>
        new TableRow({
          children: row.map((t, ci) => cell(t, colWidths[ci], { shade: ri % 2 === 1 }))
        })
      ),
    ],
  });
}

// ── Cover Page ─────────────────────────────────────────────────────────
function coverPage() {
  return [
    ...Array(6).fill(null).map(() => blankLine()),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { after: 200 },
      children: [new TextRun({ text: "Super Calculadora", font: FONT, size: 60, bold: true, color: BLUE })],
    }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { after: 100 },
      children: [new TextRun({ text: "Matem\u00e1tica", font: FONT, size: 52, bold: true, color: BLUE })],
    }),
    blankLine(),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { after: 200 },
      children: [new TextRun({ text: "Guía Completa de Funciónes y Uso", font: FONT, size: 30, color: "555555" })],
    }),
    blankLine(),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { after: 80 },
      children: [new TextRun({ text: "Diseñada para estudiantes de Olimpiadas Matemáticas (IMO)", font: FONT, size: 22, italics: true, color: "666666" })],
    }),
    ...Array(6).fill(null).map(() => blankLine()),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      children: [new TextRun({ text: "Abril 2026", font: FONT, size: 24, color: "888888" })],
    }),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── Section 1: Introducción ────────────────────────────────────────────
function secIntroducción() {
  return [
    h1("1. Introducción"),
    p("Super Calculadora es una aplicación Flutter multi-plataforma diseñada específicamente para la preparación de olimpiadas matemáticas internacionales (IMO). Combina las funciónes de una calculadora cientifica con herramientas especializadas de teoría de números, aritmética modular, combinatoria y estadística."),
    blankLine(),
    h2("Características Principales"),
    bullet([bold("Aritmética de precisión arbitraria: "), normal("útiliza BigInt y BigDecimal para manejar números de cualquier tamaño sin pérdida de precisión.")]),
    bullet([bold("Test de primalidad Miller-Rabin: "), normal("determina de manera eficiente si un número es primo, incluso para números muy grandes.")]),
    bullet([bold("Panel de análisis numérico automático: "), normal("al ingresar un número, se muestra automáticamente información detallada: factorización, divisores, propiedades especiales y funciónes aritméticas.")]),
    bullet([bold("+40 funciónes especiales: "), normal("organizadas en 4 categorías: Teoría de Números, Aritmética Modular, Combinatoria y Estadística.")]),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── Section 2: Cómo Navegar ────────────────────────────────────────────
function secNavegar() {
  return [
    h1("2. Cómo Navegar la App"),
    p("La interfaz de Super Calculadora esta diseñada para ser intuitiva y eficiente:"),
    blankLine(),
    bullet([bold("Menú lateral (drawer): "), normal("accede a \"Funciónes Especiales\" para activar el teclado especial con todas las funciónes avanzadas.")]),
    bullet([bold("Teclado scrollable superior: "), normal("muestra las funciónes organizadas por secciones (Teoría de Números, Aritmética Modular, Combinatoria, Estadística). Se puede desplazar horizontalmente.")]),
    bullet([bold("Teclado numérico fijo inferior: "), normal("siempre visible, contiene los dígitos 0-9, operaciónes básicas (+, -, x, /), punto decimal y la tecla de igual (=).")]),
    bullet([bold("Panel de análisis: "), normal("se muestra a la derecha en tabletas o debajo del teclado en dispositivos móviles. Se actualiza automáticamente al ingresar un número.")]),
    bullet([bold("Indicador de operación pendiente: "), normal("cuando una función multi-parámetro está activa, aparece un indicador con color terciario mostrando la función y los parámetros acumulados.")]),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── Section 3: Sistema de Parámetros ───────────────────────────────────
function secParámetros() {
  const col2 = [2800, 1200, 5360];
  const col3 = [3120, 6240];
  return [
    h1("3. Sistema de Parámetros"),
    p("Este es el concepto más importante para usar la calculadora correctamente. Existen tres tipos de funciónes segun la cantidad de parámetros que aceptan:"),
    blankLine(),

    // --- 1 param ---
    h2("3.1 Funciónes de 1 Parámetro (inmediatas)"),
    p("Se ingresa un número y se presiona el botón de la función. El resultado aparece inmediatamente."),
    pRuns([bold("Flujo: "), normal("número -> botón de función -> resultado")]),
    pRuns([bold("Ejemplos: "), normal("phi, mu, omega, Omega, lambda, n!, F(n), Cat, Bell, D(n), p(n), dr, sigma0, sigma, sopfr, sopf, rad, n#, pi(n), piso, techo, n!!, g")]),
    blankLine(),

    // --- Fixed params ---
    h2("3.2 Funciónes de Parámetros Fijos (2-3-4)"),
    p("Se ingresa el primer valor, se presiona la función, aparece el indicador de operación pendiente, se ingresa el segundo valor y se presiona =. Para funciónes de 3 parámetros se repite el proceso."),
    pRuns([bold("Flujo (2 params): "), normal("a -> función -> b -> =")]),
    pRuns([bold("Flujo (3 params): "), normal("a -> función -> b -> = -> c -> =")]),
    blankLine(),

    makeTable(col2,
      ["Función", "Params", "Flujo de Uso"],
      [
        ["mod", "2", "a -> mod -> b -> ="],
        ["Vp (valuación p-ádica)", "2", "n -> Vp -> p -> ="],
        ["C(n,k) combinaciones", "2", "n -> C -> k -> ="],
        ["V(n,k) variaciones", "2", "n -> V -> k -> ="],
        ["a^(-1) mod n (inverso modular)", "2", "a -> a^(-1) -> n -> ="],
        ["ord_n(a) (orden multiplicativo)", "2", "a -> ord -> n -> ="],
        ["(a/p) símbolo de Legendre", "2", "a -> (a/p) -> p -> ="],
        ["(a/n)j símbolo de Jacobi", "2", "a -> (a/n)j -> n -> ="],
        ["S2(n,k) Stirling 2da especie", "2", "n -> S2 -> k -> ="],
        ["s1(n,k) Stirling 1ra especie", "2", "n -> s1 -> k -> ="],
        ["SumDigB (suma dígitos en base)", "2", "n -> SumDigB -> base -> ="],
        ["a^b mod n (exp. modular)", "3", "a -> a^b%n -> b -> = -> n -> ="],
        ["Diof (ax+by=c)", "3", "a -> Diof -> b -> = -> c -> ="],
      ]
    ),
    blankLine(),

    // --- Variable params ---
    h2("3.3 Funciónes de Parámetros Variables (N params)"),
    p("Se ingresa el primer valor, se presiona la función, se ingresa el siguiente valor. Para agregar mas valores se presiona = (agrega parámetro). Para ejecutar la función se presiona el MISMO botón de la función nuevamente."),
    blankLine(),
    pRuns([bold("IMPORTANTE: "), normal("Para funciónes de parámetros variables:")]),
    bullet([normal("Presionar "), bold("="), normal(" agrega otro parámetro a la lista.")]),
    bullet([normal("Presionar el "), bold("botón de la función"), normal(" nuevamente EJECUTA el cálculo con todos los parámetros acumulados.")]),
    blankLine(),

    makeTable(col3,
      ["Función", "Descripcion"],
      [
        ["MCD", "Máximo común divisor de N números"],
        ["MCM", "Mínimo común múltiplo de N números"],
        ["TCR", "Teorema Chino del Residuo"],
        ["Med A", "Media aritmética de N números"],
        ["Med G", "Media geométrica de N números"],
        ["Med H", "Media armónica de N números"],
        ["Med C", "Media cuadrática de N números"],
        ["min", "Mínimo de N números"],
        ["max", "Máximo de N números"],
      ]
    ),
    blankLine(),
    pRuns([bold("Ejemplo MCD(12, 18, 24): "), normal("12 -> MCD -> 18 -> = -> 24 -> MCD")]),
    pRuns([italic("(El primer MCD inicia la operación. El = agrega 24 a la lista. El segundo MCD ejecuta el cálculo.)")]),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── Function reference helper ──────────────────────────────────────────
function funcRef(botón, nombre, definicion, fórmula, ejemplo) {
  return [
    h3(botón + " - " + nombre),
    pRuns([bold("Definición: "), normal(definicion)]),
    fórmula ? pRuns([bold("Fórmula: "), normal(fórmula)]) : null,
    pRuns([bold("Ejemplo: "), normal(ejemplo)]),
    blankLine(),
  ].filter(Boolean);
}

// ── Section 4: Teoría de Números ───────────────────────────────────────
function secTeoríaNúmeros() {
  return [
    h1("4. Referencia de Funciónes - Teoría de Números"),
    p("Funciónes clásicas de teoría de números, esenciales para olimpiadas matemáticas."),
    blankLine(),
    ...funcRef("phi(n)", "Función Totiente de Euler",
      "Cuenta los enteros positivos menores o iguales a n que son coprimos con n.",
      "phi(n) = n * Prod(1 - 1/p) para cada primo p que divide a n",
      "phi(12) = 4 (los coprimos son 1, 5, 7, 11)"),
    ...funcRef("lambda(n)", "Función de Carmichael",
      "El menor entero positivo m tal que a^m = 1 (mod n) para todo a coprimo con n.",
      "lambda(n) = mcm de lambda(p^e) para la factorización n = Prod(p^e)",
      "lambda(8) = 2"),
    ...funcRef("mu(n)", "Función de Möbius",
      "Vale 1 si n es libre de cuadrados con número par de factores primos, -1 si impar, 0 si no es libre de cuadrados.",
      "mu(n) = (-1)^k si n = p1*p2*...*pk (primos distintos), 0 si p^2 | n",
      "mu(30) = -1, mu(12) = 0"),
    ...funcRef("lambdaL(n)", "Función de Liouville",
      "Vale (-1)^Omega(n) donde Omega(n) es el número total de factores primos con repetición.",
      "lambdaL(n) = (-1)^Omega(n)",
      "lambdaL(12) = (-1)^3 = -1"),
    ...funcRef("omega(n)", "Función omega pequeña",
      "Cuenta el número de factores primos distintos de n.",
      "",
      "omega(12) = 2 (factores primos: 2, 3)"),
    ...funcRef("Omega(n)", "Función Omega grande",
      "Cuenta el número total de factores primos de n, con repetición.",
      "",
      "Omega(12) = 3 (12 = 2^2 * 3)"),
    ...funcRef("sigma0(n)", "Función divisor (conteo)",
      "Cuenta el número de divisores positivos de n.",
      "sigma0(n) = Prod(e_i + 1) para n = Prod(p_i^e_i)",
      "sigma0(12) = 6 (divisores: 1, 2, 3, 4, 6, 12)"),
    ...funcRef("sigma(n)", "Función suma de divisores",
      "Suma de todos los divisores positivos de n.",
      "sigma(n) = Prod((p^(e+1) - 1)/(p - 1))",
      "sigma(12) = 28"),
    ...funcRef("sopfr(n)", "Suma de factores primos con repetición",
      "Suma de los factores primos de n contando multiplicidad.",
      "",
      "sopfr(12) = 2 + 2 + 3 = 7"),
    ...funcRef("sopf(n)", "Suma de factores primos distintos",
      "Suma de los factores primos distintos de n.",
      "",
      "sopf(12) = 2 + 3 = 5"),
    ...funcRef("rad(n)", "Radical",
      "Producto de los factores primos distintos de n.",
      "rad(n) = Prod(p) para cada primo p | n",
      "rad(12) = 2 * 3 = 6"),
    ...funcRef("n#", "Primorial",
      "Producto de todos los primos menores o iguales a n.",
      "",
      "5# = 2 * 3 * 5 = 30"),
    ...funcRef("pi(n)", "Función conteo de primos",
      "Cuenta la cantidad de números primos menores o iguales a n.",
      "",
      "pi(10) = 4 (primos: 2, 3, 5, 7)"),
    ...funcRef("dr(n)", "Raíz digital",
      "Resultado de sumar repetidamente los dígitos hasta obtener un solo digito.",
      "dr(n) = 1 + ((n - 1) mod 9) para n > 0",
      "dr(493) = 4 + 9 + 3 = 16 -> 1 + 6 = 7"),
    ...funcRef("piso(x) / techo(x)", "Funciónes piso y techo",
      "piso(x) es el mayor entero <= x. techo(x) es el menor entero >= x.",
      "",
      "piso(3.7) = 3, techo(3.2) = 4"),
    ...funcRef("Vp(n)", "Valuación p-ádica",
      "Mayor exponente e tal que p^e divide a n. Requiere 2 parámetros: n y p.",
      "",
      "V2(12) = 2 (porque 12 = 2^2 * 3)"),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── Section 5: Aritmética Modular ──────────────────────────────────────
function secAritméticaModular() {
  return [
    h1("5. Referencia de Funciónes - Aritmética Modular"),
    p("Funciónes para trabajar con congruencias y aritmética modular."),
    blankLine(),
    ...funcRef("mod", "Módulo",
      "Calcula el residuo de la división de a entre b.", "", "17 mod 5 = 2"),
    ...funcRef("a^b mod n", "Exponenciación modular",
      "Calcula a elevado a b modulo n de forma eficiente usando exponenciación binaria. 3 parámetros.",
      "", "2^10 mod 1000 = 24"),
    ...funcRef("a^(-1) mod n", "Inverso modular",
      "Encuentra x tal que a*x = 1 (mod n). Solo existe si mcd(a, n) = 1.",
      "", "3^(-1) mod 7 = 5 (porque 3*5 = 15 = 1 mod 7)"),
    ...funcRef("ord_n(a)", "Orden multiplicativo",
      "El menor entero positivo k tal que a^k = 1 (mod n). Requiere mcd(a, n) = 1.",
      "", "ord_7(2) = 3 (porque 2^3 = 8 = 1 mod 7)"),
    ...funcRef("(a/p)", "Símbolo de Legendre",
      "Vale 1 si a es residuo cuadrático mod p, -1 si no, 0 si p | a. p debe ser primo impar.",
      "", "(2/7) = 1 (porque 3^2 = 9 = 2 mod 7)"),
    ...funcRef("(a/n)j", "Símbolo de Jacobi",
      "Generalización del símbolo de Legendre a módulos compuestos impares.",
      "(a/n) = Prod((a/p_i)^e_i) para n = Prod(p_i^e_i)",
      "(2/15) = (2/3)(2/5) = (-1)(-1) = 1"),
    ...funcRef("g", "Raíz primitiva",
      "Encuentra el menor generador del grupo multiplicativo modulo n.",
      "", "g(7) = 3 (porque las potencias de 3 mod 7 generan {1,2,3,4,5,6})"),
    ...funcRef("MCD", "Máximo Comun Divisor (N params)",
      "Calcula el MCD de N números útilizando el algoritmo de Euclides.",
      "", "MCD(12, 18, 24) = 6"),
    ...funcRef("MCM", "Mínimo Comun Múltiplo (N params)",
      "Calcula el MCM de N números.", "MCM(a,b) = |a*b| / MCD(a,b)",
      "MCM(4, 6, 10) = 60"),
    ...funcRef("Diof", "Ecuación Diofántica lineal (ax + by = c)",
      "Resuelve la ecuación diofántica lineal. Tiene solución si y solo si MCD(a,b) | c. 3 parámetros: a, b, c.",
      "", "Diof(3, 5, 1): solución x=2, y=-1 (3*2 + 5*(-1) = 1)"),
    ...funcRef("TCR", "Teorema Chino del Residuo (N params)",
      "Resuelve un sistema de congruencias simultáneas. Se ingresan pares (residuo, modulo) como parámetros variables.",
      "", "x = 2 mod 3, x = 3 mod 5 -> x = 8 mod 15"),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── Section 6: Combinatoria ────────────────────────────────────────────
function secCombinatoria() {
  return [
    h1("6. Referencia de Funciónes - Combinatoria"),
    p("Funciónes de conteo y combinatoria, fundamentales para problemas de olimpiadas."),
    blankLine(),
    ...funcRef("n!", "Factorial",
      "Producto de todos los enteros positivos desde 1 hasta n.",
      "n! = 1 * 2 * 3 * ... * n",
      "5! = 120"),
    ...funcRef("n!!", "Doble factorial",
      "Producto de enteros del mismo paridad desde 1 o 2 hasta n.",
      "n!! = n * (n-2) * (n-4) * ... ",
      "7!! = 7*5*3*1 = 105, 6!! = 6*4*2 = 48"),
    ...funcRef("C(n,k)", "Combinaciones (coeficiente binomial)",
      "Número de formas de elegir k elementos de un conjunto de n.",
      "C(n,k) = n! / (k! * (n-k)!)",
      "C(10,3) = 120"),
    ...funcRef("V(n,k)", "Variaciones (permutaciones parciales)",
      "Número de formas de elegir k elementos ordenados de n.",
      "V(n,k) = n! / (n-k)!",
      "V(5,3) = 60"),
    ...funcRef("Cat(n)", "Números de Catalan",
      "Aparecen en problemas de conteo: caminos, parentizaciones, triangulaciones, etc.",
      "Cat(n) = C(2n,n) / (n+1)",
      "Cat(4) = 14"),
    ...funcRef("D(n)", "Desarreglos (derangements)",
      "Permutaciones sin puntos fijos.",
      "D(n) = n! * Sum((-1)^k / k!, k=0..n)",
      "D(4) = 9"),
    ...funcRef("Bell(n)", "Números de Bell",
      "Cuenta el número de particiones de un conjunto de n elementos.",
      "", "Bell(4) = 15"),
    ...funcRef("p(n)", "Particiones",
      "Número de formas de escribir n como suma de enteros positivos (sin importar el orden).",
      "", "p(5) = 7 (5, 4+1, 3+2, 3+1+1, 2+2+1, 2+1+1+1, 1+1+1+1+1)"),
    ...funcRef("S2(n,k)", "Números de Stirling de segunda especie",
      "Cuenta las particiones de un conjunto de n elementos en exactamente k subconjuntos no vacíos.",
      "S2(n,k) = (1/k!) * Sum((-1)^j * C(k,j) * (k-j)^n, j=0..k)",
      "S2(4,2) = 7"),
    ...funcRef("s1(n,k)", "Números de Stirling de primera especie (con signo)",
      "Relacionados con permutaciones y ciclos. |s1(n,k)| cuenta permutaciones de n con exactamente k ciclos.",
      "", "s1(4,2) = -11, |s1(4,2)| = 11"),
    ...funcRef("F(n)", "Números de Fibonacci",
      "La clásica secuencia donde cada término es la suma de los dos anteriores.",
      "F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2)",
      "F(10) = 55"),
    ...funcRef("SumDigB", "Suma de dígitos en base",
      "Suma los dígitos de n cuando se escribe en la base indicada. 2 parámetros: n y base.",
      "", "SumDigB(255, 16) = F+F = 30 (255 = FF en base 16)"),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── Section 7: Estadística ─────────────────────────────────────────────
function secEstadística() {
  return [
    h1("7. Referencia de Funciónes - Estadística"),
    p("Funciónes estadísticas básicas que aceptan N parámetros."),
    blankLine(),
    ...funcRef("Med A", "Media Aritmética (N params)",
      "Promedio de N números.",
      "AM = (x1 + x2 + ... + xn) / n",
      "Med A(2, 8) = 5"),
    ...funcRef("Med G", "Media Geométrica (N params)",
      "Raíz n-ésima del producto de N números positivos.",
      "GM = (x1 * x2 * ... * xn)^(1/n)",
      "Med G(2, 8) = 4"),
    ...funcRef("Med H", "Media Armónica (N params)",
      "Inverso de la media aritmética de los inversos.",
      "HM = n / (1/x1 + 1/x2 + ... + 1/xn)",
      "Med H(2, 8) = 3.2"),
    ...funcRef("Med C", "Media Cuadrática (N params)",
      "Raíz cuadrada de la media de los cuadrados.",
      "QM = sqrt((x1^2 + x2^2 + ... + xn^2) / n)",
      "Med C(2, 8) = sqrt(34) aprox. 5.83"),
    ...funcRef("min", "Mínimo (N params)",
      "Devuelve el valor mínimo de los N números ingresados.",
      "", "min(3, 1, 7, 2) = 1"),
    ...funcRef("max", "Máximo (N params)",
      "Devuelve el valor máximo de los N números ingresados.",
      "", "max(3, 1, 7, 2) = 7"),
    blankLine(),
    h2("Desigualdad de las Medias"),
    p("Para números positivos, siempre se cumple la siguiente desigualdad fundamental:"),
    blankLine(),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { after: 200 },
      children: [new TextRun({ text: "HM  <=  GM  <=  AM  <=  QM", font: FONT, size: 26, bold: true, color: BLUE })],
    }),
    p("La igualdad se da si y solo si todos los números son iguales. Esta desigualdad (especialmente AM-GM) es una de las herramientas más poderosas en olimpiadas matemáticas."),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── Section 8: Panel de Análisis ───────────────────────────────────────
function secAnálisis() {
  const cw = [3500, 5860];
  return [
    h1("8. Panel de Análisis Numérico"),
    p("Al ingresar cualquier número, el panel de análisis se actualiza automáticamente mostrando una gran cantidad de información útil. Las secciones del panel incluyen:"),
    blankLine(),
    makeTable(cw,
      ["Sección", "Informacion mostrada"],
      [
        ["Propiedades básicas", "Número de dígitos, paridad (par/impar), signo"],
        ["Representaciones", "Binario, octal, hexadecimal"],
        ["Primalidad y factorización", "Si es primo (Miller-Rabin), factorización completa en primos"],
        ["Primos cercanos", "Primo anterior y primo siguiente"],
        ["Divisores", "Lista completa de divisores"],
        ["Cuadrado perfecto", "Si n es cuadrado perfecto y su raíz"],
        ["Cubo perfecto", "Si n es cubo perfecto y su raíz"],
        ["Potencia perfecta", "Si n = a^b para algun a, b > 1"],
        ["Fibonacci", "Si n es un número de Fibonacci"],
        ["Triangular", "Si n es un número triangular"],
        ["Palindromo", "Si n es palíndromo en base 10"],
        ["Funciónes aritméticas", "phi, lambda, mu, omega, Omega, sopfr, sopf, rad, dr"],
        ["Libre de cuadrados", "Si ningún primo al cuadrado divide a n"],
        ["Número poderoso", "Si para cada primo p | n, también p^2 | n"],
        ["Número de Harshad", "Si n es divisible por la suma de sus dígitos"],
        ["Semiprimo", "Si n es producto de exactamente 2 primos"],
        ["Abundante/Deficiente", "Si sigma(n) > 2n (abundante) o sigma(n) < 2n (deficiente)"],
      ]
    ),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── Section 9: Mejoras y Correcciónes ──────────────────────────────────
function secMejoras() {
  const cw = [2500, 6860];
  return [
    h1("9. Mejoras y Correcciónes Implementadas"),
    p("Resumen de todas las mejoras, correcciones de errores y nuevas funciónalidades implementadas:"),
    blankLine(),
    makeTable(cw,
      ["Categoría", "Descripcion"],
      [
        ["Corrección de bugs", "Eliminación de bytes nulos en archivos fuente que causaban errores de compilación"],
        ["Corrección de bugs", "Corrección de anclajes en expresiones regulares (regex) para validación correcta"],
        ["Corrección de bugs", "Eliminación de métodos duplicados que causaban conflictos"],
        ["Corrección de bugs", "Corrección del manejo de overflow en display de números grandes"],
        ["Nuevas funciónes", "Implementación de +30 funciónes especiales nuevas (Stirling, Bell, Catalan, etc.)"],
        ["Nuevas funciónes", "Símbolos de Legendre y Jacobi"],
        ["Nuevas funciónes", "Raíz primitiva, orden multiplicativo"],
        ["Nuevas funciónes", "Ecuaciónes diofánticas lineales"],
        ["Nuevas funciónes", "Teorema Chino del Residuo"],
        ["Nuevas funciónes", "Doble factorial, desarreglos, particiones"],
        ["Nuevas funciónes", "Medias aritmética, geométrica, armónica y cuadrática"],
        ["Sistema de entrada", "Sistema genérico de entrada multi-parámetro (modelo PendingOperation de N params)"],
        ["Sistema de entrada", "Indicador visual de operación pendiente con parámetros acumulados"],
        ["Interfaz", "Teclado scrollable categorizado con secciones para cada tipo de función"],
        ["Interfaz", "Panel de análisis numérico mejorado con +17 propiedades"],
        ["Interfaz", "Pantalla de ayuda con documentación completa integrada"],
        ["Rendimiento", "Optimizaciones para números grandes con BigInt"],
        ["Rendimiento", "Prevención de ANR (Application Not Responding) en cálculos pesados"],
      ]
    ),
    new Paragraph({ children: [new PageBreak()] }),
  ];
}

// ── Section 10: Fórmulas Clave ─────────────────────────────────────────
function secFórmulas() {
  return [
    h1("10. Fórmulas Clave para Olimpiadas"),
    p("Referencia rápida de las fórmulas más importantes que puedes verificar con la calculadora."),
    blankLine(),

    h2("Teoría de Números"),
    bullet([bold("Fórmula producto de Euler: "), normal("phi(n) = n * Prod(1 - 1/p) para cada primo p | n")]),
    bullet([bold("Propiedad multiplicativa: "), normal("phi(mn) = phi(m) * phi(n) * gcd(m,n) / phi(gcd(m,n))")]),
    bullet([bold("Teorema de Euler: "), normal("a^phi(n) = 1 (mod n) cuando gcd(a,n) = 1")]),
    bullet([bold("Pequeño teorema de Fermat: "), normal("a^(p-1) = 1 (mod p) cuando p es primo y p no divide a a")]),
    bullet([bold("Teorema de Wilson: "), normal("(p-1)! = -1 (mod p) si y solo si p es primo")]),
    blankLine(),

    h2("Inversión de Möbius"),
    bullet([normal("Si f(n) = Sum(g(d)) para d | n, entonces g(n) = Sum(mu(n/d) * f(d)) para d | n")]),
    blankLine(),

    h2("Valuación p-ádica"),
    bullet([bold("Fórmula de Legendre para v_p(n!): "), normal("v_p(n!) = Sum(piso(n/p^k)) para k = 1, 2, 3, ...")]),
    bullet([bold("Consecuencia: "), normal("v_p(C(n,k)) = (s_p(k) + s_p(n-k) - s_p(n)) / (p-1) donde s_p es la suma de dígitos en base p")]),
    blankLine(),

    h2("Combinatoria"),
    bullet([bold("Teorema de Lucas: "), normal("C(n,k) = Prod(C(n_i, k_i)) (mod p) donde n_i, k_i son dígitos en base p")]),
    bullet([bold("Números de Catalan: "), normal("Cat(n) = C(2n,n)/(n+1) = (2n)!/((n+1)!*n!)")]),
    bullet([bold("Fórmula de inclusión-exclusión: "), normal("|A1 u A2 u ... u An| = Sum|Ai| - Sum|Ai n Aj| + ...")]),
    blankLine(),

    h2("Desigualdades"),
    bullet([bold("AM-GM: "), normal("(x1+x2+...+xn)/n >= (x1*x2*...*xn)^(1/n) para xi > 0")]),
    bullet([bold("Cadena completa: "), normal("HM <= GM <= AM <= QM, igualdad sii todos iguales")]),
    bullet([bold("Desigualdad de Cauchy-Schwarz: "), normal("(Sum ai*bi)^2 <= (Sum ai^2)(Sum bi^2)")]),
    blankLine(),
    blankLine(),

    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { before: 400 },
      children: [new TextRun({ text: "--- Fin del documento ---", font: FONT, size: 20, color: "999999", italics: true })],
    }),
  ];
}

// ── Build Document ─────────────────────────────────────────────────────
async function main() {
  const doc = new Document({
    styles: {
      default: {
        document: { run: { font: FONT, size: 21 } },
      },
      paragraphStyles: [
        {
          id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
          run: { size: 32, bold: true, font: FONT, color: BLUE },
          paragraph: { spacing: { before: 360, after: 200 }, outlineLevel: 0 },
        },
        {
          id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
          run: { size: 26, bold: true, font: FONT, color: BLUE },
          paragraph: { spacing: { before: 280, after: 160 }, outlineLevel: 1 },
        },
        {
          id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
          run: { size: 22, bold: true, font: FONT, color: "3A6AAF" },
          paragraph: { spacing: { before: 200, after: 120 }, outlineLevel: 2 },
        },
      ],
    },
    numbering: {
      config: [
        {
          reference: "bullets",
          levels: [
            { level: 0, format: LevelFormat.BULLET, text: "\u2022", alignment: AlignmentType.LEFT,
              style: { paragraph: { indent: { left: 720, hanging: 360 } } } },
            { level: 1, format: LevelFormat.BULLET, text: "\u25E6", alignment: AlignmentType.LEFT,
              style: { paragraph: { indent: { left: 1440, hanging: 360 } } } },
          ],
        },
      ],
    },
    sections: [
      {
        properties: {
          page: {
            size: { width: PAGE_W, height: PAGE_H },
            margin: { top: MARGIN, right: MARGIN, bottom: MARGIN, left: MARGIN },
          },
        },
        headers: {
          default: new Header({
            children: [
              new Paragraph({
                border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: BLUE, space: 4 } },
                children: [new TextRun({ text: "Super Calculadora Matemática - Guía Completa", font: FONT, size: 16, color: "888888", italics: true })],
              }),
            ],
          }),
        },
        footers: {
          default: new Footer({
            children: [
              new Paragraph({
                alignment: AlignmentType.CENTER,
                border: { top: { style: BorderStyle.SINGLE, size: 4, color: "CCCCCC", space: 4 } },
                children: [
                  new TextRun({ text: "Página ", font: FONT, size: 16, color: "888888" }),
                  new TextRun({ children: [PageNumber.CURRENT], font: FONT, size: 16, color: "888888" }),
                ],
              }),
            ],
          }),
        },
        children: [
          ...coverPage(),
          ...secIntroducción(),
          ...secNavegar(),
          ...secParámetros(),
          ...secTeoríaNúmeros(),
          ...secAritméticaModular(),
          ...secCombinatoria(),
          ...secEstadística(),
          ...secAnálisis(),
          ...secMejoras(),
          ...secFórmulas(),
        ],
      },
    ],
  });

  const buffer = await Packer.toBuffer(doc);
  const outPath = path.join(__dirname, "Super_Calculadora_Guía_Completa.docx");
  fs.writeFileSync(outPath, buffer);
  console.log("Document created: " + outPath);
  console.log("Size: " + (buffer.length / 1024).toFixed(1) + " KB");
}

main().catch(err => { console.error(err); process.exit(1); });
