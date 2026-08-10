// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Super Calculadora';

  @override
  String get appVersion => 'Versão 1.3.0';

  @override
  String get appDeveloped => 'Desenvolvido em Flutter';

  @override
  String get appDynamicThemes => 'Com suporte a temas dinâmicos';

  @override
  String get navStandard => 'Padrão';

  @override
  String get navStandardSub => 'Operações básicas';

  @override
  String get navScientific => 'Científica';

  @override
  String get navScientificSub => 'Funções avançadas';

  @override
  String get navSpecial => 'Funções Especiais';

  @override
  String get navSpecialSub => 'Teoria dos números';

  @override
  String get navHistory => 'Histórico';

  @override
  String get navHistorySub => 'Ver operações anteriores';

  @override
  String get navSettings => 'Configurações';

  @override
  String get navSettingsSub => 'Ajustes do aplicativo';

  @override
  String get navHelp => 'Ajuda';

  @override
  String get navHelpSub => 'Guia de funções especiais';

  @override
  String get navAbout => 'Sobre';

  @override
  String get navAboutSub => 'Super Calculadora v1.3.0';

  @override
  String get navCalculator => 'Calculadora';

  @override
  String get navSelectType => 'Selecione o modo';

  @override
  String navAngleMode(String mode) {
    return 'Modo: $mode';
  }

  @override
  String get navRadians => 'Radianos';

  @override
  String get navDegrees => 'Graus';

  @override
  String get calcAnalysis => 'Análise';

  @override
  String get calcExpressions => 'Expressões';

  @override
  String get calcScientific => 'Calculadora Científica';

  @override
  String get calcSpecialFunctions => 'Funções Especiais';

  @override
  String get calcSuperCalculator => 'Super Calculadora';

  @override
  String get calcNumericAnalysis => 'Análise Numérica';

  @override
  String get calcMathExpressions => 'Expressões Matemáticas';

  @override
  String get calcResult => 'Resultado:';

  @override
  String get calcProcessing => 'Processando números grandes...';

  @override
  String get calcHighPrecision => 'Calculando (alta precisão)…';

  @override
  String get calcCancel => 'Cancelar';

  @override
  String get displayPaste => 'Colar';

  @override
  String get displayCopy => 'Copiar';

  @override
  String displayCopied(String text) {
    return 'Copiado: $text';
  }

  @override
  String get displayCopyResult => 'Copiar resultado';

  @override
  String get displayPasteNumber => 'Colar número';

  @override
  String get displayClearDisplay => 'Limpar o visor';

  @override
  String get displayInvalidNumber =>
      'Erro: o texto colado não é um número válido';

  @override
  String get displayNothingToPaste => 'Não há conteúdo para colar';

  @override
  String displayPasteError(String error) {
    return 'Erro ao colar: $error';
  }

  @override
  String displayPasted(String text) {
    return 'Colado: $text';
  }

  @override
  String get histTitle => 'Histórico';

  @override
  String get histClearAll => 'Limpar histórico';

  @override
  String get histClearAllTooltip => 'Limpar todo o histórico';

  @override
  String get histConfirmClear =>
      'Tem certeza de que deseja excluir todo o histórico?';

  @override
  String histConfirmClearN(String count) {
    return 'Tem certeza de que deseja excluir todas as $count operações do histórico? Esta ação não pode ser desfeita.';
  }

  @override
  String get histCleared => 'Histórico limpo';

  @override
  String get histDeleted => 'Histórico excluído';

  @override
  String get histOperationDeleted => 'Operação excluída';

  @override
  String get histCopiedToClipboard => 'Copiado para a área de transferência';

  @override
  String histCopiedClipboardText(String text) {
    return 'Copiado para a área de transferência: $text';
  }

  @override
  String get histFullResult => 'Resultado completo';

  @override
  String get histClose => 'Fechar';

  @override
  String get histExpression => 'Expressão:';

  @override
  String get histResult => 'Resultado:';

  @override
  String get histCopyResult => 'Copiar resultado';

  @override
  String get histCopyAll => 'Copiar tudo';

  @override
  String get histCopyExpression => 'Copiar expressão';

  @override
  String get histUseResult => 'Usar resultado';

  @override
  String get histViewResult => 'Ver resultado';

  @override
  String get histDelete => 'Excluir';

  @override
  String get histEmpty => 'Não há operações no histórico';

  @override
  String get histEmptyHint =>
      'Faça alguns cálculos para ver seu histórico aqui';

  @override
  String get histEmptyHintAlt => 'As operações que você fizer aparecerão aqui';

  @override
  String get histOperations => 'operações';

  @override
  String get histNow => 'Agora';

  @override
  String histErrorLoading(String error) {
    return 'Erro ao carregar o histórico: $error';
  }

  @override
  String histErrorClearing(String error) {
    return 'Erro ao limpar o histórico: $error';
  }

  @override
  String histErrorDeleting(String error) {
    return 'Erro ao excluir a operação: $error';
  }

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsNumberFormat => 'Formato dos números';

  @override
  String get settingsScientificNotation => 'Usar notação científica';

  @override
  String get settingsScientificHint =>
      'Os números serão exibidos por extenso (ex.: 123000) quando estiver desativado';

  @override
  String get settingsHighPrecision => 'Modo de alta precisão';

  @override
  String get settingsHighPrecisionHint =>
      'Calcula sin, cos, tan, ln, √… com reais construtivos exatos (mais lento). Singularidades como tan 90° são informadas como indefinido.';

  @override
  String settingsPrecisionDigits(int digits) {
    return 'Dígitos de precisão: $digits';
  }

  @override
  String get settingsOpenSourceLicenses => 'Licenças de código aberto';

  @override
  String get settingsFormatExamples => 'Exemplos de formato';

  @override
  String get settingsLargeNumber => 'Número grande:';

  @override
  String get settingsSmallNumber => 'Número pequeno:';

  @override
  String get settingsNormal => 'Normal:';

  @override
  String get settingsScientific => 'Científica:';

  @override
  String get settingsAboutApp => 'Sobre o aplicativo';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeAuto => 'Automático';

  @override
  String get themeLightDesc => 'Sempre usar o tema claro';

  @override
  String get themeDarkDesc => 'Sempre usar o tema escuro';

  @override
  String get themeAutoDesc => 'Seguir a configuração do sistema';

  @override
  String get aboutTitle => 'Super Calculadora';

  @override
  String get aboutDescription =>
      'Uma calculadora avançada com recursos científicos e análise numérica completa.';

  @override
  String get aboutFeatures => 'Recursos:';

  @override
  String get aboutClose => 'Fechar';

  @override
  String get aboutFeature1 => 'Números de até 1024 bits';

  @override
  String get aboutFeature2 => 'Precisão decimal de 64 bits';

  @override
  String get aboutFeature3 => 'Modo calculadora padrão e científica';

  @override
  String get aboutFeature4 => 'Funções trigonométricas (sin, cos, tan)';

  @override
  String get aboutFeature5 =>
      'Funções trigonométricas inversas (asin, acos, atan)';

  @override
  String get aboutFeature6 => 'Logaritmos naturais (ln) e de base 10 (log)';

  @override
  String get aboutFeature7 => 'Funções exponenciais (eˣ, 10ˣ)';

  @override
  String get aboutFeature8 => 'Cálculo de fatorial (n!)';

  @override
  String get aboutFeature9 => 'Constantes matemáticas (π, e)';

  @override
  String get aboutFeature10 => 'Potências e raízes (x², x³, √, ∛)';

  @override
  String get aboutFeature11 => 'Conversão entre graus e radianos';

  @override
  String get aboutFeature12 => 'Análise de números primos';

  @override
  String get aboutFeature13 => 'Decomposição em fatores primos';

  @override
  String get aboutFeature14 => 'Conversão binária e decimal';

  @override
  String get aboutFeature15 => 'Análise de propriedades matemáticas';

  @override
  String get aboutFeature16 => 'Operações com números extremamente grandes';

  @override
  String get aboutFeature17 =>
      'Cálculos pesados em threads separadas (isolates)';

  @override
  String get aboutFeature18 => 'Tratamento de erros de domínio e de tamanho';

  @override
  String get aboutFeature19 =>
      'Ferramentas de Olimpíada: 11 categorias exatas (frações, radicais, geometria, polinômios, álgebra, teoria dos números, matrizes…)';

  @override
  String get aboutFeature20 =>
      'Álgebra simbólica: desenvolvimento e identidades com várias variáveis';

  @override
  String get exprMathExpression => 'Expressão matemática';

  @override
  String get exprHideHistory => 'Ocultar histórico';

  @override
  String get exprShowHistory => 'Mostrar histórico';

  @override
  String get exprClearExpression => 'Limpar expressão';

  @override
  String get exprHint => 'Ex.: (5 + 3) * sqrt(9) - 2^3';

  @override
  String get exprDelete => 'Apagar';

  @override
  String get exprEvaluate => 'Avaliar (Enter)';

  @override
  String get exprParenthesis => 'Parênteses';

  @override
  String get exprSquareRoot => 'Raiz quadrada';

  @override
  String get exprPower => 'Potência';

  @override
  String get exprSin => 'Seno';

  @override
  String get exprCos => 'Cosseno';

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
  String get analysisEnterNumber => 'Digite um número para ver sua análise';

  @override
  String get analysisLoading => 'Analisando o número...';

  @override
  String get analysisLoadingHint =>
      'Isso pode levar alguns instantes para números grandes';

  @override
  String get analysisLimited => 'Análise limitada';

  @override
  String get analysisExtremelyLarge => 'Número Extremamente Grande';

  @override
  String analysisDigitsCount(String count) {
    return 'Dígitos: $count';
  }

  @override
  String get analysisPrimalityNote => 'Nota sobre a análise de primalidade';

  @override
  String analysisOriginalInput(String original, String analyzed) {
    return 'Entrada original: $original → Analisado: $analyzed';
  }

  @override
  String get analysisCalculatingPrimes => 'Calculando primos...';

  @override
  String get analysisSearchingPrimes =>
      'Procurando o primo anterior e o seguinte';

  @override
  String get analysisBasicProperties => 'Propriedades Básicas';

  @override
  String get analysisValue => 'Valor';

  @override
  String get analysisIsPrime => 'É primo';

  @override
  String get analysisDigits => 'Dígitos';

  @override
  String get analysisNextPrime => 'Próximo primo';

  @override
  String get analysisPrevPrime => 'Primo anterior';

  @override
  String get analysisDigitSum => 'Soma dos dígitos';

  @override
  String get analysisBinary => 'Binário';

  @override
  String get analysisYes => 'Sim';

  @override
  String get analysisNo => 'Não';

  @override
  String get analysisRepresentations => 'Representações';

  @override
  String get analysisOctal => 'Octal';

  @override
  String get analysisHex => 'Hexadecimal';

  @override
  String get analysisMathAnalysis => 'Análise Matemática';

  @override
  String get analysisIsPerfect => 'É perfeito';

  @override
  String get analysisIsPalindrome => 'É palíndromo';

  @override
  String get analysisIsFibonacci => 'É de Fibonacci';

  @override
  String get analysisIsTriangular => 'É triangular';

  @override
  String get analysisPrimeFactors => 'Fatoração em Primos';

  @override
  String get analysisPrimeFactorsLabel => 'Fatores primos';

  @override
  String get analysisDivisors => 'Divisores';

  @override
  String get analysisAllDivisors => 'Todos os divisores';

  @override
  String get analysisDivisorCount => 'Quantidade de divisores';

  @override
  String get analysisArithmeticFunctions => 'Funções Aritméticas';

  @override
  String get analysisEulerPhi => 'φ(n) Euler';

  @override
  String get analysisCarmichael => 'λ(n) Carmichael';

  @override
  String get analysisMobius => 'μ(n) Möbius';

  @override
  String get analysisSmallOmega => 'ω(n) primos distintos';

  @override
  String get analysisBigOmega => 'Ω(n) primos c/ mult.';

  @override
  String get analysisSopfr => 'sopfr(n) Σprimos rep.';

  @override
  String get analysisSopf => 'sopf(n) Σprimos dist.';

  @override
  String get analysisRadical => 'rad(n) radical';

  @override
  String get analysisDigitalRoot => 'Raiz digital';

  @override
  String get analysisClassification => 'Classificação';

  @override
  String get analysisSquareFree => 'Livre de quadrados';

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
  String get analysisOperations => 'Operações';

  @override
  String get analysisSquare => 'Quadrado';

  @override
  String get analysisCube => 'Cubo';

  @override
  String get analysisSquareRootLabel => 'Raiz quadrada';

  @override
  String get analysisIsPerfectSquare => 'É quadrado perfeito';

  @override
  String get analysisCubeRoot => 'Raiz cúbica';

  @override
  String get analysisIsPerfectCube => 'É cubo perfeito';

  @override
  String get analysisPerfectPower => 'Potência Perfeita';

  @override
  String get analysisExpression => 'Expressão';

  @override
  String get analysisBase => 'Base';

  @override
  String get analysisExponent => 'Expoente';

  @override
  String get cardPrime => 'Primo';

  @override
  String get cardPerfect => 'Perfeito';

  @override
  String get cardPalindrome => 'Palíndromo';

  @override
  String get cardFibonacci => 'Fibonacci';

  @override
  String get cardTriangular => 'Triangular';

  @override
  String get cardEven => 'Par';

  @override
  String get cardOdd => 'Ímpar';

  @override
  String get cardQuickProperties => 'Propriedades rápidas:';

  @override
  String get cardConvert => 'Converter:';

  @override
  String get cardToDecimal => 'Para Decimal';

  @override
  String get cardToBinary => 'Para Binário';

  @override
  String get cardAdvancedOps => 'Operações avançadas:';

  @override
  String get cardDigits => 'dígitos';

  @override
  String get kbdNumberTheory => 'Teoria dos Números';

  @override
  String get kbdModularArith => 'Aritmética Modular';

  @override
  String get kbdCombinatorics => 'Combinatória';

  @override
  String get kbdStatistics => 'Estatística';

  @override
  String errPower(String error) {
    return 'Erro na potência: $error';
  }

  @override
  String errSquareRoot(String error) {
    return 'Erro na raiz quadrada: $error';
  }

  @override
  String get errNegativeSqrt =>
      'Não é possível calcular a raiz quadrada de um número negativo';

  @override
  String errCubeRoot(String error) {
    return 'Erro na raiz cúbica: $error';
  }

  @override
  String errBinaryConversion(String error) {
    return 'Erro na conversão binária: $error';
  }

  @override
  String get errEmptyBinary => 'Número binário vazio';

  @override
  String get errInvalidBinary =>
      'O número deve conter apenas dígitos binários (0 e 1)';

  @override
  String errBinaryFromConversion(String error) {
    return 'Erro na conversão de binário: $error';
  }

  @override
  String get errTrigTooLarge =>
      'Número grande demais para funções trigonométricas';

  @override
  String errSin(String error) {
    return 'Erro no seno: $error';
  }

  @override
  String errCos(String error) {
    return 'Erro no cosseno: $error';
  }

  @override
  String get errTanUndefined => 'Tangente indefinida para este ângulo';

  @override
  String errTan(String error) {
    return 'Erro na tangente: $error';
  }

  @override
  String get errAsinDomain =>
      'O arco-seno só está definido para valores entre -1 e 1';

  @override
  String errAsin(String error) {
    return 'Erro no arco-seno: $error';
  }

  @override
  String get errAcosDomain =>
      'O arco-cosseno só está definido para valores entre -1 e 1';

  @override
  String errAcos(String error) {
    return 'Erro no arco-cosseno: $error';
  }

  @override
  String errAtan(String error) {
    return 'Erro na arco-tangente: $error';
  }

  @override
  String get errLnDomain =>
      'O logaritmo natural só está definido para números positivos';

  @override
  String get errLnTooLarge => 'Número grande demais para o logaritmo natural';

  @override
  String errLn(String error) {
    return 'Erro no logaritmo natural: $error';
  }

  @override
  String get errLogDomain =>
      'O logaritmo só está definido para números positivos';

  @override
  String get errLogTooLarge =>
      'Número grande demais para o logaritmo de base 10';

  @override
  String errLog(String error) {
    return 'Erro no logaritmo: $error';
  }

  @override
  String get errExpTooLarge => 'Número grande demais para a exponencial';

  @override
  String errExp(String error) {
    return 'Erro na exponencial: $error';
  }

  @override
  String get errTenPowTooLarge => 'Número grande demais para 10^x';

  @override
  String errTenPow(String error) {
    return 'Erro em 10^x: $error';
  }

  @override
  String get errFactorialInvalid => 'Número inválido para fatorial';

  @override
  String get errFactorialNonNeg =>
      'O fatorial só está definido para números inteiros não negativos';

  @override
  String get errFactorialTooLarge =>
      'Número grande demais para fatorial (máximo 170)';

  @override
  String errFactorial(String error) {
    return 'Erro no fatorial: $error';
  }

  @override
  String get errOperationCancelled => 'Operação cancelada';

  @override
  String errGeneric(String error) {
    return 'Erro: $error';
  }

  @override
  String get errPhiDomain => 'φ(n) só está definido para n > 0';

  @override
  String errPhi(String error) {
    return 'Erro em φ(n): $error';
  }

  @override
  String get errPrimorialDomain => 'O primorial só está definido para n ≥ 0';

  @override
  String errPrimorial(String error) {
    return 'Erro no primorial: $error';
  }

  @override
  String get errSigma0Domain => 'σ₀(n) só está definido para n > 0';

  @override
  String errSigma0(String error) {
    return 'Erro em σ₀(n): $error';
  }

  @override
  String get errSigmaDomain => 'σ(m,n) só está definido para n > 0';

  @override
  String errSigma(String error) {
    return 'Erro em σ(m,n): $error';
  }

  @override
  String errFloorCeil(String error) {
    return 'Erro em piso/teto: $error';
  }

  @override
  String get errMobiusDomain => 'μ(n) só está definido para n > 0';

  @override
  String errMobius(String error) {
    return 'Erro em μ(n): $error';
  }

  @override
  String get errFactorialNeg => 'O fatorial não está definido para negativos';

  @override
  String get errFactorialMax => 'n! grande demais (máx n=10000)';

  @override
  String errFactorialN(String error) {
    return 'Erro em n!: $error';
  }

  @override
  String get errDoubleFactorialNeg =>
      'O fatorial duplo não está definido para negativos';

  @override
  String errDoubleFactorial(String error) {
    return 'Erro em n!!: $error';
  }

  @override
  String get errFibonacciNeg => 'F(n) não está definido para n < 0';

  @override
  String errFibonacci(String error) {
    return 'Erro em F(n): $error';
  }

  @override
  String get errCatalanNeg => 'Catalan não está definido para n < 0';

  @override
  String errCatalan(String error) {
    return 'Erro em Catalan: $error';
  }

  @override
  String get errDerangementNeg => 'D(n) não está definido para n < 0';

  @override
  String errDerangement(String error) {
    return 'Erro em D(n): $error';
  }

  @override
  String get errPartitionNeg => 'p(n) não está definido para n < 0';

  @override
  String errPartition(String error) {
    return 'Erro em p(n): $error';
  }

  @override
  String get errBellNeg => 'B(n) não está definido para n < 0';

  @override
  String errBell(String error) {
    return 'Erro em Bell(n): $error';
  }

  @override
  String errDigitalRoot(String error) {
    return 'Erro na raiz digital: $error';
  }

  @override
  String get errPrimitiveRootDomain => 'É necessário n > 1';

  @override
  String errNoPrimitiveRoot(String n) {
    return 'Não existe raiz primitiva mod $n';
  }

  @override
  String get errLiouvilleDomain => 'λ_L(n) só está definido para n > 0';

  @override
  String errLiouville(String error) {
    return 'Erro em λ_L(n): $error';
  }

  @override
  String errPrimeCounting(String error) {
    return 'Erro em π(n): $error';
  }

  @override
  String get errRadDomain => 'rad(n) só está definido para n > 0';

  @override
  String errRad(String error) {
    return 'Erro em rad(n): $error';
  }

  @override
  String get errOmegaDomain => 'ω(n) só está definido para n > 0';

  @override
  String errOmega(String error) {
    return 'Erro em ω(n): $error';
  }

  @override
  String get errBigOmegaDomain => 'Ω(n) só está definido para n > 0';

  @override
  String errBigOmega(String error) {
    return 'Erro em Ω(n): $error';
  }

  @override
  String get errCarmichaelDomain => 'λ(n) só está definido para n > 0';

  @override
  String errCarmichael(String error) {
    return 'Erro em λ(n): $error';
  }

  @override
  String get errSopfrDomain => 'sopfr(n) só está definido para n > 0';

  @override
  String errSopfr(String error) {
    return 'Erro em sopfr(n): $error';
  }

  @override
  String get errSopfDomain => 'sopf(n) só está definido para n > 0';

  @override
  String errSopf(String error) {
    return 'Erro em sopf(n): $error';
  }

  @override
  String errPercentage(String error) {
    return 'Erro na porcentagem: $error';
  }

  @override
  String get errDivisionByZero => 'Divisão por zero';

  @override
  String errReciprocal(String error) {
    return 'Erro no recíproco: $error';
  }

  @override
  String errNoInverse(String a, String n) {
    return 'Não existe inverso modular de $a mod $n';
  }

  @override
  String errModPow(String error) {
    return 'Erro na exponenciação modular: $error';
  }

  @override
  String errDiophantine(String error) {
    return 'Erro na equação diofantina: $error';
  }

  @override
  String errCRT(String error) {
    return 'Erro no TCR: $error';
  }

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLangAuto => 'Automático (do sistema)';

  @override
  String get settingsLangAutoDesc => 'Usar o idioma do dispositivo';

  @override
  String get settingsLangEs => 'Español';

  @override
  String get settingsLangEn => 'English';

  @override
  String get settingsLangPt => 'Português';

  @override
  String get settingsLangFr => 'Français';

  @override
  String get settingsLangIt => 'Italiano';

  @override
  String get settingsLangRu => 'Русский';

  @override
  String get settingsLangVi => 'Tiếng Việt';

  @override
  String get settingsLangId => 'Bahasa Indonesia';

  @override
  String get hlpTitle => 'Guia de Funções Especiais';

  @override
  String get hlpQuickStartHeader => 'Início Rápido';

  @override
  String get hlpQuickStartWelcome => 'Bem-vindo à calculadora para olimpíadas';

  @override
  String get hlpQuickStartStep1 =>
      'Abra o menu lateral (☰) e selecione \"Funções Especiais\"';

  @override
  String get hlpQuickStartStep2 =>
      'O teclado superior (rolável) tem ~40 funções em 4 seções';

  @override
  String get hlpQuickStartStep3 =>
      'Digite um número e pressione qualquer botão de função';

  @override
  String get hlpQuickStartStep4 =>
      'Se a função precisar de mais valores, aparece um indicador de operação pendente';

  @override
  String get hlpQuickStartStep5 =>
      'O painel lateral mostra a análise automática do número digitado';

  @override
  String get hlpQuickStartNote =>
      'As funções de 1 parâmetro são executadas imediatamente.\nAs de 2 ou mais parâmetros mostram um indicador e aguardam mais valores.';

  @override
  String get hlpParamHeader => 'Sistema de Parâmetros';

  @override
  String get hlpParamTypesTitle => 'Tipos de função conforme os parâmetros';

  @override
  String get hlpParam1Title => '1 parâmetro (imediatas)';

  @override
  String get hlpParam1Desc =>
      'Digite o número → Pressione a função → Resultado';

  @override
  String get hlpParam1Example =>
      'Ex.: φ(12) → digite 12, pressione φ → mostra 4';

  @override
  String get hlpParam2Title => '2-3-4 parâmetros (fixos)';

  @override
  String get hlpParam2Desc =>
      'Digite o valor → Função → Valor → = → (repita se precisar de mais)\nExecuta sozinha ao completar todos os parâmetros.';

  @override
  String get hlpParam2Example => 'Ex.: C(10,3) → digite 10 → C(n,k) → 3 → =';

  @override
  String get hlpParamNTitle => 'N parâmetros (variáveis)';

  @override
  String get hlpParamNDesc =>
      'Digite o valor → Função → Valor → = (acrescenta mais)\nPressione a MESMA FUNÇÃO de novo para executar.';

  @override
  String get hlpParamNExample =>
      'Ex.: MDC(12,18,24) → 12 → MDC → 18 → = → 24 → MDC';

  @override
  String get hlpPendingOpTitle => 'Indicador de operação pendente';

  @override
  String get hlpPendingOpDesc =>
      'Quando uma função aguarda mais valores, aparece um indicador colorido na tela mostrando qual operação está em curso e o que falta.\n\nExemplo: \"C(10, _)\" indica que falta o k para completar C(n,k).\n\"MDC(12, 18, _) [= acrescentar, MDC resolver]\" indica uma operação variável.';

  @override
  String get hlpNumberTheoryHeader => 'Teoria dos Números';

  @override
  String get hlpEulerPhiTitle => 'φ(n) — Função de Euler (Totiente)';

  @override
  String get hlpEulerPhiParams => '1 param';

  @override
  String get hlpEulerPhiDesc =>
      'Conta quantos inteiros de 1 a n são coprimos com n (ou seja, MDC(k,n)=1).';

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
      'Multiplicativa: φ(mn) = φ(m)φ(n) se MDC(m,n)=1';

  @override
  String get hlpEulerPhiTip2 =>
      'Teorema de Euler: a^φ(n) ≡ 1 (mod n) se MDC(a,n)=1';

  @override
  String get hlpEulerPhiTip3 => 'Σ φ(d) para d|n = n';

  @override
  String get hlpCarmichaelTitle => 'λ(n) — Função λ de Carmichael';

  @override
  String get hlpCarmichaelParams => '1 param';

  @override
  String get hlpCarmichaelDesc =>
      'Menor m > 0 tal que a^m ≡ 1 (mod n) para TODO a coprimo com n. Sempre divide φ(n).';

  @override
  String get hlpCarmichaelFormula =>
      'λ(p^k) = φ(p^k) se p ímpar\nλ(2)=1, λ(4)=2, λ(2^k)=2^(k−2) se k≥3\nλ(n) = mmc das partes';

  @override
  String get hlpCarmichaelEx1 => 'λ(8) = 2';

  @override
  String get hlpCarmichaelEx2 => 'λ(15) = mmc(λ(3),λ(5)) = mmc(2,4) = 4';

  @override
  String get hlpCarmichaelEx3 => 'λ(p) = p−1 para p primo';

  @override
  String get hlpCarmichaelTip1 => 'λ(n) | φ(n) sempre';

  @override
  String get hlpCarmichaelTip2 =>
      'λ(n) = φ(n) se e somente se n tem raiz primitiva';

  @override
  String get hlpMobiusTitle => 'μ(n) — Função de Möbius';

  @override
  String get hlpMobiusParams => '1 param';

  @override
  String get hlpMobiusDesc =>
      'Detecta se n é livre de quadrados e conta os fatores primos.';

  @override
  String get hlpMobiusFormula =>
      'μ(1) = 1\nμ(n) = (−1)^k se n = p₁·p₂·...·pₖ (distintos)\nμ(n) = 0 se p² | n';

  @override
  String get hlpMobiusEx1 => 'μ(1) = 1';

  @override
  String get hlpMobiusEx2 => 'μ(6) = μ(2×3) = (−1)² = 1';

  @override
  String get hlpMobiusEx3 => 'μ(30) = μ(2×3×5) = (−1)³ = −1';

  @override
  String get hlpMobiusEx4 => 'μ(12) = 0 (tem 2²)';

  @override
  String get hlpMobiusTip1 =>
      'Inversão de Möbius: se g(n) = Σ f(d) para d|n, então f(n) = Σ μ(d)g(n/d)';

  @override
  String get hlpMobiusTip2 => 'Σ μ(d) para d|n = [n=1]';

  @override
  String get hlpLiouvilleTitle => 'λL(n) — Função de Liouville';

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
      'Σ λL(d) para d|n = 1 se n é quadrado perfeito, 0 caso contrário';

  @override
  String get hlpSmallOmegaTitle => 'ω(n) — Fatores Primos Distintos';

  @override
  String get hlpSmallOmegaParams => '1 param';

  @override
  String get hlpSmallOmegaDesc =>
      'Conta a quantidade de primos distintos que dividem n.';

  @override
  String get hlpSmallOmegaFormula => 'ω(n) = k se n = p₁^a₁ × ... × pₖ^aₖ';

  @override
  String get hlpSmallOmegaEx1 => 'ω(12) = 2 → [2, 3]';

  @override
  String get hlpSmallOmegaEx2 => 'ω(30) = 3 → [2, 3, 5]';

  @override
  String get hlpSmallOmegaEx3 => 'ω(p^k) = 1';

  @override
  String get hlpBigOmegaTitle => 'Ω(n) — Fatores Primos com Multiplicidade';

  @override
  String get hlpBigOmegaParams => '1 param';

  @override
  String get hlpBigOmegaDesc =>
      'Número total de fatores primos contando as repetições.';

  @override
  String get hlpBigOmegaFormula => 'Ω(n) = a₁ + a₂ + ... + aₖ';

  @override
  String get hlpBigOmegaEx1 => 'Ω(12) = 3 → 2×2×3';

  @override
  String get hlpBigOmegaEx2 => 'Ω(72) = 5 → 2³×3² → 3+2';

  @override
  String get hlpBigOmegaEx3 => 'Ω(p) = 1, Ω(p²) = 2';

  @override
  String get hlpSigma0Title => 'σ₀(n) — Quantidade de Divisores';

  @override
  String get hlpSigma0Params => '1 param';

  @override
  String get hlpSigma0Desc => 'Número total de divisores positivos de n.';

  @override
  String get hlpSigma0Formula =>
      'Se n = p₁^a₁ × ... × pₖ^aₖ\nσ₀(n) = (a₁+1)(a₂+1)...(aₖ+1)';

  @override
  String get hlpSigma0Ex1 => 'σ₀(12) = 6 → [1,2,3,4,6,12]';

  @override
  String get hlpSigma0Ex2 => 'σ₀(p) = 2';

  @override
  String get hlpSigma0Ex3 => 'σ₀(p²) = 3';

  @override
  String get hlpSigmaTitle => 'σ(n) — Soma dos Divisores';

  @override
  String get hlpSigmaParams => '1 param';

  @override
  String get hlpSigmaDesc => 'Soma de todos os divisores positivos de n.';

  @override
  String get hlpSigmaFormula => 'σ(n) = Σ d para d | n';

  @override
  String get hlpSigmaEx1 => 'σ(6) = 1+2+3+6 = 12 (6 é perfeito)';

  @override
  String get hlpSigmaEx2 => 'σ(12) = 1+2+3+4+6+12 = 28';

  @override
  String get hlpSigmaEx3 => 'σ(p) = p+1';

  @override
  String get hlpSigmaTip1 => 'n é perfeito ⟺ σ(n) = 2n';

  @override
  String get hlpSigmaTip2 => 'n é abundante ⟺ σ(n) > 2n';

  @override
  String get hlpSopfrTitle => 'sopfr(n) — Soma dos Primos com Repetição';

  @override
  String get hlpSopfrParams => '1 param';

  @override
  String get hlpSopfrDesc =>
      'Soma os fatores primos contando a multiplicidade.';

  @override
  String get hlpSopfrFormula => 'sopfr(n) = a₁p₁ + a₂p₂ + ... + aₖpₖ';

  @override
  String get hlpSopfrEx1 => 'sopfr(12) = 2+2+3 = 7';

  @override
  String get hlpSopfrEx2 => 'sopfr(60) = 2+2+3+5 = 12';

  @override
  String get hlpSopfTitle => 'sopf(n) — Soma dos Primos Distintos';

  @override
  String get hlpSopfParams => '1 param';

  @override
  String get hlpSopfDesc => 'Soma dos primos distintos que dividem n.';

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
      'Produto dos primos distintos que dividem n (função da Conjectura ABC).';

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
  String get hlpPrimorialDesc => 'Produto de todos os primos ≤ n.';

  @override
  String get hlpPrimorialFormula => 'n# = ∏ p para p primo, p ≤ n';

  @override
  String get hlpPrimorialEx1 => '5# = 2×3×5 = 30';

  @override
  String get hlpPrimorialEx2 => '7# = 210';

  @override
  String get hlpPrimorialEx3 => '11# = 2310';

  @override
  String get hlpPrimeCountTitle => 'π(n) — Função de Contagem de Primos';

  @override
  String get hlpPrimeCountParams => '1 param';

  @override
  String get hlpPrimeCountDesc =>
      'Conta os primos ≤ n. Exato para n ≤ 1 000 000; aproximação Li(x) para maiores.';

  @override
  String get hlpPrimeCountFormula =>
      'π(n) ~ n/ln(n) (Teorema dos Números Primos)';

  @override
  String get hlpPrimeCountEx1 => 'π(10) = 4';

  @override
  String get hlpPrimeCountEx2 => 'π(100) = 25';

  @override
  String get hlpPrimeCountEx3 => 'π(1 000 000) = 78 498';

  @override
  String get hlpDigitalRootTitle => 'dr(n) — Raiz Digital';

  @override
  String get hlpDigitalRootParams => '1 param';

  @override
  String get hlpDigitalRootDesc =>
      'Soma iterativa dos dígitos até obter um único dígito.';

  @override
  String get hlpDigitalRootFormula => 'dr(n) = 1 + (n−1) mod 9  (para n > 0)';

  @override
  String get hlpDigitalRootEx1 => 'dr(493) → 4+9+3=16 → 1+6 = 7';

  @override
  String get hlpDigitalRootEx2 => 'dr(999) = 9';

  @override
  String get hlpDigitalRootEx3 => 'dr(n) ≡ n (mod 9)';

  @override
  String get hlpFloorCeilTitle => '⌊x⌋ / ⌈x⌉ — Piso e Teto';

  @override
  String get hlpFloorCeilParams => '1 param';

  @override
  String get hlpFloorCeilDesc =>
      'Piso: maior inteiro ≤ x. Teto: menor inteiro ≥ x. Alterna entre os dois.';

  @override
  String get hlpFloorCeilFormula => '⌊x⌋ ≤ x < ⌊x⌋+1\n⌈x⌉−1 < x ≤ ⌈x⌉';

  @override
  String get hlpFloorCeilEx1 => '⌊3.7⌋ = 3, ⌈3.7⌉ = 4';

  @override
  String get hlpFloorCeilEx2 => '⌊−2.3⌋ = −3, ⌈−2.3⌉ = −2';

  @override
  String get hlpFloorCeilEx3 => '⌊5⌋ = ⌈5⌉ = 5';

  @override
  String get hlpPadicTitle => 'Vₚ(n) — Valuação p-ádica';

  @override
  String get hlpPadicParams => '2 params: n → Vₚ → p → =';

  @override
  String get hlpPadicDesc => 'Maior potência do primo p que divide n.';

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
  String get hlpModTitle => 'a mod b — Resto da Divisão';

  @override
  String get hlpModParams => '2 params: a → mod → b → =';

  @override
  String get hlpModDesc => 'Resto da divisão de a por b.';

  @override
  String get hlpModFormula => 'a mod b = a − b × ⌊a/b⌋';

  @override
  String get hlpModEx1 => '17 mod 5 = 2';

  @override
  String get hlpModEx2 => '23 mod 7 = 2';

  @override
  String get hlpModEx3 => '−8 mod 3 = 1';

  @override
  String get hlpModPowTitle => 'a^b mod n — Exponenciação Modular';

  @override
  String get hlpModPowParams => '3 params: a → a%n → b → = → n → =';

  @override
  String get hlpModPowDesc =>
      'Calcula a^b mod n de forma eficiente usando quadratura repetida O(log b).';

  @override
  String get hlpModPowFormula =>
      'Decompõe-se b em binário e eleva-se ao quadrado sucessivamente';

  @override
  String get hlpModPowEx1 => '2¹⁰⁰ mod 7 = 2';

  @override
  String get hlpModPowEx2 => '3¹³ mod 11 = 5';

  @override
  String get hlpModPowEx3 => 'Fundamental em RSA e em testes de primalidade';

  @override
  String get hlpModPowTip1 =>
      'Fluxo: digite a → pressione a%n → digite b → pressione = → digite n → pressione =';

  @override
  String get hlpModInvTitle => 'a⁻¹ mod n — Inverso Modular';

  @override
  String get hlpModInvParams => '2 params: a → a⁻¹ → n → =';

  @override
  String get hlpModInvDesc =>
      'Encontra b tal que a×b ≡ 1 (mod n). Só existe se MDC(a,n) = 1.';

  @override
  String get hlpModInvFormula => 'Algoritmo estendido de Euclides';

  @override
  String get hlpModInvEx1 => '3⁻¹ mod 7 = 5 → 3×5=15≡1';

  @override
  String get hlpModInvEx2 => '5⁻¹ mod 11 = 9 → 5×9=45≡1';

  @override
  String get hlpModInvEx3 => 'Não existe se MDC(a,n) ≠ 1';

  @override
  String get hlpOrdTitle => 'ord_n(a) — Ordem Multiplicativa';

  @override
  String get hlpOrdParams => '2 params: a → ord → n → =';

  @override
  String get hlpOrdDesc =>
      'Menor k > 0 com a^k ≡ 1 (mod n). Requer MDC(a,n)=1.';

  @override
  String get hlpOrdFormula => 'ord_n(a) = min[k > 0 : a^k ≡ 1 (mod n)]';

  @override
  String get hlpOrdEx1 => 'ord₇(2) = 3 → 2³=8≡1';

  @override
  String get hlpOrdEx2 => 'ord₁₀(3) = 4 → 3⁴=81≡1';

  @override
  String get hlpOrdTip1 => 'ord_n(a) sempre divide φ(n)';

  @override
  String get hlpOrdTip2 => 'a é raiz primitiva ⟺ ord_n(a) = φ(n)';

  @override
  String get hlpLegendreTitle => '(a/p) — Símbolo de Legendre';

  @override
  String get hlpLegendreParams => '2 params: a → (a/p) → p → =';

  @override
  String get hlpLegendreDesc =>
      '1 se a é resíduo quadrático mod p, −1 se não é, 0 se p|a. Requer p primo ímpar.';

  @override
  String get hlpLegendreFormula =>
      '(a/p) ≡ a^((p−1)/2) (mod p) — Critério de Euler';

  @override
  String get hlpLegendreEx1 => '(2/7) = 1 → 3²≡2 (mod 7)';

  @override
  String get hlpLegendreEx2 => '(3/7) = −1 → não existe x²≡3';

  @override
  String get hlpLegendreEx3 => '(5/5) = 0';

  @override
  String get hlpJacobiTitle => '(a/n)ⱼ — Símbolo de Jacobi';

  @override
  String get hlpJacobiParams => '2 params: a → (a/n)ⱼ → n → =';

  @override
  String get hlpJacobiDesc =>
      'Generalização de Legendre para n composto ímpar. Usa a reciprocidade quadrática.';

  @override
  String get hlpJacobiFormula => '(a/n) = ∏(a/pᵢ)^eᵢ onde n = ∏pᵢ^eᵢ';

  @override
  String get hlpJacobiEx1 => '(2/15) = (2/3)(2/5) = (−1)(−1) = 1';

  @override
  String get hlpJacobiEx2 => '(a/n) = −1 ⟹ a NÃO é resíduo quadrático';

  @override
  String get hlpJacobiEx3 => '(a/n) = 1 NÃO garante que seja';

  @override
  String get hlpPrimRootTitle => 'g — Raiz Primitiva';

  @override
  String get hlpPrimRootParams => '1 param';

  @override
  String get hlpPrimRootDesc =>
      'Menor raiz primitiva mod n (se existir). g é raiz primitiva se ord_n(g) = φ(n).';

  @override
  String get hlpPrimRootFormula => '[g, g², ..., g^φ(n)] = (Z/nZ)*';

  @override
  String get hlpPrimRootEx1 => 'g(7) = 3 → [3,2,6,4,5,1]';

  @override
  String get hlpPrimRootEx2 => 'g(11) = 2';

  @override
  String get hlpPrimRootEx3 => 'Existe apenas para n = 1,2,4,p^k,2p^k';

  @override
  String get hlpGcdTitle => 'MDC — Máximo Divisor Comum';

  @override
  String get hlpGcdParams => 'N params (variável, mín. 2)';

  @override
  String get hlpGcdDesc =>
      'Maior inteiro que divide todos os valores. Aceita 2 ou mais números.';

  @override
  String get hlpGcdFormula => 'MDC(a,b) pelo algoritmo de Euclides';

  @override
  String get hlpGcdEx1 => 'MDC(12,18) = 6';

  @override
  String get hlpGcdEx2 => 'MDC(12,18,24) = 6';

  @override
  String get hlpGcdEx3 => 'MDC(a,b) × MMC(a,b) = a×b';

  @override
  String get hlpGcdTip1 => 'Fluxo: 12 → MDC → 18 → MDC (executa)';

  @override
  String get hlpGcdTip2 =>
      'Para 3 ou mais números: 12 → MDC → 18 → = → 24 → MDC';

  @override
  String get hlpGcdTip3 =>
      'Pressione = para acrescentar mais, pressione MDC para executar';

  @override
  String get hlpLcmTitle => 'MMC — Mínimo Múltiplo Comum';

  @override
  String get hlpLcmParams => 'N params (variável, mín. 2)';

  @override
  String get hlpLcmDesc =>
      'Menor inteiro positivo divisível por todos os valores.';

  @override
  String get hlpLcmFormula => 'MMC(a,b) = a×b / MDC(a,b)';

  @override
  String get hlpLcmEx1 => 'MMC(4,6) = 12';

  @override
  String get hlpLcmEx2 => 'MMC(3,5,7) = 105';

  @override
  String get hlpLcmTip1 =>
      'Mesmo fluxo do MDC: pressione MMC de novo para executar';

  @override
  String get hlpDiophTitle => 'Diof — Equação Diofantina Linear';

  @override
  String get hlpDiophParams => '3 params: a → Diof → b → = → c → =';

  @override
  String get hlpDiophDesc =>
      'Resolve ax + by = c. Fornece a solução particular e a geral.';

  @override
  String get hlpDiophFormula =>
      'ax + by = c tem solução ⟺ MDC(a,b) | c\nx = x₀ + (b/g)t,  y = y₀ − (a/g)t';

  @override
  String get hlpDiophEx1 => '3x + 5y = 1 → x=2+5t, y=−1−3t';

  @override
  String get hlpDiophEx2 => '6x + 9y = 12 → x=2+3t, y=0−2t';

  @override
  String get hlpDiophEx3 => '4x + 6y = 3 → Sem solução';

  @override
  String get hlpDiophTip1 => 'Passo 1: digite a (coeficiente de x)';

  @override
  String get hlpDiophTip2 => 'Passo 2: pressione Diof';

  @override
  String get hlpDiophTip3 =>
      'Passo 3: digite b (coeficiente de y), pressione =';

  @override
  String get hlpDiophTip4 =>
      'Passo 4: digite c (termo independente), pressione =';

  @override
  String get hlpCrtTitle => 'TCR — Teorema Chinês do Resto';

  @override
  String get hlpCrtParams => 'Variável (4+ params em pares a,m)';

  @override
  String get hlpCrtDesc =>
      'Resolve um sistema de congruências x ≡ aᵢ (mod mᵢ).';

  @override
  String get hlpCrtFormula =>
      'x ≡ a₁ (mod m₁)\nx ≡ a₂ (mod m₂)\n→ x ≡ r (mod mmc(m₁,m₂))';

  @override
  String get hlpCrtEx1 => 'x≡2(mod 3), x≡3(mod 5) → x≡8(mod 15)';

  @override
  String get hlpCrtEx2 => 'x≡1(mod 4), x≡2(mod 3) → x≡5(mod 12)';

  @override
  String get hlpCrtTip1 => 'Fluxo: a₁ → TCR → m₁ → = → a₂ → = → m₂ → TCR';

  @override
  String get hlpCrtTip2 => 'Os módulos devem ser compatíveis';

  @override
  String get hlpCombinatoricsHeader => 'Combinatória';

  @override
  String get hlpFactorialTitle => 'n! — Fatorial';

  @override
  String get hlpFactorialParams => '1 param';

  @override
  String get hlpFactorialDesc => 'Produto de 1 até n. Precisão arbitrária.';

  @override
  String get hlpFactorialFormula => 'n! = 1 × 2 × ... × n,  0! = 1';

  @override
  String get hlpFactorialEx1 => '5! = 120';

  @override
  String get hlpFactorialEx2 => '10! = 3 628 800';

  @override
  String get hlpFactorialEx3 => '20! = 2 432 902 008 176 640 000';

  @override
  String get hlpDblFactorialTitle => 'n!! — Fatorial Duplo';

  @override
  String get hlpDblFactorialParams => '1 param';

  @override
  String get hlpDblFactorialDesc => 'Produto dos inteiros de mesma paridade.';

  @override
  String get hlpDblFactorialFormula => 'n!! = n × (n−2) × (n−4) × ...';

  @override
  String get hlpDblFactorialEx1 => '7!! = 7×5×3×1 = 105';

  @override
  String get hlpDblFactorialEx2 => '8!! = 8×6×4×2 = 384';

  @override
  String get hlpDblFactorialEx3 => '0!! = 1!! = 1';

  @override
  String get hlpCombTitle => 'C(n,k) — Combinações';

  @override
  String get hlpCombParams => '2 params: n → C(n,k) → k → =';

  @override
  String get hlpCombDesc =>
      'Maneiras de escolher k entre n, sem importar a ordem.';

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
      'Identidade de Pascal: C(n,k) = C(n−1,k−1) + C(n−1,k)';

  @override
  String get hlpCombTip2 => 'C(n,k) = C(n, n−k)';

  @override
  String get hlpVarTitle => 'V(n,k) — Arranjos (permutações parciais)';

  @override
  String get hlpVarParams => '2 params: n → V(n,k) → k → =';

  @override
  String get hlpVarDesc => 'Maneiras de escolher k entre n COM ordem.';

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
      'Conta árvores binárias, triangulações, caminhos de Dyck e parênteses balanceados.';

  @override
  String get hlpCatalanFormula => 'Cₙ = C(2n,n)/(n+1)';

  @override
  String get hlpCatalanEx1 => 'C₀ = 1, C₁ = 1, C₂ = 2';

  @override
  String get hlpCatalanEx2 => 'C₃ = 5, C₄ = 14, C₅ = 42';

  @override
  String get hlpDerangementTitle => 'D(n) — Derangements (desarranjos)';

  @override
  String get hlpDerangementParams => '1 param';

  @override
  String get hlpDerangementDesc =>
      'Permutações em que nenhum elemento fica na sua posição original.';

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
      'Número total de partições de um conjunto de n elementos.';

  @override
  String get hlpBellFormula => 'B(n) = Σ S₂(n,k) para k=0..n';

  @override
  String get hlpBellEx1 => 'B(3) = 5';

  @override
  String get hlpBellEx2 => 'B(4) = 15';

  @override
  String get hlpBellEx3 => 'B(5) = 52';

  @override
  String get hlpPartitionTitle => 'p(n) — Partições de Inteiros';

  @override
  String get hlpPartitionParams => '1 param';

  @override
  String get hlpPartitionDesc =>
      'Maneiras de escrever n como soma de inteiros positivos (a ordem não importa).';

  @override
  String get hlpPartitionFormula => 'Calculado com programação dinâmica';

  @override
  String get hlpPartitionEx1 => 'p(4) = 5 → [4, 3+1, 2+2, 2+1+1, 1+1+1+1]';

  @override
  String get hlpPartitionEx2 => 'p(10) = 42';

  @override
  String get hlpPartitionEx3 => 'p(100) = 190 569 292 356';

  @override
  String get hlpStirling2Title => 'S₂(n,k) — Stirling de 2ª Espécie';

  @override
  String get hlpStirling2Params => '2 params: n → S₂ → k → =';

  @override
  String get hlpStirling2Desc =>
      'Maneiras de particionar n elementos em exatamente k subconjuntos não vazios.';

  @override
  String get hlpStirling2Formula => 'S₂(n,k) = k·S₂(n−1,k) + S₂(n−1,k−1)';

  @override
  String get hlpStirling2Ex1 => 'S₂(4,2) = 7';

  @override
  String get hlpStirling2Ex2 => 'S₂(5,3) = 25';

  @override
  String get hlpStirling2Ex3 => 'B(n) = Σ S₂(n,k)';

  @override
  String get hlpStirling1Title =>
      's₁(n,k) — Stirling de 1ª Espécie (sem sinal)';

  @override
  String get hlpStirling1Params => '2 params: n → s₁ → k → =';

  @override
  String get hlpStirling1Desc =>
      'Permutações de n elementos com exatamente k ciclos.';

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
      'Calcula F(n) com duplicação rápida O(log n). Suporta n muito grandes.';

  @override
  String get hlpFibFormula => 'F(0)=0, F(1)=1, F(n)=F(n−1)+F(n−2)';

  @override
  String get hlpFibEx1 => 'F(10) = 55';

  @override
  String get hlpFibEx2 => 'F(50) = 12 586 269 025';

  @override
  String get hlpFibEx3 => 'F(100) = 354 224 848 179 261 915 075';

  @override
  String get hlpFibTip1 => 'F(n) mod m é periódico (período de Pisano)';

  @override
  String get hlpFibTip2 => 'MDC(F(m), F(n)) = F(MDC(m,n))';

  @override
  String get hlpDigitSumBaseTitle => 'ΣdígB — Soma dos Dígitos na Base b';

  @override
  String get hlpDigitSumBaseParams => '2 params: n → ΣdígB → b → =';

  @override
  String get hlpDigitSumBaseDesc => 'Soma os dígitos de n escritos na base b.';

  @override
  String get hlpDigitSumBaseFormula => 'Se n = Σ dᵢ × bⁱ, então ΣdígB = Σ dᵢ';

  @override
  String get hlpDigitSumBaseEx1 => 'ΣdígB(255, 2) = 8 → 11111111₂';

  @override
  String get hlpDigitSumBaseEx2 => 'ΣdígB(100, 10) = 1';

  @override
  String get hlpDigitSumBaseEx3 => 'ΣdígB(100, 16) = 10 → 64₁₆';

  @override
  String get hlpStatisticsHeader => 'Estatística';

  @override
  String get hlpArithMeanTitle => 'Média Aritmética — Méd A';

  @override
  String get hlpArithMeanParams => 'N params (variável, mín. 2)';

  @override
  String get hlpArithMeanDesc => 'Média clássica de N números.';

  @override
  String get hlpArithMeanFormula => 'MA = (x₁ + x₂ + ... + xₙ) / n';

  @override
  String get hlpArithMeanEx1 => 'MA(3, 7) = 5';

  @override
  String get hlpArithMeanEx2 => 'MA(2, 4, 6) = 4';

  @override
  String get hlpArithMeanTip1 => 'Fluxo: 3 → Méd A → 7 → Méd A (executa)';

  @override
  String get hlpArithMeanTip2 =>
      'Para 3 ou mais números: 2 → Méd A → 4 → = → 6 → Méd A';

  @override
  String get hlpGeoMeanTitle => 'Média Geométrica — Méd G';

  @override
  String get hlpGeoMeanParams => 'N params (variável, mín. 2)';

  @override
  String get hlpGeoMeanDesc =>
      'Raiz n-ésima do produto. Somente valores positivos.';

  @override
  String get hlpGeoMeanFormula => 'MG = (x₁ × x₂ × ... × xₙ)^(1/n)';

  @override
  String get hlpGeoMeanEx1 => 'MG(2, 8) = 4';

  @override
  String get hlpGeoMeanEx2 => 'MG(1, 4, 9) ≈ 3.30';

  @override
  String get hlpHarmMeanTitle => 'Média Harmônica — Méd H';

  @override
  String get hlpHarmMeanParams => 'N params (variável, mín. 2)';

  @override
  String get hlpHarmMeanDesc =>
      'Inverso da média aritmética dos inversos. Somente valores positivos.';

  @override
  String get hlpHarmMeanFormula => 'MH = n / (1/x₁ + 1/x₂ + ... + 1/xₙ)';

  @override
  String get hlpHarmMeanEx1 => 'MH(2, 8) = 3.2';

  @override
  String get hlpHarmMeanEx2 => 'MH(1, 4, 9) ≈ 2.08';

  @override
  String get hlpQuadMeanTitle => 'Média Quadrática — Méd Q';

  @override
  String get hlpQuadMeanParams => 'N params (variável, mín. 2)';

  @override
  String get hlpQuadMeanDesc => 'Raiz da média dos quadrados (RMS).';

  @override
  String get hlpQuadMeanFormula => 'MQ = √((x₁² + x₂² + ... + xₙ²) / n)';

  @override
  String get hlpQuadMeanEx1 => 'MQ(3, 4) ≈ 3.54';

  @override
  String get hlpQuadMeanEx2 => 'MQ(1, 2, 3) ≈ 2.16';

  @override
  String get hlpMinMaxTitle => 'min / max — Mínimo e Máximo';

  @override
  String get hlpMinMaxParams => 'N params (variável, mín. 2)';

  @override
  String get hlpMinMaxDesc =>
      'Encontra o menor/maior valor de um conjunto de N números.';

  @override
  String get hlpMinMaxFormula => 'min(a₁,...,aₙ) e max(a₁,...,aₙ)';

  @override
  String get hlpMinMaxEx1 => 'min(3, 7, 1) = 1';

  @override
  String get hlpMinMaxEx2 => 'max(3, 7, 1) = 7';

  @override
  String get hlpMinMaxTip1 =>
      'Mesmo fluxo variável: pressione min/max de novo para executar';

  @override
  String get hlpMeanInequalityTitle => 'Desigualdade das Médias (MA-MG-MH)';

  @override
  String get hlpMeanInequalityContent =>
      'Para números positivos vale sempre:\n\nMH ≤ MG ≤ MA ≤ MQ\n\nA igualdade ocorre apenas quando todos os valores são iguais.\nEssa desigualdade é fundamental em olimpíadas.';

  @override
  String get hlpAnalysisPanelHeader => 'Painel de Análise Numérica';

  @override
  String get hlpAutoAnalysisTitle => 'Análise Automática';

  @override
  String get hlpAutoAnalysisContent =>
      'Ao digitar qualquer número, o painel da direita (tablet) ou de baixo (celular) mostra automaticamente:\n\n• Propriedades: dígitos, paridade, sinal\n• Representações: binário, octal, hexadecimal\n• Primalidade: teste de Miller-Rabin, fatoração completa\n• Primos vizinhos: anterior e seguinte\n• Divisores: lista completa, soma, quantidade\n• Classificações: quadrado/cubo perfeito, potência perfeita, Fibonacci, triangular, palíndromo\n\nPara números com até 15 dígitos, também mostra:\n\n• Funções aritméticas: φ, λ, μ, ω, Ω, sopfr, sopf, rad, dr\n• Classificações: livre de quadrados, poderoso, Harshad, semiprimo, abundante/deficiente/perfeito';

  @override
  String get hlpHighPrecHeader => 'Alta Precisão e Ferramentas';

  @override
  String get hlpHighPrecTitle => 'Modo de alta precisão';

  @override
  String get hlpHighPrecContent =>
      'Ative-o em Configurações. Calcula sin, cos, tan, ln, log, exp, √ e ∛ com reais construtivos EXATOS e arredonda apenas ao exibir (5 a 100 dígitos). Sem erro de ponto flutuante: √2 com 30 dígitos = 1.41421356237309504880168872421. As singularidades são detectadas por construção (tan 90° = indefinido). Tudo roda em segundo plano com um indicador de carregamento, sem travar o aplicativo.';

  @override
  String get hlpNewToolsTitle => 'Ferramentas de Olimpíada';

  @override
  String get hlpNewToolsContent =>
      'No menu lateral → Ferramentas de Olimpíada: Frações, Radicais, Geometria (com desenhos: triângulo, Pick, centros e reta de Euler), Polinômios (gráfico, Ruffini, sistemas n×n), Álgebra (desenvolvimento e identidades com várias variáveis), Teoria dos Números (crivo, relógio modular, resíduos), Procedimentos passo a passo, Complexos (círculo unitário, Sierpiński — em alta precisão), Estatística, Matrizes (exatas), Cálculo (derivada/integral/limite) e Prática com verificação.';

  @override
  String get hlpOlympiadHeader => 'Fórmulas Essenciais para Olimpíadas';

  @override
  String get hlpIdentitiesTitle => 'Identidades Fundamentais';

  @override
  String get hlpIdentitiesContent =>
      '• Teorema de Euler: a^φ(n) ≡ 1 (mod n) se MDC(a,n)=1\n• Pequeno Teorema de Fermat: a^(p−1) ≡ 1 (mod p) se p primo\n• Wilson: (p−1)! ≡ −1 (mod p) ⟺ p é primo\n• Fórmula de Legendre: Vₚ(n!) = Σᵢ ⌊n/pⁱ⌋\n• Lucas: C(n,k) mod p = ∏ C(nᵢ,kᵢ) mod p\n• Σ φ(d) para d|n = n\n• Σ μ(d) para d|n = [n=1]\n• φ(mn) = φ(m)φ(n)·MDC(m,n)/φ(MDC(m,n))\n• MDC(F(m),F(n)) = F(MDC(m,n))\n• MA ≥ MG ≥ MH (desigualdade das médias)';

  @override
  String get hlpRefTableTitle => 'Tabela de Referência Rápida';

  @override
  String get hlpRefTableContent =>
      'n    φ(n)  λ(n)  μ(n)  σ(n)  ω  Ω\n1    1     1     1     1     0  0\n6    2     2     1     12    2  2\n12   4     2     0     28    2  3\n30   8     4     −1    72    3  3\n60   16    4     0     168   3  4\n100  40    20    0     217   2  4';

  @override
  String get hlpExamplesLabel => 'Exemplos:';

  @override
  String get hlpTipsLabel => 'Dicas:';

  @override
  String get errExprEmpty => 'Erro: expressão vazia';

  @override
  String get errExprMalformed => 'Erro: expressão malformada';

  @override
  String get errExprDivZero => 'Erro: divisão por zero';

  @override
  String get errResultInvalid => 'Erro: resultado inválido';

  @override
  String get errResultTooLarge =>
      'O resultado é grande demais para ser calculado exatamente';

  @override
  String get errAnalysisInvalid => 'Erro: número inválido para análise';

  @override
  String get errAnalysisFail => 'Não é possível analisar o número';

  @override
  String get errNoSolution => 'Sem solução';

  @override
  String get errIncompatibleSystem => 'Sistema incompatível';

  @override
  String get errCRTNeedPairs => 'O TCR precisa de pares (aᵢ, mᵢ)';

  @override
  String errUnknownOp(String op) {
    return 'Operação desconhecida: $op';
  }
}
