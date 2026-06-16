// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Super Calculadora';

  @override
  String get appVersion => 'Versión 1.0.0';

  @override
  String get appDeveloped => 'Desarrollado en Flutter';

  @override
  String get appDynamicThemes => 'Con soporte a temas dinámicos';

  @override
  String get navStandard => 'Estándar';

  @override
  String get navStandardSub => 'Operaciones básicas';

  @override
  String get navScientific => 'Científica';

  @override
  String get navScientificSub => 'Funciones avanzadas';

  @override
  String get navSpecial => 'Funciones Especiales';

  @override
  String get navSpecialSub => 'Teoría de números';

  @override
  String get navHistory => 'Historial';

  @override
  String get navHistorySub => 'Ver operaciones anteriores';

  @override
  String get navSettings => 'Configuraciones';

  @override
  String get navSettingsSub => 'Ajustes de la aplicación';

  @override
  String get navHelp => 'Ayuda';

  @override
  String get navHelpSub => 'Guía de funciones especiales';

  @override
  String get navAbout => 'Acerca de';

  @override
  String get navAboutSub => 'Super Calculadora v1.0';

  @override
  String get navCalculator => 'Calculadora';

  @override
  String get navSelectType => 'Selecciona el tipo';

  @override
  String navAngleMode(String mode) {
    return 'Modo: $mode';
  }

  @override
  String get navRadians => 'Radianes';

  @override
  String get navDegrees => 'Grados';

  @override
  String get calcAnalysis => 'Análisis';

  @override
  String get calcExpressions => 'Expresiones';

  @override
  String get calcScientific => 'Calculadora Científica';

  @override
  String get calcSpecialFunctions => 'Funciones Especiales';

  @override
  String get calcSuperCalculator => 'Super Calculadora';

  @override
  String get calcNumericAnalysis => 'Análisis Numérico';

  @override
  String get calcMathExpressions => 'Expresiones Matemáticas';

  @override
  String get calcResult => 'Resultado:';

  @override
  String get calcProcessing => 'Procesando números grandes...';

  @override
  String get calcHighPrecision => 'Calculando (alta precisión)…';

  @override
  String get calcCancel => 'Cancelar';

  @override
  String get displayPaste => 'Pegar';

  @override
  String get displayCopy => 'Copiar';

  @override
  String displayCopied(String text) {
    return 'Copiado: $text';
  }

  @override
  String get displayCopyResult => 'Copiar resultado';

  @override
  String get displayPasteNumber => 'Pegar número';

  @override
  String get displayClearDisplay => 'Limpiar display';

  @override
  String get displayInvalidNumber =>
      'Error: El texto pegado no es un número válido';

  @override
  String get displayNothingToPaste => 'No hay contenido para pegar';

  @override
  String displayPasteError(String error) {
    return 'Error al pegar: $error';
  }

  @override
  String displayPasted(String text) {
    return 'Pegado: $text';
  }

  @override
  String get histTitle => 'Historial';

  @override
  String get histClearAll => 'Limpiar historial';

  @override
  String get histClearAllTooltip => 'Limpiar todo el historial';

  @override
  String get histConfirmClear =>
      '¿Estás seguro de que quieres eliminar todo el historial?';

  @override
  String histConfirmClearN(String count) {
    return '¿Estás seguro de que quieres eliminar todas las $count operaciones del historial? Esta acción no se puede deshacer.';
  }

  @override
  String get histCleared => 'Historial limpiado';

  @override
  String get histDeleted => 'Historial eliminado';

  @override
  String get histOperationDeleted => 'Operación eliminada';

  @override
  String get histCopiedToClipboard => 'Copiado al portapapeles';

  @override
  String histCopiedClipboardText(String text) {
    return 'Copiado al portapapeles: $text';
  }

  @override
  String get histFullResult => 'Resultado completo';

  @override
  String get histClose => 'Cerrar';

  @override
  String get histExpression => 'Expresión:';

  @override
  String get histResult => 'Resultado:';

  @override
  String get histCopyResult => 'Copiar resultado';

  @override
  String get histCopyAll => 'Copiar todo';

  @override
  String get histCopyExpression => 'Copiar expresión';

  @override
  String get histUseResult => 'Usar resultado';

  @override
  String get histViewResult => 'Ver resultado';

  @override
  String get histDelete => 'Eliminar';

  @override
  String get histEmpty => 'No hay operaciones en el historial';

  @override
  String get histEmptyHint =>
      'Realiza algunos cálculos para ver tu historial aquí';

  @override
  String get histEmptyHintAlt => 'Las operaciones que realices aparecerán aquí';

  @override
  String get histOperations => 'operaciones';

  @override
  String get histNow => 'Ahora';

  @override
  String histErrorLoading(String error) {
    return 'Error cargando historial: $error';
  }

  @override
  String histErrorClearing(String error) {
    return 'Error limpiando historial: $error';
  }

  @override
  String histErrorDeleting(String error) {
    return 'Error eliminando operación: $error';
  }

  @override
  String get settingsTitle => 'Configuraciones';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsNumberFormat => 'Formato de números';

  @override
  String get settingsScientificNotation => 'Usar notación científica';

  @override
  String get settingsScientificHint =>
      'Los números se mostrarán completos (ej: 123000) cuando esté deshabilitado';

  @override
  String get settingsHighPrecision => 'Modo de alta precisión';

  @override
  String get settingsHighPrecisionHint =>
      'Calcula sin, cos, tan, ln, √… con reales constructivos exactos (más lento). Singularidades como tan 90° se reportan como indefinido.';

  @override
  String settingsPrecisionDigits(int digits) {
    return 'Dígitos de precisión: $digits';
  }

  @override
  String get settingsOpenSourceLicenses => 'Licencias de código abierto';

  @override
  String get settingsFormatExamples => 'Ejemplos de formato';

  @override
  String get settingsLargeNumber => 'Número grande:';

  @override
  String get settingsSmallNumber => 'Número pequeño:';

  @override
  String get settingsNormal => 'Normal:';

  @override
  String get settingsScientific => 'Científica:';

  @override
  String get settingsAboutApp => 'Sobre el App';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeAuto => 'Automático';

  @override
  String get themeLightDesc => 'Usa siempre el tema claro';

  @override
  String get themeDarkDesc => 'Usa siempre el tema oscuro';

  @override
  String get themeAutoDesc => 'Sigue la configuración del sistema';

  @override
  String get aboutTitle => 'Super Calculadora';

  @override
  String get aboutDescription =>
      'Una calculadora avanzada con capacidades científicas y análisis numérico completo.';

  @override
  String get aboutFeatures => 'Características:';

  @override
  String get aboutClose => 'Cerrar';

  @override
  String get aboutFeature1 => 'Números de hasta 1024 bits';

  @override
  String get aboutFeature2 => 'Precisión decimal de 64 bits';

  @override
  String get aboutFeature3 => 'Modo calculadora estándar y científica';

  @override
  String get aboutFeature4 => 'Funciones trigonométricas (sin, cos, tan)';

  @override
  String get aboutFeature5 =>
      'Funciones trigonométricas inversas (asin, acos, atan)';

  @override
  String get aboutFeature6 => 'Logaritmos naturales (ln) y base 10 (log)';

  @override
  String get aboutFeature7 => 'Funciones exponenciales (eˣ, 10ˣ)';

  @override
  String get aboutFeature8 => 'Cálculo de factorial (n!)';

  @override
  String get aboutFeature9 => 'Constantes matemáticas (π, e)';

  @override
  String get aboutFeature10 => 'Potencias y raíces (x², x³, √, ∛)';

  @override
  String get aboutFeature11 => 'Conversión entre grados y radianes';

  @override
  String get aboutFeature12 => 'Análisis de números primos';

  @override
  String get aboutFeature13 => 'Descomposición en factores primos';

  @override
  String get aboutFeature14 => 'Conversión binaria y decimal';

  @override
  String get aboutFeature15 => 'Análisis de propiedades matemáticas';

  @override
  String get aboutFeature16 => 'Operaciones con números extremadamente grandes';

  @override
  String get aboutFeature17 => 'Cálculos pesados en hilos separados (isolates)';

  @override
  String get aboutFeature18 => 'Manejo de errores de dominio y tamaño';

  @override
  String get exprMathExpression => 'Expresión matemática';

  @override
  String get exprHideHistory => 'Ocultar historial';

  @override
  String get exprShowHistory => 'Mostrar historial';

  @override
  String get exprClearExpression => 'Limpiar expresión';

  @override
  String get exprHint => 'Ej: (5 + 3) * sqrt(9) - 2^3';

  @override
  String get exprDelete => 'Borrar';

  @override
  String get exprEvaluate => 'Evaluar (Enter)';

  @override
  String get exprParenthesis => 'Paréntesis';

  @override
  String get exprSquareRoot => 'Raíz cuadrada';

  @override
  String get exprPower => 'Potencia';

  @override
  String get exprSin => 'Seno';

  @override
  String get exprCos => 'Coseno';

  @override
  String get exprTan => 'Tangente';

  @override
  String get exprLog => 'Logaritmo';

  @override
  String get exprLn => 'Logaritmo natural';

  @override
  String get exprPi => 'Pi';

  @override
  String get exprEuler => 'Euler';

  @override
  String get analysisEnterNumber => 'Ingresa un número para ver su análisis';

  @override
  String get analysisLoading => 'Analizando número...';

  @override
  String get analysisLoadingHint =>
      'Esto puede tomar unos momentos para números grandes';

  @override
  String get analysisLimited => 'Análisis limitado';

  @override
  String get analysisExtremelyLarge => 'Número Extremadamente Grande';

  @override
  String analysisDigitsCount(String count) {
    return 'Dígitos: $count';
  }

  @override
  String get analysisPrimalityNote => 'Nota sobre análisis de primalidad';

  @override
  String analysisOriginalInput(String original, String analyzed) {
    return 'Entrada original: $original → Analizado: $analyzed';
  }

  @override
  String get analysisCalculatingPrimes => 'Calculando primos...';

  @override
  String get analysisSearchingPrimes => 'Buscando primo anterior y siguiente';

  @override
  String get analysisBasicProperties => 'Propiedades Básicas';

  @override
  String get analysisValue => 'Valor';

  @override
  String get analysisIsPrime => 'Es primo';

  @override
  String get analysisDigits => 'Dígitos';

  @override
  String get analysisNextPrime => 'Siguiente primo';

  @override
  String get analysisPrevPrime => 'Primo anterior';

  @override
  String get analysisDigitSum => 'Suma de dígitos';

  @override
  String get analysisBinary => 'Binario';

  @override
  String get analysisYes => 'Sí';

  @override
  String get analysisNo => 'No';

  @override
  String get analysisRepresentations => 'Representaciones';

  @override
  String get analysisOctal => 'Octal';

  @override
  String get analysisHex => 'Hexadecimal';

  @override
  String get analysisMathAnalysis => 'Análisis Matemático';

  @override
  String get analysisIsPerfect => 'Es perfecto';

  @override
  String get analysisIsPalindrome => 'Es palíndromo';

  @override
  String get analysisIsFibonacci => 'Es Fibonacci';

  @override
  String get analysisIsTriangular => 'Es triangular';

  @override
  String get analysisPrimeFactors => 'Factorización Prima';

  @override
  String get analysisPrimeFactorsLabel => 'Factores primos';

  @override
  String get analysisDivisors => 'Divisores';

  @override
  String get analysisAllDivisors => 'Todos los divisores';

  @override
  String get analysisDivisorCount => 'Cantidad de divisores';

  @override
  String get analysisArithmeticFunctions => 'Funciones Aritméticas';

  @override
  String get analysisEulerPhi => 'φ(n) Euler';

  @override
  String get analysisCarmichael => 'λ(n) Carmichael';

  @override
  String get analysisMobius => 'μ(n) Möbius';

  @override
  String get analysisSmallOmega => 'ω(n) primos distintos';

  @override
  String get analysisBigOmega => 'Ω(n) primos c/mult.';

  @override
  String get analysisSopfr => 'sopfr(n) Σprimos rep.';

  @override
  String get analysisSopf => 'sopf(n) Σprimos dist.';

  @override
  String get analysisRadical => 'rad(n) radical';

  @override
  String get analysisDigitalRoot => 'Raíz digital';

  @override
  String get analysisClassification => 'Clasificación';

  @override
  String get analysisSquareFree => 'Libre de cuadrados';

  @override
  String get analysisPowerful => 'Poderoso';

  @override
  String get analysisHarshad => 'Harshad';

  @override
  String get analysisSemiprime => 'Semiprimo';

  @override
  String get analysisAbundant => 'Abundante';

  @override
  String get analysisDeficient => 'Deficiente';

  @override
  String get analysisOperations => 'Operaciones';

  @override
  String get analysisSquare => 'Cuadrado';

  @override
  String get analysisCube => 'Cubo';

  @override
  String get analysisSquareRootLabel => 'Raíz cuadrada';

  @override
  String get analysisIsPerfectSquare => 'Es cuadrado perfecto';

  @override
  String get analysisCubeRoot => 'Raíz cúbica';

  @override
  String get analysisIsPerfectCube => 'Es cubo perfecto';

  @override
  String get analysisPerfectPower => 'Potencia Perfecta';

  @override
  String get analysisExpression => 'Expresión';

  @override
  String get analysisBase => 'Base';

  @override
  String get analysisExponent => 'Exponente';

  @override
  String get cardPrime => 'Primo';

  @override
  String get cardPerfect => 'Perfecto';

  @override
  String get cardPalindrome => 'Palíndromo';

  @override
  String get cardFibonacci => 'Fibonacci';

  @override
  String get cardTriangular => 'Triangular';

  @override
  String get cardEven => 'Par';

  @override
  String get cardOdd => 'Impar';

  @override
  String get cardQuickProperties => 'Propiedades rápidas:';

  @override
  String get cardConvert => 'Convertir:';

  @override
  String get cardToDecimal => 'A Decimal';

  @override
  String get cardToBinary => 'A Binario';

  @override
  String get cardAdvancedOps => 'Operaciones avanzadas:';

  @override
  String get cardDigits => 'dígitos';

  @override
  String get kbdNumberTheory => 'Teoría de Números';

  @override
  String get kbdModularArith => 'Aritmética Modular';

  @override
  String get kbdCombinatorics => 'Combinatoria';

  @override
  String get kbdStatistics => 'Estadística';

  @override
  String errPower(String error) {
    return 'Error en potencia: $error';
  }

  @override
  String errSquareRoot(String error) {
    return 'Error en raíz cuadrada: $error';
  }

  @override
  String get errNegativeSqrt =>
      'No se puede calcular la raíz cuadrada de un número negativo';

  @override
  String errCubeRoot(String error) {
    return 'Error en raíz cúbica: $error';
  }

  @override
  String errBinaryConversion(String error) {
    return 'Error en conversión binaria: $error';
  }

  @override
  String get errEmptyBinary => 'Número binario vacío';

  @override
  String get errInvalidBinary =>
      'El número debe contener solo dígitos binarios (0 y 1)';

  @override
  String errBinaryFromConversion(String error) {
    return 'Error en conversión de binario: $error';
  }

  @override
  String get errTrigTooLarge =>
      'Número demasiado grande para funciones trigonométricas';

  @override
  String errSin(String error) {
    return 'Error en seno: $error';
  }

  @override
  String errCos(String error) {
    return 'Error en coseno: $error';
  }

  @override
  String get errTanUndefined => 'Tangente indefinida para este ángulo';

  @override
  String errTan(String error) {
    return 'Error en tangente: $error';
  }

  @override
  String get errAsinDomain =>
      'Arcoseno solo está definido para valores entre -1 y 1';

  @override
  String errAsin(String error) {
    return 'Error en arcoseno: $error';
  }

  @override
  String get errAcosDomain =>
      'Arcocoseno solo está definido para valores entre -1 y 1';

  @override
  String errAcos(String error) {
    return 'Error en arcocoseno: $error';
  }

  @override
  String errAtan(String error) {
    return 'Error en arcotangente: $error';
  }

  @override
  String get errLnDomain =>
      'Logaritmo natural solo está definido para números positivos';

  @override
  String get errLnTooLarge => 'Número demasiado grande para logaritmo natural';

  @override
  String errLn(String error) {
    return 'Error en logaritmo natural: $error';
  }

  @override
  String get errLogDomain =>
      'Logaritmo solo está definido para números positivos';

  @override
  String get errLogTooLarge => 'Número demasiado grande para logaritmo base 10';

  @override
  String errLog(String error) {
    return 'Error en logaritmo: $error';
  }

  @override
  String get errExpTooLarge => 'Número demasiado grande para exponencial';

  @override
  String errExp(String error) {
    return 'Error en exponencial: $error';
  }

  @override
  String get errTenPowTooLarge => 'Número demasiado grande para 10^x';

  @override
  String errTenPow(String error) {
    return 'Error en 10^x: $error';
  }

  @override
  String get errFactorialInvalid => 'Número inválido para factorial';

  @override
  String get errFactorialNonNeg =>
      'Factorial solo está definido para números enteros no negativos';

  @override
  String get errFactorialTooLarge =>
      'Número demasiado grande para factorial (máximo 170)';

  @override
  String errFactorial(String error) {
    return 'Error en factorial: $error';
  }

  @override
  String get errOperationCancelled => 'Operación cancelada';

  @override
  String errGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get errPhiDomain => 'φ(n) solo está definido para n > 0';

  @override
  String errPhi(String error) {
    return 'Error en φ(n): $error';
  }

  @override
  String get errPrimorialDomain => 'Primorial solo está definido para n ≥ 0';

  @override
  String errPrimorial(String error) {
    return 'Error en primorial: $error';
  }

  @override
  String get errSigma0Domain => 'σ₀(n) solo está definido para n > 0';

  @override
  String errSigma0(String error) {
    return 'Error en σ₀(n): $error';
  }

  @override
  String get errSigmaDomain => 'σ(m,n) solo está definido para n > 0';

  @override
  String errSigma(String error) {
    return 'Error en σ(m,n): $error';
  }

  @override
  String errFloorCeil(String error) {
    return 'Error en piso/techo: $error';
  }

  @override
  String get errMobiusDomain => 'μ(n) solo está definido para n > 0';

  @override
  String errMobius(String error) {
    return 'Error en μ(n): $error';
  }

  @override
  String get errFactorialNeg => 'El factorial no está definido para negativos';

  @override
  String get errFactorialMax => 'n! demasiado grande (máx n=10000)';

  @override
  String errFactorialN(String error) {
    return 'Error en n!: $error';
  }

  @override
  String get errDoubleFactorialNeg =>
      'El doble factorial no está definido para negativos';

  @override
  String errDoubleFactorial(String error) {
    return 'Error en n!!: $error';
  }

  @override
  String get errFibonacciNeg => 'F(n) no está definido para n < 0';

  @override
  String errFibonacci(String error) {
    return 'Error en F(n): $error';
  }

  @override
  String get errCatalanNeg => 'Catalan no está definido para n < 0';

  @override
  String errCatalan(String error) {
    return 'Error en Catalan: $error';
  }

  @override
  String get errDerangementNeg => 'D(n) no está definido para n < 0';

  @override
  String errDerangement(String error) {
    return 'Error en D(n): $error';
  }

  @override
  String get errPartitionNeg => 'p(n) no está definido para n < 0';

  @override
  String errPartition(String error) {
    return 'Error en p(n): $error';
  }

  @override
  String get errBellNeg => 'B(n) no está definido para n < 0';

  @override
  String errBell(String error) {
    return 'Error en Bell(n): $error';
  }

  @override
  String errDigitalRoot(String error) {
    return 'Error en raíz digital: $error';
  }

  @override
  String get errPrimitiveRootDomain => 'Se necesita n > 1';

  @override
  String errNoPrimitiveRoot(String n) {
    return 'No existe raíz primitiva mod $n';
  }

  @override
  String get errLiouvilleDomain => 'λ_L(n) solo está definido para n > 0';

  @override
  String errLiouville(String error) {
    return 'Error en λ_L(n): $error';
  }

  @override
  String errPrimeCounting(String error) {
    return 'Error en π(n): $error';
  }

  @override
  String get errRadDomain => 'rad(n) solo está definido para n > 0';

  @override
  String errRad(String error) {
    return 'Error en rad(n): $error';
  }

  @override
  String get errOmegaDomain => 'ω(n) solo está definido para n > 0';

  @override
  String errOmega(String error) {
    return 'Error en ω(n): $error';
  }

  @override
  String get errBigOmegaDomain => 'Ω(n) solo está definido para n > 0';

  @override
  String errBigOmega(String error) {
    return 'Error en Ω(n): $error';
  }

  @override
  String get errCarmichaelDomain => 'λ(n) solo está definido para n > 0';

  @override
  String errCarmichael(String error) {
    return 'Error en λ(n): $error';
  }

  @override
  String get errSopfrDomain => 'sopfr(n) solo está definido para n > 0';

  @override
  String errSopfr(String error) {
    return 'Error en sopfr(n): $error';
  }

  @override
  String get errSopfDomain => 'sopf(n) solo está definido para n > 0';

  @override
  String errSopf(String error) {
    return 'Error en sopf(n): $error';
  }

  @override
  String errPercentage(String error) {
    return 'Error en porcentaje: $error';
  }

  @override
  String get errDivisionByZero => 'División por cero';

  @override
  String errReciprocal(String error) {
    return 'Error en recíproco: $error';
  }

  @override
  String errNoInverse(String a, String n) {
    return 'No existe inverso modular de $a mod $n';
  }

  @override
  String errModPow(String error) {
    return 'Error en exponenciación modular: $error';
  }

  @override
  String errDiophantine(String error) {
    return 'Error en ecuación diofántica: $error';
  }

  @override
  String errCRT(String error) {
    return 'Error en TCR: $error';
  }

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLangAuto => 'Automático (del sistema)';

  @override
  String get settingsLangAutoDesc => 'Usar el idioma del dispositivo';

  @override
  String get settingsLangEs => 'Español';

  @override
  String get settingsLangEn => 'English';

  @override
  String get hlpTitle => 'Guía de Funciones Especiales';

  @override
  String get hlpQuickStartHeader => 'Inicio Rápido';

  @override
  String get hlpQuickStartWelcome =>
      'Bienvenido a la calculadora para olimpiadas';

  @override
  String get hlpQuickStartStep1 =>
      'Abre el menú lateral (☰) y selecciona \"Funciones Especiales\"';

  @override
  String get hlpQuickStartStep2 =>
      'El teclado superior (scrollable) tiene ~40 funciones en 4 secciones';

  @override
  String get hlpQuickStartStep3 =>
      'Ingresa un número y presiona cualquier botón de función';

  @override
  String get hlpQuickStartStep4 =>
      'Si la función necesita más valores, aparece un indicador de operación pendiente';

  @override
  String get hlpQuickStartStep5 =>
      'El panel lateral muestra análisis automático del número ingresado';

  @override
  String get hlpQuickStartNote =>
      'Las funciones de 1 parámetro se ejecutan inmediatamente.\nLas de 2+ parámetros muestran un indicador y esperan más valores.';

  @override
  String get hlpParamHeader => 'Sistema de Parámetros';

  @override
  String get hlpParamTypesTitle => 'Tipos de funciones según parámetros';

  @override
  String get hlpParam1Title => '1 parámetro (inmediatas)';

  @override
  String get hlpParam1Desc => 'Ingresa número → Presiona función → Resultado';

  @override
  String get hlpParam1Example =>
      'Ej: φ(12) → ingresa 12, presiona φ → muestra 4';

  @override
  String get hlpParam2Title => '2-3-4 parámetros (fijos)';

  @override
  String get hlpParam2Desc =>
      'Ingresa valor → Función → Valor → = → (repite si necesita más)\nSe auto-ejecuta al completar todos los parámetros.';

  @override
  String get hlpParam2Example => 'Ej: C(10,3) → ingresa 10 → C(n,k) → 3 → =';

  @override
  String get hlpParamNTitle => 'N parámetros (variables)';

  @override
  String get hlpParamNDesc =>
      'Ingresa valor → Función → Valor → = (agrega más)\nPresiona la MISMA FUNCIÓN otra vez para ejecutar.';

  @override
  String get hlpParamNExample =>
      'Ej: MCD(12,18,24) → 12 → MCD → 18 → = → 24 → MCD';

  @override
  String get hlpPendingOpTitle => 'Indicador de operación pendiente';

  @override
  String get hlpPendingOpDesc =>
      'Cuando una función espera más valores, aparece un indicador coloreado en la pantalla mostrando qué operación está en curso y qué falta.\n\nEjemplo: \"C(10, _)\" indica que falta k para completar C(n,k).\n\"MCD(12, 18, _) [= agregar, MCD resolver]\" indica una operación variable.';

  @override
  String get hlpNumberTheoryHeader => 'Teoría de Números';

  @override
  String get hlpEulerPhiTitle => 'φ(n) — Función de Euler (Totient)';

  @override
  String get hlpEulerPhiParams => '1 param';

  @override
  String get hlpEulerPhiDesc =>
      'Cuenta cuántos enteros de 1 a n son coprimos con n (es decir, MCD(k,n)=1).';

  @override
  String get hlpEulerPhiFormula =>
      'φ(n) = n × ∏(1 − 1/p) para cada primo p | n';

  @override
  String get hlpEulerPhiEx1 => 'φ(1) = 1';

  @override
  String get hlpEulerPhiEx2 => 'φ(9) = 6 → [1,2,4,5,7,8]';

  @override
  String get hlpEulerPhiEx3 => 'φ(12) = 4 → [1,5,7,11]';

  @override
  String get hlpEulerPhiEx4 => 'φ(p) = p−1 para p primo';

  @override
  String get hlpEulerPhiTip1 =>
      'Multiplicativa: φ(mn) = φ(m)φ(n) si MCD(m,n)=1';

  @override
  String get hlpEulerPhiTip2 =>
      'Teorema de Euler: a^φ(n) ≡ 1 (mod n) si MCD(a,n)=1';

  @override
  String get hlpEulerPhiTip3 => 'Σ φ(d) para d|n = n';

  @override
  String get hlpCarmichaelTitle => 'λ(n) — Función λ de Carmichael';

  @override
  String get hlpCarmichaelParams => '1 param';

  @override
  String get hlpCarmichaelDesc =>
      'Menor m > 0 tal que a^m ≡ 1 (mod n) para TODO a coprimo con n. Siempre divide a φ(n).';

  @override
  String get hlpCarmichaelFormula =>
      'λ(p^k) = φ(p^k) si p impar\nλ(2)=1, λ(4)=2, λ(2^k)=2^(k−2) si k≥3\nλ(n) = mcm de las partes';

  @override
  String get hlpCarmichaelEx1 => 'λ(8) = 2';

  @override
  String get hlpCarmichaelEx2 => 'λ(15) = mcm(λ(3),λ(5)) = mcm(2,4) = 4';

  @override
  String get hlpCarmichaelEx3 => 'λ(p) = p−1 para p primo';

  @override
  String get hlpCarmichaelTip1 => 'λ(n) | φ(n) siempre';

  @override
  String get hlpCarmichaelTip2 =>
      'λ(n) = φ(n) si y solo si n tiene raíz primitiva';

  @override
  String get hlpMobiusTitle => 'μ(n) — Función de Möbius';

  @override
  String get hlpMobiusParams => '1 param';

  @override
  String get hlpMobiusDesc =>
      'Detecta si n es libre de cuadrados y cuenta factores primos.';

  @override
  String get hlpMobiusFormula =>
      'μ(1) = 1\nμ(n) = (−1)^k si n = p₁·p₂·...·pₖ (distintos)\nμ(n) = 0 si p² | n';

  @override
  String get hlpMobiusEx1 => 'μ(1) = 1';

  @override
  String get hlpMobiusEx2 => 'μ(6) = μ(2×3) = (−1)² = 1';

  @override
  String get hlpMobiusEx3 => 'μ(30) = μ(2×3×5) = (−1)³ = −1';

  @override
  String get hlpMobiusEx4 => 'μ(12) = 0 (tiene 2²)';

  @override
  String get hlpMobiusTip1 =>
      'Inversión de Möbius: si g(n) = Σ f(d) para d|n, entonces f(n) = Σ μ(d)g(n/d)';

  @override
  String get hlpMobiusTip2 => 'Σ μ(d) para d|n = [n=1]';

  @override
  String get hlpLiouvilleTitle => 'λL(n) — Función de Liouville';

  @override
  String get hlpLiouvilleParams => '1 param';

  @override
  String get hlpLiouvilleDesc =>
      'Completamente multiplicativa: λL(n) = (−1)^Ω(n).';

  @override
  String get hlpLiouvilleFormula => 'λL(n) = (−1)^Ω(n)';

  @override
  String get hlpLiouvilleEx1 => 'λL(12) = (−1)³ = −1 (Ω(12)=3)';

  @override
  String get hlpLiouvilleEx2 => 'λL(36) = (−1)⁴ = 1 (Ω(36)=4)';

  @override
  String get hlpLiouvilleTip1 =>
      'Σ λL(d) para d|n = 1 si n es cuadrado perfecto, 0 si no';

  @override
  String get hlpSmallOmegaTitle => 'ω(n) — Factores Primos Distintos';

  @override
  String get hlpSmallOmegaParams => '1 param';

  @override
  String get hlpSmallOmegaDesc =>
      'Cuenta la cantidad de primos distintos que dividen a n.';

  @override
  String get hlpSmallOmegaFormula => 'ω(n) = k si n = p₁^a₁ × ... × pₖ^aₖ';

  @override
  String get hlpSmallOmegaEx1 => 'ω(12) = 2 → [2, 3]';

  @override
  String get hlpSmallOmegaEx2 => 'ω(30) = 3 → [2, 3, 5]';

  @override
  String get hlpSmallOmegaEx3 => 'ω(p^k) = 1';

  @override
  String get hlpBigOmegaTitle => 'Ω(n) — Factores Primos con Multiplicidad';

  @override
  String get hlpBigOmegaParams => '1 param';

  @override
  String get hlpBigOmegaDesc =>
      'Número total de factores primos contando repeticiones.';

  @override
  String get hlpBigOmegaFormula => 'Ω(n) = a₁ + a₂ + ... + aₖ';

  @override
  String get hlpBigOmegaEx1 => 'Ω(12) = 3 → 2×2×3';

  @override
  String get hlpBigOmegaEx2 => 'Ω(72) = 5 → 2³×3² → 3+2';

  @override
  String get hlpBigOmegaEx3 => 'Ω(p) = 1, Ω(p²) = 2';

  @override
  String get hlpSigma0Title => 'σ₀(n) — Cantidad de Divisores';

  @override
  String get hlpSigma0Params => '1 param';

  @override
  String get hlpSigma0Desc => 'Número total de divisores positivos de n.';

  @override
  String get hlpSigma0Formula =>
      'Si n = p₁^a₁ × ... × pₖ^aₖ\nσ₀(n) = (a₁+1)(a₂+1)...(aₖ+1)';

  @override
  String get hlpSigma0Ex1 => 'σ₀(12) = 6 → [1,2,3,4,6,12]';

  @override
  String get hlpSigma0Ex2 => 'σ₀(p) = 2';

  @override
  String get hlpSigma0Ex3 => 'σ₀(p²) = 3';

  @override
  String get hlpSigmaTitle => 'σ(n) — Suma de Divisores';

  @override
  String get hlpSigmaParams => '1 param';

  @override
  String get hlpSigmaDesc => 'Suma de todos los divisores positivos de n.';

  @override
  String get hlpSigmaFormula => 'σ(n) = Σ d para d | n';

  @override
  String get hlpSigmaEx1 => 'σ(6) = 1+2+3+6 = 12 (6 es perfecto)';

  @override
  String get hlpSigmaEx2 => 'σ(12) = 1+2+3+4+6+12 = 28';

  @override
  String get hlpSigmaEx3 => 'σ(p) = p+1';

  @override
  String get hlpSigmaTip1 => 'n es perfecto ⟺ σ(n) = 2n';

  @override
  String get hlpSigmaTip2 => 'n es abundante ⟺ σ(n) > 2n';

  @override
  String get hlpSopfrTitle => 'sopfr(n) — Suma de Primos con Repetición';

  @override
  String get hlpSopfrParams => '1 param';

  @override
  String get hlpSopfrDesc => 'Suma los factores primos contando multiplicidad.';

  @override
  String get hlpSopfrFormula => 'sopfr(n) = a₁p₁ + a₂p₂ + ... + aₖpₖ';

  @override
  String get hlpSopfrEx1 => 'sopfr(12) = 2+2+3 = 7';

  @override
  String get hlpSopfrEx2 => 'sopfr(60) = 2+2+3+5 = 12';

  @override
  String get hlpSopfTitle => 'sopf(n) — Suma de Primos Distintos';

  @override
  String get hlpSopfParams => '1 param';

  @override
  String get hlpSopfDesc => 'Suma de los primos distintos que dividen a n.';

  @override
  String get hlpSopfFormula => 'sopf(n) = p₁ + p₂ + ... + pₖ';

  @override
  String get hlpSopfEx1 => 'sopf(12) = 2+3 = 5';

  @override
  String get hlpSopfEx2 => 'sopf(60) = 2+3+5 = 10';

  @override
  String get hlpRadTitle => 'rad(n) — Radical';

  @override
  String get hlpRadParams => '1 param';

  @override
  String get hlpRadDesc =>
      'Producto de los primos distintos que dividen a n (función del Conjetura ABC).';

  @override
  String get hlpRadFormula => 'rad(n) = ∏ p para p primo, p | n';

  @override
  String get hlpRadEx1 => 'rad(72) = rad(2³×3²) = 2×3 = 6';

  @override
  String get hlpRadEx2 => 'rad(480) = rad(2⁵×3×5) = 30';

  @override
  String get hlpRadEx3 => 'rad(p) = p';

  @override
  String get hlpPrimorialTitle => 'n# — Primorial';

  @override
  String get hlpPrimorialParams => '1 param';

  @override
  String get hlpPrimorialDesc => 'Producto de todos los primos ≤ n.';

  @override
  String get hlpPrimorialFormula => 'n# = ∏ p para p primo, p ≤ n';

  @override
  String get hlpPrimorialEx1 => '5# = 2×3×5 = 30';

  @override
  String get hlpPrimorialEx2 => '7# = 210';

  @override
  String get hlpPrimorialEx3 => '11# = 2310';

  @override
  String get hlpPrimeCountTitle => 'π(n) — Función Contadora de Primos';

  @override
  String get hlpPrimeCountParams => '1 param';

  @override
  String get hlpPrimeCountDesc =>
      'Cuenta primos ≤ n. Exacto para n ≤ 1,000,000; aproximación Li(x) para mayores.';

  @override
  String get hlpPrimeCountFormula =>
      'π(n) ~ n/ln(n) (Teorema de los Números Primos)';

  @override
  String get hlpPrimeCountEx1 => 'π(10) = 4';

  @override
  String get hlpPrimeCountEx2 => 'π(100) = 25';

  @override
  String get hlpPrimeCountEx3 => 'π(1,000,000) = 78,498';

  @override
  String get hlpDigitalRootTitle => 'dr(n) — Raíz Digital';

  @override
  String get hlpDigitalRootParams => '1 param';

  @override
  String get hlpDigitalRootDesc =>
      'Suma iterativa de dígitos hasta obtener un solo dígito.';

  @override
  String get hlpDigitalRootFormula => 'dr(n) = 1 + (n−1) mod 9  (para n > 0)';

  @override
  String get hlpDigitalRootEx1 => 'dr(493) → 4+9+3=16 → 1+6 = 7';

  @override
  String get hlpDigitalRootEx2 => 'dr(999) = 9';

  @override
  String get hlpDigitalRootEx3 => 'dr(n) ≡ n (mod 9)';

  @override
  String get hlpFloorCeilTitle => '⌊x⌋ / ⌈x⌉ — Piso y Techo';

  @override
  String get hlpFloorCeilParams => '1 param';

  @override
  String get hlpFloorCeilDesc =>
      'Piso: mayor entero ≤ x. Techo: menor entero ≥ x. Se alterna entre ambos.';

  @override
  String get hlpFloorCeilFormula => '⌊x⌋ ≤ x < ⌊x⌋+1\n⌈x⌉−1 < x ≤ ⌈x⌉';

  @override
  String get hlpFloorCeilEx1 => '⌊3.7⌋ = 3, ⌈3.7⌉ = 4';

  @override
  String get hlpFloorCeilEx2 => '⌊−2.3⌋ = −3, ⌈−2.3⌉ = −2';

  @override
  String get hlpFloorCeilEx3 => '⌊5⌋ = ⌈5⌉ = 5';

  @override
  String get hlpPadicTitle => 'Vₚ(n) — Valuación p-ádica';

  @override
  String get hlpPadicParams => '2 params: n → Vₚ → p → =';

  @override
  String get hlpPadicDesc => 'Máxima potencia del primo p que divide a n.';

  @override
  String get hlpPadicFormula => 'Vₚ(n) = max[k : p^k | n]';

  @override
  String get hlpPadicEx1 => 'V₂(24) = 3 → 24 = 2³×3';

  @override
  String get hlpPadicEx2 => 'V₃(81) = 4 → 81 = 3⁴';

  @override
  String get hlpPadicEx3 => 'V₅(100) = 2 → 100 = 2²×5²';

  @override
  String get hlpPadicTip1 => 'Fórmula de Legendre: Vₚ(n!) = Σ ⌊n/pⁱ⌋';

  @override
  String get hlpPadicTip2 => 'Vₚ(ab) = Vₚ(a) + Vₚ(b)';

  @override
  String get hlpModArithHeader => 'Aritmética Modular';

  @override
  String get hlpModTitle => 'a mod b — Resto de División';

  @override
  String get hlpModParams => '2 params: a → mod → b → =';

  @override
  String get hlpModDesc => 'Resto de dividir a entre b.';

  @override
  String get hlpModFormula => 'a mod b = a − b × ⌊a/b⌋';

  @override
  String get hlpModEx1 => '17 mod 5 = 2';

  @override
  String get hlpModEx2 => '23 mod 7 = 2';

  @override
  String get hlpModEx3 => '−8 mod 3 = 1';

  @override
  String get hlpModPowTitle => 'a^b mod n — Exponenciación Modular';

  @override
  String get hlpModPowParams => '3 params: a → a%n → b → = → n → =';

  @override
  String get hlpModPowDesc =>
      'Calcula a^b mod n eficientemente usando cuadratura repetida O(log b).';

  @override
  String get hlpModPowFormula =>
      'Se descompone b en binario y se cuadra sucesivamente';

  @override
  String get hlpModPowEx1 => '2¹⁰⁰ mod 7 = 2';

  @override
  String get hlpModPowEx2 => '3¹³ mod 11 = 5';

  @override
  String get hlpModPowEx3 => 'Fundamental en RSA y tests de primalidad';

  @override
  String get hlpModPowTip1 =>
      'Flujo: ingresa a → presiona a%n → ingresa b → presiona = → ingresa n → presiona =';

  @override
  String get hlpModInvTitle => 'a⁻¹ mod n — Inverso Modular';

  @override
  String get hlpModInvParams => '2 params: a → a⁻¹ → n → =';

  @override
  String get hlpModInvDesc =>
      'Encuentra b tal que a×b ≡ 1 (mod n). Solo existe si MCD(a,n) = 1.';

  @override
  String get hlpModInvFormula => 'Algoritmo extendido de Euclides';

  @override
  String get hlpModInvEx1 => '3⁻¹ mod 7 = 5 → 3×5=15≡1';

  @override
  String get hlpModInvEx2 => '5⁻¹ mod 11 = 9 → 5×9=45≡1';

  @override
  String get hlpModInvEx3 => 'No existe si MCD(a,n) ≠ 1';

  @override
  String get hlpOrdTitle => 'ord_n(a) — Orden Multiplicativo';

  @override
  String get hlpOrdParams => '2 params: a → ord → n → =';

  @override
  String get hlpOrdDesc =>
      'Menor k > 0 con a^k ≡ 1 (mod n). Requiere MCD(a,n)=1.';

  @override
  String get hlpOrdFormula => 'ord_n(a) = min[k > 0 : a^k ≡ 1 (mod n)]';

  @override
  String get hlpOrdEx1 => 'ord₇(2) = 3 → 2³=8≡1';

  @override
  String get hlpOrdEx2 => 'ord₁₀(3) = 4 → 3⁴=81≡1';

  @override
  String get hlpOrdTip1 => 'ord_n(a) siempre divide a φ(n)';

  @override
  String get hlpOrdTip2 => 'a es raíz primitiva ⟺ ord_n(a) = φ(n)';

  @override
  String get hlpLegendreTitle => '(a/p) — Símbolo de Legendre';

  @override
  String get hlpLegendreParams => '2 params: a → (a/p) → p → =';

  @override
  String get hlpLegendreDesc =>
      '1 si a es residuo cuadrático mod p, −1 si no, 0 si p|a. Requiere p primo impar.';

  @override
  String get hlpLegendreFormula =>
      '(a/p) ≡ a^((p−1)/2) (mod p) — Criterio de Euler';

  @override
  String get hlpLegendreEx1 => '(2/7) = 1 → 3²≡2 (mod 7)';

  @override
  String get hlpLegendreEx2 => '(3/7) = −1 → no existe x²≡3';

  @override
  String get hlpLegendreEx3 => '(5/5) = 0';

  @override
  String get hlpJacobiTitle => '(a/n)ⱼ — Símbolo de Jacobi';

  @override
  String get hlpJacobiParams => '2 params: a → (a/n)ⱼ → n → =';

  @override
  String get hlpJacobiDesc =>
      'Generalización de Legendre para n compuesto impar. Usa reciprocidad cuadrática.';

  @override
  String get hlpJacobiFormula => '(a/n) = ∏(a/pᵢ)^eᵢ donde n = ∏pᵢ^eᵢ';

  @override
  String get hlpJacobiEx1 => '(2/15) = (2/3)(2/5) = (−1)(−1) = 1';

  @override
  String get hlpJacobiEx2 => '(a/n) = −1 ⟹ a NO es residuo cuadrático';

  @override
  String get hlpJacobiEx3 => '(a/n) = 1 NO garantiza que lo sea';

  @override
  String get hlpPrimRootTitle => 'g — Raíz Primitiva';

  @override
  String get hlpPrimRootParams => '1 param';

  @override
  String get hlpPrimRootDesc =>
      'Menor raíz primitiva mod n (si existe). g es raíz primitiva si ord_n(g) = φ(n).';

  @override
  String get hlpPrimRootFormula => '[g, g², ..., g^φ(n)] = (Z/nZ)*';

  @override
  String get hlpPrimRootEx1 => 'g(7) = 3 → [3,2,6,4,5,1]';

  @override
  String get hlpPrimRootEx2 => 'g(11) = 2';

  @override
  String get hlpPrimRootEx3 => 'Existe solo para n = 1,2,4,p^k,2p^k';

  @override
  String get hlpGcdTitle => 'MCD — Máximo Común Divisor';

  @override
  String get hlpGcdParams => 'N params (variable, mín. 2)';

  @override
  String get hlpGcdDesc =>
      'Mayor entero que divide a todos los valores. Acepta 2 o más números.';

  @override
  String get hlpGcdFormula => 'MCD(a,b) vía algoritmo de Euclides';

  @override
  String get hlpGcdEx1 => 'MCD(12,18) = 6';

  @override
  String get hlpGcdEx2 => 'MCD(12,18,24) = 6';

  @override
  String get hlpGcdEx3 => 'MCD(a,b) × MCM(a,b) = a×b';

  @override
  String get hlpGcdTip1 => 'Flujo: 12 → MCD → 18 → MCD (ejecuta)';

  @override
  String get hlpGcdTip2 => 'Para 3+ números: 12 → MCD → 18 → = → 24 → MCD';

  @override
  String get hlpGcdTip3 =>
      'Presiona = para agregar más, presiona MCD para ejecutar';

  @override
  String get hlpLcmTitle => 'MCM — Mínimo Común Múltiplo';

  @override
  String get hlpLcmParams => 'N params (variable, mín. 2)';

  @override
  String get hlpLcmDesc =>
      'Menor entero positivo divisible por todos los valores.';

  @override
  String get hlpLcmFormula => 'MCM(a,b) = a×b / MCD(a,b)';

  @override
  String get hlpLcmEx1 => 'MCM(4,6) = 12';

  @override
  String get hlpLcmEx2 => 'MCM(3,5,7) = 105';

  @override
  String get hlpLcmTip1 =>
      'Mismo flujo que MCD: presiona MCM otra vez para ejecutar';

  @override
  String get hlpDiophTitle => 'Diof — Ecuación Diofántica Lineal';

  @override
  String get hlpDiophParams => '3 params: a → Diof → b → = → c → =';

  @override
  String get hlpDiophDesc =>
      'Resuelve ax + by = c. Da solución particular y general.';

  @override
  String get hlpDiophFormula =>
      'ax + by = c tiene solución ⟺ MCD(a,b) | c\nx = x₀ + (b/g)t,  y = y₀ − (a/g)t';

  @override
  String get hlpDiophEx1 => '3x + 5y = 1 → x=2+5t, y=−1−3t';

  @override
  String get hlpDiophEx2 => '6x + 9y = 12 → x=2+3t, y=0−2t';

  @override
  String get hlpDiophEx3 => '4x + 6y = 3 → Sin solución';

  @override
  String get hlpDiophTip1 => 'Paso 1: ingresa a (coeficiente de x)';

  @override
  String get hlpDiophTip2 => 'Paso 2: presiona Diof';

  @override
  String get hlpDiophTip3 => 'Paso 3: ingresa b (coeficiente de y), presiona =';

  @override
  String get hlpDiophTip4 =>
      'Paso 4: ingresa c (término independiente), presiona =';

  @override
  String get hlpCrtTitle => 'TCR — Teorema Chino del Residuo';

  @override
  String get hlpCrtParams => 'Variable (4+ params en pares a,m)';

  @override
  String get hlpCrtDesc => 'Resuelve sistema de congruencias x ≡ aᵢ (mod mᵢ).';

  @override
  String get hlpCrtFormula =>
      'x ≡ a₁ (mod m₁)\nx ≡ a₂ (mod m₂)\n→ x ≡ r (mod mcm(m₁,m₂))';

  @override
  String get hlpCrtEx1 => 'x≡2(mod 3), x≡3(mod 5) → x≡8(mod 15)';

  @override
  String get hlpCrtEx2 => 'x≡1(mod 4), x≡2(mod 3) → x≡5(mod 12)';

  @override
  String get hlpCrtTip1 => 'Flujo: a₁ → TCR → m₁ → = → a₂ → = → m₂ → TCR';

  @override
  String get hlpCrtTip2 => 'Los módulos deben ser compatibles';

  @override
  String get hlpCombinatoricsHeader => 'Combinatoria';

  @override
  String get hlpFactorialTitle => 'n! — Factorial';

  @override
  String get hlpFactorialParams => '1 param';

  @override
  String get hlpFactorialDesc => 'Producto de 1 a n. Precisión arbitraria.';

  @override
  String get hlpFactorialFormula => 'n! = 1 × 2 × ... × n,  0! = 1';

  @override
  String get hlpFactorialEx1 => '5! = 120';

  @override
  String get hlpFactorialEx2 => '10! = 3,628,800';

  @override
  String get hlpFactorialEx3 => '20! = 2,432,902,008,176,640,000';

  @override
  String get hlpDblFactorialTitle => 'n!! — Doble Factorial';

  @override
  String get hlpDblFactorialParams => '1 param';

  @override
  String get hlpDblFactorialDesc => 'Producto de enteros de misma paridad.';

  @override
  String get hlpDblFactorialFormula => 'n!! = n × (n−2) × (n−4) × ...';

  @override
  String get hlpDblFactorialEx1 => '7!! = 7×5×3×1 = 105';

  @override
  String get hlpDblFactorialEx2 => '8!! = 8×6×4×2 = 384';

  @override
  String get hlpDblFactorialEx3 => '0!! = 1!! = 1';

  @override
  String get hlpCombTitle => 'C(n,k) — Combinaciones';

  @override
  String get hlpCombParams => '2 params: n → C(n,k) → k → =';

  @override
  String get hlpCombDesc => 'Formas de elegir k de n sin importar orden.';

  @override
  String get hlpCombFormula => 'C(n,k) = n! / (k!(n−k)!)';

  @override
  String get hlpCombEx1 => 'C(5,2) = 10';

  @override
  String get hlpCombEx2 => 'C(10,3) = 120';

  @override
  String get hlpCombEx3 => 'C(n,0) = C(n,n) = 1';

  @override
  String get hlpCombTip1 =>
      'Identidad de Pascal: C(n,k) = C(n−1,k−1) + C(n−1,k)';

  @override
  String get hlpCombTip2 => 'C(n,k) = C(n, n−k)';

  @override
  String get hlpVarTitle => 'V(n,k) — Variaciones (Permutaciones parciales)';

  @override
  String get hlpVarParams => '2 params: n → V(n,k) → k → =';

  @override
  String get hlpVarDesc => 'Formas de elegir k de n CON orden.';

  @override
  String get hlpVarFormula => 'V(n,k) = n! / (n−k)!';

  @override
  String get hlpVarEx1 => 'V(5,2) = 20';

  @override
  String get hlpVarEx2 => 'V(10,3) = 720';

  @override
  String get hlpCatalanTitle => 'Cat(n) — Números de Catalan';

  @override
  String get hlpCatalanParams => '1 param';

  @override
  String get hlpCatalanDesc =>
      'Cuenta árboles binarios, triangulaciones, caminos de Dyck, paréntesis balanceados.';

  @override
  String get hlpCatalanFormula => 'Cₙ = C(2n,n)/(n+1)';

  @override
  String get hlpCatalanEx1 => 'C₀ = 1, C₁ = 1, C₂ = 2';

  @override
  String get hlpCatalanEx2 => 'C₃ = 5, C₄ = 14, C₅ = 42';

  @override
  String get hlpDerangementTitle => 'D(n) — Derangements (Desarreglos)';

  @override
  String get hlpDerangementParams => '1 param';

  @override
  String get hlpDerangementDesc =>
      'Permutaciones donde ningún elemento queda en su posición original.';

  @override
  String get hlpDerangementFormula =>
      'D(n) = n! × Σ(−1)^k/k! = (n−1)(D(n−1)+D(n−2))';

  @override
  String get hlpDerangementEx1 => 'D(3) = 2 → [231, 312]';

  @override
  String get hlpDerangementEx2 => 'D(4) = 9';

  @override
  String get hlpDerangementEx3 => 'D(n)/n! → 1/e ≈ 0.3679';

  @override
  String get hlpBellTitle => 'B(n) — Números de Bell';

  @override
  String get hlpBellParams => '1 param';

  @override
  String get hlpBellDesc =>
      'Número total de particiones de un conjunto de n elementos.';

  @override
  String get hlpBellFormula => 'B(n) = Σ S₂(n,k) para k=0..n';

  @override
  String get hlpBellEx1 => 'B(3) = 5';

  @override
  String get hlpBellEx2 => 'B(4) = 15';

  @override
  String get hlpBellEx3 => 'B(5) = 52';

  @override
  String get hlpPartitionTitle => 'p(n) — Particiones de Enteros';

  @override
  String get hlpPartitionParams => '1 param';

  @override
  String get hlpPartitionDesc =>
      'Formas de escribir n como suma de enteros positivos (orden no importa).';

  @override
  String get hlpPartitionFormula => 'Calculado con programación dinámica';

  @override
  String get hlpPartitionEx1 => 'p(4) = 5 → [4, 3+1, 2+2, 2+1+1, 1+1+1+1]';

  @override
  String get hlpPartitionEx2 => 'p(10) = 42';

  @override
  String get hlpPartitionEx3 => 'p(100) = 190,569,292,356';

  @override
  String get hlpStirling2Title => 'S₂(n,k) — Stirling 2da Especie';

  @override
  String get hlpStirling2Params => '2 params: n → S₂ → k → =';

  @override
  String get hlpStirling2Desc =>
      'Formas de particionar n elementos en exactamente k subconjuntos no vacíos.';

  @override
  String get hlpStirling2Formula => 'S₂(n,k) = k·S₂(n−1,k) + S₂(n−1,k−1)';

  @override
  String get hlpStirling2Ex1 => 'S₂(4,2) = 7';

  @override
  String get hlpStirling2Ex2 => 'S₂(5,3) = 25';

  @override
  String get hlpStirling2Ex3 => 'B(n) = Σ S₂(n,k)';

  @override
  String get hlpStirling1Title => 's₁(n,k) — Stirling 1ra Especie (sin signo)';

  @override
  String get hlpStirling1Params => '2 params: n → s₁ → k → =';

  @override
  String get hlpStirling1Desc =>
      'Permutaciones de n elementos con exactamente k ciclos.';

  @override
  String get hlpStirling1Formula =>
      '|s₁(n,k)| = (n−1)·|s₁(n−1,k)| + |s₁(n−1,k−1)|';

  @override
  String get hlpStirling1Ex1 => 's₁(4,2) = 11';

  @override
  String get hlpStirling1Ex2 => 's₁(4,1) = 6';

  @override
  String get hlpFibTitle => 'F(n) — n-ésimo Fibonacci';

  @override
  String get hlpFibParams => '1 param';

  @override
  String get hlpFibDesc =>
      'Calcula F(n) con duplicación rápida O(log n). Soporta n muy grandes.';

  @override
  String get hlpFibFormula => 'F(0)=0, F(1)=1, F(n)=F(n−1)+F(n−2)';

  @override
  String get hlpFibEx1 => 'F(10) = 55';

  @override
  String get hlpFibEx2 => 'F(50) = 12,586,269,025';

  @override
  String get hlpFibEx3 => 'F(100) = 354,224,848,179,261,915,075';

  @override
  String get hlpFibTip1 => 'F(n) mod m es periódico (período de Pisano)';

  @override
  String get hlpFibTip2 => 'MCD(F(m), F(n)) = F(MCD(m,n))';

  @override
  String get hlpDigitSumBaseTitle => 'ΣdígB — Suma de Dígitos en Base b';

  @override
  String get hlpDigitSumBaseParams => '2 params: n → ΣdígB → b → =';

  @override
  String get hlpDigitSumBaseDesc => 'Suma los dígitos de n escritos en base b.';

  @override
  String get hlpDigitSumBaseFormula =>
      'Si n = Σ dᵢ × bⁱ, entonces ΣdígB = Σ dᵢ';

  @override
  String get hlpDigitSumBaseEx1 => 'ΣdígB(255, 2) = 8 → 11111111₂';

  @override
  String get hlpDigitSumBaseEx2 => 'ΣdígB(100, 10) = 1';

  @override
  String get hlpDigitSumBaseEx3 => 'ΣdígB(100, 16) = 10 → 64₁₆';

  @override
  String get hlpStatisticsHeader => 'Estadística';

  @override
  String get hlpArithMeanTitle => 'Media Aritmética — Med A';

  @override
  String get hlpArithMeanParams => 'N params (variable, mín. 2)';

  @override
  String get hlpArithMeanDesc => 'Promedio clásico de N números.';

  @override
  String get hlpArithMeanFormula => 'MA = (x₁ + x₂ + ... + xₙ) / n';

  @override
  String get hlpArithMeanEx1 => 'MA(3, 7) = 5';

  @override
  String get hlpArithMeanEx2 => 'MA(2, 4, 6) = 4';

  @override
  String get hlpArithMeanTip1 => 'Flujo: 3 → Med A → 7 → Med A (ejecuta)';

  @override
  String get hlpArithMeanTip2 => 'Para 3+ nums: 2 → Med A → 4 → = → 6 → Med A';

  @override
  String get hlpGeoMeanTitle => 'Media Geométrica — Med G';

  @override
  String get hlpGeoMeanParams => 'N params (variable, mín. 2)';

  @override
  String get hlpGeoMeanDesc =>
      'Raíz n-ésima del producto. Solo valores positivos.';

  @override
  String get hlpGeoMeanFormula => 'MG = (x₁ × x₂ × ... × xₙ)^(1/n)';

  @override
  String get hlpGeoMeanEx1 => 'MG(2, 8) = 4';

  @override
  String get hlpGeoMeanEx2 => 'MG(1, 4, 9) ≈ 3.30';

  @override
  String get hlpHarmMeanTitle => 'Media Armónica — Med H';

  @override
  String get hlpHarmMeanParams => 'N params (variable, mín. 2)';

  @override
  String get hlpHarmMeanDesc =>
      'Inverso de la media aritmética de los inversos. Solo valores positivos.';

  @override
  String get hlpHarmMeanFormula => 'MH = n / (1/x₁ + 1/x₂ + ... + 1/xₙ)';

  @override
  String get hlpHarmMeanEx1 => 'MH(2, 8) = 3.2';

  @override
  String get hlpHarmMeanEx2 => 'MH(1, 4, 9) ≈ 2.08';

  @override
  String get hlpQuadMeanTitle => 'Media Cuadrática — Med C';

  @override
  String get hlpQuadMeanParams => 'N params (variable, mín. 2)';

  @override
  String get hlpQuadMeanDesc => 'Raíz de la media de los cuadrados (RMS).';

  @override
  String get hlpQuadMeanFormula => 'MC = √((x₁² + x₂² + ... + xₙ²) / n)';

  @override
  String get hlpQuadMeanEx1 => 'MC(3, 4) ≈ 3.54';

  @override
  String get hlpQuadMeanEx2 => 'MC(1, 2, 3) ≈ 2.16';

  @override
  String get hlpMinMaxTitle => 'min / max — Mínimo y Máximo';

  @override
  String get hlpMinMaxParams => 'N params (variable, mín. 2)';

  @override
  String get hlpMinMaxDesc =>
      'Encuentra el menor/mayor valor de un conjunto de N números.';

  @override
  String get hlpMinMaxFormula => 'min(a₁,...,aₙ) y max(a₁,...,aₙ)';

  @override
  String get hlpMinMaxEx1 => 'min(3, 7, 1) = 1';

  @override
  String get hlpMinMaxEx2 => 'max(3, 7, 1) = 7';

  @override
  String get hlpMinMaxTip1 =>
      'Mismo flujo variable: presiona min/max otra vez para ejecutar';

  @override
  String get hlpMeanInequalityTitle => 'Desigualdad de Medias (AM-GM-HM)';

  @override
  String get hlpMeanInequalityContent =>
      'Para números positivos siempre se cumple:\n\nMH ≤ MG ≤ MA ≤ MC\n\nLa igualdad se da solo cuando todos los valores son iguales.\nEsta desigualdad es fundamental en olimpiadas.';

  @override
  String get hlpAnalysisPanelHeader => 'Panel de Análisis Numérico';

  @override
  String get hlpAutoAnalysisTitle => 'Análisis Automático';

  @override
  String get hlpAutoAnalysisContent =>
      'Al ingresar cualquier número, el panel derecho (tablet) o inferior (móvil) muestra automáticamente:\n\n• Propiedades: dígitos, paridad, signo\n• Representaciones: binario, octal, hexadecimal\n• Primalidad: test Miller-Rabin, factorización completa\n• Primos vecinos: anterior y siguiente\n• Divisores: lista completa, suma, cantidad\n• Clasificaciones: cuadrado/cubo perfecto, potencia perfecta, Fibonacci, triangular, palíndromo\n\nPara números ≤ 15 dígitos, también muestra:\n\n• Funciones aritméticas: φ, λ, μ, ω, Ω, sopfr, sopf, rad, dr\n• Clasificaciones: libre de cuadrados, poderoso, Harshad, semiprimo, abundante/deficiente/perfecto';

  @override
  String get hlpOlympiadHeader => 'Fórmulas Clave para Olimpiadas';

  @override
  String get hlpIdentitiesTitle => 'Identidades Fundamentales';

  @override
  String get hlpIdentitiesContent =>
      '• Teorema de Euler: a^φ(n) ≡ 1 (mod n) si MCD(a,n)=1\n• Pequeño Fermat: a^(p−1) ≡ 1 (mod p) si p primo\n• Wilson: (p−1)! ≡ −1 (mod p) ⟺ p es primo\n• Fórmula de Legendre: Vₚ(n!) = Σᵢ ⌊n/pⁱ⌋\n• Lucas: C(n,k) mod p = ∏ C(nᵢ,kᵢ) mod p\n• Σ φ(d) para d|n = n\n• Σ μ(d) para d|n = [n=1]\n• φ(mn) = φ(m)φ(n)·MCD(m,n)/φ(MCD(m,n))\n• MCD(F(m),F(n)) = F(MCD(m,n))\n• AM ≥ GM ≥ HM (desigualdad de medias)';

  @override
  String get hlpRefTableTitle => 'Tabla de Referencia Rápida';

  @override
  String get hlpRefTableContent =>
      'n    φ(n)  λ(n)  μ(n)  σ(n)  ω  Ω\n1    1     1     1     1     0  0\n6    2     2     1     12    2  2\n12   4     2     0     28    2  3\n30   8     4     −1    72    3  3\n60   16    4     0     168   3  4\n100  40    20    0     217   2  4';

  @override
  String get hlpExamplesLabel => 'Ejemplos:';

  @override
  String get hlpTipsLabel => 'Tips:';

  @override
  String get errExprEmpty => 'Error: Expresión vacía';

  @override
  String get errExprMalformed => 'Error: Expresión malformada';

  @override
  String get errExprDivZero => 'Error: División por cero';

  @override
  String get errResultInvalid => 'Error: Resultado no válido';

  @override
  String get errResultTooLarge =>
      'El resultado es demasiado grande para calcularse exactamente';

  @override
  String get errAnalysisInvalid => 'Error: número inválido para análisis';

  @override
  String get errAnalysisFail => 'No se puede analizar el número';

  @override
  String get errNoSolution => 'Sin solución';

  @override
  String get errIncompatibleSystem => 'Sistema incompatible';

  @override
  String get errCRTNeedPairs => 'TCR necesita pares (aᵢ, mᵢ)';

  @override
  String errUnknownOp(String op) {
    return 'Operación desconocida: $op';
  }
}
