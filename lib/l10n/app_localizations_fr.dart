// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Super Calculatrice';

  @override
  String get appVersion => 'Version 1.2.1';

  @override
  String get appDeveloped => 'Développé avec Flutter';

  @override
  String get appDynamicThemes => 'Avec prise en charge des thèmes dynamiques';

  @override
  String get navStandard => 'Standard';

  @override
  String get navStandardSub => 'Opérations de base';

  @override
  String get navScientific => 'Scientifique';

  @override
  String get navScientificSub => 'Fonctions avancées';

  @override
  String get navSpecial => 'Fonctions spéciales';

  @override
  String get navSpecialSub => 'Théorie des nombres';

  @override
  String get navHistory => 'Historique';

  @override
  String get navHistorySub => 'Voir les opérations précédentes';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navSettingsSub => 'Réglages de l\'application';

  @override
  String get navHelp => 'Aide';

  @override
  String get navHelpSub => 'Guide des fonctions spéciales';

  @override
  String get navAbout => 'À propos';

  @override
  String get navAboutSub => 'Super Calculatrice v1.2.1';

  @override
  String get navCalculator => 'Calculatrice';

  @override
  String get navSelectType => 'Sélectionnez le mode';

  @override
  String navAngleMode(String mode) {
    return 'Mode : $mode';
  }

  @override
  String get navRadians => 'Radians';

  @override
  String get navDegrees => 'Degrés';

  @override
  String get calcAnalysis => 'Analyse';

  @override
  String get calcExpressions => 'Expressions';

  @override
  String get calcScientific => 'Calculatrice scientifique';

  @override
  String get calcSpecialFunctions => 'Fonctions spéciales';

  @override
  String get calcSuperCalculator => 'Super Calculatrice';

  @override
  String get calcNumericAnalysis => 'Analyse numérique';

  @override
  String get calcMathExpressions => 'Expressions mathématiques';

  @override
  String get calcResult => 'Résultat :';

  @override
  String get calcProcessing => 'Traitement des grands nombres…';

  @override
  String get calcHighPrecision => 'Calcul en cours (haute précision)…';

  @override
  String get calcCancel => 'Annuler';

  @override
  String get displayPaste => 'Coller';

  @override
  String get displayCopy => 'Copier';

  @override
  String displayCopied(String text) {
    return 'Copié : $text';
  }

  @override
  String get displayCopyResult => 'Copier le résultat';

  @override
  String get displayPasteNumber => 'Coller un nombre';

  @override
  String get displayClearDisplay => 'Effacer l\'affichage';

  @override
  String get displayInvalidNumber =>
      'Erreur : le texte collé n\'est pas un nombre valide';

  @override
  String get displayNothingToPaste => 'Rien à coller';

  @override
  String displayPasteError(String error) {
    return 'Erreur lors du collage : $error';
  }

  @override
  String displayPasted(String text) {
    return 'Collé : $text';
  }

  @override
  String get histTitle => 'Historique';

  @override
  String get histClearAll => 'Effacer l\'historique';

  @override
  String get histClearAllTooltip => 'Effacer tout l\'historique';

  @override
  String get histConfirmClear =>
      'Voulez-vous vraiment supprimer tout l\'historique ?';

  @override
  String histConfirmClearN(String count) {
    return 'Voulez-vous vraiment supprimer les $count opérations de l\'historique ? Cette action est irréversible.';
  }

  @override
  String get histCleared => 'Historique effacé';

  @override
  String get histDeleted => 'Historique supprimé';

  @override
  String get histOperationDeleted => 'Opération supprimée';

  @override
  String get histCopiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String histCopiedClipboardText(String text) {
    return 'Copié dans le presse-papiers : $text';
  }

  @override
  String get histFullResult => 'Résultat complet';

  @override
  String get histClose => 'Fermer';

  @override
  String get histExpression => 'Expression :';

  @override
  String get histResult => 'Résultat :';

  @override
  String get histCopyResult => 'Copier le résultat';

  @override
  String get histCopyAll => 'Tout copier';

  @override
  String get histCopyExpression => 'Copier l\'expression';

  @override
  String get histUseResult => 'Utiliser le résultat';

  @override
  String get histViewResult => 'Voir le résultat';

  @override
  String get histDelete => 'Supprimer';

  @override
  String get histEmpty => 'Aucune opération dans l\'historique';

  @override
  String get histEmptyHint =>
      'Effectuez quelques calculs pour voir votre historique ici';

  @override
  String get histEmptyHintAlt =>
      'Les opérations que vous effectuez apparaîtront ici';

  @override
  String get histOperations => 'opérations';

  @override
  String get histNow => 'Maintenant';

  @override
  String histErrorLoading(String error) {
    return 'Erreur lors du chargement de l\'historique : $error';
  }

  @override
  String histErrorClearing(String error) {
    return 'Erreur lors de l\'effacement de l\'historique : $error';
  }

  @override
  String histErrorDeleting(String error) {
    return 'Erreur lors de la suppression de l\'opération : $error';
  }

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsNumberFormat => 'Format des nombres';

  @override
  String get settingsScientificNotation => 'Utiliser la notation scientifique';

  @override
  String get settingsScientificHint =>
      'Les nombres s\'affichent en entier (ex. : 123000) lorsque l\'option est désactivée';

  @override
  String get settingsHighPrecision => 'Mode haute précision';

  @override
  String get settingsHighPrecisionHint =>
      'Calcule sin, cos, tan, ln, √… avec des réels constructifs exacts (plus lent). Les singularités comme tan 90° sont signalées comme indéfinies.';

  @override
  String settingsPrecisionDigits(int digits) {
    return 'Chiffres de précision : $digits';
  }

  @override
  String get settingsOpenSourceLicenses => 'Licences open source';

  @override
  String get settingsFormatExamples => 'Exemples de format';

  @override
  String get settingsLargeNumber => 'Grand nombre :';

  @override
  String get settingsSmallNumber => 'Petit nombre :';

  @override
  String get settingsNormal => 'Normal :';

  @override
  String get settingsScientific => 'Scientifique :';

  @override
  String get settingsAboutApp => 'À propos de l\'application';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeAuto => 'Automatique';

  @override
  String get themeLightDesc => 'Toujours utiliser le thème clair';

  @override
  String get themeDarkDesc => 'Toujours utiliser le thème sombre';

  @override
  String get themeAutoDesc => 'Suivre les réglages du système';

  @override
  String get aboutTitle => 'Super Calculatrice';

  @override
  String get aboutDescription =>
      'Une calculatrice avancée dotée de fonctions scientifiques et d\'une analyse numérique complète.';

  @override
  String get aboutFeatures => 'Fonctionnalités :';

  @override
  String get aboutClose => 'Fermer';

  @override
  String get aboutFeature1 => 'Nombres jusqu\'à 1024 bits';

  @override
  String get aboutFeature2 => 'Précision décimale de 64 bits';

  @override
  String get aboutFeature3 => 'Modes calculatrice standard et scientifique';

  @override
  String get aboutFeature4 => 'Fonctions trigonométriques (sin, cos, tan)';

  @override
  String get aboutFeature5 =>
      'Fonctions trigonométriques inverses (asin, acos, atan)';

  @override
  String get aboutFeature6 => 'Logarithmes népérien (ln) et décimal (log)';

  @override
  String get aboutFeature7 => 'Fonctions exponentielles (eˣ, 10ˣ)';

  @override
  String get aboutFeature8 => 'Calcul de factorielle (n!)';

  @override
  String get aboutFeature9 => 'Constantes mathématiques (π, e)';

  @override
  String get aboutFeature10 => 'Puissances et racines (x², x³, √, ∛)';

  @override
  String get aboutFeature11 => 'Conversion entre degrés et radians';

  @override
  String get aboutFeature12 => 'Analyse des nombres premiers';

  @override
  String get aboutFeature13 => 'Décomposition en facteurs premiers';

  @override
  String get aboutFeature14 => 'Conversion binaire et décimale';

  @override
  String get aboutFeature15 => 'Analyse des propriétés mathématiques';

  @override
  String get aboutFeature16 => 'Opérations sur des nombres extrêmement grands';

  @override
  String get aboutFeature17 =>
      'Calculs lourds sur des threads séparés (isolates)';

  @override
  String get aboutFeature18 => 'Gestion des erreurs de domaine et de taille';

  @override
  String get aboutFeature19 =>
      'Outils d\'Olympiades : 11 catégories exactes (fractions, radicaux, géométrie, polynômes, algèbre, théorie des nombres, matrices…)';

  @override
  String get aboutFeature20 =>
      'Algèbre symbolique : développement et identités à plusieurs variables';

  @override
  String get exprMathExpression => 'Expression mathématique';

  @override
  String get exprHideHistory => 'Masquer l\'historique';

  @override
  String get exprShowHistory => 'Afficher l\'historique';

  @override
  String get exprClearExpression => 'Effacer l\'expression';

  @override
  String get exprHint => 'Ex. : (5 + 3) * sqrt(9) - 2^3';

  @override
  String get exprDelete => 'Effacer';

  @override
  String get exprEvaluate => 'Évaluer (Entrée)';

  @override
  String get exprParenthesis => 'Parenthèses';

  @override
  String get exprSquareRoot => 'Racine carrée';

  @override
  String get exprPower => 'Puissance';

  @override
  String get exprSin => 'Sinus';

  @override
  String get exprCos => 'Cosinus';

  @override
  String get exprTan => 'Tangente';

  @override
  String get exprLog => 'Logarithme';

  @override
  String get exprLn => 'Logarithme népérien';

  @override
  String get exprPi => 'Pi';

  @override
  String get exprEuler => 'Euler';

  @override
  String get analysisEnterNumber => 'Saisissez un nombre pour voir son analyse';

  @override
  String get analysisLoading => 'Analyse du nombre…';

  @override
  String get analysisLoadingHint =>
      'Cela peut prendre un instant pour les grands nombres';

  @override
  String get analysisLimited => 'Analyse limitée';

  @override
  String get analysisExtremelyLarge => 'Nombre extrêmement grand';

  @override
  String analysisDigitsCount(String count) {
    return 'Chiffres : $count';
  }

  @override
  String get analysisPrimalityNote => 'Remarque sur l\'analyse de primalité';

  @override
  String analysisOriginalInput(String original, String analyzed) {
    return 'Saisie d\'origine : $original → Analysé : $analyzed';
  }

  @override
  String get analysisCalculatingPrimes => 'Calcul des nombres premiers…';

  @override
  String get analysisSearchingPrimes =>
      'Recherche du premier précédent et du suivant';

  @override
  String get analysisBasicProperties => 'Propriétés de base';

  @override
  String get analysisValue => 'Valeur';

  @override
  String get analysisIsPrime => 'Est premier';

  @override
  String get analysisDigits => 'Chiffres';

  @override
  String get analysisNextPrime => 'Premier suivant';

  @override
  String get analysisPrevPrime => 'Premier précédent';

  @override
  String get analysisDigitSum => 'Somme des chiffres';

  @override
  String get analysisBinary => 'Binaire';

  @override
  String get analysisYes => 'Oui';

  @override
  String get analysisNo => 'Non';

  @override
  String get analysisRepresentations => 'Représentations';

  @override
  String get analysisOctal => 'Octal';

  @override
  String get analysisHex => 'Hexadécimal';

  @override
  String get analysisMathAnalysis => 'Analyse mathématique';

  @override
  String get analysisIsPerfect => 'Est parfait';

  @override
  String get analysisIsPalindrome => 'Est palindrome';

  @override
  String get analysisIsFibonacci => 'Est de Fibonacci';

  @override
  String get analysisIsTriangular => 'Est triangulaire';

  @override
  String get analysisPrimeFactors => 'Décomposition en facteurs premiers';

  @override
  String get analysisPrimeFactorsLabel => 'Facteurs premiers';

  @override
  String get analysisDivisors => 'Diviseurs';

  @override
  String get analysisAllDivisors => 'Tous les diviseurs';

  @override
  String get analysisDivisorCount => 'Nombre de diviseurs';

  @override
  String get analysisArithmeticFunctions => 'Fonctions arithmétiques';

  @override
  String get analysisEulerPhi => 'φ(n) Euler';

  @override
  String get analysisCarmichael => 'λ(n) Carmichael';

  @override
  String get analysisMobius => 'μ(n) Möbius';

  @override
  String get analysisSmallOmega => 'ω(n) premiers distincts';

  @override
  String get analysisBigOmega => 'Ω(n) premiers avec mult.';

  @override
  String get analysisSopfr => 'sopfr(n) Σpremiers rép.';

  @override
  String get analysisSopf => 'sopf(n) Σpremiers dist.';

  @override
  String get analysisRadical => 'rad(n) radical';

  @override
  String get analysisDigitalRoot => 'Racine numérique';

  @override
  String get analysisClassification => 'Classification';

  @override
  String get analysisSquareFree => 'Sans facteur carré';

  @override
  String get analysisPowerful => 'Puissant';

  @override
  String get analysisHarshad => 'Harshad';

  @override
  String get analysisSemiprime => 'Semi-premier';

  @override
  String get analysisAbundant => 'Abondant';

  @override
  String get analysisDeficient => 'Déficient';

  @override
  String get analysisOperations => 'Opérations';

  @override
  String get analysisSquare => 'Carré';

  @override
  String get analysisCube => 'Cube';

  @override
  String get analysisSquareRootLabel => 'Racine carrée';

  @override
  String get analysisIsPerfectSquare => 'Est un carré parfait';

  @override
  String get analysisCubeRoot => 'Racine cubique';

  @override
  String get analysisIsPerfectCube => 'Est un cube parfait';

  @override
  String get analysisPerfectPower => 'Puissance parfaite';

  @override
  String get analysisExpression => 'Expression';

  @override
  String get analysisBase => 'Base';

  @override
  String get analysisExponent => 'Exposant';

  @override
  String get cardPrime => 'Premier';

  @override
  String get cardPerfect => 'Parfait';

  @override
  String get cardPalindrome => 'Palindrome';

  @override
  String get cardFibonacci => 'Fibonacci';

  @override
  String get cardTriangular => 'Triangulaire';

  @override
  String get cardEven => 'Pair';

  @override
  String get cardOdd => 'Impair';

  @override
  String get cardQuickProperties => 'Propriétés rapides :';

  @override
  String get cardConvert => 'Convertir :';

  @override
  String get cardToDecimal => 'En décimal';

  @override
  String get cardToBinary => 'En binaire';

  @override
  String get cardAdvancedOps => 'Opérations avancées :';

  @override
  String get cardDigits => 'chiffres';

  @override
  String get kbdNumberTheory => 'Théorie des nombres';

  @override
  String get kbdModularArith => 'Arithmétique modulaire';

  @override
  String get kbdCombinatorics => 'Combinatoire';

  @override
  String get kbdStatistics => 'Statistiques';

  @override
  String errPower(String error) {
    return 'Erreur de puissance : $error';
  }

  @override
  String errSquareRoot(String error) {
    return 'Erreur de racine carrée : $error';
  }

  @override
  String get errNegativeSqrt =>
      'Impossible de calculer la racine carrée d\'un nombre négatif';

  @override
  String errCubeRoot(String error) {
    return 'Erreur de racine cubique : $error';
  }

  @override
  String errBinaryConversion(String error) {
    return 'Erreur de conversion binaire : $error';
  }

  @override
  String get errEmptyBinary => 'Nombre binaire vide';

  @override
  String get errInvalidBinary =>
      'Le nombre ne doit contenir que des chiffres binaires (0 et 1)';

  @override
  String errBinaryFromConversion(String error) {
    return 'Erreur de conversion depuis le binaire : $error';
  }

  @override
  String get errTrigTooLarge =>
      'Nombre trop grand pour les fonctions trigonométriques';

  @override
  String errSin(String error) {
    return 'Erreur de sinus : $error';
  }

  @override
  String errCos(String error) {
    return 'Erreur de cosinus : $error';
  }

  @override
  String get errTanUndefined => 'Tangente indéfinie pour cet angle';

  @override
  String errTan(String error) {
    return 'Erreur de tangente : $error';
  }

  @override
  String get errAsinDomain =>
      'L\'arc sinus n\'est défini que pour des valeurs entre -1 et 1';

  @override
  String errAsin(String error) {
    return 'Erreur d\'arc sinus : $error';
  }

  @override
  String get errAcosDomain =>
      'L\'arc cosinus n\'est défini que pour des valeurs entre -1 et 1';

  @override
  String errAcos(String error) {
    return 'Erreur d\'arc cosinus : $error';
  }

  @override
  String errAtan(String error) {
    return 'Erreur d\'arc tangente : $error';
  }

  @override
  String get errLnDomain =>
      'Le logarithme népérien n\'est défini que pour les nombres positifs';

  @override
  String get errLnTooLarge => 'Nombre trop grand pour le logarithme népérien';

  @override
  String errLn(String error) {
    return 'Erreur de logarithme népérien : $error';
  }

  @override
  String get errLogDomain =>
      'Le logarithme n\'est défini que pour les nombres positifs';

  @override
  String get errLogTooLarge => 'Nombre trop grand pour le logarithme décimal';

  @override
  String errLog(String error) {
    return 'Erreur de logarithme : $error';
  }

  @override
  String get errExpTooLarge => 'Nombre trop grand pour l\'exponentielle';

  @override
  String errExp(String error) {
    return 'Erreur d\'exponentielle : $error';
  }

  @override
  String get errTenPowTooLarge => 'Nombre trop grand pour 10^x';

  @override
  String errTenPow(String error) {
    return 'Erreur de 10^x : $error';
  }

  @override
  String get errFactorialInvalid => 'Nombre invalide pour la factorielle';

  @override
  String get errFactorialNonNeg =>
      'La factorielle n\'est définie que pour les entiers positifs ou nuls';

  @override
  String get errFactorialTooLarge =>
      'Nombre trop grand pour la factorielle (maximum 170)';

  @override
  String errFactorial(String error) {
    return 'Erreur de factorielle : $error';
  }

  @override
  String get errOperationCancelled => 'Opération annulée';

  @override
  String errGeneric(String error) {
    return 'Erreur : $error';
  }

  @override
  String get errPhiDomain => 'φ(n) n\'est défini que pour n > 0';

  @override
  String errPhi(String error) {
    return 'Erreur de φ(n) : $error';
  }

  @override
  String get errPrimorialDomain =>
      'La primorielle n\'est définie que pour n ≥ 0';

  @override
  String errPrimorial(String error) {
    return 'Erreur de primorielle : $error';
  }

  @override
  String get errSigma0Domain => 'σ₀(n) n\'est défini que pour n > 0';

  @override
  String errSigma0(String error) {
    return 'Erreur de σ₀(n) : $error';
  }

  @override
  String get errSigmaDomain => 'σ(m,n) n\'est défini que pour n > 0';

  @override
  String errSigma(String error) {
    return 'Erreur de σ(m,n) : $error';
  }

  @override
  String errFloorCeil(String error) {
    return 'Erreur de plancher/plafond : $error';
  }

  @override
  String get errMobiusDomain => 'μ(n) n\'est défini que pour n > 0';

  @override
  String errMobius(String error) {
    return 'Erreur de μ(n) : $error';
  }

  @override
  String get errFactorialNeg =>
      'La factorielle n\'est pas définie pour les nombres négatifs';

  @override
  String get errFactorialMax => 'n! trop grand (max n=10000)';

  @override
  String errFactorialN(String error) {
    return 'Erreur de n! : $error';
  }

  @override
  String get errDoubleFactorialNeg =>
      'La double factorielle n\'est pas définie pour les nombres négatifs';

  @override
  String errDoubleFactorial(String error) {
    return 'Erreur de n!! : $error';
  }

  @override
  String get errFibonacciNeg => 'F(n) n\'est pas défini pour n < 0';

  @override
  String errFibonacci(String error) {
    return 'Erreur de F(n) : $error';
  }

  @override
  String get errCatalanNeg => 'Catalan n\'est pas défini pour n < 0';

  @override
  String errCatalan(String error) {
    return 'Erreur de Catalan : $error';
  }

  @override
  String get errDerangementNeg => 'D(n) n\'est pas défini pour n < 0';

  @override
  String errDerangement(String error) {
    return 'Erreur de D(n) : $error';
  }

  @override
  String get errPartitionNeg => 'p(n) n\'est pas défini pour n < 0';

  @override
  String errPartition(String error) {
    return 'Erreur de p(n) : $error';
  }

  @override
  String get errBellNeg => 'B(n) n\'est pas défini pour n < 0';

  @override
  String errBell(String error) {
    return 'Erreur de Bell(n) : $error';
  }

  @override
  String errDigitalRoot(String error) {
    return 'Erreur de racine numérique : $error';
  }

  @override
  String get errPrimitiveRootDomain => 'n > 1 est requis';

  @override
  String errNoPrimitiveRoot(String n) {
    return 'Il n\'existe pas de racine primitive mod $n';
  }

  @override
  String get errLiouvilleDomain => 'λ_L(n) n\'est défini que pour n > 0';

  @override
  String errLiouville(String error) {
    return 'Erreur de λ_L(n) : $error';
  }

  @override
  String errPrimeCounting(String error) {
    return 'Erreur de π(n) : $error';
  }

  @override
  String get errRadDomain => 'rad(n) n\'est défini que pour n > 0';

  @override
  String errRad(String error) {
    return 'Erreur de rad(n) : $error';
  }

  @override
  String get errOmegaDomain => 'ω(n) n\'est défini que pour n > 0';

  @override
  String errOmega(String error) {
    return 'Erreur de ω(n) : $error';
  }

  @override
  String get errBigOmegaDomain => 'Ω(n) n\'est défini que pour n > 0';

  @override
  String errBigOmega(String error) {
    return 'Erreur de Ω(n) : $error';
  }

  @override
  String get errCarmichaelDomain => 'λ(n) n\'est défini que pour n > 0';

  @override
  String errCarmichael(String error) {
    return 'Erreur de λ(n) : $error';
  }

  @override
  String get errSopfrDomain => 'sopfr(n) n\'est défini que pour n > 0';

  @override
  String errSopfr(String error) {
    return 'Erreur de sopfr(n) : $error';
  }

  @override
  String get errSopfDomain => 'sopf(n) n\'est défini que pour n > 0';

  @override
  String errSopf(String error) {
    return 'Erreur de sopf(n) : $error';
  }

  @override
  String errPercentage(String error) {
    return 'Erreur de pourcentage : $error';
  }

  @override
  String get errDivisionByZero => 'Division par zéro';

  @override
  String errReciprocal(String error) {
    return 'Erreur d\'inverse : $error';
  }

  @override
  String errNoInverse(String a, String n) {
    return 'Il n\'existe pas d\'inverse modulaire de $a mod $n';
  }

  @override
  String errModPow(String error) {
    return 'Erreur d\'exponentiation modulaire : $error';
  }

  @override
  String errDiophantine(String error) {
    return 'Erreur d\'équation diophantienne : $error';
  }

  @override
  String errCRT(String error) {
    return 'Erreur du TRC : $error';
  }

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLangAuto => 'Automatique (système)';

  @override
  String get settingsLangAutoDesc => 'Utiliser la langue de l\'appareil';

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
  String get hlpTitle => 'Guide des fonctions spéciales';

  @override
  String get hlpQuickStartHeader => 'Démarrage rapide';

  @override
  String get hlpQuickStartWelcome =>
      'Bienvenue dans la calculatrice pour olympiades';

  @override
  String get hlpQuickStartStep1 =>
      'Ouvrez le menu latéral (☰) et sélectionnez « Fonctions spéciales »';

  @override
  String get hlpQuickStartStep2 =>
      'Le clavier supérieur (défilant) comporte ~40 fonctions réparties en 4 sections';

  @override
  String get hlpQuickStartStep3 =>
      'Saisissez un nombre et appuyez sur n\'importe quel bouton de fonction';

  @override
  String get hlpQuickStartStep4 =>
      'Si la fonction attend d\'autres valeurs, un indicateur d\'opération en attente apparaît';

  @override
  String get hlpQuickStartStep5 =>
      'Le panneau latéral affiche l\'analyse automatique du nombre saisi';

  @override
  String get hlpQuickStartNote =>
      'Les fonctions à 1 paramètre s\'exécutent immédiatement.\nCelles à 2 paramètres ou plus affichent un indicateur et attendent d\'autres valeurs.';

  @override
  String get hlpParamHeader => 'Système de paramètres';

  @override
  String get hlpParamTypesTitle => 'Types de fonctions selon les paramètres';

  @override
  String get hlpParam1Title => '1 paramètre (immédiates)';

  @override
  String get hlpParam1Desc =>
      'Saisissez un nombre → Appuyez sur la fonction → Résultat';

  @override
  String get hlpParam1Example =>
      'Ex. : φ(12) → saisissez 12, appuyez sur φ → affiche 4';

  @override
  String get hlpParam2Title => '2-3-4 paramètres (fixes)';

  @override
  String get hlpParam2Desc =>
      'Saisissez une valeur → Fonction → Valeur → = → (répétez si besoin)\nS\'exécute automatiquement une fois tous les paramètres saisis.';

  @override
  String get hlpParam2Example =>
      'Ex. : C(10,3) → saisissez 10 → C(n,k) → 3 → =';

  @override
  String get hlpParamNTitle => 'N paramètres (variables)';

  @override
  String get hlpParamNDesc =>
      'Saisissez une valeur → Fonction → Valeur → = (ajoutez-en d\'autres)\nAppuyez de nouveau sur LA MÊME FONCTION pour exécuter.';

  @override
  String get hlpParamNExample =>
      'Ex. : PGCD(12,18,24) → 12 → PGCD → 18 → = → 24 → PGCD';

  @override
  String get hlpPendingOpTitle => 'Indicateur d\'opération en attente';

  @override
  String get hlpPendingOpDesc =>
      'Lorsqu\'une fonction attend d\'autres valeurs, un indicateur coloré apparaît à l\'écran et montre quelle opération est en cours et ce qui manque.\n\nExemple : « C(10, _) » indique qu\'il manque k pour compléter C(n,k).\n« PGCD(12, 18, _) [= ajouter, PGCD résoudre] » indique une opération à longueur variable.';

  @override
  String get hlpNumberTheoryHeader => 'Théorie des nombres';

  @override
  String get hlpEulerPhiTitle => 'φ(n) — Indicatrice d\'Euler';

  @override
  String get hlpEulerPhiParams => '1 param';

  @override
  String get hlpEulerPhiDesc =>
      'Compte les entiers de 1 à n qui sont premiers avec n (c\'est-à-dire PGCD(k,n)=1).';

  @override
  String get hlpEulerPhiFormula =>
      'φ(n) = n × ∏(1 − 1/p) pour chaque premier p | n';

  @override
  String get hlpEulerPhiEx1 => 'φ(1) = 1';

  @override
  String get hlpEulerPhiEx2 => 'φ(9) = 6 → [1,2,4,5,7,8]';

  @override
  String get hlpEulerPhiEx3 => 'φ(12) = 4 → [1,5,7,11]';

  @override
  String get hlpEulerPhiEx4 => 'φ(p) = p−1 pour p premier';

  @override
  String get hlpEulerPhiTip1 =>
      'Multiplicative : φ(mn) = φ(m)φ(n) si PGCD(m,n)=1';

  @override
  String get hlpEulerPhiTip2 =>
      'Théorème d\'Euler : a^φ(n) ≡ 1 (mod n) si PGCD(a,n)=1';

  @override
  String get hlpEulerPhiTip3 => 'Σ φ(d) pour d|n = n';

  @override
  String get hlpCarmichaelTitle => 'λ(n) — Fonction λ de Carmichael';

  @override
  String get hlpCarmichaelParams => '1 param';

  @override
  String get hlpCarmichaelDesc =>
      'Le plus petit m > 0 tel que a^m ≡ 1 (mod n) pour TOUT a premier avec n. Divise toujours φ(n).';

  @override
  String get hlpCarmichaelFormula =>
      'λ(p^k) = φ(p^k) si p impair\nλ(2)=1, λ(4)=2, λ(2^k)=2^(k−2) si k≥3\nλ(n) = ppcm des parties';

  @override
  String get hlpCarmichaelEx1 => 'λ(8) = 2';

  @override
  String get hlpCarmichaelEx2 => 'λ(15) = ppcm(λ(3),λ(5)) = ppcm(2,4) = 4';

  @override
  String get hlpCarmichaelEx3 => 'λ(p) = p−1 pour p premier';

  @override
  String get hlpCarmichaelTip1 => 'λ(n) | φ(n) toujours';

  @override
  String get hlpCarmichaelTip2 =>
      'λ(n) = φ(n) si et seulement si n admet une racine primitive';

  @override
  String get hlpMobiusTitle => 'μ(n) — Fonction de Möbius';

  @override
  String get hlpMobiusParams => '1 param';

  @override
  String get hlpMobiusDesc =>
      'Détecte si n est sans facteur carré et compte ses facteurs premiers.';

  @override
  String get hlpMobiusFormula =>
      'μ(1) = 1\nμ(n) = (−1)^k si n = p₁·p₂·...·pₖ (distincts)\nμ(n) = 0 si p² | n';

  @override
  String get hlpMobiusEx1 => 'μ(1) = 1';

  @override
  String get hlpMobiusEx2 => 'μ(6) = μ(2×3) = (−1)² = 1';

  @override
  String get hlpMobiusEx3 => 'μ(30) = μ(2×3×5) = (−1)³ = −1';

  @override
  String get hlpMobiusEx4 => 'μ(12) = 0 (contient 2²)';

  @override
  String get hlpMobiusTip1 =>
      'Inversion de Möbius : si g(n) = Σ f(d) pour d|n, alors f(n) = Σ μ(d)g(n/d)';

  @override
  String get hlpMobiusTip2 => 'Σ μ(d) pour d|n = [n=1]';

  @override
  String get hlpLiouvilleTitle => 'λL(n) — Fonction de Liouville';

  @override
  String get hlpLiouvilleParams => '1 param';

  @override
  String get hlpLiouvilleDesc =>
      'Complètement multiplicative : λL(n) = (−1)^Ω(n).';

  @override
  String get hlpLiouvilleFormula => 'λL(n) = (−1)^Ω(n)';

  @override
  String get hlpLiouvilleEx1 => 'λL(12) = (−1)³ = −1 (Ω(12)=3)';

  @override
  String get hlpLiouvilleEx2 => 'λL(36) = (−1)⁴ = 1 (Ω(36)=4)';

  @override
  String get hlpLiouvilleTip1 =>
      'Σ λL(d) pour d|n = 1 si n est un carré parfait, 0 sinon';

  @override
  String get hlpSmallOmegaTitle => 'ω(n) — Facteurs premiers distincts';

  @override
  String get hlpSmallOmegaParams => '1 param';

  @override
  String get hlpSmallOmegaDesc =>
      'Compte le nombre de premiers distincts qui divisent n.';

  @override
  String get hlpSmallOmegaFormula => 'ω(n) = k si n = p₁^a₁ × ... × pₖ^aₖ';

  @override
  String get hlpSmallOmegaEx1 => 'ω(12) = 2 → [2, 3]';

  @override
  String get hlpSmallOmegaEx2 => 'ω(30) = 3 → [2, 3, 5]';

  @override
  String get hlpSmallOmegaEx3 => 'ω(p^k) = 1';

  @override
  String get hlpBigOmegaTitle => 'Ω(n) — Facteurs premiers avec multiplicité';

  @override
  String get hlpBigOmegaParams => '1 param';

  @override
  String get hlpBigOmegaDesc =>
      'Nombre total de facteurs premiers, répétitions comprises.';

  @override
  String get hlpBigOmegaFormula => 'Ω(n) = a₁ + a₂ + ... + aₖ';

  @override
  String get hlpBigOmegaEx1 => 'Ω(12) = 3 → 2×2×3';

  @override
  String get hlpBigOmegaEx2 => 'Ω(72) = 5 → 2³×3² → 3+2';

  @override
  String get hlpBigOmegaEx3 => 'Ω(p) = 1, Ω(p²) = 2';

  @override
  String get hlpSigma0Title => 'σ₀(n) — Nombre de diviseurs';

  @override
  String get hlpSigma0Params => '1 param';

  @override
  String get hlpSigma0Desc => 'Nombre total de diviseurs positifs de n.';

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
  String get hlpSigmaTitle => 'σ(n) — Somme des diviseurs';

  @override
  String get hlpSigmaParams => '1 param';

  @override
  String get hlpSigmaDesc => 'Somme de tous les diviseurs positifs de n.';

  @override
  String get hlpSigmaFormula => 'σ(n) = Σ d pour d | n';

  @override
  String get hlpSigmaEx1 => 'σ(6) = 1+2+3+6 = 12 (6 est parfait)';

  @override
  String get hlpSigmaEx2 => 'σ(12) = 1+2+3+4+6+12 = 28';

  @override
  String get hlpSigmaEx3 => 'σ(p) = p+1';

  @override
  String get hlpSigmaTip1 => 'n est parfait ⟺ σ(n) = 2n';

  @override
  String get hlpSigmaTip2 => 'n est abondant ⟺ σ(n) > 2n';

  @override
  String get hlpSopfrTitle => 'sopfr(n) — Somme des premiers avec répétition';

  @override
  String get hlpSopfrParams => '1 param';

  @override
  String get hlpSopfrDesc =>
      'Somme des facteurs premiers en comptant la multiplicité.';

  @override
  String get hlpSopfrFormula => 'sopfr(n) = a₁p₁ + a₂p₂ + ... + aₖpₖ';

  @override
  String get hlpSopfrEx1 => 'sopfr(12) = 2+2+3 = 7';

  @override
  String get hlpSopfrEx2 => 'sopfr(60) = 2+2+3+5 = 12';

  @override
  String get hlpSopfTitle => 'sopf(n) — Somme des premiers distincts';

  @override
  String get hlpSopfParams => '1 param';

  @override
  String get hlpSopfDesc => 'Somme des premiers distincts qui divisent n.';

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
      'Produit des premiers distincts qui divisent n (fonction de la conjecture abc).';

  @override
  String get hlpRadFormula => 'rad(n) = ∏ p pour p premier, p | n';

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
  String get hlpPrimorialDesc => 'Produit de tous les nombres premiers ≤ n.';

  @override
  String get hlpPrimorialFormula => 'n# = ∏ p pour p premier, p ≤ n';

  @override
  String get hlpPrimorialEx1 => '5# = 2×3×5 = 30';

  @override
  String get hlpPrimorialEx2 => '7# = 210';

  @override
  String get hlpPrimorialEx3 => '11# = 2310';

  @override
  String get hlpPrimeCountTitle =>
      'π(n) — Fonction de compte des nombres premiers';

  @override
  String get hlpPrimeCountParams => '1 param';

  @override
  String get hlpPrimeCountDesc =>
      'Compte les premiers ≤ n. Exact pour n ≤ 1 000 000 ; approximation Li(x) au-delà.';

  @override
  String get hlpPrimeCountFormula =>
      'π(n) ~ n/ln(n) (théorème des nombres premiers)';

  @override
  String get hlpPrimeCountEx1 => 'π(10) = 4';

  @override
  String get hlpPrimeCountEx2 => 'π(100) = 25';

  @override
  String get hlpPrimeCountEx3 => 'π(1 000 000) = 78 498';

  @override
  String get hlpDigitalRootTitle => 'dr(n) — Racine numérique';

  @override
  String get hlpDigitalRootParams => '1 param';

  @override
  String get hlpDigitalRootDesc =>
      'Somme itérée des chiffres jusqu\'à obtenir un seul chiffre.';

  @override
  String get hlpDigitalRootFormula => 'dr(n) = 1 + (n−1) mod 9  (pour n > 0)';

  @override
  String get hlpDigitalRootEx1 => 'dr(493) → 4+9+3=16 → 1+6 = 7';

  @override
  String get hlpDigitalRootEx2 => 'dr(999) = 9';

  @override
  String get hlpDigitalRootEx3 => 'dr(n) ≡ n (mod 9)';

  @override
  String get hlpFloorCeilTitle => '⌊x⌋ / ⌈x⌉ — Plancher et plafond';

  @override
  String get hlpFloorCeilParams => '1 param';

  @override
  String get hlpFloorCeilDesc =>
      'Plancher : le plus grand entier ≤ x. Plafond : le plus petit entier ≥ x. Alterne entre les deux.';

  @override
  String get hlpFloorCeilFormula => '⌊x⌋ ≤ x < ⌊x⌋+1\n⌈x⌉−1 < x ≤ ⌈x⌉';

  @override
  String get hlpFloorCeilEx1 => '⌊3,7⌋ = 3, ⌈3,7⌉ = 4';

  @override
  String get hlpFloorCeilEx2 => '⌊−2,3⌋ = −3, ⌈−2,3⌉ = −2';

  @override
  String get hlpFloorCeilEx3 => '⌊5⌋ = ⌈5⌉ = 5';

  @override
  String get hlpPadicTitle => 'Vₚ(n) — Valuation p-adique';

  @override
  String get hlpPadicParams => '2 params: n → Vₚ → p → =';

  @override
  String get hlpPadicDesc => 'Plus grande puissance du premier p qui divise n.';

  @override
  String get hlpPadicFormula => 'Vₚ(n) = max[k : p^k | n]';

  @override
  String get hlpPadicEx1 => 'V₂(24) = 3 → 24 = 2³×3';

  @override
  String get hlpPadicEx2 => 'V₃(81) = 4 → 81 = 3⁴';

  @override
  String get hlpPadicEx3 => 'V₅(100) = 2 → 100 = 2²×5²';

  @override
  String get hlpPadicTip1 => 'Formule de Legendre : Vₚ(n!) = Σ ⌊n/pⁱ⌋';

  @override
  String get hlpPadicTip2 => 'Vₚ(ab) = Vₚ(a) + Vₚ(b)';

  @override
  String get hlpModArithHeader => 'Arithmétique modulaire';

  @override
  String get hlpModTitle => 'a mod b — Reste de la division';

  @override
  String get hlpModParams => '2 params: a → mod → b → =';

  @override
  String get hlpModDesc => 'Reste de la division de a par b.';

  @override
  String get hlpModFormula => 'a mod b = a − b × ⌊a/b⌋';

  @override
  String get hlpModEx1 => '17 mod 5 = 2';

  @override
  String get hlpModEx2 => '23 mod 7 = 2';

  @override
  String get hlpModEx3 => '−8 mod 3 = 1';

  @override
  String get hlpModPowTitle => 'a^b mod n — Exponentiation modulaire';

  @override
  String get hlpModPowParams => '3 params: a → a%n → b → = → n → =';

  @override
  String get hlpModPowDesc =>
      'Calcule a^b mod n efficacement par élévations au carré successives, en O(log b).';

  @override
  String get hlpModPowFormula =>
      'On décompose b en binaire et on élève au carré successivement';

  @override
  String get hlpModPowEx1 => '2¹⁰⁰ mod 7 = 2';

  @override
  String get hlpModPowEx2 => '3¹³ mod 11 = 5';

  @override
  String get hlpModPowEx3 =>
      'Fondamental en RSA et dans les tests de primalité';

  @override
  String get hlpModPowTip1 =>
      'Enchaînement : saisissez a → appuyez sur a%n → saisissez b → appuyez sur = → saisissez n → appuyez sur =';

  @override
  String get hlpModInvTitle => 'a⁻¹ mod n — Inverse modulaire';

  @override
  String get hlpModInvParams => '2 params: a → a⁻¹ → n → =';

  @override
  String get hlpModInvDesc =>
      'Trouve b tel que a×b ≡ 1 (mod n). N\'existe que si PGCD(a,n) = 1.';

  @override
  String get hlpModInvFormula => 'Algorithme d\'Euclide étendu';

  @override
  String get hlpModInvEx1 => '3⁻¹ mod 7 = 5 → 3×5=15≡1';

  @override
  String get hlpModInvEx2 => '5⁻¹ mod 11 = 9 → 5×9=45≡1';

  @override
  String get hlpModInvEx3 => 'N\'existe pas si PGCD(a,n) ≠ 1';

  @override
  String get hlpOrdTitle => 'ord_n(a) — Ordre multiplicatif';

  @override
  String get hlpOrdParams => '2 params: a → ord → n → =';

  @override
  String get hlpOrdDesc =>
      'Le plus petit k > 0 tel que a^k ≡ 1 (mod n). Requiert PGCD(a,n)=1.';

  @override
  String get hlpOrdFormula => 'ord_n(a) = min[k > 0 : a^k ≡ 1 (mod n)]';

  @override
  String get hlpOrdEx1 => 'ord₇(2) = 3 → 2³=8≡1';

  @override
  String get hlpOrdEx2 => 'ord₁₀(3) = 4 → 3⁴=81≡1';

  @override
  String get hlpOrdTip1 => 'ord_n(a) divise toujours φ(n)';

  @override
  String get hlpOrdTip2 => 'a est une racine primitive ⟺ ord_n(a) = φ(n)';

  @override
  String get hlpLegendreTitle => '(a/p) — Symbole de Legendre';

  @override
  String get hlpLegendreParams => '2 params: a → (a/p) → p → =';

  @override
  String get hlpLegendreDesc =>
      '1 si a est un résidu quadratique mod p, −1 sinon, 0 si p|a. Requiert p premier impair.';

  @override
  String get hlpLegendreFormula =>
      '(a/p) ≡ a^((p−1)/2) (mod p) — critère d\'Euler';

  @override
  String get hlpLegendreEx1 => '(2/7) = 1 → 3²≡2 (mod 7)';

  @override
  String get hlpLegendreEx2 => '(3/7) = −1 → il n\'existe pas de x²≡3';

  @override
  String get hlpLegendreEx3 => '(5/5) = 0';

  @override
  String get hlpJacobiTitle => '(a/n)ⱼ — Symbole de Jacobi';

  @override
  String get hlpJacobiParams => '2 params: a → (a/n)ⱼ → n → =';

  @override
  String get hlpJacobiDesc =>
      'Généralisation de Legendre pour n composé impair. Utilise la réciprocité quadratique.';

  @override
  String get hlpJacobiFormula => '(a/n) = ∏(a/pᵢ)^eᵢ où n = ∏pᵢ^eᵢ';

  @override
  String get hlpJacobiEx1 => '(2/15) = (2/3)(2/5) = (−1)(−1) = 1';

  @override
  String get hlpJacobiEx2 => '(a/n) = −1 ⟹ a N\'EST PAS un résidu quadratique';

  @override
  String get hlpJacobiEx3 => '(a/n) = 1 ne garantit PAS qu\'il en soit un';

  @override
  String get hlpPrimRootTitle => 'g — Racine primitive';

  @override
  String get hlpPrimRootParams => '1 param';

  @override
  String get hlpPrimRootDesc =>
      'La plus petite racine primitive mod n (si elle existe). g est primitive si ord_n(g) = φ(n).';

  @override
  String get hlpPrimRootFormula => '[g, g², ..., g^φ(n)] = (Z/nZ)*';

  @override
  String get hlpPrimRootEx1 => 'g(7) = 3 → [3,2,6,4,5,1]';

  @override
  String get hlpPrimRootEx2 => 'g(11) = 2';

  @override
  String get hlpPrimRootEx3 => 'N\'existe que pour n = 1,2,4,p^k,2p^k';

  @override
  String get hlpGcdTitle => 'PGCD — Plus grand commun diviseur';

  @override
  String get hlpGcdParams => 'N params (variable, min. 2)';

  @override
  String get hlpGcdDesc =>
      'Le plus grand entier qui divise toutes les valeurs. Accepte 2 nombres ou plus.';

  @override
  String get hlpGcdFormula => 'PGCD(a,b) par l\'algorithme d\'Euclide';

  @override
  String get hlpGcdEx1 => 'PGCD(12,18) = 6';

  @override
  String get hlpGcdEx2 => 'PGCD(12,18,24) = 6';

  @override
  String get hlpGcdEx3 => 'PGCD(a,b) × PPCM(a,b) = a×b';

  @override
  String get hlpGcdTip1 => 'Enchaînement : 12 → PGCD → 18 → PGCD (exécute)';

  @override
  String get hlpGcdTip2 =>
      'Pour 3 nombres ou plus : 12 → PGCD → 18 → = → 24 → PGCD';

  @override
  String get hlpGcdTip3 =>
      'Appuyez sur = pour en ajouter, sur PGCD pour exécuter';

  @override
  String get hlpLcmTitle => 'PPCM — Plus petit commun multiple';

  @override
  String get hlpLcmParams => 'N params (variable, min. 2)';

  @override
  String get hlpLcmDesc =>
      'Le plus petit entier positif divisible par toutes les valeurs.';

  @override
  String get hlpLcmFormula => 'PPCM(a,b) = a×b / PGCD(a,b)';

  @override
  String get hlpLcmEx1 => 'PPCM(4,6) = 12';

  @override
  String get hlpLcmEx2 => 'PPCM(3,5,7) = 105';

  @override
  String get hlpLcmTip1 =>
      'Même enchaînement que le PGCD : appuyez de nouveau sur PPCM pour exécuter';

  @override
  String get hlpDiophTitle => 'Dioph — Équation diophantienne linéaire';

  @override
  String get hlpDiophParams => '3 params : a → Dioph → b → = → c → =';

  @override
  String get hlpDiophDesc =>
      'Résout ax + by = c. Donne la solution particulière et la solution générale.';

  @override
  String get hlpDiophFormula =>
      'ax + by = c a une solution ⟺ PGCD(a,b) | c\nx = x₀ + (b/g)t,  y = y₀ − (a/g)t';

  @override
  String get hlpDiophEx1 => '3x + 5y = 1 → x=2+5t, y=−1−3t';

  @override
  String get hlpDiophEx2 => '6x + 9y = 12 → x=2+3t, y=0−2t';

  @override
  String get hlpDiophEx3 => '4x + 6y = 3 → Aucune solution';

  @override
  String get hlpDiophTip1 => 'Étape 1 : saisissez a (coefficient de x)';

  @override
  String get hlpDiophTip2 => 'Étape 2 : appuyez sur Dioph';

  @override
  String get hlpDiophTip3 =>
      'Étape 3 : saisissez b (coefficient de y), appuyez sur =';

  @override
  String get hlpDiophTip4 =>
      'Étape 4 : saisissez c (terme constant), appuyez sur =';

  @override
  String get hlpCrtTitle => 'TRC — Théorème des restes chinois';

  @override
  String get hlpCrtParams => 'Variable (4+ params par paires a,m)';

  @override
  String get hlpCrtDesc => 'Résout un système de congruences x ≡ aᵢ (mod mᵢ).';

  @override
  String get hlpCrtFormula =>
      'x ≡ a₁ (mod m₁)\nx ≡ a₂ (mod m₂)\n→ x ≡ r (mod ppcm(m₁,m₂))';

  @override
  String get hlpCrtEx1 => 'x≡2(mod 3), x≡3(mod 5) → x≡8(mod 15)';

  @override
  String get hlpCrtEx2 => 'x≡1(mod 4), x≡2(mod 3) → x≡5(mod 12)';

  @override
  String get hlpCrtTip1 =>
      'Enchaînement : a₁ → TRC → m₁ → = → a₂ → = → m₂ → TRC';

  @override
  String get hlpCrtTip2 => 'Les modules doivent être compatibles';

  @override
  String get hlpCombinatoricsHeader => 'Combinatoire';

  @override
  String get hlpFactorialTitle => 'n! — Factorial';

  @override
  String get hlpFactorialParams => '1 param';

  @override
  String get hlpFactorialDesc => 'Produit de 1 à n. Précision arbitraire.';

  @override
  String get hlpFactorialFormula => 'n! = 1 × 2 × ... × n,  0! = 1';

  @override
  String get hlpFactorialEx1 => '5! = 120';

  @override
  String get hlpFactorialEx2 => '10! = 3 628 800';

  @override
  String get hlpFactorialEx3 => '20! = 2 432 902 008 176 640 000';

  @override
  String get hlpDblFactorialTitle => 'n!! — Double factorielle';

  @override
  String get hlpDblFactorialParams => '1 param';

  @override
  String get hlpDblFactorialDesc => 'Produit des entiers de même parité.';

  @override
  String get hlpDblFactorialFormula => 'n!! = n × (n−2) × (n−4) × ...';

  @override
  String get hlpDblFactorialEx1 => '7!! = 7×5×3×1 = 105';

  @override
  String get hlpDblFactorialEx2 => '8!! = 8×6×4×2 = 384';

  @override
  String get hlpDblFactorialEx3 => '0!! = 1!! = 1';

  @override
  String get hlpCombTitle => 'C(n,k) — Combinaisons';

  @override
  String get hlpCombParams => '2 params: n → C(n,k) → k → =';

  @override
  String get hlpCombDesc =>
      'Façons de choisir k parmi n sans tenir compte de l\'ordre.';

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
      'Identité de Pascal : C(n,k) = C(n−1,k−1) + C(n−1,k)';

  @override
  String get hlpCombTip2 => 'C(n,k) = C(n, n−k)';

  @override
  String get hlpVarTitle => 'V(n,k) — Arrangements (permutations partielles)';

  @override
  String get hlpVarParams => '2 params: n → V(n,k) → k → =';

  @override
  String get hlpVarDesc =>
      'Façons de choisir k parmi n EN tenant compte de l\'ordre.';

  @override
  String get hlpVarFormula => 'V(n,k) = n! / (n−k)!';

  @override
  String get hlpVarEx1 => 'V(5,2) = 20';

  @override
  String get hlpVarEx2 => 'V(10,3) = 720';

  @override
  String get hlpCatalanTitle => 'Cat(n) — Nombres de Catalan';

  @override
  String get hlpCatalanParams => '1 param';

  @override
  String get hlpCatalanDesc =>
      'Compte les arbres binaires, les triangulations, les chemins de Dyck, les parenthésages équilibrés.';

  @override
  String get hlpCatalanFormula => 'Cₙ = C(2n,n)/(n+1)';

  @override
  String get hlpCatalanEx1 => 'C₀ = 1, C₁ = 1, C₂ = 2';

  @override
  String get hlpCatalanEx2 => 'C₃ = 5, C₄ = 14, C₅ = 42';

  @override
  String get hlpDerangementTitle => 'D(n) — Dérangements';

  @override
  String get hlpDerangementParams => '1 param';

  @override
  String get hlpDerangementDesc =>
      'Permutations où aucun élément ne reste à sa place initiale.';

  @override
  String get hlpDerangementFormula =>
      'D(n) = n! × Σ(−1)^k/k! = (n−1)(D(n−1)+D(n−2))';

  @override
  String get hlpDerangementEx1 => 'D(3) = 2 → [231, 312]';

  @override
  String get hlpDerangementEx2 => 'D(4) = 9';

  @override
  String get hlpDerangementEx3 => 'D(n)/n! → 1/e ≈ 0,3679';

  @override
  String get hlpBellTitle => 'B(n) — Nombres de Bell';

  @override
  String get hlpBellParams => '1 param';

  @override
  String get hlpBellDesc =>
      'Nombre total de partitions d\'un ensemble à n éléments.';

  @override
  String get hlpBellFormula => 'B(n) = Σ S₂(n,k) pour k=0..n';

  @override
  String get hlpBellEx1 => 'B(3) = 5';

  @override
  String get hlpBellEx2 => 'B(4) = 15';

  @override
  String get hlpBellEx3 => 'B(5) = 52';

  @override
  String get hlpPartitionTitle => 'p(n) — Partitions d\'entiers';

  @override
  String get hlpPartitionParams => '1 param';

  @override
  String get hlpPartitionDesc =>
      'Façons d\'écrire n comme somme d\'entiers positifs (l\'ordre n\'importe pas).';

  @override
  String get hlpPartitionFormula => 'Calculé par programmation dynamique';

  @override
  String get hlpPartitionEx1 => 'p(4) = 5 → [4, 3+1, 2+2, 2+1+1, 1+1+1+1]';

  @override
  String get hlpPartitionEx2 => 'p(10) = 42';

  @override
  String get hlpPartitionEx3 => 'p(100) = 190 569 292 356';

  @override
  String get hlpStirling2Title => 'S₂(n,k) — Stirling de 2e espèce';

  @override
  String get hlpStirling2Params => '2 params: n → S₂ → k → =';

  @override
  String get hlpStirling2Desc =>
      'Façons de partitionner n éléments en exactement k sous-ensembles non vides.';

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
      's₁(n,k) — Stirling de 1re espèce (non signés)';

  @override
  String get hlpStirling1Params => '2 params: n → s₁ → k → =';

  @override
  String get hlpStirling1Desc =>
      'Permutations de n éléments comportant exactement k cycles.';

  @override
  String get hlpStirling1Formula =>
      '|s₁(n,k)| = (n−1)·|s₁(n−1,k)| + |s₁(n−1,k−1)|';

  @override
  String get hlpStirling1Ex1 => 's₁(4,2) = 11';

  @override
  String get hlpStirling1Ex2 => 's₁(4,1) = 6';

  @override
  String get hlpFibTitle => 'F(n) — n-ième de Fibonacci';

  @override
  String get hlpFibParams => '1 param';

  @override
  String get hlpFibDesc =>
      'Calcule F(n) par doublement rapide en O(log n). Accepte de très grands n.';

  @override
  String get hlpFibFormula => 'F(0)=0, F(1)=1, F(n)=F(n−1)+F(n−2)';

  @override
  String get hlpFibEx1 => 'F(10) = 55';

  @override
  String get hlpFibEx2 => 'F(50) = 12 586 269 025';

  @override
  String get hlpFibEx3 => 'F(100) = 354 224 848 179 261 915 075';

  @override
  String get hlpFibTip1 => 'F(n) mod m est périodique (période de Pisano)';

  @override
  String get hlpFibTip2 => 'PGCD(F(m), F(n)) = F(PGCD(m,n))';

  @override
  String get hlpDigitSumBaseTitle => 'ΣchifB — Somme des chiffres en base b';

  @override
  String get hlpDigitSumBaseParams => '2 params : n → ΣchifB → b → =';

  @override
  String get hlpDigitSumBaseDesc => 'Somme des chiffres de n écrit en base b.';

  @override
  String get hlpDigitSumBaseFormula => 'Si n = Σ dᵢ × bⁱ, alors ΣchifB = Σ dᵢ';

  @override
  String get hlpDigitSumBaseEx1 => 'ΣchifB(255, 2) = 8 → 11111111₂';

  @override
  String get hlpDigitSumBaseEx2 => 'ΣchifB(100, 10) = 1';

  @override
  String get hlpDigitSumBaseEx3 => 'ΣchifB(100, 16) = 10 → 64₁₆';

  @override
  String get hlpStatisticsHeader => 'Statistiques';

  @override
  String get hlpArithMeanTitle => 'Moyenne arithmétique — Moy A';

  @override
  String get hlpArithMeanParams => 'N params (variable, min. 2)';

  @override
  String get hlpArithMeanDesc => 'Moyenne classique de N nombres.';

  @override
  String get hlpArithMeanFormula => 'MA = (x₁ + x₂ + ... + xₙ) / n';

  @override
  String get hlpArithMeanEx1 => 'MA(3, 7) = 5';

  @override
  String get hlpArithMeanEx2 => 'MA(2, 4, 6) = 4';

  @override
  String get hlpArithMeanTip1 =>
      'Enchaînement : 3 → Moy A → 7 → Moy A (exécute)';

  @override
  String get hlpArithMeanTip2 =>
      'Pour 3 nombres ou plus : 2 → Moy A → 4 → = → 6 → Moy A';

  @override
  String get hlpGeoMeanTitle => 'Moyenne géométrique — Moy G';

  @override
  String get hlpGeoMeanParams => 'N params (variable, min. 2)';

  @override
  String get hlpGeoMeanDesc =>
      'Racine n-ième du produit. Valeurs positives uniquement.';

  @override
  String get hlpGeoMeanFormula => 'MG = (x₁ × x₂ × ... × xₙ)^(1/n)';

  @override
  String get hlpGeoMeanEx1 => 'MG(2, 8) = 4';

  @override
  String get hlpGeoMeanEx2 => 'MG(1, 4, 9) ≈ 3,30';

  @override
  String get hlpHarmMeanTitle => 'Moyenne harmonique — Moy H';

  @override
  String get hlpHarmMeanParams => 'N params (variable, min. 2)';

  @override
  String get hlpHarmMeanDesc =>
      'Inverse de la moyenne arithmétique des inverses. Valeurs positives uniquement.';

  @override
  String get hlpHarmMeanFormula => 'MH = n / (1/x₁ + 1/x₂ + ... + 1/xₙ)';

  @override
  String get hlpHarmMeanEx1 => 'MH(2, 8) = 3,2';

  @override
  String get hlpHarmMeanEx2 => 'MH(1, 4, 9) ≈ 2,08';

  @override
  String get hlpQuadMeanTitle => 'Moyenne quadratique — Moy Q';

  @override
  String get hlpQuadMeanParams => 'N params (variable, min. 2)';

  @override
  String get hlpQuadMeanDesc => 'Racine de la moyenne des carrés (RMS).';

  @override
  String get hlpQuadMeanFormula => 'MQ = √((x₁² + x₂² + ... + xₙ²) / n)';

  @override
  String get hlpQuadMeanEx1 => 'MQ(3, 4) ≈ 3,54';

  @override
  String get hlpQuadMeanEx2 => 'MQ(1, 2, 3) ≈ 2,16';

  @override
  String get hlpMinMaxTitle => 'min / max — Minimum et maximum';

  @override
  String get hlpMinMaxParams => 'N params (variable, min. 2)';

  @override
  String get hlpMinMaxDesc =>
      'Trouve la plus petite / la plus grande valeur d\'un ensemble de N nombres.';

  @override
  String get hlpMinMaxFormula => 'min(a₁,...,aₙ) et max(a₁,...,aₙ)';

  @override
  String get hlpMinMaxEx1 => 'min(3, 7, 1) = 1';

  @override
  String get hlpMinMaxEx2 => 'max(3, 7, 1) = 7';

  @override
  String get hlpMinMaxTip1 =>
      'Même enchaînement variable : appuyez de nouveau sur min/max pour exécuter';

  @override
  String get hlpMeanInequalityTitle => 'Inégalité des moyennes (MA-MG-MH)';

  @override
  String get hlpMeanInequalityContent =>
      'Pour des nombres positifs, on a toujours :\n\nMH ≤ MG ≤ MA ≤ MQ\n\nL\'égalité n\'a lieu que si toutes les valeurs sont égales.\nCette inégalité est fondamentale en olympiades.';

  @override
  String get hlpAnalysisPanelHeader => 'Panneau d\'analyse numérique';

  @override
  String get hlpAutoAnalysisTitle => 'Analyse automatique';

  @override
  String get hlpAutoAnalysisContent =>
      'Dès qu\'un nombre est saisi, le panneau de droite (tablette) ou du bas (mobile) affiche automatiquement :\n\n• Propriétés : chiffres, parité, signe\n• Représentations : binaire, octal, hexadécimal\n• Primalité : test de Miller-Rabin, décomposition complète\n• Premiers voisins : précédent et suivant\n• Diviseurs : liste complète, somme, nombre\n• Classifications : carré/cube parfait, puissance parfaite, Fibonacci, triangulaire, palindrome\n\nPour les nombres d\'au plus 15 chiffres, il affiche aussi :\n\n• Fonctions arithmétiques : φ, λ, μ, ω, Ω, sopfr, sopf, rad, dr\n• Classifications : sans facteur carré, puissant, Harshad, semi-premier, abondant/déficient/parfait';

  @override
  String get hlpHighPrecHeader => 'Haute précision et outils';

  @override
  String get hlpHighPrecTitle => 'Mode haute précision';

  @override
  String get hlpHighPrecContent =>
      'Activez-le dans les Paramètres. Calcule sin, cos, tan, ln, log, exp, √ et ∛ avec des réels constructifs EXACTS et n\'arrondit qu\'à l\'affichage (5 à 100 chiffres). Aucune erreur de virgule flottante : √2 à 30 chiffres = 1,41421356237309504880168872421. Les singularités sont détectées par construction (tan 90° = indéfini). Tout s\'exécute en arrière-plan avec un indicateur de chargement, sans jamais figer l\'application.';

  @override
  String get hlpNewToolsTitle => 'Outils d\'Olympiades';

  @override
  String get hlpNewToolsContent =>
      'Depuis le menu latéral → Outils d\'Olympiades : Fractions, Radicaux, Géométrie (avec figures : triangle, Pick, centres et droite d\'Euler), Polynômes (courbe, Ruffini, systèmes n×n), Algèbre (développement et identités à plusieurs variables), Théorie des nombres (crible, horloge modulaire, résidus), Procédures pas à pas, Complexes (cercle unité, Sierpiński — en haute précision), Statistiques, Matrices (exactes), Analyse (dérivée/intégrale/limite) et Entraînement avec correction.';

  @override
  String get hlpOlympiadHeader => 'Formules clés pour les olympiades';

  @override
  String get hlpIdentitiesTitle => 'Identités fondamentales';

  @override
  String get hlpIdentitiesContent =>
      '• Théorème d\'Euler : a^φ(n) ≡ 1 (mod n) si PGCD(a,n)=1\n• Petit théorème de Fermat : a^(p−1) ≡ 1 (mod p) si p premier\n• Wilson : (p−1)! ≡ −1 (mod p) ⟺ p est premier\n• Formule de Legendre : Vₚ(n!) = Σᵢ ⌊n/pⁱ⌋\n• Lucas : C(n,k) mod p = ∏ C(nᵢ,kᵢ) mod p\n• Σ φ(d) pour d|n = n\n• Σ μ(d) pour d|n = [n=1]\n• φ(mn) = φ(m)φ(n)·PGCD(m,n)/φ(PGCD(m,n))\n• PGCD(F(m),F(n)) = F(PGCD(m,n))\n• MA ≥ MG ≥ MH (inégalité des moyennes)';

  @override
  String get hlpRefTableTitle => 'Tableau de référence rapide';

  @override
  String get hlpRefTableContent =>
      'n    φ(n)  λ(n)  μ(n)  σ(n)  ω  Ω\n1    1     1     1     1     0  0\n6    2     2     1     12    2  2\n12   4     2     0     28    2  3\n30   8     4     −1    72    3  3\n60   16    4     0     168   3  4\n100  40    20    0     217   2  4';

  @override
  String get hlpExamplesLabel => 'Exemples :';

  @override
  String get hlpTipsLabel => 'Tips:';

  @override
  String get errExprEmpty => 'Erreur : expression vide';

  @override
  String get errExprMalformed => 'Erreur : expression mal formée';

  @override
  String get errExprDivZero => 'Erreur : division par zéro';

  @override
  String get errResultInvalid => 'Erreur : résultat invalide';

  @override
  String get errResultTooLarge =>
      'Le résultat est trop grand pour être calculé exactement';

  @override
  String get errAnalysisInvalid => 'Erreur : nombre invalide pour l\'analyse';

  @override
  String get errAnalysisFail => 'Impossible d\'analyser le nombre';

  @override
  String get errNoSolution => 'Aucune solution';

  @override
  String get errIncompatibleSystem => 'Système incompatible';

  @override
  String get errCRTNeedPairs => 'Le TRC exige des paires (aᵢ, mᵢ)';

  @override
  String errUnknownOp(String op) {
    return 'Opération inconnue : $op';
  }
}
