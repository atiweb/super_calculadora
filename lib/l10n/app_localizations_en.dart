// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Super Calculator';

  @override
  String get appVersion => 'Version 1.0.0';

  @override
  String get appDeveloped => 'Developed in Flutter';

  @override
  String get appDynamicThemes => 'With dynamic theme support';

  @override
  String get navStandard => 'Standard';

  @override
  String get navStandardSub => 'Basic operations';

  @override
  String get navScientific => 'Scientific';

  @override
  String get navScientificSub => 'Advanced functions';

  @override
  String get navSpecial => 'Special Functions';

  @override
  String get navSpecialSub => 'Number theory';

  @override
  String get navHistory => 'History';

  @override
  String get navHistorySub => 'View previous operations';

  @override
  String get navSettings => 'Settings';

  @override
  String get navSettingsSub => 'App settings';

  @override
  String get navHelp => 'Help';

  @override
  String get navHelpSub => 'Special functions guide';

  @override
  String get navAbout => 'About';

  @override
  String get navAboutSub => 'Super Calculator v1.0';

  @override
  String get navCalculator => 'Calculator';

  @override
  String get navSelectType => 'Select mode';

  @override
  String navAngleMode(String mode) {
    return 'Mode: $mode';
  }

  @override
  String get navRadians => 'Radians';

  @override
  String get navDegrees => 'Degrees';

  @override
  String get calcAnalysis => 'Analysis';

  @override
  String get calcExpressions => 'Expressions';

  @override
  String get calcScientific => 'Scientific Calculator';

  @override
  String get calcSpecialFunctions => 'Special Functions';

  @override
  String get calcSuperCalculator => 'Super Calculator';

  @override
  String get calcNumericAnalysis => 'Numeric Analysis';

  @override
  String get calcMathExpressions => 'Math Expressions';

  @override
  String get calcResult => 'Result:';

  @override
  String get calcProcessing => 'Processing large numbers...';

  @override
  String get calcCancel => 'Cancel';

  @override
  String get displayPaste => 'Paste';

  @override
  String get displayCopy => 'Copy';

  @override
  String displayCopied(String text) {
    return 'Copied: $text';
  }

  @override
  String get displayCopyResult => 'Copy result';

  @override
  String get displayPasteNumber => 'Paste number';

  @override
  String get displayClearDisplay => 'Clear display';

  @override
  String get displayInvalidNumber => 'Error: Pasted text is not a valid number';

  @override
  String get displayNothingToPaste => 'Nothing to paste';

  @override
  String displayPasteError(String error) {
    return 'Paste error: $error';
  }

  @override
  String displayPasted(String text) {
    return 'Pasted: $text';
  }

  @override
  String get histTitle => 'History';

  @override
  String get histClearAll => 'Clear history';

  @override
  String get histClearAllTooltip => 'Clear all history';

  @override
  String get histConfirmClear => 'Are you sure you want to delete all history?';

  @override
  String histConfirmClearN(String count) {
    return 'Are you sure you want to delete all $count operations from history? This action cannot be undone.';
  }

  @override
  String get histCleared => 'History cleared';

  @override
  String get histDeleted => 'History deleted';

  @override
  String get histOperationDeleted => 'Operation deleted';

  @override
  String get histCopiedToClipboard => 'Copied to clipboard';

  @override
  String histCopiedClipboardText(String text) {
    return 'Copied to clipboard: $text';
  }

  @override
  String get histFullResult => 'Full result';

  @override
  String get histClose => 'Close';

  @override
  String get histExpression => 'Expression:';

  @override
  String get histResult => 'Result:';

  @override
  String get histCopyResult => 'Copy result';

  @override
  String get histCopyAll => 'Copy all';

  @override
  String get histCopyExpression => 'Copy expression';

  @override
  String get histUseResult => 'Use result';

  @override
  String get histViewResult => 'View result';

  @override
  String get histDelete => 'Delete';

  @override
  String get histEmpty => 'No operations in history';

  @override
  String get histEmptyHint =>
      'Perform some calculations to see your history here';

  @override
  String get histEmptyHintAlt => 'Operations you perform will appear here';

  @override
  String get histOperations => 'operations';

  @override
  String get histNow => 'Now';

  @override
  String histErrorLoading(String error) {
    return 'Error loading history: $error';
  }

  @override
  String histErrorClearing(String error) {
    return 'Error clearing history: $error';
  }

  @override
  String histErrorDeleting(String error) {
    return 'Error deleting operation: $error';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsNumberFormat => 'Number format';

  @override
  String get settingsScientificNotation => 'Use scientific notation';

  @override
  String get settingsScientificHint =>
      'Numbers will be displayed in full (e.g. 123000) when disabled';

  @override
  String get settingsFormatExamples => 'Format examples';

  @override
  String get settingsLargeNumber => 'Large number:';

  @override
  String get settingsSmallNumber => 'Small number:';

  @override
  String get settingsNormal => 'Normal:';

  @override
  String get settingsScientific => 'Scientific:';

  @override
  String get settingsAboutApp => 'About the App';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeAuto => 'Automatic';

  @override
  String get themeLightDesc => 'Always use light theme';

  @override
  String get themeDarkDesc => 'Always use dark theme';

  @override
  String get themeAutoDesc => 'Follow system settings';

  @override
  String get aboutTitle => 'Super Calculator';

  @override
  String get aboutDescription =>
      'An advanced calculator with scientific capabilities and complete numeric analysis.';

  @override
  String get aboutFeatures => 'Features:';

  @override
  String get aboutClose => 'Close';

  @override
  String get aboutFeature1 => 'Numbers up to 1024 bits';

  @override
  String get aboutFeature2 => '64-bit decimal precision';

  @override
  String get aboutFeature3 => 'Standard and scientific calculator modes';

  @override
  String get aboutFeature4 => 'Trigonometric functions (sin, cos, tan)';

  @override
  String get aboutFeature5 =>
      'Inverse trigonometric functions (asin, acos, atan)';

  @override
  String get aboutFeature6 => 'Natural (ln) and base-10 (log) logarithms';

  @override
  String get aboutFeature7 => 'Exponential functions (eˣ, 10ˣ)';

  @override
  String get aboutFeature8 => 'Factorial calculation (n!)';

  @override
  String get aboutFeature9 => 'Mathematical constants (π, e)';

  @override
  String get aboutFeature10 => 'Powers and roots (x², x³, √, ∛)';

  @override
  String get aboutFeature11 => 'Degree and radian conversion';

  @override
  String get aboutFeature12 => 'Prime number analysis';

  @override
  String get aboutFeature13 => 'Prime factorization';

  @override
  String get aboutFeature14 => 'Binary and decimal conversion';

  @override
  String get aboutFeature15 => 'Mathematical property analysis';

  @override
  String get aboutFeature16 => 'Operations with extremely large numbers';

  @override
  String get aboutFeature17 =>
      'Heavy calculations on separate threads (isolates)';

  @override
  String get aboutFeature18 => 'Domain and size error handling';

  @override
  String get exprMathExpression => 'Mathematical expression';

  @override
  String get exprHideHistory => 'Hide history';

  @override
  String get exprShowHistory => 'Show history';

  @override
  String get exprClearExpression => 'Clear expression';

  @override
  String get exprHint => 'E.g.: (5 + 3) * sqrt(9) - 2^3';

  @override
  String get exprDelete => 'Delete';

  @override
  String get exprEvaluate => 'Evaluate (Enter)';

  @override
  String get exprParenthesis => 'Parentheses';

  @override
  String get exprSquareRoot => 'Square root';

  @override
  String get exprPower => 'Power';

  @override
  String get exprSin => 'Sine';

  @override
  String get exprCos => 'Cosine';

  @override
  String get exprTan => 'Tangent';

  @override
  String get exprLog => 'Logarithm';

  @override
  String get exprLn => 'Natural logarithm';

  @override
  String get exprPi => 'Pi';

  @override
  String get exprEuler => 'Euler';

  @override
  String get analysisEnterNumber => 'Enter a number to see its analysis';

  @override
  String get analysisLoading => 'Analyzing number...';

  @override
  String get analysisLoadingHint => 'This may take a moment for large numbers';

  @override
  String get analysisLimited => 'Limited analysis';

  @override
  String get analysisExtremelyLarge => 'Extremely Large Number';

  @override
  String analysisDigitsCount(String count) {
    return 'Digits: $count';
  }

  @override
  String get analysisPrimalityNote => 'Note on primality analysis';

  @override
  String analysisOriginalInput(String original, String analyzed) {
    return 'Original input: $original → Analyzed: $analyzed';
  }

  @override
  String get analysisCalculatingPrimes => 'Calculating primes...';

  @override
  String get analysisSearchingPrimes => 'Searching for previous and next prime';

  @override
  String get analysisBasicProperties => 'Basic Properties';

  @override
  String get analysisValue => 'Value';

  @override
  String get analysisIsPrime => 'Is prime';

  @override
  String get analysisDigits => 'Digits';

  @override
  String get analysisNextPrime => 'Next prime';

  @override
  String get analysisPrevPrime => 'Previous prime';

  @override
  String get analysisDigitSum => 'Digit sum';

  @override
  String get analysisBinary => 'Binary';

  @override
  String get analysisYes => 'Yes';

  @override
  String get analysisNo => 'No';

  @override
  String get analysisRepresentations => 'Representations';

  @override
  String get analysisOctal => 'Octal';

  @override
  String get analysisHex => 'Hexadecimal';

  @override
  String get analysisMathAnalysis => 'Mathematical Analysis';

  @override
  String get analysisIsPerfect => 'Is perfect';

  @override
  String get analysisIsPalindrome => 'Is palindrome';

  @override
  String get analysisIsFibonacci => 'Is Fibonacci';

  @override
  String get analysisIsTriangular => 'Is triangular';

  @override
  String get analysisPrimeFactors => 'Prime Factorization';

  @override
  String get analysisPrimeFactorsLabel => 'Prime factors';

  @override
  String get analysisDivisors => 'Divisors';

  @override
  String get analysisAllDivisors => 'All divisors';

  @override
  String get analysisDivisorCount => 'Divisor count';

  @override
  String get analysisArithmeticFunctions => 'Arithmetic Functions';

  @override
  String get analysisEulerPhi => 'φ(n) Euler';

  @override
  String get analysisCarmichael => 'λ(n) Carmichael';

  @override
  String get analysisMobius => 'μ(n) Möbius';

  @override
  String get analysisSmallOmega => 'ω(n) distinct primes';

  @override
  String get analysisBigOmega => 'Ω(n) primes w/mult.';

  @override
  String get analysisSopfr => 'sopfr(n) Σprimes rep.';

  @override
  String get analysisSopf => 'sopf(n) Σprimes dist.';

  @override
  String get analysisRadical => 'rad(n) radical';

  @override
  String get analysisDigitalRoot => 'Digital root';

  @override
  String get analysisClassification => 'Classification';

  @override
  String get analysisSquareFree => 'Square-free';

  @override
  String get analysisPowerful => 'Powerful';

  @override
  String get analysisHarshad => 'Harshad';

  @override
  String get analysisSemiprime => 'Semiprime';

  @override
  String get analysisAbundant => 'Abundant';

  @override
  String get analysisDeficient => 'Deficient';

  @override
  String get analysisOperations => 'Operations';

  @override
  String get analysisSquare => 'Square';

  @override
  String get analysisCube => 'Cube';

  @override
  String get analysisSquareRootLabel => 'Square root';

  @override
  String get analysisIsPerfectSquare => 'Is perfect square';

  @override
  String get analysisCubeRoot => 'Cube root';

  @override
  String get analysisIsPerfectCube => 'Is perfect cube';

  @override
  String get analysisPerfectPower => 'Perfect Power';

  @override
  String get analysisExpression => 'Expression';

  @override
  String get analysisBase => 'Base';

  @override
  String get analysisExponent => 'Exponent';

  @override
  String get cardPrime => 'Prime';

  @override
  String get cardPerfect => 'Perfect';

  @override
  String get cardPalindrome => 'Palindrome';

  @override
  String get cardFibonacci => 'Fibonacci';

  @override
  String get cardTriangular => 'Triangular';

  @override
  String get cardEven => 'Even';

  @override
  String get cardOdd => 'Odd';

  @override
  String get cardQuickProperties => 'Quick properties:';

  @override
  String get cardConvert => 'Convert:';

  @override
  String get cardToDecimal => 'To Decimal';

  @override
  String get cardToBinary => 'To Binary';

  @override
  String get cardAdvancedOps => 'Advanced operations:';

  @override
  String get cardDigits => 'digits';

  @override
  String get kbdNumberTheory => 'Number Theory';

  @override
  String get kbdModularArith => 'Modular Arithmetic';

  @override
  String get kbdCombinatorics => 'Combinatorics';

  @override
  String get kbdStatistics => 'Statistics';

  @override
  String errPower(String error) {
    return 'Power error: $error';
  }

  @override
  String errSquareRoot(String error) {
    return 'Square root error: $error';
  }

  @override
  String errCubeRoot(String error) {
    return 'Cube root error: $error';
  }

  @override
  String errBinaryConversion(String error) {
    return 'Binary conversion error: $error';
  }

  @override
  String get errEmptyBinary => 'Empty binary number';

  @override
  String get errInvalidBinary =>
      'Number must contain only binary digits (0 and 1)';

  @override
  String errBinaryFromConversion(String error) {
    return 'Binary conversion error: $error';
  }

  @override
  String get errTrigTooLarge => 'Number too large for trigonometric functions';

  @override
  String errSin(String error) {
    return 'Sine error: $error';
  }

  @override
  String errCos(String error) {
    return 'Cosine error: $error';
  }

  @override
  String get errTanUndefined => 'Tangent undefined for this angle';

  @override
  String errTan(String error) {
    return 'Tangent error: $error';
  }

  @override
  String get errAsinDomain =>
      'Arcsine is only defined for values between -1 and 1';

  @override
  String errAsin(String error) {
    return 'Arcsine error: $error';
  }

  @override
  String get errAcosDomain =>
      'Arccosine is only defined for values between -1 and 1';

  @override
  String errAcos(String error) {
    return 'Arccosine error: $error';
  }

  @override
  String errAtan(String error) {
    return 'Arctangent error: $error';
  }

  @override
  String get errLnDomain =>
      'Natural logarithm is only defined for positive numbers';

  @override
  String get errLnTooLarge => 'Number too large for natural logarithm';

  @override
  String errLn(String error) {
    return 'Natural logarithm error: $error';
  }

  @override
  String get errLogDomain => 'Logarithm is only defined for positive numbers';

  @override
  String get errLogTooLarge => 'Number too large for base-10 logarithm';

  @override
  String errLog(String error) {
    return 'Logarithm error: $error';
  }

  @override
  String get errExpTooLarge => 'Number too large for exponential';

  @override
  String errExp(String error) {
    return 'Exponential error: $error';
  }

  @override
  String get errTenPowTooLarge => 'Number too large for 10^x';

  @override
  String errTenPow(String error) {
    return '10^x error: $error';
  }

  @override
  String get errFactorialInvalid => 'Invalid number for factorial';

  @override
  String get errFactorialNonNeg =>
      'Factorial is only defined for non-negative integers';

  @override
  String get errFactorialTooLarge =>
      'Number too large for factorial (maximum 170)';

  @override
  String errFactorial(String error) {
    return 'Factorial error: $error';
  }

  @override
  String get errOperationCancelled => 'Operation cancelled';

  @override
  String errGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get errPhiDomain => 'φ(n) is only defined for n > 0';

  @override
  String errPhi(String error) {
    return 'φ(n) error: $error';
  }

  @override
  String get errPrimorialDomain => 'Primorial is only defined for n ≥ 0';

  @override
  String errPrimorial(String error) {
    return 'Primorial error: $error';
  }

  @override
  String get errSigma0Domain => 'σ₀(n) is only defined for n > 0';

  @override
  String errSigma0(String error) {
    return 'σ₀(n) error: $error';
  }

  @override
  String get errSigmaDomain => 'σ(m,n) is only defined for n > 0';

  @override
  String errSigma(String error) {
    return 'σ(m,n) error: $error';
  }

  @override
  String errFloorCeil(String error) {
    return 'Floor/ceiling error: $error';
  }

  @override
  String get errMobiusDomain => 'μ(n) is only defined for n > 0';

  @override
  String errMobius(String error) {
    return 'μ(n) error: $error';
  }

  @override
  String get errFactorialNeg => 'Factorial is not defined for negative numbers';

  @override
  String get errFactorialMax => 'n! too large (max n=10000)';

  @override
  String errFactorialN(String error) {
    return 'n! error: $error';
  }

  @override
  String get errDoubleFactorialNeg =>
      'Double factorial is not defined for negative numbers';

  @override
  String errDoubleFactorial(String error) {
    return 'n!! error: $error';
  }

  @override
  String get errFibonacciNeg => 'F(n) is not defined for n < 0';

  @override
  String errFibonacci(String error) {
    return 'F(n) error: $error';
  }

  @override
  String get errCatalanNeg => 'Catalan is not defined for n < 0';

  @override
  String errCatalan(String error) {
    return 'Catalan error: $error';
  }

  @override
  String get errDerangementNeg => 'D(n) is not defined for n < 0';

  @override
  String errDerangement(String error) {
    return 'D(n) error: $error';
  }

  @override
  String get errPartitionNeg => 'p(n) is not defined for n < 0';

  @override
  String errPartition(String error) {
    return 'p(n) error: $error';
  }

  @override
  String get errBellNeg => 'B(n) is not defined for n < 0';

  @override
  String errBell(String error) {
    return 'Bell(n) error: $error';
  }

  @override
  String errDigitalRoot(String error) {
    return 'Digital root error: $error';
  }

  @override
  String get errPrimitiveRootDomain => 'n > 1 required';

  @override
  String errNoPrimitiveRoot(String n) {
    return 'No primitive root exists mod $n';
  }

  @override
  String get errLiouvilleDomain => 'λ_L(n) is only defined for n > 0';

  @override
  String errLiouville(String error) {
    return 'λ_L(n) error: $error';
  }

  @override
  String errPrimeCounting(String error) {
    return 'π(n) error: $error';
  }

  @override
  String get errRadDomain => 'rad(n) is only defined for n > 0';

  @override
  String errRad(String error) {
    return 'rad(n) error: $error';
  }

  @override
  String get errOmegaDomain => 'ω(n) is only defined for n > 0';

  @override
  String errOmega(String error) {
    return 'ω(n) error: $error';
  }

  @override
  String get errBigOmegaDomain => 'Ω(n) is only defined for n > 0';

  @override
  String errBigOmega(String error) {
    return 'Ω(n) error: $error';
  }

  @override
  String get errCarmichaelDomain => 'λ(n) is only defined for n > 0';

  @override
  String errCarmichael(String error) {
    return 'λ(n) error: $error';
  }

  @override
  String get errSopfrDomain => 'sopfr(n) is only defined for n > 0';

  @override
  String errSopfr(String error) {
    return 'sopfr(n) error: $error';
  }

  @override
  String get errSopfDomain => 'sopf(n) is only defined for n > 0';

  @override
  String errSopf(String error) {
    return 'sopf(n) error: $error';
  }

  @override
  String errPercentage(String error) {
    return 'Percentage error: $error';
  }

  @override
  String get errDivisionByZero => 'Division by zero';

  @override
  String errReciprocal(String error) {
    return 'Reciprocal error: $error';
  }

  @override
  String errNoInverse(String a, String n) {
    return 'No modular inverse of $a mod $n';
  }

  @override
  String errModPow(String error) {
    return 'Modular exponentiation error: $error';
  }

  @override
  String errDiophantine(String error) {
    return 'Diophantine equation error: $error';
  }

  @override
  String errCRT(String error) {
    return 'CRT error: $error';
  }

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLangAuto => 'Automatic (system)';

  @override
  String get settingsLangAutoDesc => 'Use device language';

  @override
  String get settingsLangEs => 'Español';

  @override
  String get settingsLangEn => 'English';

  @override
  String get hlpTitle => 'Special Functions Guide';

  @override
  String get hlpQuickStartHeader => 'Quick Start';

  @override
  String get hlpQuickStartWelcome => 'Welcome to the olympiad calculator';

  @override
  String get hlpQuickStartStep1 =>
      'Open the side menu (☰) and select \"Special Functions\"';

  @override
  String get hlpQuickStartStep2 =>
      'The top keyboard (scrollable) has ~40 functions in 4 sections';

  @override
  String get hlpQuickStartStep3 =>
      'Enter a number and press any function button';

  @override
  String get hlpQuickStartStep4 =>
      'If the function needs more values, a pending operation indicator appears';

  @override
  String get hlpQuickStartStep5 =>
      'The side panel shows automatic analysis of the entered number';

  @override
  String get hlpQuickStartNote =>
      '1-parameter functions execute immediately.\n2+ parameter functions show an indicator and wait for more values.';

  @override
  String get hlpParamHeader => 'Parameter System';

  @override
  String get hlpParamTypesTitle => 'Function types by parameters';

  @override
  String get hlpParam1Title => '1 parameter (immediate)';

  @override
  String get hlpParam1Desc => 'Enter number → Press function → Result';

  @override
  String get hlpParam1Example => 'E.g.: φ(12) → enter 12, press φ → shows 4';

  @override
  String get hlpParam2Title => '2-3-4 parameters (fixed)';

  @override
  String get hlpParam2Desc =>
      'Enter value → Function → Value → = → (repeat if more needed)\nAuto-executes when all parameters are filled.';

  @override
  String get hlpParam2Example => 'E.g.: C(10,3) → enter 10 → C(n,k) → 3 → =';

  @override
  String get hlpParamNTitle => 'N parameters (variable)';

  @override
  String get hlpParamNDesc =>
      'Enter value → Function → Value → = (add more)\nPress the SAME FUNCTION again to execute.';

  @override
  String get hlpParamNExample =>
      'E.g.: GCD(12,18,24) → 12 → GCD → 18 → = → 24 → GCD';

  @override
  String get hlpPendingOpTitle => 'Pending operation indicator';

  @override
  String get hlpPendingOpDesc =>
      'When a function awaits more values, a colored indicator appears on screen showing which operation is in progress and what is missing.\n\nExample: \"C(10, _)\" indicates that k is missing to complete C(n,k).\n\"GCD(12, 18, _) [= add, GCD solve]\" indicates a variable operation.';

  @override
  String get hlpNumberTheoryHeader => 'Number Theory';

  @override
  String get hlpEulerPhiTitle => 'φ(n) — Euler\'s Totient Function';

  @override
  String get hlpEulerPhiParams => '1 param';

  @override
  String get hlpEulerPhiDesc =>
      'Counts how many integers from 1 to n are coprime with n (i.e., GCD(k,n)=1).';

  @override
  String get hlpEulerPhiFormula => 'φ(n) = n × ∏(1 − 1/p) for each prime p | n';

  @override
  String get hlpEulerPhiEx1 => 'φ(1) = 1';

  @override
  String get hlpEulerPhiEx2 => 'φ(9) = 6 → [1,2,4,5,7,8]';

  @override
  String get hlpEulerPhiEx3 => 'φ(12) = 4 → [1,5,7,11]';

  @override
  String get hlpEulerPhiEx4 => 'φ(p) = p−1 for prime p';

  @override
  String get hlpEulerPhiTip1 =>
      'Multiplicative: φ(mn) = φ(m)φ(n) if GCD(m,n)=1';

  @override
  String get hlpEulerPhiTip2 =>
      'Euler\'s theorem: a^φ(n) ≡ 1 (mod n) if GCD(a,n)=1';

  @override
  String get hlpEulerPhiTip3 => 'Σ φ(d) for d|n = n';

  @override
  String get hlpCarmichaelTitle => 'λ(n) — Carmichael\'s λ Function';

  @override
  String get hlpCarmichaelParams => '1 param';

  @override
  String get hlpCarmichaelDesc =>
      'Smallest m > 0 such that a^m ≡ 1 (mod n) for ALL a coprime to n. Always divides φ(n).';

  @override
  String get hlpCarmichaelFormula =>
      'λ(p^k) = φ(p^k) if p odd\nλ(2)=1, λ(4)=2, λ(2^k)=2^(k−2) if k≥3\nλ(n) = lcm of parts';

  @override
  String get hlpCarmichaelEx1 => 'λ(8) = 2';

  @override
  String get hlpCarmichaelEx2 => 'λ(15) = lcm(λ(3),λ(5)) = lcm(2,4) = 4';

  @override
  String get hlpCarmichaelEx3 => 'λ(p) = p−1 for prime p';

  @override
  String get hlpCarmichaelTip1 => 'λ(n) | φ(n) always';

  @override
  String get hlpCarmichaelTip2 =>
      'λ(n) = φ(n) if and only if n has a primitive root';

  @override
  String get hlpMobiusTitle => 'μ(n) — Möbius Function';

  @override
  String get hlpMobiusParams => '1 param';

  @override
  String get hlpMobiusDesc =>
      'Detects whether n is square-free and counts prime factors.';

  @override
  String get hlpMobiusFormula =>
      'μ(1) = 1\nμ(n) = (−1)^k if n = p₁·p₂·...·pₖ (distinct)\nμ(n) = 0 if p² | n';

  @override
  String get hlpMobiusEx1 => 'μ(1) = 1';

  @override
  String get hlpMobiusEx2 => 'μ(6) = μ(2×3) = (−1)² = 1';

  @override
  String get hlpMobiusEx3 => 'μ(30) = μ(2×3×5) = (−1)³ = −1';

  @override
  String get hlpMobiusEx4 => 'μ(12) = 0 (has 2²)';

  @override
  String get hlpMobiusTip1 =>
      'Möbius inversion: if g(n) = Σ f(d) for d|n, then f(n) = Σ μ(d)g(n/d)';

  @override
  String get hlpMobiusTip2 => 'Σ μ(d) for d|n = [n=1]';

  @override
  String get hlpLiouvilleTitle => 'λL(n) — Liouville Function';

  @override
  String get hlpLiouvilleParams => '1 param';

  @override
  String get hlpLiouvilleDesc =>
      'Completely multiplicative: λL(n) = (−1)^Ω(n).';

  @override
  String get hlpLiouvilleFormula => 'λL(n) = (−1)^Ω(n)';

  @override
  String get hlpLiouvilleEx1 => 'λL(12) = (−1)³ = −1 (Ω(12)=3)';

  @override
  String get hlpLiouvilleEx2 => 'λL(36) = (−1)⁴ = 1 (Ω(36)=4)';

  @override
  String get hlpLiouvilleTip1 =>
      'Σ λL(d) for d|n = 1 if n is a perfect square, 0 otherwise';

  @override
  String get hlpSmallOmegaTitle => 'ω(n) — Distinct Prime Factors';

  @override
  String get hlpSmallOmegaParams => '1 param';

  @override
  String get hlpSmallOmegaDesc =>
      'Counts the number of distinct primes dividing n.';

  @override
  String get hlpSmallOmegaFormula => 'ω(n) = k if n = p₁^a₁ × ... × pₖ^aₖ';

  @override
  String get hlpSmallOmegaEx1 => 'ω(12) = 2 → [2, 3]';

  @override
  String get hlpSmallOmegaEx2 => 'ω(30) = 3 → [2, 3, 5]';

  @override
  String get hlpSmallOmegaEx3 => 'ω(p^k) = 1';

  @override
  String get hlpBigOmegaTitle => 'Ω(n) — Prime Factors with Multiplicity';

  @override
  String get hlpBigOmegaParams => '1 param';

  @override
  String get hlpBigOmegaDesc =>
      'Total number of prime factors counting repetitions.';

  @override
  String get hlpBigOmegaFormula => 'Ω(n) = a₁ + a₂ + ... + aₖ';

  @override
  String get hlpBigOmegaEx1 => 'Ω(12) = 3 → 2×2×3';

  @override
  String get hlpBigOmegaEx2 => 'Ω(72) = 5 → 2³×3² → 3+2';

  @override
  String get hlpBigOmegaEx3 => 'Ω(p) = 1, Ω(p²) = 2';

  @override
  String get hlpSigma0Title => 'σ₀(n) — Divisor Count';

  @override
  String get hlpSigma0Params => '1 param';

  @override
  String get hlpSigma0Desc => 'Total number of positive divisors of n.';

  @override
  String get hlpSigma0Formula =>
      'If n = p₁^a₁ × ... × pₖ^aₖ\nσ₀(n) = (a₁+1)(a₂+1)...(aₖ+1)';

  @override
  String get hlpSigma0Ex1 => 'σ₀(12) = 6 → [1,2,3,4,6,12]';

  @override
  String get hlpSigma0Ex2 => 'σ₀(p) = 2';

  @override
  String get hlpSigma0Ex3 => 'σ₀(p²) = 3';

  @override
  String get hlpSigmaTitle => 'σ(n) — Sum of Divisors';

  @override
  String get hlpSigmaParams => '1 param';

  @override
  String get hlpSigmaDesc => 'Sum of all positive divisors of n.';

  @override
  String get hlpSigmaFormula => 'σ(n) = Σ d for d | n';

  @override
  String get hlpSigmaEx1 => 'σ(6) = 1+2+3+6 = 12 (6 is perfect)';

  @override
  String get hlpSigmaEx2 => 'σ(12) = 1+2+3+4+6+12 = 28';

  @override
  String get hlpSigmaEx3 => 'σ(p) = p+1';

  @override
  String get hlpSigmaTip1 => 'n is perfect ⟺ σ(n) = 2n';

  @override
  String get hlpSigmaTip2 => 'n is abundant ⟺ σ(n) > 2n';

  @override
  String get hlpSopfrTitle => 'sopfr(n) — Sum of Primes with Repetition';

  @override
  String get hlpSopfrParams => '1 param';

  @override
  String get hlpSopfrDesc => 'Sums the prime factors counting multiplicity.';

  @override
  String get hlpSopfrFormula => 'sopfr(n) = a₁p₁ + a₂p₂ + ... + aₖpₖ';

  @override
  String get hlpSopfrEx1 => 'sopfr(12) = 2+2+3 = 7';

  @override
  String get hlpSopfrEx2 => 'sopfr(60) = 2+2+3+5 = 12';

  @override
  String get hlpSopfTitle => 'sopf(n) — Sum of Distinct Primes';

  @override
  String get hlpSopfParams => '1 param';

  @override
  String get hlpSopfDesc => 'Sum of distinct primes dividing n.';

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
      'Product of distinct primes dividing n (ABC Conjecture function).';

  @override
  String get hlpRadFormula => 'rad(n) = ∏ p for p prime, p | n';

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
  String get hlpPrimorialDesc => 'Product of all primes ≤ n.';

  @override
  String get hlpPrimorialFormula => 'n# = ∏ p for p prime, p ≤ n';

  @override
  String get hlpPrimorialEx1 => '5# = 2×3×5 = 30';

  @override
  String get hlpPrimorialEx2 => '7# = 210';

  @override
  String get hlpPrimorialEx3 => '11# = 2310';

  @override
  String get hlpPrimeCountTitle => 'π(n) — Prime Counting Function';

  @override
  String get hlpPrimeCountParams => '1 param';

  @override
  String get hlpPrimeCountDesc =>
      'Counts primes ≤ n. Exact for n ≤ 1,000,000; Li(x) approximation for larger.';

  @override
  String get hlpPrimeCountFormula => 'π(n) ~ n/ln(n) (Prime Number Theorem)';

  @override
  String get hlpPrimeCountEx1 => 'π(10) = 4';

  @override
  String get hlpPrimeCountEx2 => 'π(100) = 25';

  @override
  String get hlpPrimeCountEx3 => 'π(1,000,000) = 78,498';

  @override
  String get hlpDigitalRootTitle => 'dr(n) — Digital Root';

  @override
  String get hlpDigitalRootParams => '1 param';

  @override
  String get hlpDigitalRootDesc =>
      'Iterative digit sum until a single digit is obtained.';

  @override
  String get hlpDigitalRootFormula => 'dr(n) = 1 + (n−1) mod 9  (for n > 0)';

  @override
  String get hlpDigitalRootEx1 => 'dr(493) → 4+9+3=16 → 1+6 = 7';

  @override
  String get hlpDigitalRootEx2 => 'dr(999) = 9';

  @override
  String get hlpDigitalRootEx3 => 'dr(n) ≡ n (mod 9)';

  @override
  String get hlpFloorCeilTitle => '⌊x⌋ / ⌈x⌉ — Floor and Ceiling';

  @override
  String get hlpFloorCeilParams => '1 param';

  @override
  String get hlpFloorCeilDesc =>
      'Floor: greatest integer ≤ x. Ceiling: smallest integer ≥ x. Toggles between both.';

  @override
  String get hlpFloorCeilFormula => '⌊x⌋ ≤ x < ⌊x⌋+1\n⌈x⌉−1 < x ≤ ⌈x⌉';

  @override
  String get hlpFloorCeilEx1 => '⌊3.7⌋ = 3, ⌈3.7⌉ = 4';

  @override
  String get hlpFloorCeilEx2 => '⌊−2.3⌋ = −3, ⌈−2.3⌉ = −2';

  @override
  String get hlpFloorCeilEx3 => '⌊5⌋ = ⌈5⌉ = 5';

  @override
  String get hlpPadicTitle => 'Vₚ(n) — p-adic Valuation';

  @override
  String get hlpPadicParams => '2 params: n → Vₚ → p → =';

  @override
  String get hlpPadicDesc => 'Maximum power of prime p dividing n.';

  @override
  String get hlpPadicFormula => 'Vₚ(n) = max[k : p^k | n]';

  @override
  String get hlpPadicEx1 => 'V₂(24) = 3 → 24 = 2³×3';

  @override
  String get hlpPadicEx2 => 'V₃(81) = 4 → 81 = 3⁴';

  @override
  String get hlpPadicEx3 => 'V₅(100) = 2 → 100 = 2²×5²';

  @override
  String get hlpPadicTip1 => 'Legendre\'s formula: Vₚ(n!) = Σ ⌊n/pⁱ⌋';

  @override
  String get hlpPadicTip2 => 'Vₚ(ab) = Vₚ(a) + Vₚ(b)';

  @override
  String get hlpModArithHeader => 'Modular Arithmetic';

  @override
  String get hlpModTitle => 'a mod b — Division Remainder';

  @override
  String get hlpModParams => '2 params: a → mod → b → =';

  @override
  String get hlpModDesc => 'Remainder of dividing a by b.';

  @override
  String get hlpModFormula => 'a mod b = a − b × ⌊a/b⌋';

  @override
  String get hlpModEx1 => '17 mod 5 = 2';

  @override
  String get hlpModEx2 => '23 mod 7 = 2';

  @override
  String get hlpModEx3 => '−8 mod 3 = 1';

  @override
  String get hlpModPowTitle => 'a^b mod n — Modular Exponentiation';

  @override
  String get hlpModPowParams => '3 params: a → a%n → b → = → n → =';

  @override
  String get hlpModPowDesc =>
      'Computes a^b mod n efficiently using repeated squaring O(log b).';

  @override
  String get hlpModPowFormula =>
      'Decompose b in binary and square successively';

  @override
  String get hlpModPowEx1 => '2¹⁰⁰ mod 7 = 2';

  @override
  String get hlpModPowEx2 => '3¹³ mod 11 = 5';

  @override
  String get hlpModPowEx3 => 'Fundamental in RSA and primality tests';

  @override
  String get hlpModPowTip1 =>
      'Flow: enter a → press a%n → enter b → press = → enter n → press =';

  @override
  String get hlpModInvTitle => 'a⁻¹ mod n — Modular Inverse';

  @override
  String get hlpModInvParams => '2 params: a → a⁻¹ → n → =';

  @override
  String get hlpModInvDesc =>
      'Finds b such that a×b ≡ 1 (mod n). Only exists if GCD(a,n) = 1.';

  @override
  String get hlpModInvFormula => 'Extended Euclidean algorithm';

  @override
  String get hlpModInvEx1 => '3⁻¹ mod 7 = 5 → 3×5=15≡1';

  @override
  String get hlpModInvEx2 => '5⁻¹ mod 11 = 9 → 5×9=45≡1';

  @override
  String get hlpModInvEx3 => 'Does not exist if GCD(a,n) ≠ 1';

  @override
  String get hlpOrdTitle => 'ord_n(a) — Multiplicative Order';

  @override
  String get hlpOrdParams => '2 params: a → ord → n → =';

  @override
  String get hlpOrdDesc =>
      'Smallest k > 0 with a^k ≡ 1 (mod n). Requires GCD(a,n)=1.';

  @override
  String get hlpOrdFormula => 'ord_n(a) = min[k > 0 : a^k ≡ 1 (mod n)]';

  @override
  String get hlpOrdEx1 => 'ord₇(2) = 3 → 2³=8≡1';

  @override
  String get hlpOrdEx2 => 'ord₁₀(3) = 4 → 3⁴=81≡1';

  @override
  String get hlpOrdTip1 => 'ord_n(a) always divides φ(n)';

  @override
  String get hlpOrdTip2 => 'a is a primitive root ⟺ ord_n(a) = φ(n)';

  @override
  String get hlpLegendreTitle => '(a/p) — Legendre Symbol';

  @override
  String get hlpLegendreParams => '2 params: a → (a/p) → p → =';

  @override
  String get hlpLegendreDesc =>
      '1 if a is a quadratic residue mod p, −1 if not, 0 if p|a. Requires p odd prime.';

  @override
  String get hlpLegendreFormula =>
      '(a/p) ≡ a^((p−1)/2) (mod p) — Euler\'s Criterion';

  @override
  String get hlpLegendreEx1 => '(2/7) = 1 → 3²≡2 (mod 7)';

  @override
  String get hlpLegendreEx2 => '(3/7) = −1 → no x²≡3 exists';

  @override
  String get hlpLegendreEx3 => '(5/5) = 0';

  @override
  String get hlpJacobiTitle => '(a/n)ⱼ — Jacobi Symbol';

  @override
  String get hlpJacobiParams => '2 params: a → (a/n)ⱼ → n → =';

  @override
  String get hlpJacobiDesc =>
      'Generalization of Legendre for odd composite n. Uses quadratic reciprocity.';

  @override
  String get hlpJacobiFormula => '(a/n) = ∏(a/pᵢ)^eᵢ where n = ∏pᵢ^eᵢ';

  @override
  String get hlpJacobiEx1 => '(2/15) = (2/3)(2/5) = (−1)(−1) = 1';

  @override
  String get hlpJacobiEx2 => '(a/n) = −1 ⟹ a is NOT a quadratic residue';

  @override
  String get hlpJacobiEx3 => '(a/n) = 1 does NOT guarantee it is';

  @override
  String get hlpPrimRootTitle => 'g — Primitive Root';

  @override
  String get hlpPrimRootParams => '1 param';

  @override
  String get hlpPrimRootDesc =>
      'Smallest primitive root mod n (if exists). g is a primitive root if ord_n(g) = φ(n).';

  @override
  String get hlpPrimRootFormula => '[g, g², ..., g^φ(n)] = (Z/nZ)*';

  @override
  String get hlpPrimRootEx1 => 'g(7) = 3 → [3,2,6,4,5,1]';

  @override
  String get hlpPrimRootEx2 => 'g(11) = 2';

  @override
  String get hlpPrimRootEx3 => 'Exists only for n = 1,2,4,p^k,2p^k';

  @override
  String get hlpGcdTitle => 'GCD — Greatest Common Divisor';

  @override
  String get hlpGcdParams => 'N params (variable, min. 2)';

  @override
  String get hlpGcdDesc =>
      'Largest integer dividing all values. Accepts 2 or more numbers.';

  @override
  String get hlpGcdFormula => 'GCD(a,b) via Euclidean algorithm';

  @override
  String get hlpGcdEx1 => 'GCD(12,18) = 6';

  @override
  String get hlpGcdEx2 => 'GCD(12,18,24) = 6';

  @override
  String get hlpGcdEx3 => 'GCD(a,b) × LCM(a,b) = a×b';

  @override
  String get hlpGcdTip1 => 'Flow: 12 → GCD → 18 → GCD (executes)';

  @override
  String get hlpGcdTip2 => 'For 3+ numbers: 12 → GCD → 18 → = → 24 → GCD';

  @override
  String get hlpGcdTip3 => 'Press = to add more, press GCD to execute';

  @override
  String get hlpLcmTitle => 'LCM — Least Common Multiple';

  @override
  String get hlpLcmParams => 'N params (variable, min. 2)';

  @override
  String get hlpLcmDesc => 'Smallest positive integer divisible by all values.';

  @override
  String get hlpLcmFormula => 'LCM(a,b) = a×b / GCD(a,b)';

  @override
  String get hlpLcmEx1 => 'LCM(4,6) = 12';

  @override
  String get hlpLcmEx2 => 'LCM(3,5,7) = 105';

  @override
  String get hlpLcmTip1 => 'Same flow as GCD: press LCM again to execute';

  @override
  String get hlpDiophTitle => 'Dioph — Linear Diophantine Equation';

  @override
  String get hlpDiophParams => '3 params: a → Dioph → b → = → c → =';

  @override
  String get hlpDiophDesc =>
      'Solves ax + by = c. Gives particular and general solution.';

  @override
  String get hlpDiophFormula =>
      'ax + by = c has a solution ⟺ GCD(a,b) | c\nx = x₀ + (b/g)t,  y = y₀ − (a/g)t';

  @override
  String get hlpDiophEx1 => '3x + 5y = 1 → x=2+5t, y=−1−3t';

  @override
  String get hlpDiophEx2 => '6x + 9y = 12 → x=2+3t, y=0−2t';

  @override
  String get hlpDiophEx3 => '4x + 6y = 3 → No solution';

  @override
  String get hlpDiophTip1 => 'Step 1: enter a (coefficient of x)';

  @override
  String get hlpDiophTip2 => 'Step 2: press Dioph';

  @override
  String get hlpDiophTip3 => 'Step 3: enter b (coefficient of y), press =';

  @override
  String get hlpDiophTip4 => 'Step 4: enter c (constant term), press =';

  @override
  String get hlpCrtTitle => 'CRT — Chinese Remainder Theorem';

  @override
  String get hlpCrtParams => 'Variable (4+ params in pairs a,m)';

  @override
  String get hlpCrtDesc => 'Solves system of congruences x ≡ aᵢ (mod mᵢ).';

  @override
  String get hlpCrtFormula =>
      'x ≡ a₁ (mod m₁)\nx ≡ a₂ (mod m₂)\n→ x ≡ r (mod lcm(m₁,m₂))';

  @override
  String get hlpCrtEx1 => 'x≡2(mod 3), x≡3(mod 5) → x≡8(mod 15)';

  @override
  String get hlpCrtEx2 => 'x≡1(mod 4), x≡2(mod 3) → x≡5(mod 12)';

  @override
  String get hlpCrtTip1 => 'Flow: a₁ → CRT → m₁ → = → a₂ → = → m₂ → CRT';

  @override
  String get hlpCrtTip2 => 'The moduli must be compatible';

  @override
  String get hlpCombinatoricsHeader => 'Combinatorics';

  @override
  String get hlpFactorialTitle => 'n! — Factorial';

  @override
  String get hlpFactorialParams => '1 param';

  @override
  String get hlpFactorialDesc => 'Product from 1 to n. Arbitrary precision.';

  @override
  String get hlpFactorialFormula => 'n! = 1 × 2 × ... × n,  0! = 1';

  @override
  String get hlpFactorialEx1 => '5! = 120';

  @override
  String get hlpFactorialEx2 => '10! = 3,628,800';

  @override
  String get hlpFactorialEx3 => '20! = 2,432,902,008,176,640,000';

  @override
  String get hlpDblFactorialTitle => 'n!! — Double Factorial';

  @override
  String get hlpDblFactorialParams => '1 param';

  @override
  String get hlpDblFactorialDesc => 'Product of integers with same parity.';

  @override
  String get hlpDblFactorialFormula => 'n!! = n × (n−2) × (n−4) × ...';

  @override
  String get hlpDblFactorialEx1 => '7!! = 7×5×3×1 = 105';

  @override
  String get hlpDblFactorialEx2 => '8!! = 8×6×4×2 = 384';

  @override
  String get hlpDblFactorialEx3 => '0!! = 1!! = 1';

  @override
  String get hlpCombTitle => 'C(n,k) — Combinations';

  @override
  String get hlpCombParams => '2 params: n → C(n,k) → k → =';

  @override
  String get hlpCombDesc => 'Ways to choose k from n regardless of order.';

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
      'Pascal\'s identity: C(n,k) = C(n−1,k−1) + C(n−1,k)';

  @override
  String get hlpCombTip2 => 'C(n,k) = C(n, n−k)';

  @override
  String get hlpVarTitle => 'V(n,k) — Variations (Partial Permutations)';

  @override
  String get hlpVarParams => '2 params: n → V(n,k) → k → =';

  @override
  String get hlpVarDesc => 'Ways to choose k from n WITH order.';

  @override
  String get hlpVarFormula => 'V(n,k) = n! / (n−k)!';

  @override
  String get hlpVarEx1 => 'V(5,2) = 20';

  @override
  String get hlpVarEx2 => 'V(10,3) = 720';

  @override
  String get hlpCatalanTitle => 'Cat(n) — Catalan Numbers';

  @override
  String get hlpCatalanParams => '1 param';

  @override
  String get hlpCatalanDesc =>
      'Counts binary trees, triangulations, Dyck paths, balanced parentheses.';

  @override
  String get hlpCatalanFormula => 'Cₙ = C(2n,n)/(n+1)';

  @override
  String get hlpCatalanEx1 => 'C₀ = 1, C₁ = 1, C₂ = 2';

  @override
  String get hlpCatalanEx2 => 'C₃ = 5, C₄ = 14, C₅ = 42';

  @override
  String get hlpDerangementTitle => 'D(n) — Derangements';

  @override
  String get hlpDerangementParams => '1 param';

  @override
  String get hlpDerangementDesc =>
      'Permutations where no element remains in its original position.';

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
  String get hlpBellTitle => 'B(n) — Bell Numbers';

  @override
  String get hlpBellParams => '1 param';

  @override
  String get hlpBellDesc =>
      'Total number of partitions of a set of n elements.';

  @override
  String get hlpBellFormula => 'B(n) = Σ S₂(n,k) for k=0..n';

  @override
  String get hlpBellEx1 => 'B(3) = 5';

  @override
  String get hlpBellEx2 => 'B(4) = 15';

  @override
  String get hlpBellEx3 => 'B(5) = 52';

  @override
  String get hlpPartitionTitle => 'p(n) — Integer Partitions';

  @override
  String get hlpPartitionParams => '1 param';

  @override
  String get hlpPartitionDesc =>
      'Ways to write n as a sum of positive integers (order does not matter).';

  @override
  String get hlpPartitionFormula => 'Computed with dynamic programming';

  @override
  String get hlpPartitionEx1 => 'p(4) = 5 → [4, 3+1, 2+2, 2+1+1, 1+1+1+1]';

  @override
  String get hlpPartitionEx2 => 'p(10) = 42';

  @override
  String get hlpPartitionEx3 => 'p(100) = 190,569,292,356';

  @override
  String get hlpStirling2Title => 'S₂(n,k) — Stirling Numbers 2nd Kind';

  @override
  String get hlpStirling2Params => '2 params: n → S₂ → k → =';

  @override
  String get hlpStirling2Desc =>
      'Ways to partition n elements into exactly k non-empty subsets.';

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
      's₁(n,k) — Stirling Numbers 1st Kind (unsigned)';

  @override
  String get hlpStirling1Params => '2 params: n → s₁ → k → =';

  @override
  String get hlpStirling1Desc =>
      'Permutations of n elements with exactly k cycles.';

  @override
  String get hlpStirling1Formula =>
      '|s₁(n,k)| = (n−1)·|s₁(n−1,k)| + |s₁(n−1,k−1)|';

  @override
  String get hlpStirling1Ex1 => 's₁(4,2) = 11';

  @override
  String get hlpStirling1Ex2 => 's₁(4,1) = 6';

  @override
  String get hlpFibTitle => 'F(n) — nth Fibonacci';

  @override
  String get hlpFibParams => '1 param';

  @override
  String get hlpFibDesc =>
      'Computes F(n) with fast doubling O(log n). Supports very large n.';

  @override
  String get hlpFibFormula => 'F(0)=0, F(1)=1, F(n)=F(n−1)+F(n−2)';

  @override
  String get hlpFibEx1 => 'F(10) = 55';

  @override
  String get hlpFibEx2 => 'F(50) = 12,586,269,025';

  @override
  String get hlpFibEx3 => 'F(100) = 354,224,848,179,261,915,075';

  @override
  String get hlpFibTip1 => 'F(n) mod m is periodic (Pisano period)';

  @override
  String get hlpFibTip2 => 'GCD(F(m), F(n)) = F(GCD(m,n))';

  @override
  String get hlpDigitSumBaseTitle => 'ΣdigB — Digit Sum in Base b';

  @override
  String get hlpDigitSumBaseParams => '2 params: n → ΣdigB → b → =';

  @override
  String get hlpDigitSumBaseDesc => 'Sums the digits of n written in base b.';

  @override
  String get hlpDigitSumBaseFormula => 'If n = Σ dᵢ × bⁱ, then ΣdigB = Σ dᵢ';

  @override
  String get hlpDigitSumBaseEx1 => 'ΣdigB(255, 2) = 8 → 11111111₂';

  @override
  String get hlpDigitSumBaseEx2 => 'ΣdigB(100, 10) = 1';

  @override
  String get hlpDigitSumBaseEx3 => 'ΣdigB(100, 16) = 10 → 64₁₆';

  @override
  String get hlpStatisticsHeader => 'Statistics';

  @override
  String get hlpArithMeanTitle => 'Arithmetic Mean — Med A';

  @override
  String get hlpArithMeanParams => 'N params (variable, min. 2)';

  @override
  String get hlpArithMeanDesc => 'Classic average of N numbers.';

  @override
  String get hlpArithMeanFormula => 'AM = (x₁ + x₂ + ... + xₙ) / n';

  @override
  String get hlpArithMeanEx1 => 'AM(3, 7) = 5';

  @override
  String get hlpArithMeanEx2 => 'AM(2, 4, 6) = 4';

  @override
  String get hlpArithMeanTip1 => 'Flow: 3 → Med A → 7 → Med A (executes)';

  @override
  String get hlpArithMeanTip2 => 'For 3+ nums: 2 → Med A → 4 → = → 6 → Med A';

  @override
  String get hlpGeoMeanTitle => 'Geometric Mean — Med G';

  @override
  String get hlpGeoMeanParams => 'N params (variable, min. 2)';

  @override
  String get hlpGeoMeanDesc => 'nth root of the product. Positive values only.';

  @override
  String get hlpGeoMeanFormula => 'GM = (x₁ × x₂ × ... × xₙ)^(1/n)';

  @override
  String get hlpGeoMeanEx1 => 'GM(2, 8) = 4';

  @override
  String get hlpGeoMeanEx2 => 'GM(1, 4, 9) ≈ 3.30';

  @override
  String get hlpHarmMeanTitle => 'Harmonic Mean — Med H';

  @override
  String get hlpHarmMeanParams => 'N params (variable, min. 2)';

  @override
  String get hlpHarmMeanDesc =>
      'Reciprocal of the arithmetic mean of the reciprocals. Positive values only.';

  @override
  String get hlpHarmMeanFormula => 'HM = n / (1/x₁ + 1/x₂ + ... + 1/xₙ)';

  @override
  String get hlpHarmMeanEx1 => 'HM(2, 8) = 3.2';

  @override
  String get hlpHarmMeanEx2 => 'HM(1, 4, 9) ≈ 2.08';

  @override
  String get hlpQuadMeanTitle => 'Quadratic Mean — Med C';

  @override
  String get hlpQuadMeanParams => 'N params (variable, min. 2)';

  @override
  String get hlpQuadMeanDesc => 'Root of the mean of squares (RMS).';

  @override
  String get hlpQuadMeanFormula => 'QM = √((x₁² + x₂² + ... + xₙ²) / n)';

  @override
  String get hlpQuadMeanEx1 => 'QM(3, 4) ≈ 3.54';

  @override
  String get hlpQuadMeanEx2 => 'QM(1, 2, 3) ≈ 2.16';

  @override
  String get hlpMinMaxTitle => 'min / max — Minimum and Maximum';

  @override
  String get hlpMinMaxParams => 'N params (variable, min. 2)';

  @override
  String get hlpMinMaxDesc =>
      'Finds the smallest/largest value in a set of N numbers.';

  @override
  String get hlpMinMaxFormula => 'min(a₁,...,aₙ) and max(a₁,...,aₙ)';

  @override
  String get hlpMinMaxEx1 => 'min(3, 7, 1) = 1';

  @override
  String get hlpMinMaxEx2 => 'max(3, 7, 1) = 7';

  @override
  String get hlpMinMaxTip1 =>
      'Same variable flow: press min/max again to execute';

  @override
  String get hlpMeanInequalityTitle => 'Mean Inequality (AM-GM-HM)';

  @override
  String get hlpMeanInequalityContent =>
      'For positive numbers it always holds that:\n\nHM ≤ GM ≤ AM ≤ QM\n\nEquality holds only when all values are equal.\nThis inequality is fundamental in olympiads.';

  @override
  String get hlpAnalysisPanelHeader => 'Numeric Analysis Panel';

  @override
  String get hlpAutoAnalysisTitle => 'Automatic Analysis';

  @override
  String get hlpAutoAnalysisContent =>
      'When any number is entered, the right panel (tablet) or bottom panel (mobile) automatically shows:\n\n• Properties: digits, parity, sign\n• Representations: binary, octal, hexadecimal\n• Primality: Miller-Rabin test, full factorization\n• Neighboring primes: previous and next\n• Divisors: complete list, sum, count\n• Classifications: perfect square/cube, perfect power, Fibonacci, triangular, palindrome\n\nFor numbers ≤ 15 digits, it also shows:\n\n• Arithmetic functions: φ, λ, μ, ω, Ω, sopfr, sopf, rad, dr\n• Classifications: square-free, powerful, Harshad, semiprime, abundant/deficient/perfect';

  @override
  String get hlpOlympiadHeader => 'Key Olympiad Formulas';

  @override
  String get hlpIdentitiesTitle => 'Fundamental Identities';

  @override
  String get hlpIdentitiesContent =>
      '• Euler\'s theorem: a^φ(n) ≡ 1 (mod n) if GCD(a,n)=1\n• Fermat\'s little: a^(p−1) ≡ 1 (mod p) if p prime\n• Wilson: (p−1)! ≡ −1 (mod p) ⟺ p is prime\n• Legendre\'s formula: Vₚ(n!) = Σᵢ ⌊n/pⁱ⌋\n• Lucas: C(n,k) mod p = ∏ C(nᵢ,kᵢ) mod p\n• Σ φ(d) for d|n = n\n• Σ μ(d) for d|n = [n=1]\n• φ(mn) = φ(m)φ(n)·GCD(m,n)/φ(GCD(m,n))\n• GCD(F(m),F(n)) = F(GCD(m,n))\n• AM ≥ GM ≥ HM (mean inequality)';

  @override
  String get hlpRefTableTitle => 'Quick Reference Table';

  @override
  String get hlpRefTableContent =>
      'n    φ(n)  λ(n)  μ(n)  σ(n)  ω  Ω\n1    1     1     1     1     0  0\n6    2     2     1     12    2  2\n12   4     2     0     28    2  3\n30   8     4     −1    72    3  3\n60   16    4     0     168   3  4\n100  40    20    0     217   2  4';

  @override
  String get hlpExamplesLabel => 'Examples:';

  @override
  String get hlpTipsLabel => 'Tips:';

  @override
  String get errExprEmpty => 'Error: Empty expression';

  @override
  String get errExprMalformed => 'Error: Malformed expression';

  @override
  String get errExprDivZero => 'Error: Division by zero';

  @override
  String get errResultInvalid => 'Error: Invalid result';

  @override
  String get errAnalysisInvalid => 'Error: Invalid number for analysis';

  @override
  String get errAnalysisFail => 'Cannot analyze the number';

  @override
  String get errNoSolution => 'No solution';

  @override
  String get errIncompatibleSystem => 'Incompatible system';

  @override
  String get errCRTNeedPairs => 'CRT needs pairs (aᵢ, mᵢ)';

  @override
  String errUnknownOp(String op) {
    return 'Unknown operation: $op';
  }
}
