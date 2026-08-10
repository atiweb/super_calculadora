// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Super Calcolatrice';

  @override
  String get appVersion => 'Versione 1.2.1';

  @override
  String get appDeveloped => 'Sviluppata in Flutter';

  @override
  String get appDynamicThemes => 'Con supporto ai temi dinamici';

  @override
  String get navStandard => 'Standard';

  @override
  String get navStandardSub => 'Operazioni di base';

  @override
  String get navScientific => 'Scientifica';

  @override
  String get navScientificSub => 'Funzioni avanzate';

  @override
  String get navSpecial => 'Funzioni speciali';

  @override
  String get navSpecialSub => 'Teoria dei numeri';

  @override
  String get navHistory => 'Cronologia';

  @override
  String get navHistorySub => 'Vedi le operazioni precedenti';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get navSettingsSub => 'Impostazioni dell\'app';

  @override
  String get navHelp => 'Guida';

  @override
  String get navHelpSub => 'Guida alle funzioni speciali';

  @override
  String get navAbout => 'Informazioni';

  @override
  String get navAboutSub => 'Super Calcolatrice v1.2.1';

  @override
  String get navCalculator => 'Calcolatrice';

  @override
  String get navSelectType => 'Seleziona la modalità';

  @override
  String navAngleMode(String mode) {
    return 'Modalità: $mode';
  }

  @override
  String get navRadians => 'Radianti';

  @override
  String get navDegrees => 'Gradi';

  @override
  String get calcAnalysis => 'Analisi';

  @override
  String get calcExpressions => 'Espressioni';

  @override
  String get calcScientific => 'Calcolatrice scientifica';

  @override
  String get calcSpecialFunctions => 'Funzioni speciali';

  @override
  String get calcSuperCalculator => 'Super Calcolatrice';

  @override
  String get calcNumericAnalysis => 'Analisi numerica';

  @override
  String get calcMathExpressions => 'Espressioni matematiche';

  @override
  String get calcResult => 'Risultato:';

  @override
  String get calcProcessing => 'Elaborazione di numeri grandi…';

  @override
  String get calcHighPrecision => 'Calcolo in corso (alta precisione)…';

  @override
  String get calcCancel => 'Annulla';

  @override
  String get displayPaste => 'Incolla';

  @override
  String get displayCopy => 'Copia';

  @override
  String displayCopied(String text) {
    return 'Copiato: $text';
  }

  @override
  String get displayCopyResult => 'Copia il risultato';

  @override
  String get displayPasteNumber => 'Incolla un numero';

  @override
  String get displayClearDisplay => 'Cancella il display';

  @override
  String get displayInvalidNumber =>
      'Errore: il testo incollato non è un numero valido';

  @override
  String get displayNothingToPaste => 'Niente da incollare';

  @override
  String displayPasteError(String error) {
    return 'Errore durante l\'incolla: $error';
  }

  @override
  String displayPasted(String text) {
    return 'Incollato: $text';
  }

  @override
  String get histTitle => 'Cronologia';

  @override
  String get histClearAll => 'Cancella la cronologia';

  @override
  String get histClearAllTooltip => 'Cancella tutta la cronologia';

  @override
  String get histConfirmClear => 'Vuoi davvero eliminare tutta la cronologia?';

  @override
  String histConfirmClearN(String count) {
    return 'Vuoi davvero eliminare tutte le $count operazioni dalla cronologia? L\'azione non può essere annullata.';
  }

  @override
  String get histCleared => 'Cronologia cancellata';

  @override
  String get histDeleted => 'Cronologia eliminata';

  @override
  String get histOperationDeleted => 'Operazione eliminata';

  @override
  String get histCopiedToClipboard => 'Copiato negli appunti';

  @override
  String histCopiedClipboardText(String text) {
    return 'Copiato negli appunti: $text';
  }

  @override
  String get histFullResult => 'Risultato completo';

  @override
  String get histClose => 'Chiudi';

  @override
  String get histExpression => 'Espressione:';

  @override
  String get histResult => 'Risultato:';

  @override
  String get histCopyResult => 'Copia il risultato';

  @override
  String get histCopyAll => 'Copia tutto';

  @override
  String get histCopyExpression => 'Copia l\'espressione';

  @override
  String get histUseResult => 'Usa il risultato';

  @override
  String get histViewResult => 'Vedi il risultato';

  @override
  String get histDelete => 'Elimina';

  @override
  String get histEmpty => 'Nessuna operazione nella cronologia';

  @override
  String get histEmptyHint =>
      'Esegui qualche calcolo per vedere qui la tua cronologia';

  @override
  String get histEmptyHintAlt => 'Le operazioni che esegui compariranno qui';

  @override
  String get histOperations => 'operazioni';

  @override
  String get histNow => 'Adesso';

  @override
  String histErrorLoading(String error) {
    return 'Errore durante il caricamento della cronologia: $error';
  }

  @override
  String histErrorClearing(String error) {
    return 'Errore durante la cancellazione della cronologia: $error';
  }

  @override
  String histErrorDeleting(String error) {
    return 'Errore durante l\'eliminazione dell\'operazione: $error';
  }

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsNumberFormat => 'Formato dei numeri';

  @override
  String get settingsScientificNotation => 'Usa la notazione scientifica';

  @override
  String get settingsScientificHint =>
      'Se disattivata, i numeri vengono mostrati per intero (es. 123000)';

  @override
  String get settingsHighPrecision => 'Modalità alta precisione';

  @override
  String get settingsHighPrecisionHint =>
      'Calcola sin, cos, tan, ln, √… con numeri reali costruttivi esatti (più lento). Le singolarità come tan 90° vengono segnalate come indefinite.';

  @override
  String settingsPrecisionDigits(int digits) {
    return 'Cifre di precisione: $digits';
  }

  @override
  String get settingsOpenSourceLicenses => 'Licenze open source';

  @override
  String get settingsFormatExamples => 'Esempi di formato';

  @override
  String get settingsLargeNumber => 'Numero grande:';

  @override
  String get settingsSmallNumber => 'Numero piccolo:';

  @override
  String get settingsNormal => 'Normale:';

  @override
  String get settingsScientific => 'Scientifica:';

  @override
  String get settingsAboutApp => 'Informazioni sull\'app';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeAuto => 'Automatico';

  @override
  String get themeLightDesc => 'Usa sempre il tema chiaro';

  @override
  String get themeDarkDesc => 'Usa sempre il tema scuro';

  @override
  String get themeAutoDesc => 'Segui le impostazioni di sistema';

  @override
  String get aboutTitle => 'Super Calcolatrice';

  @override
  String get aboutDescription =>
      'Una calcolatrice avanzata con funzioni scientifiche e analisi numerica completa.';

  @override
  String get aboutFeatures => 'Caratteristiche:';

  @override
  String get aboutClose => 'Chiudi';

  @override
  String get aboutFeature1 => 'Numeri fino a 1024 bit';

  @override
  String get aboutFeature2 => 'Precisione decimale a 64 bit';

  @override
  String get aboutFeature3 => 'Modalità calcolatrice standard e scientifica';

  @override
  String get aboutFeature4 => 'Funzioni trigonometriche (sin, cos, tan)';

  @override
  String get aboutFeature5 =>
      'Funzioni trigonometriche inverse (asin, acos, atan)';

  @override
  String get aboutFeature6 => 'Logaritmi naturale (ln) e in base 10 (log)';

  @override
  String get aboutFeature7 => 'Funzioni esponenziali (eˣ, 10ˣ)';

  @override
  String get aboutFeature8 => 'Calcolo del fattoriale (n!)';

  @override
  String get aboutFeature9 => 'Costanti matematiche (π, e)';

  @override
  String get aboutFeature10 => 'Potenze e radici (x², x³, √, ∛)';

  @override
  String get aboutFeature11 => 'Conversione tra gradi e radianti';

  @override
  String get aboutFeature12 => 'Analisi dei numeri primi';

  @override
  String get aboutFeature13 => 'Scomposizione in fattori primi';

  @override
  String get aboutFeature14 => 'Conversione binaria e decimale';

  @override
  String get aboutFeature15 => 'Analisi delle proprietà matematiche';

  @override
  String get aboutFeature16 => 'Operazioni con numeri estremamente grandi';

  @override
  String get aboutFeature17 => 'Calcoli pesanti su thread separati (isolate)';

  @override
  String get aboutFeature18 =>
      'Gestione degli errori di dominio e di dimensione';

  @override
  String get aboutFeature19 =>
      'Strumenti per le Olimpiadi: 11 categorie esatte (frazioni, radicali, geometria, polinomi, algebra, teoria dei numeri, matrici…)';

  @override
  String get aboutFeature20 =>
      'Algebra simbolica: sviluppo e identità in più variabili';

  @override
  String get exprMathExpression => 'Espressione matematica';

  @override
  String get exprHideHistory => 'Nascondi la cronologia';

  @override
  String get exprShowHistory => 'Mostra la cronologia';

  @override
  String get exprClearExpression => 'Cancella l\'espressione';

  @override
  String get exprHint => 'Es.: (5 + 3) * sqrt(9) - 2^3';

  @override
  String get exprDelete => 'Cancella';

  @override
  String get exprEvaluate => 'Calcola (Invio)';

  @override
  String get exprParenthesis => 'Parentesi';

  @override
  String get exprSquareRoot => 'Radice quadrata';

  @override
  String get exprPower => 'Potenza';

  @override
  String get exprSin => 'Seno';

  @override
  String get exprCos => 'Coseno';

  @override
  String get exprTan => 'Tangente';

  @override
  String get exprLog => 'Logaritmo';

  @override
  String get exprLn => 'Logaritmo naturale';

  @override
  String get exprPi => 'Pi';

  @override
  String get exprEuler => 'Euler';

  @override
  String get analysisEnterNumber =>
      'Inserisci un numero per vederne l\'analisi';

  @override
  String get analysisLoading => 'Analisi del numero…';

  @override
  String get analysisLoadingHint =>
      'Per i numeri grandi può richiedere qualche istante';

  @override
  String get analysisLimited => 'Analisi limitata';

  @override
  String get analysisExtremelyLarge => 'Numero estremamente grande';

  @override
  String analysisDigitsCount(String count) {
    return 'Cifre: $count';
  }

  @override
  String get analysisPrimalityNote => 'Nota sull\'analisi di primalità';

  @override
  String analysisOriginalInput(String original, String analyzed) {
    return 'Input originale: $original → Analizzato: $analyzed';
  }

  @override
  String get analysisCalculatingPrimes => 'Calcolo dei numeri primi…';

  @override
  String get analysisSearchingPrimes =>
      'Ricerca del primo precedente e del successivo';

  @override
  String get analysisBasicProperties => 'Proprietà di base';

  @override
  String get analysisValue => 'Valore';

  @override
  String get analysisIsPrime => 'È primo';

  @override
  String get analysisDigits => 'Cifre';

  @override
  String get analysisNextPrime => 'Primo successivo';

  @override
  String get analysisPrevPrime => 'Primo precedente';

  @override
  String get analysisDigitSum => 'Somma delle cifre';

  @override
  String get analysisBinary => 'Binario';

  @override
  String get analysisYes => 'Sì';

  @override
  String get analysisNo => 'No';

  @override
  String get analysisRepresentations => 'Rappresentazioni';

  @override
  String get analysisOctal => 'Ottale';

  @override
  String get analysisHex => 'Esadecimale';

  @override
  String get analysisMathAnalysis => 'Analisi matematica';

  @override
  String get analysisIsPerfect => 'È perfetto';

  @override
  String get analysisIsPalindrome => 'È palindromo';

  @override
  String get analysisIsFibonacci => 'È di Fibonacci';

  @override
  String get analysisIsTriangular => 'È triangolare';

  @override
  String get analysisPrimeFactors => 'Scomposizione in fattori primi';

  @override
  String get analysisPrimeFactorsLabel => 'Fattori primi';

  @override
  String get analysisDivisors => 'Divisori';

  @override
  String get analysisAllDivisors => 'Tutti i divisori';

  @override
  String get analysisDivisorCount => 'Numero di divisori';

  @override
  String get analysisArithmeticFunctions => 'Funzioni aritmetiche';

  @override
  String get analysisEulerPhi => 'φ(n) Euler';

  @override
  String get analysisCarmichael => 'λ(n) Carmichael';

  @override
  String get analysisMobius => 'μ(n) Möbius';

  @override
  String get analysisSmallOmega => 'ω(n) primi distinti';

  @override
  String get analysisBigOmega => 'Ω(n) primi con molt.';

  @override
  String get analysisSopfr => 'sopfr(n) Σprimi rip.';

  @override
  String get analysisSopf => 'sopf(n) Σprimi dist.';

  @override
  String get analysisRadical => 'rad(n) radicale';

  @override
  String get analysisDigitalRoot => 'Radice numerica';

  @override
  String get analysisClassification => 'Classificazione';

  @override
  String get analysisSquareFree => 'Privo di quadrati';

  @override
  String get analysisPowerful => 'Potente';

  @override
  String get analysisHarshad => 'Harshad';

  @override
  String get analysisSemiprime => 'Semiprimo';

  @override
  String get analysisAbundant => 'Abbondante';

  @override
  String get analysisDeficient => 'Difettivo';

  @override
  String get analysisOperations => 'Operazioni';

  @override
  String get analysisSquare => 'Quadrato';

  @override
  String get analysisCube => 'Cubo';

  @override
  String get analysisSquareRootLabel => 'Radice quadrata';

  @override
  String get analysisIsPerfectSquare => 'È un quadrato perfetto';

  @override
  String get analysisCubeRoot => 'Radice cubica';

  @override
  String get analysisIsPerfectCube => 'È un cubo perfetto';

  @override
  String get analysisPerfectPower => 'Potenza perfetta';

  @override
  String get analysisExpression => 'Espressione';

  @override
  String get analysisBase => 'Base';

  @override
  String get analysisExponent => 'Esponente';

  @override
  String get cardPrime => 'Primo';

  @override
  String get cardPerfect => 'Perfetto';

  @override
  String get cardPalindrome => 'Palindromo';

  @override
  String get cardFibonacci => 'Fibonacci';

  @override
  String get cardTriangular => 'Triangolare';

  @override
  String get cardEven => 'Pari';

  @override
  String get cardOdd => 'Dispari';

  @override
  String get cardQuickProperties => 'Proprietà rapide:';

  @override
  String get cardConvert => 'Converti:';

  @override
  String get cardToDecimal => 'In decimale';

  @override
  String get cardToBinary => 'In binario';

  @override
  String get cardAdvancedOps => 'Operazioni avanzate:';

  @override
  String get cardDigits => 'cifre';

  @override
  String get kbdNumberTheory => 'Teoria dei numeri';

  @override
  String get kbdModularArith => 'Aritmetica modulare';

  @override
  String get kbdCombinatorics => 'Calcolo combinatorio';

  @override
  String get kbdStatistics => 'Statistica';

  @override
  String errPower(String error) {
    return 'Errore nella potenza: $error';
  }

  @override
  String errSquareRoot(String error) {
    return 'Errore nella radice quadrata: $error';
  }

  @override
  String get errNegativeSqrt =>
      'Non è possibile calcolare la radice quadrata di un numero negativo';

  @override
  String errCubeRoot(String error) {
    return 'Errore nella radice cubica: $error';
  }

  @override
  String errBinaryConversion(String error) {
    return 'Errore nella conversione in binario: $error';
  }

  @override
  String get errEmptyBinary => 'Numero binario vuoto';

  @override
  String get errInvalidBinary =>
      'Il numero deve contenere solo cifre binarie (0 e 1)';

  @override
  String errBinaryFromConversion(String error) {
    return 'Errore nella conversione dal binario: $error';
  }

  @override
  String get errTrigTooLarge =>
      'Numero troppo grande per le funzioni trigonometriche';

  @override
  String errSin(String error) {
    return 'Errore nel seno: $error';
  }

  @override
  String errCos(String error) {
    return 'Errore nel coseno: $error';
  }

  @override
  String get errTanUndefined => 'Tangente indefinita per questo angolo';

  @override
  String errTan(String error) {
    return 'Errore nella tangente: $error';
  }

  @override
  String get errAsinDomain =>
      'L\'arcoseno è definito solo per valori compresi tra -1 e 1';

  @override
  String errAsin(String error) {
    return 'Errore nell\'arcoseno: $error';
  }

  @override
  String get errAcosDomain =>
      'L\'arcocoseno è definito solo per valori compresi tra -1 e 1';

  @override
  String errAcos(String error) {
    return 'Errore nell\'arcocoseno: $error';
  }

  @override
  String errAtan(String error) {
    return 'Errore nell\'arcotangente: $error';
  }

  @override
  String get errLnDomain =>
      'Il logaritmo naturale è definito solo per numeri positivi';

  @override
  String get errLnTooLarge => 'Numero troppo grande per il logaritmo naturale';

  @override
  String errLn(String error) {
    return 'Errore nel logaritmo naturale: $error';
  }

  @override
  String get errLogDomain => 'Il logaritmo è definito solo per numeri positivi';

  @override
  String get errLogTooLarge =>
      'Numero troppo grande per il logaritmo in base 10';

  @override
  String errLog(String error) {
    return 'Errore nel logaritmo: $error';
  }

  @override
  String get errExpTooLarge => 'Numero troppo grande per l\'esponenziale';

  @override
  String errExp(String error) {
    return 'Errore nell\'esponenziale: $error';
  }

  @override
  String get errTenPowTooLarge => 'Numero troppo grande per 10^x';

  @override
  String errTenPow(String error) {
    return 'Errore in 10^x: $error';
  }

  @override
  String get errFactorialInvalid => 'Numero non valido per il fattoriale';

  @override
  String get errFactorialNonNeg =>
      'Il fattoriale è definito solo per interi non negativi';

  @override
  String get errFactorialTooLarge =>
      'Numero troppo grande per il fattoriale (massimo 170)';

  @override
  String errFactorial(String error) {
    return 'Errore nel fattoriale: $error';
  }

  @override
  String get errOperationCancelled => 'Operazione annullata';

  @override
  String errGeneric(String error) {
    return 'Errore: $error';
  }

  @override
  String get errPhiDomain => 'φ(n) è definita solo per n > 0';

  @override
  String errPhi(String error) {
    return 'Errore in φ(n): $error';
  }

  @override
  String get errPrimorialDomain => 'Il primoriale è definito solo per n ≥ 0';

  @override
  String errPrimorial(String error) {
    return 'Errore nel primoriale: $error';
  }

  @override
  String get errSigma0Domain => 'σ₀(n) è definita solo per n > 0';

  @override
  String errSigma0(String error) {
    return 'Errore in σ₀(n): $error';
  }

  @override
  String get errSigmaDomain => 'σ(m,n) è definita solo per n > 0';

  @override
  String errSigma(String error) {
    return 'Errore in σ(m,n): $error';
  }

  @override
  String errFloorCeil(String error) {
    return 'Errore nella parte intera inferiore/superiore: $error';
  }

  @override
  String get errMobiusDomain => 'μ(n) è definita solo per n > 0';

  @override
  String errMobius(String error) {
    return 'Errore in μ(n): $error';
  }

  @override
  String get errFactorialNeg =>
      'Il fattoriale non è definito per i numeri negativi';

  @override
  String get errFactorialMax => 'n! troppo grande (max n=10000)';

  @override
  String errFactorialN(String error) {
    return 'Errore in n!: $error';
  }

  @override
  String get errDoubleFactorialNeg =>
      'Il semifattoriale non è definito per i numeri negativi';

  @override
  String errDoubleFactorial(String error) {
    return 'Errore in n!!: $error';
  }

  @override
  String get errFibonacciNeg => 'F(n) non è definito per n < 0';

  @override
  String errFibonacci(String error) {
    return 'Errore in F(n): $error';
  }

  @override
  String get errCatalanNeg => 'Catalan non è definito per n < 0';

  @override
  String errCatalan(String error) {
    return 'Errore in Catalan: $error';
  }

  @override
  String get errDerangementNeg => 'D(n) non è definito per n < 0';

  @override
  String errDerangement(String error) {
    return 'Errore in D(n): $error';
  }

  @override
  String get errPartitionNeg => 'p(n) non è definito per n < 0';

  @override
  String errPartition(String error) {
    return 'Errore in p(n): $error';
  }

  @override
  String get errBellNeg => 'B(n) non è definito per n < 0';

  @override
  String errBell(String error) {
    return 'Errore in Bell(n): $error';
  }

  @override
  String errDigitalRoot(String error) {
    return 'Errore nella radice numerica: $error';
  }

  @override
  String get errPrimitiveRootDomain => 'È richiesto n > 1';

  @override
  String errNoPrimitiveRoot(String n) {
    return 'Non esiste una radice primitiva mod $n';
  }

  @override
  String get errLiouvilleDomain => 'λ_L(n) è definita solo per n > 0';

  @override
  String errLiouville(String error) {
    return 'Errore in λ_L(n): $error';
  }

  @override
  String errPrimeCounting(String error) {
    return 'Errore in π(n): $error';
  }

  @override
  String get errRadDomain => 'rad(n) è definita solo per n > 0';

  @override
  String errRad(String error) {
    return 'Errore in rad(n): $error';
  }

  @override
  String get errOmegaDomain => 'ω(n) è definita solo per n > 0';

  @override
  String errOmega(String error) {
    return 'Errore in ω(n): $error';
  }

  @override
  String get errBigOmegaDomain => 'Ω(n) è definita solo per n > 0';

  @override
  String errBigOmega(String error) {
    return 'Errore in Ω(n): $error';
  }

  @override
  String get errCarmichaelDomain => 'λ(n) è definita solo per n > 0';

  @override
  String errCarmichael(String error) {
    return 'Errore in λ(n): $error';
  }

  @override
  String get errSopfrDomain => 'sopfr(n) è definita solo per n > 0';

  @override
  String errSopfr(String error) {
    return 'Errore in sopfr(n): $error';
  }

  @override
  String get errSopfDomain => 'sopf(n) è definita solo per n > 0';

  @override
  String errSopf(String error) {
    return 'Errore in sopf(n): $error';
  }

  @override
  String errPercentage(String error) {
    return 'Errore nella percentuale: $error';
  }

  @override
  String get errDivisionByZero => 'Divisione per zero';

  @override
  String errReciprocal(String error) {
    return 'Errore nel reciproco: $error';
  }

  @override
  String errNoInverse(String a, String n) {
    return 'Non esiste l\'inverso modulare di $a mod $n';
  }

  @override
  String errModPow(String error) {
    return 'Errore nell\'esponenziazione modulare: $error';
  }

  @override
  String errDiophantine(String error) {
    return 'Errore nell\'equazione diofantea: $error';
  }

  @override
  String errCRT(String error) {
    return 'Errore nel TCR: $error';
  }

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLangAuto => 'Automatica (di sistema)';

  @override
  String get settingsLangAutoDesc => 'Usa la lingua del dispositivo';

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
  String get hlpTitle => 'Guida alle funzioni speciali';

  @override
  String get hlpQuickStartHeader => 'Avvio rapido';

  @override
  String get hlpQuickStartWelcome =>
      'Benvenuto nella calcolatrice per le olimpiadi';

  @override
  String get hlpQuickStartStep1 =>
      'Apri il menu laterale (☰) e seleziona «Funzioni speciali»';

  @override
  String get hlpQuickStartStep2 =>
      'La tastiera superiore (scorrevole) ha ~40 funzioni in 4 sezioni';

  @override
  String get hlpQuickStartStep3 =>
      'Inserisci un numero e premi un pulsante di funzione qualsiasi';

  @override
  String get hlpQuickStartStep4 =>
      'Se la funzione richiede altri valori, compare un indicatore di operazione in sospeso';

  @override
  String get hlpQuickStartStep5 =>
      'Il pannello laterale mostra l\'analisi automatica del numero inserito';

  @override
  String get hlpQuickStartNote =>
      'Le funzioni a 1 parametro si eseguono subito.\nQuelle a 2 o più parametri mostrano un indicatore e attendono altri valori.';

  @override
  String get hlpParamHeader => 'Sistema di parametri';

  @override
  String get hlpParamTypesTitle => 'Tipi di funzione in base ai parametri';

  @override
  String get hlpParam1Title => '1 parametro (immediate)';

  @override
  String get hlpParam1Desc =>
      'Inserisci un numero → Premi la funzione → Risultato';

  @override
  String get hlpParam1Example =>
      'Es.: φ(12) → inserisci 12, premi φ → mostra 4';

  @override
  String get hlpParam2Title => '2-3-4 parametri (fissi)';

  @override
  String get hlpParam2Desc =>
      'Inserisci un valore → Funzione → Valore → = → (ripeti se ne servono altri)\nSi esegue da sola quando tutti i parametri sono completi.';

  @override
  String get hlpParam2Example => 'Es.: C(10,3) → inserisci 10 → C(n,k) → 3 → =';

  @override
  String get hlpParamNTitle => 'N parametri (variabili)';

  @override
  String get hlpParamNDesc =>
      'Inserisci un valore → Funzione → Valore → = (aggiungine altri)\nPremi di nuovo LA STESSA FUNZIONE per eseguire.';

  @override
  String get hlpParamNExample =>
      'Es.: MCD(12,18,24) → 12 → MCD → 18 → = → 24 → MCD';

  @override
  String get hlpPendingOpTitle => 'Indicatore di operazione in sospeso';

  @override
  String get hlpPendingOpDesc =>
      'Quando una funzione attende altri valori, sullo schermo compare un indicatore colorato che mostra quale operazione è in corso e che cosa manca.\n\nEsempio: «C(10, _)» indica che manca k per completare C(n,k).\n«MCD(12, 18, _) [= aggiungi, MCD risolvi]» indica un\'operazione a lunghezza variabile.';

  @override
  String get hlpNumberTheoryHeader => 'Teoria dei numeri';

  @override
  String get hlpEulerPhiTitle => 'φ(n) — Funzione φ di Eulero (toziente)';

  @override
  String get hlpEulerPhiParams => '1 param.';

  @override
  String get hlpEulerPhiDesc =>
      'Conta quanti interi da 1 a n sono coprimi con n (cioè MCD(k,n)=1).';

  @override
  String get hlpEulerPhiFormula => 'φ(n) = n × ∏(1 − 1/p) per ogni primo p | n';

  @override
  String get hlpEulerPhiEx1 => 'φ(1) = 1';

  @override
  String get hlpEulerPhiEx2 => 'φ(9) = 6 → [1,2,4,5,7,8]';

  @override
  String get hlpEulerPhiEx3 => 'φ(12) = 4 → [1,5,7,11]';

  @override
  String get hlpEulerPhiEx4 => 'φ(p) = p−1 per p primo';

  @override
  String get hlpEulerPhiTip1 =>
      'Moltiplicativa: φ(mn) = φ(m)φ(n) se MCD(m,n)=1';

  @override
  String get hlpEulerPhiTip2 =>
      'Teorema di Eulero: a^φ(n) ≡ 1 (mod n) se MCD(a,n)=1';

  @override
  String get hlpEulerPhiTip3 => 'Σ φ(d) per d|n = n';

  @override
  String get hlpCarmichaelTitle => 'λ(n) — Funzione λ di Carmichael';

  @override
  String get hlpCarmichaelParams => '1 param.';

  @override
  String get hlpCarmichaelDesc =>
      'Il più piccolo m > 0 tale che a^m ≡ 1 (mod n) per OGNI a coprimo con n. Divide sempre φ(n).';

  @override
  String get hlpCarmichaelFormula =>
      'λ(p^k) = φ(p^k) se p dispari\nλ(2)=1, λ(4)=2, λ(2^k)=2^(k−2) se k≥3\nλ(n) = mcm delle parti';

  @override
  String get hlpCarmichaelEx1 => 'λ(8) = 2';

  @override
  String get hlpCarmichaelEx2 => 'λ(15) = mcm(λ(3),λ(5)) = mcm(2,4) = 4';

  @override
  String get hlpCarmichaelEx3 => 'λ(p) = p−1 per p primo';

  @override
  String get hlpCarmichaelTip1 => 'λ(n) | φ(n) sempre';

  @override
  String get hlpCarmichaelTip2 =>
      'λ(n) = φ(n) se e solo se n ammette una radice primitiva';

  @override
  String get hlpMobiusTitle => 'μ(n) — Funzione di Möbius';

  @override
  String get hlpMobiusParams => '1 param.';

  @override
  String get hlpMobiusDesc =>
      'Rileva se n è privo di quadrati e conta i suoi fattori primi.';

  @override
  String get hlpMobiusFormula =>
      'μ(1) = 1\nμ(n) = (−1)^k se n = p₁·p₂·...·pₖ (distinti)\nμ(n) = 0 se p² | n';

  @override
  String get hlpMobiusEx1 => 'μ(1) = 1';

  @override
  String get hlpMobiusEx2 => 'μ(6) = μ(2×3) = (−1)² = 1';

  @override
  String get hlpMobiusEx3 => 'μ(30) = μ(2×3×5) = (−1)³ = −1';

  @override
  String get hlpMobiusEx4 => 'μ(12) = 0 (contiene 2²)';

  @override
  String get hlpMobiusTip1 =>
      'Inversione di Möbius: se g(n) = Σ f(d) per d|n, allora f(n) = Σ μ(d)g(n/d)';

  @override
  String get hlpMobiusTip2 => 'Σ μ(d) per d|n = [n=1]';

  @override
  String get hlpLiouvilleTitle => 'λL(n) — Funzione di Liouville';

  @override
  String get hlpLiouvilleParams => '1 param.';

  @override
  String get hlpLiouvilleDesc =>
      'Completamente moltiplicativa: λL(n) = (−1)^Ω(n).';

  @override
  String get hlpLiouvilleFormula => 'λL(n) = (−1)^Ω(n)';

  @override
  String get hlpLiouvilleEx1 => 'λL(12) = (−1)³ = −1 (Ω(12)=3)';

  @override
  String get hlpLiouvilleEx2 => 'λL(36) = (−1)⁴ = 1 (Ω(36)=4)';

  @override
  String get hlpLiouvilleTip1 =>
      'Σ λL(d) per d|n = 1 se n è un quadrato perfetto, 0 altrimenti';

  @override
  String get hlpSmallOmegaTitle => 'ω(n) — Fattori primi distinti';

  @override
  String get hlpSmallOmegaParams => '1 param.';

  @override
  String get hlpSmallOmegaDesc =>
      'Conta il numero di primi distinti che dividono n.';

  @override
  String get hlpSmallOmegaFormula => 'ω(n) = k se n = p₁^a₁ × ... × pₖ^aₖ';

  @override
  String get hlpSmallOmegaEx1 => 'ω(12) = 2 → [2, 3]';

  @override
  String get hlpSmallOmegaEx2 => 'ω(30) = 3 → [2, 3, 5]';

  @override
  String get hlpSmallOmegaEx3 => 'ω(p^k) = 1';

  @override
  String get hlpBigOmegaTitle => 'Ω(n) — Fattori primi con molteplicità';

  @override
  String get hlpBigOmegaParams => '1 param.';

  @override
  String get hlpBigOmegaDesc =>
      'Numero totale di fattori primi, ripetizioni comprese.';

  @override
  String get hlpBigOmegaFormula => 'Ω(n) = a₁ + a₂ + ... + aₖ';

  @override
  String get hlpBigOmegaEx1 => 'Ω(12) = 3 → 2×2×3';

  @override
  String get hlpBigOmegaEx2 => 'Ω(72) = 5 → 2³×3² → 3+2';

  @override
  String get hlpBigOmegaEx3 => 'Ω(p) = 1, Ω(p²) = 2';

  @override
  String get hlpSigma0Title => 'σ₀(n) — Numero di divisori';

  @override
  String get hlpSigma0Params => '1 param.';

  @override
  String get hlpSigma0Desc => 'Numero totale di divisori positivi di n.';

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
  String get hlpSigmaTitle => 'σ(n) — Somma dei divisori';

  @override
  String get hlpSigmaParams => '1 param.';

  @override
  String get hlpSigmaDesc => 'Somma di tutti i divisori positivi di n.';

  @override
  String get hlpSigmaFormula => 'σ(n) = Σ d per d | n';

  @override
  String get hlpSigmaEx1 => 'σ(6) = 1+2+3+6 = 12 (6 è perfetto)';

  @override
  String get hlpSigmaEx2 => 'σ(12) = 1+2+3+4+6+12 = 28';

  @override
  String get hlpSigmaEx3 => 'σ(p) = p+1';

  @override
  String get hlpSigmaTip1 => 'n è perfetto ⟺ σ(n) = 2n';

  @override
  String get hlpSigmaTip2 => 'n è abbondante ⟺ σ(n) > 2n';

  @override
  String get hlpSopfrTitle => 'sopfr(n) — Somma dei primi con ripetizione';

  @override
  String get hlpSopfrParams => '1 param.';

  @override
  String get hlpSopfrDesc => 'Somma i fattori primi contando la molteplicità.';

  @override
  String get hlpSopfrFormula => 'sopfr(n) = a₁p₁ + a₂p₂ + ... + aₖpₖ';

  @override
  String get hlpSopfrEx1 => 'sopfr(12) = 2+2+3 = 7';

  @override
  String get hlpSopfrEx2 => 'sopfr(60) = 2+2+3+5 = 12';

  @override
  String get hlpSopfTitle => 'sopf(n) — Somma dei primi distinti';

  @override
  String get hlpSopfParams => '1 param.';

  @override
  String get hlpSopfDesc => 'Somma dei primi distinti che dividono n.';

  @override
  String get hlpSopfFormula => 'sopf(n) = p₁ + p₂ + ... + pₖ';

  @override
  String get hlpSopfEx1 => 'sopf(12) = 2+3 = 5';

  @override
  String get hlpSopfEx2 => 'sopf(60) = 2+3+5 = 10';

  @override
  String get hlpRadTitle => 'rad(n) — Radicale';

  @override
  String get hlpRadParams => '1 param.';

  @override
  String get hlpRadDesc =>
      'Prodotto dei primi distinti che dividono n (funzione della congettura abc).';

  @override
  String get hlpRadFormula => 'rad(n) = ∏ p per p primo, p | n';

  @override
  String get hlpRadEx1 => 'rad(72) = rad(2³×3²) = 2×3 = 6';

  @override
  String get hlpRadEx2 => 'rad(480) = rad(2⁵×3×5) = 30';

  @override
  String get hlpRadEx3 => 'rad(p) = p';

  @override
  String get hlpPrimorialTitle => 'n# — Primoriale';

  @override
  String get hlpPrimorialParams => '1 param.';

  @override
  String get hlpPrimorialDesc => 'Prodotto di tutti i numeri primi ≤ n.';

  @override
  String get hlpPrimorialFormula => 'n# = ∏ p per p primo, p ≤ n';

  @override
  String get hlpPrimorialEx1 => '5# = 2×3×5 = 30';

  @override
  String get hlpPrimorialEx2 => '7# = 210';

  @override
  String get hlpPrimorialEx3 => '11# = 2310';

  @override
  String get hlpPrimeCountTitle => 'π(n) — Funzione enumerativa dei primi';

  @override
  String get hlpPrimeCountParams => '1 param.';

  @override
  String get hlpPrimeCountDesc =>
      'Conta i primi ≤ n. Esatta per n ≤ 1 000 000; approssimazione Li(x) oltre.';

  @override
  String get hlpPrimeCountFormula =>
      'π(n) ~ n/ln(n) (teorema dei numeri primi)';

  @override
  String get hlpPrimeCountEx1 => 'π(10) = 4';

  @override
  String get hlpPrimeCountEx2 => 'π(100) = 25';

  @override
  String get hlpPrimeCountEx3 => 'π(1 000 000) = 78 498';

  @override
  String get hlpDigitalRootTitle => 'dr(n) — Radice numerica';

  @override
  String get hlpDigitalRootParams => '1 param.';

  @override
  String get hlpDigitalRootDesc =>
      'Somma iterata delle cifre fino a ottenere una sola cifra.';

  @override
  String get hlpDigitalRootFormula => 'dr(n) = 1 + (n−1) mod 9  (per n > 0)';

  @override
  String get hlpDigitalRootEx1 => 'dr(493) → 4+9+3=16 → 1+6 = 7';

  @override
  String get hlpDigitalRootEx2 => 'dr(999) = 9';

  @override
  String get hlpDigitalRootEx3 => 'dr(n) ≡ n (mod 9)';

  @override
  String get hlpFloorCeilTitle =>
      '⌊x⌋ / ⌈x⌉ — Parte intera inferiore e superiore';

  @override
  String get hlpFloorCeilParams => '1 param.';

  @override
  String get hlpFloorCeilDesc =>
      'Parte intera inferiore: il più grande intero ≤ x. Parte intera superiore: il più piccolo intero ≥ x. Si alterna tra le due.';

  @override
  String get hlpFloorCeilFormula => '⌊x⌋ ≤ x < ⌊x⌋+1\n⌈x⌉−1 < x ≤ ⌈x⌉';

  @override
  String get hlpFloorCeilEx1 => '⌊3.7⌋ = 3, ⌈3.7⌉ = 4';

  @override
  String get hlpFloorCeilEx2 => '⌊−2.3⌋ = −3, ⌈−2.3⌉ = −2';

  @override
  String get hlpFloorCeilEx3 => '⌊5⌋ = ⌈5⌉ = 5';

  @override
  String get hlpPadicTitle => 'Vₚ(n) — Valutazione p-adica';

  @override
  String get hlpPadicParams => '2 param.: n → Vₚ → p → =';

  @override
  String get hlpPadicDesc => 'La massima potenza del primo p che divide n.';

  @override
  String get hlpPadicFormula => 'Vₚ(n) = max[k : p^k | n]';

  @override
  String get hlpPadicEx1 => 'V₂(24) = 3 → 24 = 2³×3';

  @override
  String get hlpPadicEx2 => 'V₃(81) = 4 → 81 = 3⁴';

  @override
  String get hlpPadicEx3 => 'V₅(100) = 2 → 100 = 2²×5²';

  @override
  String get hlpPadicTip1 => 'Formula di Legendre: Vₚ(n!) = Σ ⌊n/pⁱ⌋';

  @override
  String get hlpPadicTip2 => 'Vₚ(ab) = Vₚ(a) + Vₚ(b)';

  @override
  String get hlpModArithHeader => 'Aritmetica modulare';

  @override
  String get hlpModTitle => 'a mod b — Resto della divisione';

  @override
  String get hlpModParams => '2 param.: a → mod → b → =';

  @override
  String get hlpModDesc => 'Resto della divisione di a per b.';

  @override
  String get hlpModFormula => 'a mod b = a − b × ⌊a/b⌋';

  @override
  String get hlpModEx1 => '17 mod 5 = 2';

  @override
  String get hlpModEx2 => '23 mod 7 = 2';

  @override
  String get hlpModEx3 => '−8 mod 3 = 1';

  @override
  String get hlpModPowTitle => 'a^b mod n — Esponenziazione modulare';

  @override
  String get hlpModPowParams => '3 param.: a → a%n → b → = → n → =';

  @override
  String get hlpModPowDesc =>
      'Calcola a^b mod n in modo efficiente con elevamenti al quadrato successivi, in O(log b).';

  @override
  String get hlpModPowFormula =>
      'Si scompone b in binario e si eleva al quadrato successivamente';

  @override
  String get hlpModPowEx1 => '2¹⁰⁰ mod 7 = 2';

  @override
  String get hlpModPowEx2 => '3¹³ mod 11 = 5';

  @override
  String get hlpModPowEx3 => 'Fondamentale in RSA e nei test di primalità';

  @override
  String get hlpModPowTip1 =>
      'Sequenza: inserisci a → premi a%n → inserisci b → premi = → inserisci n → premi =';

  @override
  String get hlpModInvTitle => 'a⁻¹ mod n — Inverso modulare';

  @override
  String get hlpModInvParams => '2 param.: a → a⁻¹ → n → =';

  @override
  String get hlpModInvDesc =>
      'Trova b tale che a×b ≡ 1 (mod n). Esiste solo se MCD(a,n) = 1.';

  @override
  String get hlpModInvFormula => 'Algoritmo di Euclide esteso';

  @override
  String get hlpModInvEx1 => '3⁻¹ mod 7 = 5 → 3×5=15≡1';

  @override
  String get hlpModInvEx2 => '5⁻¹ mod 11 = 9 → 5×9=45≡1';

  @override
  String get hlpModInvEx3 => 'Non esiste se MCD(a,n) ≠ 1';

  @override
  String get hlpOrdTitle => 'ord_n(a) — Ordine moltiplicativo';

  @override
  String get hlpOrdParams => '2 param.: a → ord → n → =';

  @override
  String get hlpOrdDesc =>
      'Il più piccolo k > 0 con a^k ≡ 1 (mod n). Richiede MCD(a,n)=1.';

  @override
  String get hlpOrdFormula => 'ord_n(a) = min[k > 0 : a^k ≡ 1 (mod n)]';

  @override
  String get hlpOrdEx1 => 'ord₇(2) = 3 → 2³=8≡1';

  @override
  String get hlpOrdEx2 => 'ord₁₀(3) = 4 → 3⁴=81≡1';

  @override
  String get hlpOrdTip1 => 'ord_n(a) divide sempre φ(n)';

  @override
  String get hlpOrdTip2 => 'a è una radice primitiva ⟺ ord_n(a) = φ(n)';

  @override
  String get hlpLegendreTitle => '(a/p) — Simbolo di Legendre';

  @override
  String get hlpLegendreParams => '2 param.: a → (a/p) → p → =';

  @override
  String get hlpLegendreDesc =>
      '1 se a è un residuo quadratico mod p, −1 se non lo è, 0 se p|a. Richiede p primo dispari.';

  @override
  String get hlpLegendreFormula =>
      '(a/p) ≡ a^((p−1)/2) (mod p) — criterio di Eulero';

  @override
  String get hlpLegendreEx1 => '(2/7) = 1 → 3²≡2 (mod 7)';

  @override
  String get hlpLegendreEx2 => '(3/7) = −1 → non esiste x²≡3';

  @override
  String get hlpLegendreEx3 => '(5/5) = 0';

  @override
  String get hlpJacobiTitle => '(a/n)ⱼ — Simbolo di Jacobi';

  @override
  String get hlpJacobiParams => '2 param.: a → (a/n)ⱼ → n → =';

  @override
  String get hlpJacobiDesc =>
      'Generalizzazione di Legendre per n composto dispari. Usa la reciprocità quadratica.';

  @override
  String get hlpJacobiFormula => '(a/n) = ∏(a/pᵢ)^eᵢ dove n = ∏pᵢ^eᵢ';

  @override
  String get hlpJacobiEx1 => '(2/15) = (2/3)(2/5) = (−1)(−1) = 1';

  @override
  String get hlpJacobiEx2 => '(a/n) = −1 ⟹ a NON è un residuo quadratico';

  @override
  String get hlpJacobiEx3 => '(a/n) = 1 NON garantisce che lo sia';

  @override
  String get hlpPrimRootTitle => 'g — Radice primitiva';

  @override
  String get hlpPrimRootParams => '1 param.';

  @override
  String get hlpPrimRootDesc =>
      'La più piccola radice primitiva mod n (se esiste). g è primitiva se ord_n(g) = φ(n).';

  @override
  String get hlpPrimRootFormula => '[g, g², ..., g^φ(n)] = (Z/nZ)*';

  @override
  String get hlpPrimRootEx1 => 'g(7) = 3 → [3,2,6,4,5,1]';

  @override
  String get hlpPrimRootEx2 => 'g(11) = 2';

  @override
  String get hlpPrimRootEx3 => 'Esiste solo per n = 1,2,4,p^k,2p^k';

  @override
  String get hlpGcdTitle => 'MCD — Massimo comune divisore';

  @override
  String get hlpGcdParams => 'N param. (variabile, min. 2)';

  @override
  String get hlpGcdDesc =>
      'Il più grande intero che divide tutti i valori. Accetta 2 o più numeri.';

  @override
  String get hlpGcdFormula => 'MCD(a,b) con l\'algoritmo di Euclide';

  @override
  String get hlpGcdEx1 => 'MCD(12,18) = 6';

  @override
  String get hlpGcdEx2 => 'MCD(12,18,24) = 6';

  @override
  String get hlpGcdEx3 => 'MCD(a,b) × mcm(a,b) = a×b';

  @override
  String get hlpGcdTip1 => 'Sequenza: 12 → MCD → 18 → MCD (esegue)';

  @override
  String get hlpGcdTip2 => 'Per 3 o più numeri: 12 → MCD → 18 → = → 24 → MCD';

  @override
  String get hlpGcdTip3 =>
      'Premi = per aggiungerne altri, premi MCD per eseguire';

  @override
  String get hlpLcmTitle => 'mcm — Minimo comune multiplo';

  @override
  String get hlpLcmParams => 'N param. (variabile, min. 2)';

  @override
  String get hlpLcmDesc =>
      'Il più piccolo intero positivo divisibile per tutti i valori.';

  @override
  String get hlpLcmFormula => 'mcm(a,b) = a×b / MCD(a,b)';

  @override
  String get hlpLcmEx1 => 'mcm(4,6) = 12';

  @override
  String get hlpLcmEx2 => 'mcm(3,5,7) = 105';

  @override
  String get hlpLcmTip1 =>
      'Stessa sequenza del MCD: premi di nuovo mcm per eseguire';

  @override
  String get hlpDiophTitle => 'Dioph — Equazione diofantea lineare';

  @override
  String get hlpDiophParams => '3 param.: a → Dioph → b → = → c → =';

  @override
  String get hlpDiophDesc =>
      'Risolve ax + by = c. Fornisce la soluzione particolare e quella generale.';

  @override
  String get hlpDiophFormula =>
      'ax + by = c ha soluzione ⟺ MCD(a,b) | c\nx = x₀ + (b/g)t,  y = y₀ − (a/g)t';

  @override
  String get hlpDiophEx1 => '3x + 5y = 1 → x=2+5t, y=−1−3t';

  @override
  String get hlpDiophEx2 => '6x + 9y = 12 → x=2+3t, y=0−2t';

  @override
  String get hlpDiophEx3 => '4x + 6y = 3 → Nessuna soluzione';

  @override
  String get hlpDiophTip1 => 'Passo 1: inserisci a (coefficiente di x)';

  @override
  String get hlpDiophTip2 => 'Passo 2: premi Dioph';

  @override
  String get hlpDiophTip3 =>
      'Passo 3: inserisci b (coefficiente di y), premi =';

  @override
  String get hlpDiophTip4 => 'Passo 4: inserisci c (termine noto), premi =';

  @override
  String get hlpCrtTitle => 'TCR — Teorema cinese del resto';

  @override
  String get hlpCrtParams => 'Variabile (4+ param. a coppie a,m)';

  @override
  String get hlpCrtDesc => 'Risolve un sistema di congruenze x ≡ aᵢ (mod mᵢ).';

  @override
  String get hlpCrtFormula =>
      'x ≡ a₁ (mod m₁)\nx ≡ a₂ (mod m₂)\n→ x ≡ r (mod mcm(m₁,m₂))';

  @override
  String get hlpCrtEx1 => 'x≡2(mod 3), x≡3(mod 5) → x≡8(mod 15)';

  @override
  String get hlpCrtEx2 => 'x≡1(mod 4), x≡2(mod 3) → x≡5(mod 12)';

  @override
  String get hlpCrtTip1 => 'Sequenza: a₁ → TCR → m₁ → = → a₂ → = → m₂ → TCR';

  @override
  String get hlpCrtTip2 => 'I moduli devono essere compatibili';

  @override
  String get hlpCombinatoricsHeader => 'Calcolo combinatorio';

  @override
  String get hlpFactorialTitle => 'n! — Fattoriale';

  @override
  String get hlpFactorialParams => '1 param.';

  @override
  String get hlpFactorialDesc => 'Prodotto da 1 a n. Precisione arbitraria.';

  @override
  String get hlpFactorialFormula => 'n! = 1 × 2 × ... × n,  0! = 1';

  @override
  String get hlpFactorialEx1 => '5! = 120';

  @override
  String get hlpFactorialEx2 => '10! = 3 628 800';

  @override
  String get hlpFactorialEx3 => '20! = 2 432 902 008 176 640 000';

  @override
  String get hlpDblFactorialTitle => 'n!! — Semifattoriale';

  @override
  String get hlpDblFactorialParams => '1 param.';

  @override
  String get hlpDblFactorialDesc =>
      'Prodotto degli interi della stessa parità di n.';

  @override
  String get hlpDblFactorialFormula => 'n!! = n × (n−2) × (n−4) × ...';

  @override
  String get hlpDblFactorialEx1 => '7!! = 7×5×3×1 = 105';

  @override
  String get hlpDblFactorialEx2 => '8!! = 8×6×4×2 = 384';

  @override
  String get hlpDblFactorialEx3 => '0!! = 1!! = 1';

  @override
  String get hlpCombTitle => 'C(n,k) — Combinazioni';

  @override
  String get hlpCombParams => '2 param.: n → C(n,k) → k → =';

  @override
  String get hlpCombDesc =>
      'Modi di scegliere k elementi tra n senza tenere conto dell\'ordine.';

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
      'Identità di Pascal (Stifel): C(n,k) = C(n−1,k−1) + C(n−1,k)';

  @override
  String get hlpCombTip2 => 'C(n,k) = C(n, n−k)';

  @override
  String get hlpVarTitle => 'V(n,k) — Disposizioni semplici';

  @override
  String get hlpVarParams => '2 param.: n → V(n,k) → k → =';

  @override
  String get hlpVarDesc =>
      'Modi di scegliere k elementi tra n TENENDO CONTO dell\'ordine.';

  @override
  String get hlpVarFormula => 'V(n,k) = n! / (n−k)!';

  @override
  String get hlpVarEx1 => 'V(5,2) = 20';

  @override
  String get hlpVarEx2 => 'V(10,3) = 720';

  @override
  String get hlpCatalanTitle => 'Cat(n) — Numeri di Catalan';

  @override
  String get hlpCatalanParams => '1 param.';

  @override
  String get hlpCatalanDesc =>
      'Contano alberi binari, triangolazioni, cammini di Dyck, parentesi bilanciate.';

  @override
  String get hlpCatalanFormula => 'Cₙ = C(2n,n)/(n+1)';

  @override
  String get hlpCatalanEx1 => 'C₀ = 1, C₁ = 1, C₂ = 2';

  @override
  String get hlpCatalanEx2 => 'C₃ = 5, C₄ = 14, C₅ = 42';

  @override
  String get hlpDerangementTitle => 'D(n) — Dismutazioni';

  @override
  String get hlpDerangementParams => '1 param.';

  @override
  String get hlpDerangementDesc =>
      'Permutazioni in cui nessun elemento resta al posto iniziale.';

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
  String get hlpBellTitle => 'B(n) — Numeri di Bell';

  @override
  String get hlpBellParams => '1 param.';

  @override
  String get hlpBellDesc =>
      'Numero totale di partizioni di un insieme di n elementi.';

  @override
  String get hlpBellFormula => 'B(n) = Σ S₂(n,k) per k=0..n';

  @override
  String get hlpBellEx1 => 'B(3) = 5';

  @override
  String get hlpBellEx2 => 'B(4) = 15';

  @override
  String get hlpBellEx3 => 'B(5) = 52';

  @override
  String get hlpPartitionTitle => 'p(n) — Partizioni di un intero';

  @override
  String get hlpPartitionParams => '1 param.';

  @override
  String get hlpPartitionDesc =>
      'Modi di scrivere n come somma di interi positivi (l\'ordine non conta).';

  @override
  String get hlpPartitionFormula => 'Calcolato con la programmazione dinamica';

  @override
  String get hlpPartitionEx1 => 'p(4) = 5 → [4, 3+1, 2+2, 2+1+1, 1+1+1+1]';

  @override
  String get hlpPartitionEx2 => 'p(10) = 42';

  @override
  String get hlpPartitionEx3 => 'p(100) = 190 569 292 356';

  @override
  String get hlpStirling2Title => 'S₂(n,k) — Numeri di Stirling di 2ª specie';

  @override
  String get hlpStirling2Params => '2 param.: n → S₂ → k → =';

  @override
  String get hlpStirling2Desc =>
      'Modi di partizionare n elementi in esattamente k sottoinsiemi non vuoti.';

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
      's₁(n,k) — Numeri di Stirling di 1ª specie (senza segno)';

  @override
  String get hlpStirling1Params => '2 param.: n → s₁ → k → =';

  @override
  String get hlpStirling1Desc =>
      'Permutazioni di n elementi con esattamente k cicli.';

  @override
  String get hlpStirling1Formula =>
      '|s₁(n,k)| = (n−1)·|s₁(n−1,k)| + |s₁(n−1,k−1)|';

  @override
  String get hlpStirling1Ex1 => 's₁(4,2) = 11';

  @override
  String get hlpStirling1Ex2 => 's₁(4,1) = 6';

  @override
  String get hlpFibTitle => 'F(n) — n-esimo di Fibonacci';

  @override
  String get hlpFibParams => '1 param.';

  @override
  String get hlpFibDesc =>
      'Calcola F(n) con il raddoppio veloce in O(log n). Accetta n molto grandi.';

  @override
  String get hlpFibFormula => 'F(0)=0, F(1)=1, F(n)=F(n−1)+F(n−2)';

  @override
  String get hlpFibEx1 => 'F(10) = 55';

  @override
  String get hlpFibEx2 => 'F(50) = 12 586 269 025';

  @override
  String get hlpFibEx3 => 'F(100) = 354 224 848 179 261 915 075';

  @override
  String get hlpFibTip1 => 'F(n) mod m è periodico (periodo di Pisano)';

  @override
  String get hlpFibTip2 => 'MCD(F(m), F(n)) = F(MCD(m,n))';

  @override
  String get hlpDigitSumBaseTitle => 'ΣcifB — Somma delle cifre in base b';

  @override
  String get hlpDigitSumBaseParams => '2 param.: n → ΣcifB → b → =';

  @override
  String get hlpDigitSumBaseDesc => 'Somma le cifre di n scritto in base b.';

  @override
  String get hlpDigitSumBaseFormula => 'Se n = Σ dᵢ × bⁱ, allora ΣcifB = Σ dᵢ';

  @override
  String get hlpDigitSumBaseEx1 => 'ΣcifB(255, 2) = 8 → 11111111₂';

  @override
  String get hlpDigitSumBaseEx2 => 'ΣcifB(100, 10) = 1';

  @override
  String get hlpDigitSumBaseEx3 => 'ΣcifB(100, 16) = 10 → 64₁₆';

  @override
  String get hlpStatisticsHeader => 'Statistica';

  @override
  String get hlpArithMeanTitle => 'Media aritmetica — Med A';

  @override
  String get hlpArithMeanParams => 'N param. (variabile, min. 2)';

  @override
  String get hlpArithMeanDesc => 'La media classica di N numeri.';

  @override
  String get hlpArithMeanFormula => 'MA = (x₁ + x₂ + ... + xₙ) / n';

  @override
  String get hlpArithMeanEx1 => 'MA(3, 7) = 5';

  @override
  String get hlpArithMeanEx2 => 'MA(2, 4, 6) = 4';

  @override
  String get hlpArithMeanTip1 => 'Sequenza: 3 → Med A → 7 → Med A (esegue)';

  @override
  String get hlpArithMeanTip2 =>
      'Per 3 o più numeri: 2 → Med A → 4 → = → 6 → Med A';

  @override
  String get hlpGeoMeanTitle => 'Media geometrica — Med G';

  @override
  String get hlpGeoMeanParams => 'N param. (variabile, min. 2)';

  @override
  String get hlpGeoMeanDesc =>
      'Radice n-esima del prodotto. Solo valori positivi.';

  @override
  String get hlpGeoMeanFormula => 'MG = (x₁ × x₂ × ... × xₙ)^(1/n)';

  @override
  String get hlpGeoMeanEx1 => 'MG(2, 8) = 4';

  @override
  String get hlpGeoMeanEx2 => 'MG(1, 4, 9) ≈ 3.30';

  @override
  String get hlpHarmMeanTitle => 'Media armonica — Med H';

  @override
  String get hlpHarmMeanParams => 'N param. (variabile, min. 2)';

  @override
  String get hlpHarmMeanDesc =>
      'Reciproco della media aritmetica dei reciproci. Solo valori positivi.';

  @override
  String get hlpHarmMeanFormula => 'MH = n / (1/x₁ + 1/x₂ + ... + 1/xₙ)';

  @override
  String get hlpHarmMeanEx1 => 'MH(2, 8) = 3.2';

  @override
  String get hlpHarmMeanEx2 => 'MH(1, 4, 9) ≈ 2.08';

  @override
  String get hlpQuadMeanTitle => 'Media quadratica — Med Q';

  @override
  String get hlpQuadMeanParams => 'N param. (variabile, min. 2)';

  @override
  String get hlpQuadMeanDesc => 'Radice della media dei quadrati (RMS).';

  @override
  String get hlpQuadMeanFormula => 'MQ = √((x₁² + x₂² + ... + xₙ²) / n)';

  @override
  String get hlpQuadMeanEx1 => 'MQ(3, 4) ≈ 3.54';

  @override
  String get hlpQuadMeanEx2 => 'MQ(1, 2, 3) ≈ 2.16';

  @override
  String get hlpMinMaxTitle => 'min / max — Minimo e massimo';

  @override
  String get hlpMinMaxParams => 'N param. (variabile, min. 2)';

  @override
  String get hlpMinMaxDesc =>
      'Trova il valore più piccolo/più grande in un insieme di N numeri.';

  @override
  String get hlpMinMaxFormula => 'min(a₁,...,aₙ) e max(a₁,...,aₙ)';

  @override
  String get hlpMinMaxEx1 => 'min(3, 7, 1) = 1';

  @override
  String get hlpMinMaxEx2 => 'max(3, 7, 1) = 7';

  @override
  String get hlpMinMaxTip1 =>
      'Stessa sequenza variabile: premi di nuovo min/max per eseguire';

  @override
  String get hlpMeanInequalityTitle => 'Disuguaglianza tra le medie (MA-MG-MH)';

  @override
  String get hlpMeanInequalityContent =>
      'Per i numeri positivi vale sempre:\n\nMH ≤ MG ≤ MA ≤ MQ\n\nL\'uguaglianza si ha solo quando tutti i valori sono uguali.\nQuesta disuguaglianza è fondamentale nelle olimpiadi.';

  @override
  String get hlpAnalysisPanelHeader => 'Pannello di analisi numerica';

  @override
  String get hlpAutoAnalysisTitle => 'Analisi automatica';

  @override
  String get hlpAutoAnalysisContent =>
      'Appena si inserisce un numero, il pannello di destra (tablet) o quello in basso (cellulare) mostra automaticamente:\n\n• Proprietà: cifre, parità, segno\n• Rappresentazioni: binario, ottale, esadecimale\n• Primalità: test di Miller-Rabin, scomposizione completa\n• Primi vicini: precedente e successivo\n• Divisori: elenco completo, somma, numero\n• Classificazioni: quadrato/cubo perfetto, potenza perfetta, Fibonacci, triangolare, palindromo\n\nPer i numeri fino a 15 cifre mostra anche:\n\n• Funzioni aritmetiche: φ, λ, μ, ω, Ω, sopfr, sopf, rad, dr\n• Classificazioni: privo di quadrati, potente, Harshad, semiprimo, abbondante/difettivo/perfetto';

  @override
  String get hlpHighPrecHeader => 'Alta precisione e strumenti';

  @override
  String get hlpHighPrecTitle => 'Modalità alta precisione';

  @override
  String get hlpHighPrecContent =>
      'Attivala nelle Impostazioni. Calcola sin, cos, tan, ln, log, exp, √ e ∛ con numeri reali costruttivi ESATTI e arrotonda solo al momento di mostrare il risultato (da 5 a 100 cifre). Nessun errore di virgola mobile: √2 a 30 cifre = 1.41421356237309504880168872421. Le singolarità vengono rilevate per costruzione (tan 90° = indefinito). Tutto viene eseguito in secondo piano con un indicatore di caricamento, senza mai bloccare l\'app.';

  @override
  String get hlpNewToolsTitle => 'Strumenti per le Olimpiadi';

  @override
  String get hlpNewToolsContent =>
      'Dal menu laterale → Strumenti per le Olimpiadi: Frazioni, Radicali, Geometria (con disegni: triangolo, Pick, centri e retta di Eulero), Polinomi (grafico, Ruffini, sistemi n×n), Algebra (sviluppo e identità in più variabili), Teoria dei numeri (crivello, orologio modulare, residui), Procedure passo passo, Complessi (circonferenza unitaria, Sierpiński — in alta precisione), Statistica, Matrici (esatte), Analisi (derivata/integrale/limite) e Allenamento con verifica.';

  @override
  String get hlpOlympiadHeader => 'Formule chiave per le olimpiadi';

  @override
  String get hlpIdentitiesTitle => 'Identità fondamentali';

  @override
  String get hlpIdentitiesContent =>
      '• Teorema di Eulero: a^φ(n) ≡ 1 (mod n) se MCD(a,n)=1\n• Piccolo teorema di Fermat: a^(p−1) ≡ 1 (mod p) se p primo\n• Wilson: (p−1)! ≡ −1 (mod p) ⟺ p è primo\n• Formula di Legendre: Vₚ(n!) = Σᵢ ⌊n/pⁱ⌋\n• Lucas: C(n,k) mod p = ∏ C(nᵢ,kᵢ) mod p\n• Σ φ(d) per d|n = n\n• Σ μ(d) per d|n = [n=1]\n• φ(mn) = φ(m)φ(n)·MCD(m,n)/φ(MCD(m,n))\n• MCD(F(m),F(n)) = F(MCD(m,n))\n• MA ≥ MG ≥ MH (disuguaglianza tra le medie)';

  @override
  String get hlpRefTableTitle => 'Tabella di riferimento rapido';

  @override
  String get hlpRefTableContent =>
      'n    φ(n)  λ(n)  μ(n)  σ(n)  ω  Ω\n1    1     1     1     1     0  0\n6    2     2     1     12    2  2\n12   4     2     0     28    2  3\n30   8     4     −1    72    3  3\n60   16    4     0     168   3  4\n100  40    20    0     217   2  4';

  @override
  String get hlpExamplesLabel => 'Esempi:';

  @override
  String get hlpTipsLabel => 'Suggerimenti:';

  @override
  String get errExprEmpty => 'Errore: espressione vuota';

  @override
  String get errExprMalformed => 'Errore: espressione mal formata';

  @override
  String get errExprDivZero => 'Errore: divisione per zero';

  @override
  String get errResultInvalid => 'Errore: risultato non valido';

  @override
  String get errResultTooLarge =>
      'Il risultato è troppo grande per essere calcolato esattamente';

  @override
  String get errAnalysisInvalid => 'Errore: numero non valido per l\'analisi';

  @override
  String get errAnalysisFail => 'Non è possibile analizzare il numero';

  @override
  String get errNoSolution => 'Nessuna soluzione';

  @override
  String get errIncompatibleSystem => 'Sistema incompatibile';

  @override
  String get errCRTNeedPairs => 'Il TCR richiede coppie (aᵢ, mᵢ)';

  @override
  String errUnknownOp(String op) {
    return 'Operazione sconosciuta: $op';
  }
}
