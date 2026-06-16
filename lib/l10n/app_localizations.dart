import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// App title shown in the title bar and about screen
  ///
  /// In es, this message translates to:
  /// **'Super Calculadora'**
  String get appTitle;

  /// App version string
  ///
  /// In es, this message translates to:
  /// **'Versión 1.0.0'**
  String get appVersion;

  /// Framework credit shown in about section
  ///
  /// In es, this message translates to:
  /// **'Desarrollado en Flutter'**
  String get appDeveloped;

  /// Dynamic theme support note in about section
  ///
  /// In es, this message translates to:
  /// **'Con soporte a temas dinámicos'**
  String get appDynamicThemes;

  /// Navigation drawer item for standard calculator
  ///
  /// In es, this message translates to:
  /// **'Estándar'**
  String get navStandard;

  /// Subtitle for standard calculator nav item
  ///
  /// In es, this message translates to:
  /// **'Operaciones básicas'**
  String get navStandardSub;

  /// Navigation drawer item for scientific calculator
  ///
  /// In es, this message translates to:
  /// **'Científica'**
  String get navScientific;

  /// Subtitle for scientific calculator nav item
  ///
  /// In es, this message translates to:
  /// **'Funciones avanzadas'**
  String get navScientificSub;

  /// Navigation drawer item for special functions
  ///
  /// In es, this message translates to:
  /// **'Funciones Especiales'**
  String get navSpecial;

  /// Subtitle for special functions nav item
  ///
  /// In es, this message translates to:
  /// **'Teoría de números'**
  String get navSpecialSub;

  /// Navigation drawer item for history
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get navHistory;

  /// Subtitle for history nav item
  ///
  /// In es, this message translates to:
  /// **'Ver operaciones anteriores'**
  String get navHistorySub;

  /// Navigation drawer item for settings
  ///
  /// In es, this message translates to:
  /// **'Configuraciones'**
  String get navSettings;

  /// Subtitle for settings nav item
  ///
  /// In es, this message translates to:
  /// **'Ajustes de la aplicación'**
  String get navSettingsSub;

  /// Navigation drawer item for help
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get navHelp;

  /// Subtitle for help nav item
  ///
  /// In es, this message translates to:
  /// **'Guía de funciones especiales'**
  String get navHelpSub;

  /// Navigation drawer item for about dialog
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get navAbout;

  /// Subtitle for about nav item
  ///
  /// In es, this message translates to:
  /// **'Super Calculadora v1.0'**
  String get navAboutSub;

  /// Calculator label in navigation
  ///
  /// In es, this message translates to:
  /// **'Calculadora'**
  String get navCalculator;

  /// Prompt to select calculator type
  ///
  /// In es, this message translates to:
  /// **'Selecciona el tipo'**
  String get navSelectType;

  /// Angle mode label in drawer
  ///
  /// In es, this message translates to:
  /// **'Modo: {mode}'**
  String navAngleMode(String mode);

  /// Radians angle mode label
  ///
  /// In es, this message translates to:
  /// **'Radianes'**
  String get navRadians;

  /// Degrees angle mode label
  ///
  /// In es, this message translates to:
  /// **'Grados'**
  String get navDegrees;

  /// Tab label for analysis view
  ///
  /// In es, this message translates to:
  /// **'Análisis'**
  String get calcAnalysis;

  /// Tab label for expressions view
  ///
  /// In es, this message translates to:
  /// **'Expresiones'**
  String get calcExpressions;

  /// Title for scientific calculator screen
  ///
  /// In es, this message translates to:
  /// **'Calculadora Científica'**
  String get calcScientific;

  /// Title for special functions screen
  ///
  /// In es, this message translates to:
  /// **'Funciones Especiales'**
  String get calcSpecialFunctions;

  /// Main calculator title
  ///
  /// In es, this message translates to:
  /// **'Super Calculadora'**
  String get calcSuperCalculator;

  /// Title for numeric analysis section
  ///
  /// In es, this message translates to:
  /// **'Análisis Numérico'**
  String get calcNumericAnalysis;

  /// Title for math expressions section
  ///
  /// In es, this message translates to:
  /// **'Expresiones Matemáticas'**
  String get calcMathExpressions;

  /// Label shown before a calculation result
  ///
  /// In es, this message translates to:
  /// **'Resultado:'**
  String get calcResult;

  /// Message shown while processing large numbers
  ///
  /// In es, this message translates to:
  /// **'Procesando números grandes...'**
  String get calcProcessing;

  /// Loader text while computing in high-precision mode
  ///
  /// In es, this message translates to:
  /// **'Calculando (alta precisión)…'**
  String get calcHighPrecision;

  /// Cancel button label during processing
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get calcCancel;

  /// Paste action label on display
  ///
  /// In es, this message translates to:
  /// **'Pegar'**
  String get displayPaste;

  /// Copy action label on display
  ///
  /// In es, this message translates to:
  /// **'Copiar'**
  String get displayCopy;

  /// Confirmation message after copying text
  ///
  /// In es, this message translates to:
  /// **'Copiado: {text}'**
  String displayCopied(String text);

  /// Context menu option to copy result
  ///
  /// In es, this message translates to:
  /// **'Copiar resultado'**
  String get displayCopyResult;

  /// Context menu option to paste a number
  ///
  /// In es, this message translates to:
  /// **'Pegar número'**
  String get displayPasteNumber;

  /// Context menu option to clear the display
  ///
  /// In es, this message translates to:
  /// **'Limpiar display'**
  String get displayClearDisplay;

  /// Error when pasted text is not a valid number
  ///
  /// In es, this message translates to:
  /// **'Error: El texto pegado no es un número válido'**
  String get displayInvalidNumber;

  /// Message when clipboard is empty
  ///
  /// In es, this message translates to:
  /// **'No hay contenido para pegar'**
  String get displayNothingToPaste;

  /// Error message when paste operation fails
  ///
  /// In es, this message translates to:
  /// **'Error al pegar: {error}'**
  String displayPasteError(String error);

  /// Confirmation message after pasting text
  ///
  /// In es, this message translates to:
  /// **'Pegado: {text}'**
  String displayPasted(String text);

  /// Title of the history screen
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get histTitle;

  /// Button label to clear all history
  ///
  /// In es, this message translates to:
  /// **'Limpiar historial'**
  String get histClearAll;

  /// Tooltip for clear all history button
  ///
  /// In es, this message translates to:
  /// **'Limpiar todo el historial'**
  String get histClearAllTooltip;

  /// Confirmation dialog text for clearing history
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar todo el historial?'**
  String get histConfirmClear;

  /// Confirmation dialog text for clearing N history items
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar todas las {count} operaciones del historial? Esta acción no se puede deshacer.'**
  String histConfirmClearN(String count);

  /// Snackbar message after clearing history
  ///
  /// In es, this message translates to:
  /// **'Historial limpiado'**
  String get histCleared;

  /// Snackbar message after deleting history
  ///
  /// In es, this message translates to:
  /// **'Historial eliminado'**
  String get histDeleted;

  /// Snackbar message after deleting single operation
  ///
  /// In es, this message translates to:
  /// **'Operación eliminada'**
  String get histOperationDeleted;

  /// Snackbar message after copying to clipboard
  ///
  /// In es, this message translates to:
  /// **'Copiado al portapapeles'**
  String get histCopiedToClipboard;

  /// Snackbar message after copying specific text to clipboard
  ///
  /// In es, this message translates to:
  /// **'Copiado al portapapeles: {text}'**
  String histCopiedClipboardText(String text);

  /// Dialog title for full result view
  ///
  /// In es, this message translates to:
  /// **'Resultado completo'**
  String get histFullResult;

  /// Close button label in history dialogs
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get histClose;

  /// Label for expression in history detail
  ///
  /// In es, this message translates to:
  /// **'Expresión:'**
  String get histExpression;

  /// Label for result in history detail
  ///
  /// In es, this message translates to:
  /// **'Resultado:'**
  String get histResult;

  /// Button to copy result from history
  ///
  /// In es, this message translates to:
  /// **'Copiar resultado'**
  String get histCopyResult;

  /// Button to copy all from history item
  ///
  /// In es, this message translates to:
  /// **'Copiar todo'**
  String get histCopyAll;

  /// Button to copy expression from history
  ///
  /// In es, this message translates to:
  /// **'Copiar expresión'**
  String get histCopyExpression;

  /// Button to use result from history in calculator
  ///
  /// In es, this message translates to:
  /// **'Usar resultado'**
  String get histUseResult;

  /// Button to view full result from history
  ///
  /// In es, this message translates to:
  /// **'Ver resultado'**
  String get histViewResult;

  /// Button to delete a history item
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get histDelete;

  /// Empty state title in history screen
  ///
  /// In es, this message translates to:
  /// **'No hay operaciones en el historial'**
  String get histEmpty;

  /// Empty state hint in history screen
  ///
  /// In es, this message translates to:
  /// **'Realiza algunos cálculos para ver tu historial aquí'**
  String get histEmptyHint;

  /// Alternative empty state hint in history screen
  ///
  /// In es, this message translates to:
  /// **'Las operaciones que realices aparecerán aquí'**
  String get histEmptyHintAlt;

  /// Label for number of operations in history
  ///
  /// In es, this message translates to:
  /// **'operaciones'**
  String get histOperations;

  /// Time label for very recent history items
  ///
  /// In es, this message translates to:
  /// **'Ahora'**
  String get histNow;

  /// Error message when history fails to load
  ///
  /// In es, this message translates to:
  /// **'Error cargando historial: {error}'**
  String histErrorLoading(String error);

  /// Error message when history fails to clear
  ///
  /// In es, this message translates to:
  /// **'Error limpiando historial: {error}'**
  String histErrorClearing(String error);

  /// Error message when a history item fails to delete
  ///
  /// In es, this message translates to:
  /// **'Error eliminando operación: {error}'**
  String histErrorDeleting(String error);

  /// Title of the settings screen
  ///
  /// In es, this message translates to:
  /// **'Configuraciones'**
  String get settingsTitle;

  /// Theme section title in settings
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get settingsTheme;

  /// Number format section title in settings
  ///
  /// In es, this message translates to:
  /// **'Formato de números'**
  String get settingsNumberFormat;

  /// Toggle label for scientific notation
  ///
  /// In es, this message translates to:
  /// **'Usar notación científica'**
  String get settingsScientificNotation;

  /// Hint text for scientific notation toggle
  ///
  /// In es, this message translates to:
  /// **'Los números se mostrarán completos (ej: 123000) cuando esté deshabilitado'**
  String get settingsScientificHint;

  /// High precision mode toggle title
  ///
  /// In es, this message translates to:
  /// **'Modo de alta precisión'**
  String get settingsHighPrecision;

  /// High precision mode hint
  ///
  /// In es, this message translates to:
  /// **'Calcula sin, cos, tan, ln, √… con reales constructivos exactos (más lento). Singularidades como tan 90° se reportan como indefinido.'**
  String get settingsHighPrecisionHint;

  /// Precision digits label
  ///
  /// In es, this message translates to:
  /// **'Dígitos de precisión: {digits}'**
  String settingsPrecisionDigits(int digits);

  /// Open source licenses entry
  ///
  /// In es, this message translates to:
  /// **'Licencias de código abierto'**
  String get settingsOpenSourceLicenses;

  /// Section title for format examples
  ///
  /// In es, this message translates to:
  /// **'Ejemplos de formato'**
  String get settingsFormatExamples;

  /// Label for large number format example
  ///
  /// In es, this message translates to:
  /// **'Número grande:'**
  String get settingsLargeNumber;

  /// Label for small number format example
  ///
  /// In es, this message translates to:
  /// **'Número pequeño:'**
  String get settingsSmallNumber;

  /// Label for normal format example
  ///
  /// In es, this message translates to:
  /// **'Normal:'**
  String get settingsNormal;

  /// Label for scientific format example
  ///
  /// In es, this message translates to:
  /// **'Científica:'**
  String get settingsScientific;

  /// About app section title in settings
  ///
  /// In es, this message translates to:
  /// **'Sobre el App'**
  String get settingsAboutApp;

  /// Light theme option label
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// Dark theme option label
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// Auto theme option label
  ///
  /// In es, this message translates to:
  /// **'Automático'**
  String get themeAuto;

  /// Description for light theme option
  ///
  /// In es, this message translates to:
  /// **'Usa siempre el tema claro'**
  String get themeLightDesc;

  /// Description for dark theme option
  ///
  /// In es, this message translates to:
  /// **'Usa siempre el tema oscuro'**
  String get themeDarkDesc;

  /// Description for auto theme option
  ///
  /// In es, this message translates to:
  /// **'Sigue la configuración del sistema'**
  String get themeAutoDesc;

  /// Title of the about dialog
  ///
  /// In es, this message translates to:
  /// **'Super Calculadora'**
  String get aboutTitle;

  /// Description text in about dialog
  ///
  /// In es, this message translates to:
  /// **'Una calculadora avanzada con capacidades científicas y análisis numérico completo.'**
  String get aboutDescription;

  /// Features section header in about dialog
  ///
  /// In es, this message translates to:
  /// **'Características:'**
  String get aboutFeatures;

  /// Close button in about dialog
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get aboutClose;

  /// About feature: large number support
  ///
  /// In es, this message translates to:
  /// **'Números de hasta 1024 bits'**
  String get aboutFeature1;

  /// About feature: decimal precision
  ///
  /// In es, this message translates to:
  /// **'Precisión decimal de 64 bits'**
  String get aboutFeature2;

  /// About feature: calculator modes
  ///
  /// In es, this message translates to:
  /// **'Modo calculadora estándar y científica'**
  String get aboutFeature3;

  /// About feature: trig functions
  ///
  /// In es, this message translates to:
  /// **'Funciones trigonométricas (sin, cos, tan)'**
  String get aboutFeature4;

  /// About feature: inverse trig functions
  ///
  /// In es, this message translates to:
  /// **'Funciones trigonométricas inversas (asin, acos, atan)'**
  String get aboutFeature5;

  /// About feature: logarithms
  ///
  /// In es, this message translates to:
  /// **'Logaritmos naturales (ln) y base 10 (log)'**
  String get aboutFeature6;

  /// About feature: exponential functions
  ///
  /// In es, this message translates to:
  /// **'Funciones exponenciales (eˣ, 10ˣ)'**
  String get aboutFeature7;

  /// About feature: factorial
  ///
  /// In es, this message translates to:
  /// **'Cálculo de factorial (n!)'**
  String get aboutFeature8;

  /// About feature: math constants
  ///
  /// In es, this message translates to:
  /// **'Constantes matemáticas (π, e)'**
  String get aboutFeature9;

  /// About feature: powers and roots
  ///
  /// In es, this message translates to:
  /// **'Potencias y raíces (x², x³, √, ∛)'**
  String get aboutFeature10;

  /// About feature: angle conversion
  ///
  /// In es, this message translates to:
  /// **'Conversión entre grados y radianes'**
  String get aboutFeature11;

  /// About feature: prime analysis
  ///
  /// In es, this message translates to:
  /// **'Análisis de números primos'**
  String get aboutFeature12;

  /// About feature: prime factorization
  ///
  /// In es, this message translates to:
  /// **'Descomposición en factores primos'**
  String get aboutFeature13;

  /// About feature: binary/decimal conversion
  ///
  /// In es, this message translates to:
  /// **'Conversión binaria y decimal'**
  String get aboutFeature14;

  /// About feature: math property analysis
  ///
  /// In es, this message translates to:
  /// **'Análisis de propiedades matemáticas'**
  String get aboutFeature15;

  /// About feature: extremely large numbers
  ///
  /// In es, this message translates to:
  /// **'Operaciones con números extremadamente grandes'**
  String get aboutFeature16;

  /// About feature: isolate-based computation
  ///
  /// In es, this message translates to:
  /// **'Cálculos pesados en hilos separados (isolates)'**
  String get aboutFeature17;

  /// About feature: domain and size error handling
  ///
  /// In es, this message translates to:
  /// **'Manejo de errores de dominio y tamaño'**
  String get aboutFeature18;

  /// Label for math expression input field
  ///
  /// In es, this message translates to:
  /// **'Expresión matemática'**
  String get exprMathExpression;

  /// Toggle to hide expression history
  ///
  /// In es, this message translates to:
  /// **'Ocultar historial'**
  String get exprHideHistory;

  /// Toggle to show expression history
  ///
  /// In es, this message translates to:
  /// **'Mostrar historial'**
  String get exprShowHistory;

  /// Button to clear the expression input
  ///
  /// In es, this message translates to:
  /// **'Limpiar expresión'**
  String get exprClearExpression;

  /// Hint text in expression input field
  ///
  /// In es, this message translates to:
  /// **'Ej: (5 + 3) * sqrt(9) - 2^3'**
  String get exprHint;

  /// Delete/backspace button label
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get exprDelete;

  /// Evaluate button label
  ///
  /// In es, this message translates to:
  /// **'Evaluar (Enter)'**
  String get exprEvaluate;

  /// Parenthesis button tooltip
  ///
  /// In es, this message translates to:
  /// **'Paréntesis'**
  String get exprParenthesis;

  /// Square root button tooltip
  ///
  /// In es, this message translates to:
  /// **'Raíz cuadrada'**
  String get exprSquareRoot;

  /// Power button tooltip
  ///
  /// In es, this message translates to:
  /// **'Potencia'**
  String get exprPower;

  /// Sine button tooltip
  ///
  /// In es, this message translates to:
  /// **'Seno'**
  String get exprSin;

  /// Cosine button tooltip
  ///
  /// In es, this message translates to:
  /// **'Coseno'**
  String get exprCos;

  /// Tangent button tooltip
  ///
  /// In es, this message translates to:
  /// **'Tangente'**
  String get exprTan;

  /// Log base 10 button tooltip
  ///
  /// In es, this message translates to:
  /// **'Logaritmo'**
  String get exprLog;

  /// Natural logarithm button tooltip
  ///
  /// In es, this message translates to:
  /// **'Logaritmo natural'**
  String get exprLn;

  /// Pi constant button tooltip
  ///
  /// In es, this message translates to:
  /// **'Pi'**
  String get exprPi;

  /// Euler constant button tooltip
  ///
  /// In es, this message translates to:
  /// **'Euler'**
  String get exprEuler;

  /// Placeholder text when no number is entered for analysis
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número para ver su análisis'**
  String get analysisEnterNumber;

  /// Loading message during number analysis
  ///
  /// In es, this message translates to:
  /// **'Analizando número...'**
  String get analysisLoading;

  /// Hint shown during long analysis computations
  ///
  /// In es, this message translates to:
  /// **'Esto puede tomar unos momentos para números grandes'**
  String get analysisLoadingHint;

  /// Label when analysis is limited due to number size
  ///
  /// In es, this message translates to:
  /// **'Análisis limitado'**
  String get analysisLimited;

  /// Label for extremely large numbers
  ///
  /// In es, this message translates to:
  /// **'Número Extremadamente Grande'**
  String get analysisExtremelyLarge;

  /// Shows the number of digits in the analyzed number
  ///
  /// In es, this message translates to:
  /// **'Dígitos: {count}'**
  String analysisDigitsCount(String count);

  /// Note header about primality testing limitations
  ///
  /// In es, this message translates to:
  /// **'Nota sobre análisis de primalidad'**
  String get analysisPrimalityNote;

  /// Shows original input vs analyzed value
  ///
  /// In es, this message translates to:
  /// **'Entrada original: {original} → Analizado: {analyzed}'**
  String analysisOriginalInput(String original, String analyzed);

  /// Loading message while calculating primes
  ///
  /// In es, this message translates to:
  /// **'Calculando primos...'**
  String get analysisCalculatingPrimes;

  /// Loading message while searching for adjacent primes
  ///
  /// In es, this message translates to:
  /// **'Buscando primo anterior y siguiente'**
  String get analysisSearchingPrimes;

  /// Section title for basic number properties
  ///
  /// In es, this message translates to:
  /// **'Propiedades Básicas'**
  String get analysisBasicProperties;

  /// Label for the number value
  ///
  /// In es, this message translates to:
  /// **'Valor'**
  String get analysisValue;

  /// Label for primality check
  ///
  /// In es, this message translates to:
  /// **'Es primo'**
  String get analysisIsPrime;

  /// Label for digit count
  ///
  /// In es, this message translates to:
  /// **'Dígitos'**
  String get analysisDigits;

  /// Label for next prime number
  ///
  /// In es, this message translates to:
  /// **'Siguiente primo'**
  String get analysisNextPrime;

  /// Label for previous prime number
  ///
  /// In es, this message translates to:
  /// **'Primo anterior'**
  String get analysisPrevPrime;

  /// Label for digit sum
  ///
  /// In es, this message translates to:
  /// **'Suma de dígitos'**
  String get analysisDigitSum;

  /// Label for binary representation
  ///
  /// In es, this message translates to:
  /// **'Binario'**
  String get analysisBinary;

  /// Yes value for boolean properties
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get analysisYes;

  /// No value for boolean properties
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get analysisNo;

  /// Section title for number representations
  ///
  /// In es, this message translates to:
  /// **'Representaciones'**
  String get analysisRepresentations;

  /// Label for octal representation
  ///
  /// In es, this message translates to:
  /// **'Octal'**
  String get analysisOctal;

  /// Label for hexadecimal representation
  ///
  /// In es, this message translates to:
  /// **'Hexadecimal'**
  String get analysisHex;

  /// Section title for mathematical analysis
  ///
  /// In es, this message translates to:
  /// **'Análisis Matemático'**
  String get analysisMathAnalysis;

  /// Label for perfect number check
  ///
  /// In es, this message translates to:
  /// **'Es perfecto'**
  String get analysisIsPerfect;

  /// Label for palindrome check
  ///
  /// In es, this message translates to:
  /// **'Es palíndromo'**
  String get analysisIsPalindrome;

  /// Label for Fibonacci number check
  ///
  /// In es, this message translates to:
  /// **'Es Fibonacci'**
  String get analysisIsFibonacci;

  /// Label for triangular number check
  ///
  /// In es, this message translates to:
  /// **'Es triangular'**
  String get analysisIsTriangular;

  /// Section title for prime factorization
  ///
  /// In es, this message translates to:
  /// **'Factorización Prima'**
  String get analysisPrimeFactors;

  /// Label for prime factors list
  ///
  /// In es, this message translates to:
  /// **'Factores primos'**
  String get analysisPrimeFactorsLabel;

  /// Section title for divisors
  ///
  /// In es, this message translates to:
  /// **'Divisores'**
  String get analysisDivisors;

  /// Label for complete list of divisors
  ///
  /// In es, this message translates to:
  /// **'Todos los divisores'**
  String get analysisAllDivisors;

  /// Label for number of divisors
  ///
  /// In es, this message translates to:
  /// **'Cantidad de divisores'**
  String get analysisDivisorCount;

  /// Section title for arithmetic functions
  ///
  /// In es, this message translates to:
  /// **'Funciones Aritméticas'**
  String get analysisArithmeticFunctions;

  /// Label for Euler totient function
  ///
  /// In es, this message translates to:
  /// **'φ(n) Euler'**
  String get analysisEulerPhi;

  /// Label for Carmichael function
  ///
  /// In es, this message translates to:
  /// **'λ(n) Carmichael'**
  String get analysisCarmichael;

  /// Label for Möbius function
  ///
  /// In es, this message translates to:
  /// **'μ(n) Möbius'**
  String get analysisMobius;

  /// Label for small omega function (distinct prime factors)
  ///
  /// In es, this message translates to:
  /// **'ω(n) primos distintos'**
  String get analysisSmallOmega;

  /// Label for big omega function (prime factors with multiplicity)
  ///
  /// In es, this message translates to:
  /// **'Ω(n) primos c/mult.'**
  String get analysisBigOmega;

  /// Label for sum of prime factors with repetition
  ///
  /// In es, this message translates to:
  /// **'sopfr(n) Σprimos rep.'**
  String get analysisSopfr;

  /// Label for sum of distinct prime factors
  ///
  /// In es, this message translates to:
  /// **'sopf(n) Σprimos dist.'**
  String get analysisSopf;

  /// Label for radical of n
  ///
  /// In es, this message translates to:
  /// **'rad(n) radical'**
  String get analysisRadical;

  /// Label for digital root
  ///
  /// In es, this message translates to:
  /// **'Raíz digital'**
  String get analysisDigitalRoot;

  /// Section title for number classification
  ///
  /// In es, this message translates to:
  /// **'Clasificación'**
  String get analysisClassification;

  /// Label for square-free check
  ///
  /// In es, this message translates to:
  /// **'Libre de cuadrados'**
  String get analysisSquareFree;

  /// Label for powerful number check
  ///
  /// In es, this message translates to:
  /// **'Poderoso'**
  String get analysisPowerful;

  /// Label for Harshad number check
  ///
  /// In es, this message translates to:
  /// **'Harshad'**
  String get analysisHarshad;

  /// Label for semiprime check
  ///
  /// In es, this message translates to:
  /// **'Semiprimo'**
  String get analysisSemiprime;

  /// Label for abundant number check
  ///
  /// In es, this message translates to:
  /// **'Abundante'**
  String get analysisAbundant;

  /// Label for deficient number check
  ///
  /// In es, this message translates to:
  /// **'Deficiente'**
  String get analysisDeficient;

  /// Section title for number operations
  ///
  /// In es, this message translates to:
  /// **'Operaciones'**
  String get analysisOperations;

  /// Label for square of the number
  ///
  /// In es, this message translates to:
  /// **'Cuadrado'**
  String get analysisSquare;

  /// Label for cube of the number
  ///
  /// In es, this message translates to:
  /// **'Cubo'**
  String get analysisCube;

  /// Label for square root in analysis
  ///
  /// In es, this message translates to:
  /// **'Raíz cuadrada'**
  String get analysisSquareRootLabel;

  /// Label for perfect square check
  ///
  /// In es, this message translates to:
  /// **'Es cuadrado perfecto'**
  String get analysisIsPerfectSquare;

  /// Label for cube root
  ///
  /// In es, this message translates to:
  /// **'Raíz cúbica'**
  String get analysisCubeRoot;

  /// Label for perfect cube check
  ///
  /// In es, this message translates to:
  /// **'Es cubo perfecto'**
  String get analysisIsPerfectCube;

  /// Section title for perfect power analysis
  ///
  /// In es, this message translates to:
  /// **'Potencia Perfecta'**
  String get analysisPerfectPower;

  /// Label for perfect power expression
  ///
  /// In es, this message translates to:
  /// **'Expresión'**
  String get analysisExpression;

  /// Label for base in perfect power
  ///
  /// In es, this message translates to:
  /// **'Base'**
  String get analysisBase;

  /// Label for exponent in perfect power
  ///
  /// In es, this message translates to:
  /// **'Exponente'**
  String get analysisExponent;

  /// Prime badge label on number card
  ///
  /// In es, this message translates to:
  /// **'Primo'**
  String get cardPrime;

  /// Perfect number badge label on number card
  ///
  /// In es, this message translates to:
  /// **'Perfecto'**
  String get cardPerfect;

  /// Palindrome badge label on number card
  ///
  /// In es, this message translates to:
  /// **'Palíndromo'**
  String get cardPalindrome;

  /// Fibonacci badge label on number card
  ///
  /// In es, this message translates to:
  /// **'Fibonacci'**
  String get cardFibonacci;

  /// Triangular badge label on number card
  ///
  /// In es, this message translates to:
  /// **'Triangular'**
  String get cardTriangular;

  /// Even number badge label on number card
  ///
  /// In es, this message translates to:
  /// **'Par'**
  String get cardEven;

  /// Odd number badge label on number card
  ///
  /// In es, this message translates to:
  /// **'Impar'**
  String get cardOdd;

  /// Quick properties section header on number card
  ///
  /// In es, this message translates to:
  /// **'Propiedades rápidas:'**
  String get cardQuickProperties;

  /// Convert section header on number card
  ///
  /// In es, this message translates to:
  /// **'Convertir:'**
  String get cardConvert;

  /// Convert to decimal button label
  ///
  /// In es, this message translates to:
  /// **'A Decimal'**
  String get cardToDecimal;

  /// Convert to binary button label
  ///
  /// In es, this message translates to:
  /// **'A Binario'**
  String get cardToBinary;

  /// Advanced operations section header on number card
  ///
  /// In es, this message translates to:
  /// **'Operaciones avanzadas:'**
  String get cardAdvancedOps;

  /// Digits count suffix on number card
  ///
  /// In es, this message translates to:
  /// **'dígitos'**
  String get cardDigits;

  /// Number theory keyboard section title
  ///
  /// In es, this message translates to:
  /// **'Teoría de Números'**
  String get kbdNumberTheory;

  /// Modular arithmetic keyboard section title
  ///
  /// In es, this message translates to:
  /// **'Aritmética Modular'**
  String get kbdModularArith;

  /// Combinatorics keyboard section title
  ///
  /// In es, this message translates to:
  /// **'Combinatoria'**
  String get kbdCombinatorics;

  /// Statistics keyboard section title
  ///
  /// In es, this message translates to:
  /// **'Estadística'**
  String get kbdStatistics;

  /// Error message for power operation
  ///
  /// In es, this message translates to:
  /// **'Error en potencia: {error}'**
  String errPower(String error);

  /// Error message for square root operation
  ///
  /// In es, this message translates to:
  /// **'Error en raíz cuadrada: {error}'**
  String errSquareRoot(String error);

  /// Error when taking square root of a negative number
  ///
  /// In es, this message translates to:
  /// **'No se puede calcular la raíz cuadrada de un número negativo'**
  String get errNegativeSqrt;

  /// Error message for cube root operation
  ///
  /// In es, this message translates to:
  /// **'Error en raíz cúbica: {error}'**
  String errCubeRoot(String error);

  /// Error message for binary conversion
  ///
  /// In es, this message translates to:
  /// **'Error en conversión binaria: {error}'**
  String errBinaryConversion(String error);

  /// Error when binary input is empty
  ///
  /// In es, this message translates to:
  /// **'Número binario vacío'**
  String get errEmptyBinary;

  /// Error when binary input contains invalid digits
  ///
  /// In es, this message translates to:
  /// **'El número debe contener solo dígitos binarios (0 y 1)'**
  String get errInvalidBinary;

  /// Error message for conversion from binary
  ///
  /// In es, this message translates to:
  /// **'Error en conversión de binario: {error}'**
  String errBinaryFromConversion(String error);

  /// Error when number is too large for trig functions
  ///
  /// In es, this message translates to:
  /// **'Número demasiado grande para funciones trigonométricas'**
  String get errTrigTooLarge;

  /// Error message for sine operation
  ///
  /// In es, this message translates to:
  /// **'Error en seno: {error}'**
  String errSin(String error);

  /// Error message for cosine operation
  ///
  /// In es, this message translates to:
  /// **'Error en coseno: {error}'**
  String errCos(String error);

  /// Error when tangent is undefined
  ///
  /// In es, this message translates to:
  /// **'Tangente indefinida para este ángulo'**
  String get errTanUndefined;

  /// Error message for tangent operation
  ///
  /// In es, this message translates to:
  /// **'Error en tangente: {error}'**
  String errTan(String error);

  /// Domain error for arcsine
  ///
  /// In es, this message translates to:
  /// **'Arcoseno solo está definido para valores entre -1 y 1'**
  String get errAsinDomain;

  /// Error message for arcsine operation
  ///
  /// In es, this message translates to:
  /// **'Error en arcoseno: {error}'**
  String errAsin(String error);

  /// Domain error for arccosine
  ///
  /// In es, this message translates to:
  /// **'Arcocoseno solo está definido para valores entre -1 y 1'**
  String get errAcosDomain;

  /// Error message for arccosine operation
  ///
  /// In es, this message translates to:
  /// **'Error en arcocoseno: {error}'**
  String errAcos(String error);

  /// Error message for arctangent operation
  ///
  /// In es, this message translates to:
  /// **'Error en arcotangente: {error}'**
  String errAtan(String error);

  /// Domain error for natural logarithm
  ///
  /// In es, this message translates to:
  /// **'Logaritmo natural solo está definido para números positivos'**
  String get errLnDomain;

  /// Error when number is too large for natural log
  ///
  /// In es, this message translates to:
  /// **'Número demasiado grande para logaritmo natural'**
  String get errLnTooLarge;

  /// Error message for natural logarithm operation
  ///
  /// In es, this message translates to:
  /// **'Error en logaritmo natural: {error}'**
  String errLn(String error);

  /// Domain error for log base 10
  ///
  /// In es, this message translates to:
  /// **'Logaritmo solo está definido para números positivos'**
  String get errLogDomain;

  /// Error when number is too large for log base 10
  ///
  /// In es, this message translates to:
  /// **'Número demasiado grande para logaritmo base 10'**
  String get errLogTooLarge;

  /// Error message for log base 10 operation
  ///
  /// In es, this message translates to:
  /// **'Error en logaritmo: {error}'**
  String errLog(String error);

  /// Error when number is too large for exponential
  ///
  /// In es, this message translates to:
  /// **'Número demasiado grande para exponencial'**
  String get errExpTooLarge;

  /// Error message for exponential operation
  ///
  /// In es, this message translates to:
  /// **'Error en exponencial: {error}'**
  String errExp(String error);

  /// Error when number is too large for 10^x
  ///
  /// In es, this message translates to:
  /// **'Número demasiado grande para 10^x'**
  String get errTenPowTooLarge;

  /// Error message for 10^x operation
  ///
  /// In es, this message translates to:
  /// **'Error en 10^x: {error}'**
  String errTenPow(String error);

  /// Error when factorial input is invalid
  ///
  /// In es, this message translates to:
  /// **'Número inválido para factorial'**
  String get errFactorialInvalid;

  /// Error when factorial input is negative
  ///
  /// In es, this message translates to:
  /// **'Factorial solo está definido para números enteros no negativos'**
  String get errFactorialNonNeg;

  /// Error when factorial input exceeds 170
  ///
  /// In es, this message translates to:
  /// **'Número demasiado grande para factorial (máximo 170)'**
  String get errFactorialTooLarge;

  /// Error message for factorial operation
  ///
  /// In es, this message translates to:
  /// **'Error en factorial: {error}'**
  String errFactorial(String error);

  /// Message when user cancels an operation
  ///
  /// In es, this message translates to:
  /// **'Operación cancelada'**
  String get errOperationCancelled;

  /// Generic error message
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String errGeneric(String error);

  /// Domain error for Euler totient function
  ///
  /// In es, this message translates to:
  /// **'φ(n) solo está definido para n > 0'**
  String get errPhiDomain;

  /// Error message for Euler totient function
  ///
  /// In es, this message translates to:
  /// **'Error en φ(n): {error}'**
  String errPhi(String error);

  /// Domain error for primorial
  ///
  /// In es, this message translates to:
  /// **'Primorial solo está definido para n ≥ 0'**
  String get errPrimorialDomain;

  /// Error message for primorial operation
  ///
  /// In es, this message translates to:
  /// **'Error en primorial: {error}'**
  String errPrimorial(String error);

  /// Domain error for divisor count function
  ///
  /// In es, this message translates to:
  /// **'σ₀(n) solo está definido para n > 0'**
  String get errSigma0Domain;

  /// Error message for divisor count function
  ///
  /// In es, this message translates to:
  /// **'Error en σ₀(n): {error}'**
  String errSigma0(String error);

  /// Domain error for divisor sum function
  ///
  /// In es, this message translates to:
  /// **'σ(m,n) solo está definido para n > 0'**
  String get errSigmaDomain;

  /// Error message for divisor sum function
  ///
  /// In es, this message translates to:
  /// **'Error en σ(m,n): {error}'**
  String errSigma(String error);

  /// Error message for floor/ceiling operation
  ///
  /// In es, this message translates to:
  /// **'Error en piso/techo: {error}'**
  String errFloorCeil(String error);

  /// Domain error for Möbius function
  ///
  /// In es, this message translates to:
  /// **'μ(n) solo está definido para n > 0'**
  String get errMobiusDomain;

  /// Error message for Möbius function
  ///
  /// In es, this message translates to:
  /// **'Error en μ(n): {error}'**
  String errMobius(String error);

  /// Error when factorial input is negative (special functions)
  ///
  /// In es, this message translates to:
  /// **'El factorial no está definido para negativos'**
  String get errFactorialNeg;

  /// Error when factorial exceeds max limit of 10000
  ///
  /// In es, this message translates to:
  /// **'n! demasiado grande (máx n=10000)'**
  String get errFactorialMax;

  /// Error message for n! in special functions
  ///
  /// In es, this message translates to:
  /// **'Error en n!: {error}'**
  String errFactorialN(String error);

  /// Error when double factorial input is negative
  ///
  /// In es, this message translates to:
  /// **'El doble factorial no está definido para negativos'**
  String get errDoubleFactorialNeg;

  /// Error message for double factorial operation
  ///
  /// In es, this message translates to:
  /// **'Error en n!!: {error}'**
  String errDoubleFactorial(String error);

  /// Error when Fibonacci input is negative
  ///
  /// In es, this message translates to:
  /// **'F(n) no está definido para n < 0'**
  String get errFibonacciNeg;

  /// Error message for Fibonacci operation
  ///
  /// In es, this message translates to:
  /// **'Error en F(n): {error}'**
  String errFibonacci(String error);

  /// Error when Catalan input is negative
  ///
  /// In es, this message translates to:
  /// **'Catalan no está definido para n < 0'**
  String get errCatalanNeg;

  /// Error message for Catalan number operation
  ///
  /// In es, this message translates to:
  /// **'Error en Catalan: {error}'**
  String errCatalan(String error);

  /// Error when derangement input is negative
  ///
  /// In es, this message translates to:
  /// **'D(n) no está definido para n < 0'**
  String get errDerangementNeg;

  /// Error message for derangement operation
  ///
  /// In es, this message translates to:
  /// **'Error en D(n): {error}'**
  String errDerangement(String error);

  /// Error when partition input is negative
  ///
  /// In es, this message translates to:
  /// **'p(n) no está definido para n < 0'**
  String get errPartitionNeg;

  /// Error message for partition function
  ///
  /// In es, this message translates to:
  /// **'Error en p(n): {error}'**
  String errPartition(String error);

  /// Error when Bell number input is negative
  ///
  /// In es, this message translates to:
  /// **'B(n) no está definido para n < 0'**
  String get errBellNeg;

  /// Error message for Bell number operation
  ///
  /// In es, this message translates to:
  /// **'Error en Bell(n): {error}'**
  String errBell(String error);

  /// Error message for digital root operation
  ///
  /// In es, this message translates to:
  /// **'Error en raíz digital: {error}'**
  String errDigitalRoot(String error);

  /// Domain error for primitive root
  ///
  /// In es, this message translates to:
  /// **'Se necesita n > 1'**
  String get errPrimitiveRootDomain;

  /// Error when no primitive root exists
  ///
  /// In es, this message translates to:
  /// **'No existe raíz primitiva mod {n}'**
  String errNoPrimitiveRoot(String n);

  /// Domain error for Liouville function
  ///
  /// In es, this message translates to:
  /// **'λ_L(n) solo está definido para n > 0'**
  String get errLiouvilleDomain;

  /// Error message for Liouville function
  ///
  /// In es, this message translates to:
  /// **'Error en λ_L(n): {error}'**
  String errLiouville(String error);

  /// Error message for prime counting function
  ///
  /// In es, this message translates to:
  /// **'Error en π(n): {error}'**
  String errPrimeCounting(String error);

  /// Domain error for radical function
  ///
  /// In es, this message translates to:
  /// **'rad(n) solo está definido para n > 0'**
  String get errRadDomain;

  /// Error message for radical function
  ///
  /// In es, this message translates to:
  /// **'Error en rad(n): {error}'**
  String errRad(String error);

  /// Domain error for small omega function
  ///
  /// In es, this message translates to:
  /// **'ω(n) solo está definido para n > 0'**
  String get errOmegaDomain;

  /// Error message for small omega function
  ///
  /// In es, this message translates to:
  /// **'Error en ω(n): {error}'**
  String errOmega(String error);

  /// Domain error for big omega function
  ///
  /// In es, this message translates to:
  /// **'Ω(n) solo está definido para n > 0'**
  String get errBigOmegaDomain;

  /// Error message for big omega function
  ///
  /// In es, this message translates to:
  /// **'Error en Ω(n): {error}'**
  String errBigOmega(String error);

  /// Domain error for Carmichael function
  ///
  /// In es, this message translates to:
  /// **'λ(n) solo está definido para n > 0'**
  String get errCarmichaelDomain;

  /// Error message for Carmichael function
  ///
  /// In es, this message translates to:
  /// **'Error en λ(n): {error}'**
  String errCarmichael(String error);

  /// Domain error for sopfr function
  ///
  /// In es, this message translates to:
  /// **'sopfr(n) solo está definido para n > 0'**
  String get errSopfrDomain;

  /// Error message for sopfr function
  ///
  /// In es, this message translates to:
  /// **'Error en sopfr(n): {error}'**
  String errSopfr(String error);

  /// Domain error for sopf function
  ///
  /// In es, this message translates to:
  /// **'sopf(n) solo está definido para n > 0'**
  String get errSopfDomain;

  /// Error message for sopf function
  ///
  /// In es, this message translates to:
  /// **'Error en sopf(n): {error}'**
  String errSopf(String error);

  /// Error message for percentage operation
  ///
  /// In es, this message translates to:
  /// **'Error en porcentaje: {error}'**
  String errPercentage(String error);

  /// Error for division by zero
  ///
  /// In es, this message translates to:
  /// **'División por cero'**
  String get errDivisionByZero;

  /// Error message for reciprocal operation
  ///
  /// In es, this message translates to:
  /// **'Error en recíproco: {error}'**
  String errReciprocal(String error);

  /// Error when modular inverse does not exist
  ///
  /// In es, this message translates to:
  /// **'No existe inverso modular de {a} mod {n}'**
  String errNoInverse(String a, String n);

  /// Error message for modular exponentiation
  ///
  /// In es, this message translates to:
  /// **'Error en exponenciación modular: {error}'**
  String errModPow(String error);

  /// Error message for Diophantine equation solver
  ///
  /// In es, this message translates to:
  /// **'Error en ecuación diofántica: {error}'**
  String errDiophantine(String error);

  /// Error message for Chinese Remainder Theorem
  ///
  /// In es, this message translates to:
  /// **'Error en TCR: {error}'**
  String errCRT(String error);

  /// Language section title in settings
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguage;

  /// Automatic language option label
  ///
  /// In es, this message translates to:
  /// **'Automático (del sistema)'**
  String get settingsLangAuto;

  /// Automatic language option description
  ///
  /// In es, this message translates to:
  /// **'Usar el idioma del dispositivo'**
  String get settingsLangAutoDesc;

  /// Spanish language option
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get settingsLangEs;

  /// English language option
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get settingsLangEn;

  /// Help screen title
  ///
  /// In es, this message translates to:
  /// **'Guía de Funciones Especiales'**
  String get hlpTitle;

  /// Quick start section header
  ///
  /// In es, this message translates to:
  /// **'Inicio Rápido'**
  String get hlpQuickStartHeader;

  /// Quick start welcome title
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a la calculadora para olimpiadas'**
  String get hlpQuickStartWelcome;

  /// Quick start step 1
  ///
  /// In es, this message translates to:
  /// **'Abre el menú lateral (☰) y selecciona \"Funciones Especiales\"'**
  String get hlpQuickStartStep1;

  /// Quick start step 2
  ///
  /// In es, this message translates to:
  /// **'El teclado superior (scrollable) tiene ~40 funciones en 4 secciones'**
  String get hlpQuickStartStep2;

  /// Quick start step 3
  ///
  /// In es, this message translates to:
  /// **'Ingresa un número y presiona cualquier botón de función'**
  String get hlpQuickStartStep3;

  /// Quick start step 4
  ///
  /// In es, this message translates to:
  /// **'Si la función necesita más valores, aparece un indicador de operación pendiente'**
  String get hlpQuickStartStep4;

  /// Quick start step 5
  ///
  /// In es, this message translates to:
  /// **'El panel lateral muestra análisis automático del número ingresado'**
  String get hlpQuickStartStep5;

  /// Quick start info note
  ///
  /// In es, this message translates to:
  /// **'Las funciones de 1 parámetro se ejecutan inmediatamente.\nLas de 2+ parámetros muestran un indicador y esperan más valores.'**
  String get hlpQuickStartNote;

  /// Parameter system section header
  ///
  /// In es, this message translates to:
  /// **'Sistema de Parámetros'**
  String get hlpParamHeader;

  /// Parameter types card title
  ///
  /// In es, this message translates to:
  /// **'Tipos de funciones según parámetros'**
  String get hlpParamTypesTitle;

  /// 1-param type title
  ///
  /// In es, this message translates to:
  /// **'1 parámetro (inmediatas)'**
  String get hlpParam1Title;

  /// 1-param type description
  ///
  /// In es, this message translates to:
  /// **'Ingresa número → Presiona función → Resultado'**
  String get hlpParam1Desc;

  /// 1-param type example
  ///
  /// In es, this message translates to:
  /// **'Ej: φ(12) → ingresa 12, presiona φ → muestra 4'**
  String get hlpParam1Example;

  /// 2-3-4 param type title
  ///
  /// In es, this message translates to:
  /// **'2-3-4 parámetros (fijos)'**
  String get hlpParam2Title;

  /// 2-3-4 param type description
  ///
  /// In es, this message translates to:
  /// **'Ingresa valor → Función → Valor → = → (repite si necesita más)\nSe auto-ejecuta al completar todos los parámetros.'**
  String get hlpParam2Desc;

  /// 2-3-4 param type example
  ///
  /// In es, this message translates to:
  /// **'Ej: C(10,3) → ingresa 10 → C(n,k) → 3 → ='**
  String get hlpParam2Example;

  /// N-param type title
  ///
  /// In es, this message translates to:
  /// **'N parámetros (variables)'**
  String get hlpParamNTitle;

  /// N-param type description
  ///
  /// In es, this message translates to:
  /// **'Ingresa valor → Función → Valor → = (agrega más)\nPresiona la MISMA FUNCIÓN otra vez para ejecutar.'**
  String get hlpParamNDesc;

  /// N-param type example
  ///
  /// In es, this message translates to:
  /// **'Ej: MCD(12,18,24) → 12 → MCD → 18 → = → 24 → MCD'**
  String get hlpParamNExample;

  /// Pending operation indicator title
  ///
  /// In es, this message translates to:
  /// **'Indicador de operación pendiente'**
  String get hlpPendingOpTitle;

  /// Pending operation indicator description
  ///
  /// In es, this message translates to:
  /// **'Cuando una función espera más valores, aparece un indicador coloreado en la pantalla mostrando qué operación está en curso y qué falta.\n\nEjemplo: \"C(10, _)\" indica que falta k para completar C(n,k).\n\"MCD(12, 18, _) [= agregar, MCD resolver]\" indica una operación variable.'**
  String get hlpPendingOpDesc;

  /// Number theory section header
  ///
  /// In es, this message translates to:
  /// **'Teoría de Números'**
  String get hlpNumberTheoryHeader;

  /// Euler phi function title
  ///
  /// In es, this message translates to:
  /// **'φ(n) — Función de Euler (Totient)'**
  String get hlpEulerPhiTitle;

  /// Euler phi params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpEulerPhiParams;

  /// Euler phi description
  ///
  /// In es, this message translates to:
  /// **'Cuenta cuántos enteros de 1 a n son coprimos con n (es decir, MCD(k,n)=1).'**
  String get hlpEulerPhiDesc;

  /// Euler phi formula
  ///
  /// In es, this message translates to:
  /// **'φ(n) = n × ∏(1 − 1/p) para cada primo p | n'**
  String get hlpEulerPhiFormula;

  /// Euler phi example 1
  ///
  /// In es, this message translates to:
  /// **'φ(1) = 1'**
  String get hlpEulerPhiEx1;

  /// Euler phi example 2
  ///
  /// In es, this message translates to:
  /// **'φ(9) = 6 → [1,2,4,5,7,8]'**
  String get hlpEulerPhiEx2;

  /// Euler phi example 3
  ///
  /// In es, this message translates to:
  /// **'φ(12) = 4 → [1,5,7,11]'**
  String get hlpEulerPhiEx3;

  /// Euler phi example 4
  ///
  /// In es, this message translates to:
  /// **'φ(p) = p−1 para p primo'**
  String get hlpEulerPhiEx4;

  /// Euler phi tip 1
  ///
  /// In es, this message translates to:
  /// **'Multiplicativa: φ(mn) = φ(m)φ(n) si MCD(m,n)=1'**
  String get hlpEulerPhiTip1;

  /// Euler phi tip 2
  ///
  /// In es, this message translates to:
  /// **'Teorema de Euler: a^φ(n) ≡ 1 (mod n) si MCD(a,n)=1'**
  String get hlpEulerPhiTip2;

  /// Euler phi tip 3
  ///
  /// In es, this message translates to:
  /// **'Σ φ(d) para d|n = n'**
  String get hlpEulerPhiTip3;

  /// Carmichael function title
  ///
  /// In es, this message translates to:
  /// **'λ(n) — Función λ de Carmichael'**
  String get hlpCarmichaelTitle;

  /// Carmichael params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpCarmichaelParams;

  /// Carmichael description
  ///
  /// In es, this message translates to:
  /// **'Menor m > 0 tal que a^m ≡ 1 (mod n) para TODO a coprimo con n. Siempre divide a φ(n).'**
  String get hlpCarmichaelDesc;

  /// Carmichael formula
  ///
  /// In es, this message translates to:
  /// **'λ(p^k) = φ(p^k) si p impar\nλ(2)=1, λ(4)=2, λ(2^k)=2^(k−2) si k≥3\nλ(n) = mcm de las partes'**
  String get hlpCarmichaelFormula;

  /// Carmichael example 1
  ///
  /// In es, this message translates to:
  /// **'λ(8) = 2'**
  String get hlpCarmichaelEx1;

  /// Carmichael example 2
  ///
  /// In es, this message translates to:
  /// **'λ(15) = mcm(λ(3),λ(5)) = mcm(2,4) = 4'**
  String get hlpCarmichaelEx2;

  /// Carmichael example 3
  ///
  /// In es, this message translates to:
  /// **'λ(p) = p−1 para p primo'**
  String get hlpCarmichaelEx3;

  /// Carmichael tip 1
  ///
  /// In es, this message translates to:
  /// **'λ(n) | φ(n) siempre'**
  String get hlpCarmichaelTip1;

  /// Carmichael tip 2
  ///
  /// In es, this message translates to:
  /// **'λ(n) = φ(n) si y solo si n tiene raíz primitiva'**
  String get hlpCarmichaelTip2;

  /// Mobius function title
  ///
  /// In es, this message translates to:
  /// **'μ(n) — Función de Möbius'**
  String get hlpMobiusTitle;

  /// Mobius params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpMobiusParams;

  /// Mobius description
  ///
  /// In es, this message translates to:
  /// **'Detecta si n es libre de cuadrados y cuenta factores primos.'**
  String get hlpMobiusDesc;

  /// Mobius formula
  ///
  /// In es, this message translates to:
  /// **'μ(1) = 1\nμ(n) = (−1)^k si n = p₁·p₂·...·pₖ (distintos)\nμ(n) = 0 si p² | n'**
  String get hlpMobiusFormula;

  /// Mobius example 1
  ///
  /// In es, this message translates to:
  /// **'μ(1) = 1'**
  String get hlpMobiusEx1;

  /// Mobius example 2
  ///
  /// In es, this message translates to:
  /// **'μ(6) = μ(2×3) = (−1)² = 1'**
  String get hlpMobiusEx2;

  /// Mobius example 3
  ///
  /// In es, this message translates to:
  /// **'μ(30) = μ(2×3×5) = (−1)³ = −1'**
  String get hlpMobiusEx3;

  /// Mobius example 4
  ///
  /// In es, this message translates to:
  /// **'μ(12) = 0 (tiene 2²)'**
  String get hlpMobiusEx4;

  /// Mobius tip 1
  ///
  /// In es, this message translates to:
  /// **'Inversión de Möbius: si g(n) = Σ f(d) para d|n, entonces f(n) = Σ μ(d)g(n/d)'**
  String get hlpMobiusTip1;

  /// Mobius tip 2
  ///
  /// In es, this message translates to:
  /// **'Σ μ(d) para d|n = [n=1]'**
  String get hlpMobiusTip2;

  /// Liouville function title
  ///
  /// In es, this message translates to:
  /// **'λL(n) — Función de Liouville'**
  String get hlpLiouvilleTitle;

  /// Liouville params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpLiouvilleParams;

  /// Liouville description
  ///
  /// In es, this message translates to:
  /// **'Completamente multiplicativa: λL(n) = (−1)^Ω(n).'**
  String get hlpLiouvilleDesc;

  /// Liouville formula
  ///
  /// In es, this message translates to:
  /// **'λL(n) = (−1)^Ω(n)'**
  String get hlpLiouvilleFormula;

  /// Liouville example 1
  ///
  /// In es, this message translates to:
  /// **'λL(12) = (−1)³ = −1 (Ω(12)=3)'**
  String get hlpLiouvilleEx1;

  /// Liouville example 2
  ///
  /// In es, this message translates to:
  /// **'λL(36) = (−1)⁴ = 1 (Ω(36)=4)'**
  String get hlpLiouvilleEx2;

  /// Liouville tip 1
  ///
  /// In es, this message translates to:
  /// **'Σ λL(d) para d|n = 1 si n es cuadrado perfecto, 0 si no'**
  String get hlpLiouvilleTip1;

  /// Small omega function title
  ///
  /// In es, this message translates to:
  /// **'ω(n) — Factores Primos Distintos'**
  String get hlpSmallOmegaTitle;

  /// Small omega params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpSmallOmegaParams;

  /// Small omega description
  ///
  /// In es, this message translates to:
  /// **'Cuenta la cantidad de primos distintos que dividen a n.'**
  String get hlpSmallOmegaDesc;

  /// Small omega formula
  ///
  /// In es, this message translates to:
  /// **'ω(n) = k si n = p₁^a₁ × ... × pₖ^aₖ'**
  String get hlpSmallOmegaFormula;

  /// Small omega example 1
  ///
  /// In es, this message translates to:
  /// **'ω(12) = 2 → [2, 3]'**
  String get hlpSmallOmegaEx1;

  /// Small omega example 2
  ///
  /// In es, this message translates to:
  /// **'ω(30) = 3 → [2, 3, 5]'**
  String get hlpSmallOmegaEx2;

  /// Small omega example 3
  ///
  /// In es, this message translates to:
  /// **'ω(p^k) = 1'**
  String get hlpSmallOmegaEx3;

  /// Big omega function title
  ///
  /// In es, this message translates to:
  /// **'Ω(n) — Factores Primos con Multiplicidad'**
  String get hlpBigOmegaTitle;

  /// Big omega params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpBigOmegaParams;

  /// Big omega description
  ///
  /// In es, this message translates to:
  /// **'Número total de factores primos contando repeticiones.'**
  String get hlpBigOmegaDesc;

  /// Big omega formula
  ///
  /// In es, this message translates to:
  /// **'Ω(n) = a₁ + a₂ + ... + aₖ'**
  String get hlpBigOmegaFormula;

  /// Big omega example 1
  ///
  /// In es, this message translates to:
  /// **'Ω(12) = 3 → 2×2×3'**
  String get hlpBigOmegaEx1;

  /// Big omega example 2
  ///
  /// In es, this message translates to:
  /// **'Ω(72) = 5 → 2³×3² → 3+2'**
  String get hlpBigOmegaEx2;

  /// Big omega example 3
  ///
  /// In es, this message translates to:
  /// **'Ω(p) = 1, Ω(p²) = 2'**
  String get hlpBigOmegaEx3;

  /// Sigma0 function title
  ///
  /// In es, this message translates to:
  /// **'σ₀(n) — Cantidad de Divisores'**
  String get hlpSigma0Title;

  /// Sigma0 params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpSigma0Params;

  /// Sigma0 description
  ///
  /// In es, this message translates to:
  /// **'Número total de divisores positivos de n.'**
  String get hlpSigma0Desc;

  /// Sigma0 formula
  ///
  /// In es, this message translates to:
  /// **'Si n = p₁^a₁ × ... × pₖ^aₖ\nσ₀(n) = (a₁+1)(a₂+1)...(aₖ+1)'**
  String get hlpSigma0Formula;

  /// Sigma0 example 1
  ///
  /// In es, this message translates to:
  /// **'σ₀(12) = 6 → [1,2,3,4,6,12]'**
  String get hlpSigma0Ex1;

  /// Sigma0 example 2
  ///
  /// In es, this message translates to:
  /// **'σ₀(p) = 2'**
  String get hlpSigma0Ex2;

  /// Sigma0 example 3
  ///
  /// In es, this message translates to:
  /// **'σ₀(p²) = 3'**
  String get hlpSigma0Ex3;

  /// Sigma function title
  ///
  /// In es, this message translates to:
  /// **'σ(n) — Suma de Divisores'**
  String get hlpSigmaTitle;

  /// Sigma params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpSigmaParams;

  /// Sigma description
  ///
  /// In es, this message translates to:
  /// **'Suma de todos los divisores positivos de n.'**
  String get hlpSigmaDesc;

  /// Sigma formula
  ///
  /// In es, this message translates to:
  /// **'σ(n) = Σ d para d | n'**
  String get hlpSigmaFormula;

  /// Sigma example 1
  ///
  /// In es, this message translates to:
  /// **'σ(6) = 1+2+3+6 = 12 (6 es perfecto)'**
  String get hlpSigmaEx1;

  /// Sigma example 2
  ///
  /// In es, this message translates to:
  /// **'σ(12) = 1+2+3+4+6+12 = 28'**
  String get hlpSigmaEx2;

  /// Sigma example 3
  ///
  /// In es, this message translates to:
  /// **'σ(p) = p+1'**
  String get hlpSigmaEx3;

  /// Sigma tip 1
  ///
  /// In es, this message translates to:
  /// **'n es perfecto ⟺ σ(n) = 2n'**
  String get hlpSigmaTip1;

  /// Sigma tip 2
  ///
  /// In es, this message translates to:
  /// **'n es abundante ⟺ σ(n) > 2n'**
  String get hlpSigmaTip2;

  /// Sopfr function title
  ///
  /// In es, this message translates to:
  /// **'sopfr(n) — Suma de Primos con Repetición'**
  String get hlpSopfrTitle;

  /// Sopfr params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpSopfrParams;

  /// Sopfr description
  ///
  /// In es, this message translates to:
  /// **'Suma los factores primos contando multiplicidad.'**
  String get hlpSopfrDesc;

  /// Sopfr formula
  ///
  /// In es, this message translates to:
  /// **'sopfr(n) = a₁p₁ + a₂p₂ + ... + aₖpₖ'**
  String get hlpSopfrFormula;

  /// Sopfr example 1
  ///
  /// In es, this message translates to:
  /// **'sopfr(12) = 2+2+3 = 7'**
  String get hlpSopfrEx1;

  /// Sopfr example 2
  ///
  /// In es, this message translates to:
  /// **'sopfr(60) = 2+2+3+5 = 12'**
  String get hlpSopfrEx2;

  /// Sopf function title
  ///
  /// In es, this message translates to:
  /// **'sopf(n) — Suma de Primos Distintos'**
  String get hlpSopfTitle;

  /// Sopf params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpSopfParams;

  /// Sopf description
  ///
  /// In es, this message translates to:
  /// **'Suma de los primos distintos que dividen a n.'**
  String get hlpSopfDesc;

  /// Sopf formula
  ///
  /// In es, this message translates to:
  /// **'sopf(n) = p₁ + p₂ + ... + pₖ'**
  String get hlpSopfFormula;

  /// Sopf example 1
  ///
  /// In es, this message translates to:
  /// **'sopf(12) = 2+3 = 5'**
  String get hlpSopfEx1;

  /// Sopf example 2
  ///
  /// In es, this message translates to:
  /// **'sopf(60) = 2+3+5 = 10'**
  String get hlpSopfEx2;

  /// Radical function title
  ///
  /// In es, this message translates to:
  /// **'rad(n) — Radical'**
  String get hlpRadTitle;

  /// Radical params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpRadParams;

  /// Radical description
  ///
  /// In es, this message translates to:
  /// **'Producto de los primos distintos que dividen a n (función del Conjetura ABC).'**
  String get hlpRadDesc;

  /// Radical formula
  ///
  /// In es, this message translates to:
  /// **'rad(n) = ∏ p para p primo, p | n'**
  String get hlpRadFormula;

  /// Radical example 1
  ///
  /// In es, this message translates to:
  /// **'rad(72) = rad(2³×3²) = 2×3 = 6'**
  String get hlpRadEx1;

  /// Radical example 2
  ///
  /// In es, this message translates to:
  /// **'rad(480) = rad(2⁵×3×5) = 30'**
  String get hlpRadEx2;

  /// Radical example 3
  ///
  /// In es, this message translates to:
  /// **'rad(p) = p'**
  String get hlpRadEx3;

  /// Primorial function title
  ///
  /// In es, this message translates to:
  /// **'n# — Primorial'**
  String get hlpPrimorialTitle;

  /// Primorial params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpPrimorialParams;

  /// Primorial description
  ///
  /// In es, this message translates to:
  /// **'Producto de todos los primos ≤ n.'**
  String get hlpPrimorialDesc;

  /// Primorial formula
  ///
  /// In es, this message translates to:
  /// **'n# = ∏ p para p primo, p ≤ n'**
  String get hlpPrimorialFormula;

  /// Primorial example 1
  ///
  /// In es, this message translates to:
  /// **'5# = 2×3×5 = 30'**
  String get hlpPrimorialEx1;

  /// Primorial example 2
  ///
  /// In es, this message translates to:
  /// **'7# = 210'**
  String get hlpPrimorialEx2;

  /// Primorial example 3
  ///
  /// In es, this message translates to:
  /// **'11# = 2310'**
  String get hlpPrimorialEx3;

  /// Prime counting function title
  ///
  /// In es, this message translates to:
  /// **'π(n) — Función Contadora de Primos'**
  String get hlpPrimeCountTitle;

  /// Prime counting params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpPrimeCountParams;

  /// Prime counting description
  ///
  /// In es, this message translates to:
  /// **'Cuenta primos ≤ n. Exacto para n ≤ 1,000,000; aproximación Li(x) para mayores.'**
  String get hlpPrimeCountDesc;

  /// Prime counting formula
  ///
  /// In es, this message translates to:
  /// **'π(n) ~ n/ln(n) (Teorema de los Números Primos)'**
  String get hlpPrimeCountFormula;

  /// Prime counting example 1
  ///
  /// In es, this message translates to:
  /// **'π(10) = 4'**
  String get hlpPrimeCountEx1;

  /// Prime counting example 2
  ///
  /// In es, this message translates to:
  /// **'π(100) = 25'**
  String get hlpPrimeCountEx2;

  /// Prime counting example 3
  ///
  /// In es, this message translates to:
  /// **'π(1,000,000) = 78,498'**
  String get hlpPrimeCountEx3;

  /// Digital root function title
  ///
  /// In es, this message translates to:
  /// **'dr(n) — Raíz Digital'**
  String get hlpDigitalRootTitle;

  /// Digital root params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpDigitalRootParams;

  /// Digital root description
  ///
  /// In es, this message translates to:
  /// **'Suma iterativa de dígitos hasta obtener un solo dígito.'**
  String get hlpDigitalRootDesc;

  /// Digital root formula
  ///
  /// In es, this message translates to:
  /// **'dr(n) = 1 + (n−1) mod 9  (para n > 0)'**
  String get hlpDigitalRootFormula;

  /// Digital root example 1
  ///
  /// In es, this message translates to:
  /// **'dr(493) → 4+9+3=16 → 1+6 = 7'**
  String get hlpDigitalRootEx1;

  /// Digital root example 2
  ///
  /// In es, this message translates to:
  /// **'dr(999) = 9'**
  String get hlpDigitalRootEx2;

  /// Digital root example 3
  ///
  /// In es, this message translates to:
  /// **'dr(n) ≡ n (mod 9)'**
  String get hlpDigitalRootEx3;

  /// Floor/ceiling function title
  ///
  /// In es, this message translates to:
  /// **'⌊x⌋ / ⌈x⌉ — Piso y Techo'**
  String get hlpFloorCeilTitle;

  /// Floor/ceiling params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpFloorCeilParams;

  /// Floor/ceiling description
  ///
  /// In es, this message translates to:
  /// **'Piso: mayor entero ≤ x. Techo: menor entero ≥ x. Se alterna entre ambos.'**
  String get hlpFloorCeilDesc;

  /// Floor/ceiling formula
  ///
  /// In es, this message translates to:
  /// **'⌊x⌋ ≤ x < ⌊x⌋+1\n⌈x⌉−1 < x ≤ ⌈x⌉'**
  String get hlpFloorCeilFormula;

  /// Floor/ceiling example 1
  ///
  /// In es, this message translates to:
  /// **'⌊3.7⌋ = 3, ⌈3.7⌉ = 4'**
  String get hlpFloorCeilEx1;

  /// Floor/ceiling example 2
  ///
  /// In es, this message translates to:
  /// **'⌊−2.3⌋ = −3, ⌈−2.3⌉ = −2'**
  String get hlpFloorCeilEx2;

  /// Floor/ceiling example 3
  ///
  /// In es, this message translates to:
  /// **'⌊5⌋ = ⌈5⌉ = 5'**
  String get hlpFloorCeilEx3;

  /// p-adic valuation title
  ///
  /// In es, this message translates to:
  /// **'Vₚ(n) — Valuación p-ádica'**
  String get hlpPadicTitle;

  /// p-adic valuation params
  ///
  /// In es, this message translates to:
  /// **'2 params: n → Vₚ → p → ='**
  String get hlpPadicParams;

  /// p-adic valuation description
  ///
  /// In es, this message translates to:
  /// **'Máxima potencia del primo p que divide a n.'**
  String get hlpPadicDesc;

  /// p-adic valuation formula
  ///
  /// In es, this message translates to:
  /// **'Vₚ(n) = max[k : p^k | n]'**
  String get hlpPadicFormula;

  /// p-adic example 1
  ///
  /// In es, this message translates to:
  /// **'V₂(24) = 3 → 24 = 2³×3'**
  String get hlpPadicEx1;

  /// p-adic example 2
  ///
  /// In es, this message translates to:
  /// **'V₃(81) = 4 → 81 = 3⁴'**
  String get hlpPadicEx2;

  /// p-adic example 3
  ///
  /// In es, this message translates to:
  /// **'V₅(100) = 2 → 100 = 2²×5²'**
  String get hlpPadicEx3;

  /// p-adic tip 1
  ///
  /// In es, this message translates to:
  /// **'Fórmula de Legendre: Vₚ(n!) = Σ ⌊n/pⁱ⌋'**
  String get hlpPadicTip1;

  /// p-adic tip 2
  ///
  /// In es, this message translates to:
  /// **'Vₚ(ab) = Vₚ(a) + Vₚ(b)'**
  String get hlpPadicTip2;

  /// Modular arithmetic section header
  ///
  /// In es, this message translates to:
  /// **'Aritmética Modular'**
  String get hlpModArithHeader;

  /// Modulo function title
  ///
  /// In es, this message translates to:
  /// **'a mod b — Resto de División'**
  String get hlpModTitle;

  /// Modulo params
  ///
  /// In es, this message translates to:
  /// **'2 params: a → mod → b → ='**
  String get hlpModParams;

  /// Modulo description
  ///
  /// In es, this message translates to:
  /// **'Resto de dividir a entre b.'**
  String get hlpModDesc;

  /// Modulo formula
  ///
  /// In es, this message translates to:
  /// **'a mod b = a − b × ⌊a/b⌋'**
  String get hlpModFormula;

  /// Modulo example 1
  ///
  /// In es, this message translates to:
  /// **'17 mod 5 = 2'**
  String get hlpModEx1;

  /// Modulo example 2
  ///
  /// In es, this message translates to:
  /// **'23 mod 7 = 2'**
  String get hlpModEx2;

  /// Modulo example 3
  ///
  /// In es, this message translates to:
  /// **'−8 mod 3 = 1'**
  String get hlpModEx3;

  /// Modular exponentiation title
  ///
  /// In es, this message translates to:
  /// **'a^b mod n — Exponenciación Modular'**
  String get hlpModPowTitle;

  /// Modular exponentiation params
  ///
  /// In es, this message translates to:
  /// **'3 params: a → a%n → b → = → n → ='**
  String get hlpModPowParams;

  /// Modular exponentiation description
  ///
  /// In es, this message translates to:
  /// **'Calcula a^b mod n eficientemente usando cuadratura repetida O(log b).'**
  String get hlpModPowDesc;

  /// Modular exponentiation formula
  ///
  /// In es, this message translates to:
  /// **'Se descompone b en binario y se cuadra sucesivamente'**
  String get hlpModPowFormula;

  /// Modular exponentiation example 1
  ///
  /// In es, this message translates to:
  /// **'2¹⁰⁰ mod 7 = 2'**
  String get hlpModPowEx1;

  /// Modular exponentiation example 2
  ///
  /// In es, this message translates to:
  /// **'3¹³ mod 11 = 5'**
  String get hlpModPowEx2;

  /// Modular exponentiation example 3
  ///
  /// In es, this message translates to:
  /// **'Fundamental en RSA y tests de primalidad'**
  String get hlpModPowEx3;

  /// Modular exponentiation tip 1
  ///
  /// In es, this message translates to:
  /// **'Flujo: ingresa a → presiona a%n → ingresa b → presiona = → ingresa n → presiona ='**
  String get hlpModPowTip1;

  /// Modular inverse title
  ///
  /// In es, this message translates to:
  /// **'a⁻¹ mod n — Inverso Modular'**
  String get hlpModInvTitle;

  /// Modular inverse params
  ///
  /// In es, this message translates to:
  /// **'2 params: a → a⁻¹ → n → ='**
  String get hlpModInvParams;

  /// Modular inverse description
  ///
  /// In es, this message translates to:
  /// **'Encuentra b tal que a×b ≡ 1 (mod n). Solo existe si MCD(a,n) = 1.'**
  String get hlpModInvDesc;

  /// Modular inverse formula
  ///
  /// In es, this message translates to:
  /// **'Algoritmo extendido de Euclides'**
  String get hlpModInvFormula;

  /// Modular inverse example 1
  ///
  /// In es, this message translates to:
  /// **'3⁻¹ mod 7 = 5 → 3×5=15≡1'**
  String get hlpModInvEx1;

  /// Modular inverse example 2
  ///
  /// In es, this message translates to:
  /// **'5⁻¹ mod 11 = 9 → 5×9=45≡1'**
  String get hlpModInvEx2;

  /// Modular inverse example 3
  ///
  /// In es, this message translates to:
  /// **'No existe si MCD(a,n) ≠ 1'**
  String get hlpModInvEx3;

  /// Multiplicative order title
  ///
  /// In es, this message translates to:
  /// **'ord_n(a) — Orden Multiplicativo'**
  String get hlpOrdTitle;

  /// Multiplicative order params
  ///
  /// In es, this message translates to:
  /// **'2 params: a → ord → n → ='**
  String get hlpOrdParams;

  /// Multiplicative order description
  ///
  /// In es, this message translates to:
  /// **'Menor k > 0 con a^k ≡ 1 (mod n). Requiere MCD(a,n)=1.'**
  String get hlpOrdDesc;

  /// Multiplicative order formula
  ///
  /// In es, this message translates to:
  /// **'ord_n(a) = min[k > 0 : a^k ≡ 1 (mod n)]'**
  String get hlpOrdFormula;

  /// Multiplicative order example 1
  ///
  /// In es, this message translates to:
  /// **'ord₇(2) = 3 → 2³=8≡1'**
  String get hlpOrdEx1;

  /// Multiplicative order example 2
  ///
  /// In es, this message translates to:
  /// **'ord₁₀(3) = 4 → 3⁴=81≡1'**
  String get hlpOrdEx2;

  /// Multiplicative order tip 1
  ///
  /// In es, this message translates to:
  /// **'ord_n(a) siempre divide a φ(n)'**
  String get hlpOrdTip1;

  /// Multiplicative order tip 2
  ///
  /// In es, this message translates to:
  /// **'a es raíz primitiva ⟺ ord_n(a) = φ(n)'**
  String get hlpOrdTip2;

  /// Legendre symbol title
  ///
  /// In es, this message translates to:
  /// **'(a/p) — Símbolo de Legendre'**
  String get hlpLegendreTitle;

  /// Legendre symbol params
  ///
  /// In es, this message translates to:
  /// **'2 params: a → (a/p) → p → ='**
  String get hlpLegendreParams;

  /// Legendre symbol description
  ///
  /// In es, this message translates to:
  /// **'1 si a es residuo cuadrático mod p, −1 si no, 0 si p|a. Requiere p primo impar.'**
  String get hlpLegendreDesc;

  /// Legendre symbol formula
  ///
  /// In es, this message translates to:
  /// **'(a/p) ≡ a^((p−1)/2) (mod p) — Criterio de Euler'**
  String get hlpLegendreFormula;

  /// Legendre symbol example 1
  ///
  /// In es, this message translates to:
  /// **'(2/7) = 1 → 3²≡2 (mod 7)'**
  String get hlpLegendreEx1;

  /// Legendre symbol example 2
  ///
  /// In es, this message translates to:
  /// **'(3/7) = −1 → no existe x²≡3'**
  String get hlpLegendreEx2;

  /// Legendre symbol example 3
  ///
  /// In es, this message translates to:
  /// **'(5/5) = 0'**
  String get hlpLegendreEx3;

  /// Jacobi symbol title
  ///
  /// In es, this message translates to:
  /// **'(a/n)ⱼ — Símbolo de Jacobi'**
  String get hlpJacobiTitle;

  /// Jacobi symbol params
  ///
  /// In es, this message translates to:
  /// **'2 params: a → (a/n)ⱼ → n → ='**
  String get hlpJacobiParams;

  /// Jacobi symbol description
  ///
  /// In es, this message translates to:
  /// **'Generalización de Legendre para n compuesto impar. Usa reciprocidad cuadrática.'**
  String get hlpJacobiDesc;

  /// Jacobi symbol formula
  ///
  /// In es, this message translates to:
  /// **'(a/n) = ∏(a/pᵢ)^eᵢ donde n = ∏pᵢ^eᵢ'**
  String get hlpJacobiFormula;

  /// Jacobi symbol example 1
  ///
  /// In es, this message translates to:
  /// **'(2/15) = (2/3)(2/5) = (−1)(−1) = 1'**
  String get hlpJacobiEx1;

  /// Jacobi symbol example 2
  ///
  /// In es, this message translates to:
  /// **'(a/n) = −1 ⟹ a NO es residuo cuadrático'**
  String get hlpJacobiEx2;

  /// Jacobi symbol example 3
  ///
  /// In es, this message translates to:
  /// **'(a/n) = 1 NO garantiza que lo sea'**
  String get hlpJacobiEx3;

  /// Primitive root title
  ///
  /// In es, this message translates to:
  /// **'g — Raíz Primitiva'**
  String get hlpPrimRootTitle;

  /// Primitive root params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpPrimRootParams;

  /// Primitive root description
  ///
  /// In es, this message translates to:
  /// **'Menor raíz primitiva mod n (si existe). g es raíz primitiva si ord_n(g) = φ(n).'**
  String get hlpPrimRootDesc;

  /// Primitive root formula
  ///
  /// In es, this message translates to:
  /// **'[g, g², ..., g^φ(n)] = (Z/nZ)*'**
  String get hlpPrimRootFormula;

  /// Primitive root example 1
  ///
  /// In es, this message translates to:
  /// **'g(7) = 3 → [3,2,6,4,5,1]'**
  String get hlpPrimRootEx1;

  /// Primitive root example 2
  ///
  /// In es, this message translates to:
  /// **'g(11) = 2'**
  String get hlpPrimRootEx2;

  /// Primitive root example 3
  ///
  /// In es, this message translates to:
  /// **'Existe solo para n = 1,2,4,p^k,2p^k'**
  String get hlpPrimRootEx3;

  /// GCD function title
  ///
  /// In es, this message translates to:
  /// **'MCD — Máximo Común Divisor'**
  String get hlpGcdTitle;

  /// GCD params
  ///
  /// In es, this message translates to:
  /// **'N params (variable, mín. 2)'**
  String get hlpGcdParams;

  /// GCD description
  ///
  /// In es, this message translates to:
  /// **'Mayor entero que divide a todos los valores. Acepta 2 o más números.'**
  String get hlpGcdDesc;

  /// GCD formula
  ///
  /// In es, this message translates to:
  /// **'MCD(a,b) vía algoritmo de Euclides'**
  String get hlpGcdFormula;

  /// GCD example 1
  ///
  /// In es, this message translates to:
  /// **'MCD(12,18) = 6'**
  String get hlpGcdEx1;

  /// GCD example 2
  ///
  /// In es, this message translates to:
  /// **'MCD(12,18,24) = 6'**
  String get hlpGcdEx2;

  /// GCD example 3
  ///
  /// In es, this message translates to:
  /// **'MCD(a,b) × MCM(a,b) = a×b'**
  String get hlpGcdEx3;

  /// GCD tip 1
  ///
  /// In es, this message translates to:
  /// **'Flujo: 12 → MCD → 18 → MCD (ejecuta)'**
  String get hlpGcdTip1;

  /// GCD tip 2
  ///
  /// In es, this message translates to:
  /// **'Para 3+ números: 12 → MCD → 18 → = → 24 → MCD'**
  String get hlpGcdTip2;

  /// GCD tip 3
  ///
  /// In es, this message translates to:
  /// **'Presiona = para agregar más, presiona MCD para ejecutar'**
  String get hlpGcdTip3;

  /// LCM function title
  ///
  /// In es, this message translates to:
  /// **'MCM — Mínimo Común Múltiplo'**
  String get hlpLcmTitle;

  /// LCM params
  ///
  /// In es, this message translates to:
  /// **'N params (variable, mín. 2)'**
  String get hlpLcmParams;

  /// LCM description
  ///
  /// In es, this message translates to:
  /// **'Menor entero positivo divisible por todos los valores.'**
  String get hlpLcmDesc;

  /// LCM formula
  ///
  /// In es, this message translates to:
  /// **'MCM(a,b) = a×b / MCD(a,b)'**
  String get hlpLcmFormula;

  /// LCM example 1
  ///
  /// In es, this message translates to:
  /// **'MCM(4,6) = 12'**
  String get hlpLcmEx1;

  /// LCM example 2
  ///
  /// In es, this message translates to:
  /// **'MCM(3,5,7) = 105'**
  String get hlpLcmEx2;

  /// LCM tip 1
  ///
  /// In es, this message translates to:
  /// **'Mismo flujo que MCD: presiona MCM otra vez para ejecutar'**
  String get hlpLcmTip1;

  /// Diophantine equation title
  ///
  /// In es, this message translates to:
  /// **'Diof — Ecuación Diofántica Lineal'**
  String get hlpDiophTitle;

  /// Diophantine equation params
  ///
  /// In es, this message translates to:
  /// **'3 params: a → Diof → b → = → c → ='**
  String get hlpDiophParams;

  /// Diophantine equation description
  ///
  /// In es, this message translates to:
  /// **'Resuelve ax + by = c. Da solución particular y general.'**
  String get hlpDiophDesc;

  /// Diophantine equation formula
  ///
  /// In es, this message translates to:
  /// **'ax + by = c tiene solución ⟺ MCD(a,b) | c\nx = x₀ + (b/g)t,  y = y₀ − (a/g)t'**
  String get hlpDiophFormula;

  /// Diophantine example 1
  ///
  /// In es, this message translates to:
  /// **'3x + 5y = 1 → x=2+5t, y=−1−3t'**
  String get hlpDiophEx1;

  /// Diophantine example 2
  ///
  /// In es, this message translates to:
  /// **'6x + 9y = 12 → x=2+3t, y=0−2t'**
  String get hlpDiophEx2;

  /// Diophantine example 3
  ///
  /// In es, this message translates to:
  /// **'4x + 6y = 3 → Sin solución'**
  String get hlpDiophEx3;

  /// Diophantine tip 1
  ///
  /// In es, this message translates to:
  /// **'Paso 1: ingresa a (coeficiente de x)'**
  String get hlpDiophTip1;

  /// Diophantine tip 2
  ///
  /// In es, this message translates to:
  /// **'Paso 2: presiona Diof'**
  String get hlpDiophTip2;

  /// Diophantine tip 3
  ///
  /// In es, this message translates to:
  /// **'Paso 3: ingresa b (coeficiente de y), presiona ='**
  String get hlpDiophTip3;

  /// Diophantine tip 4
  ///
  /// In es, this message translates to:
  /// **'Paso 4: ingresa c (término independiente), presiona ='**
  String get hlpDiophTip4;

  /// CRT title
  ///
  /// In es, this message translates to:
  /// **'TCR — Teorema Chino del Residuo'**
  String get hlpCrtTitle;

  /// CRT params
  ///
  /// In es, this message translates to:
  /// **'Variable (4+ params en pares a,m)'**
  String get hlpCrtParams;

  /// CRT description
  ///
  /// In es, this message translates to:
  /// **'Resuelve sistema de congruencias x ≡ aᵢ (mod mᵢ).'**
  String get hlpCrtDesc;

  /// CRT formula
  ///
  /// In es, this message translates to:
  /// **'x ≡ a₁ (mod m₁)\nx ≡ a₂ (mod m₂)\n→ x ≡ r (mod mcm(m₁,m₂))'**
  String get hlpCrtFormula;

  /// CRT example 1
  ///
  /// In es, this message translates to:
  /// **'x≡2(mod 3), x≡3(mod 5) → x≡8(mod 15)'**
  String get hlpCrtEx1;

  /// CRT example 2
  ///
  /// In es, this message translates to:
  /// **'x≡1(mod 4), x≡2(mod 3) → x≡5(mod 12)'**
  String get hlpCrtEx2;

  /// CRT tip 1
  ///
  /// In es, this message translates to:
  /// **'Flujo: a₁ → TCR → m₁ → = → a₂ → = → m₂ → TCR'**
  String get hlpCrtTip1;

  /// CRT tip 2
  ///
  /// In es, this message translates to:
  /// **'Los módulos deben ser compatibles'**
  String get hlpCrtTip2;

  /// Combinatorics section header
  ///
  /// In es, this message translates to:
  /// **'Combinatoria'**
  String get hlpCombinatoricsHeader;

  /// Factorial function title
  ///
  /// In es, this message translates to:
  /// **'n! — Factorial'**
  String get hlpFactorialTitle;

  /// Factorial params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpFactorialParams;

  /// Factorial description
  ///
  /// In es, this message translates to:
  /// **'Producto de 1 a n. Precisión arbitraria.'**
  String get hlpFactorialDesc;

  /// Factorial formula
  ///
  /// In es, this message translates to:
  /// **'n! = 1 × 2 × ... × n,  0! = 1'**
  String get hlpFactorialFormula;

  /// Factorial example 1
  ///
  /// In es, this message translates to:
  /// **'5! = 120'**
  String get hlpFactorialEx1;

  /// Factorial example 2
  ///
  /// In es, this message translates to:
  /// **'10! = 3,628,800'**
  String get hlpFactorialEx2;

  /// Factorial example 3
  ///
  /// In es, this message translates to:
  /// **'20! = 2,432,902,008,176,640,000'**
  String get hlpFactorialEx3;

  /// Double factorial title
  ///
  /// In es, this message translates to:
  /// **'n!! — Doble Factorial'**
  String get hlpDblFactorialTitle;

  /// Double factorial params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpDblFactorialParams;

  /// Double factorial description
  ///
  /// In es, this message translates to:
  /// **'Producto de enteros de misma paridad.'**
  String get hlpDblFactorialDesc;

  /// Double factorial formula
  ///
  /// In es, this message translates to:
  /// **'n!! = n × (n−2) × (n−4) × ...'**
  String get hlpDblFactorialFormula;

  /// Double factorial example 1
  ///
  /// In es, this message translates to:
  /// **'7!! = 7×5×3×1 = 105'**
  String get hlpDblFactorialEx1;

  /// Double factorial example 2
  ///
  /// In es, this message translates to:
  /// **'8!! = 8×6×4×2 = 384'**
  String get hlpDblFactorialEx2;

  /// Double factorial example 3
  ///
  /// In es, this message translates to:
  /// **'0!! = 1!! = 1'**
  String get hlpDblFactorialEx3;

  /// Combinations title
  ///
  /// In es, this message translates to:
  /// **'C(n,k) — Combinaciones'**
  String get hlpCombTitle;

  /// Combinations params
  ///
  /// In es, this message translates to:
  /// **'2 params: n → C(n,k) → k → ='**
  String get hlpCombParams;

  /// Combinations description
  ///
  /// In es, this message translates to:
  /// **'Formas de elegir k de n sin importar orden.'**
  String get hlpCombDesc;

  /// Combinations formula
  ///
  /// In es, this message translates to:
  /// **'C(n,k) = n! / (k!(n−k)!)'**
  String get hlpCombFormula;

  /// Combinations example 1
  ///
  /// In es, this message translates to:
  /// **'C(5,2) = 10'**
  String get hlpCombEx1;

  /// Combinations example 2
  ///
  /// In es, this message translates to:
  /// **'C(10,3) = 120'**
  String get hlpCombEx2;

  /// Combinations example 3
  ///
  /// In es, this message translates to:
  /// **'C(n,0) = C(n,n) = 1'**
  String get hlpCombEx3;

  /// Combinations tip 1
  ///
  /// In es, this message translates to:
  /// **'Identidad de Pascal: C(n,k) = C(n−1,k−1) + C(n−1,k)'**
  String get hlpCombTip1;

  /// Combinations tip 2
  ///
  /// In es, this message translates to:
  /// **'C(n,k) = C(n, n−k)'**
  String get hlpCombTip2;

  /// Variations/partial permutations title
  ///
  /// In es, this message translates to:
  /// **'V(n,k) — Variaciones (Permutaciones parciales)'**
  String get hlpVarTitle;

  /// Variations params
  ///
  /// In es, this message translates to:
  /// **'2 params: n → V(n,k) → k → ='**
  String get hlpVarParams;

  /// Variations description
  ///
  /// In es, this message translates to:
  /// **'Formas de elegir k de n CON orden.'**
  String get hlpVarDesc;

  /// Variations formula
  ///
  /// In es, this message translates to:
  /// **'V(n,k) = n! / (n−k)!'**
  String get hlpVarFormula;

  /// Variations example 1
  ///
  /// In es, this message translates to:
  /// **'V(5,2) = 20'**
  String get hlpVarEx1;

  /// Variations example 2
  ///
  /// In es, this message translates to:
  /// **'V(10,3) = 720'**
  String get hlpVarEx2;

  /// Catalan numbers title
  ///
  /// In es, this message translates to:
  /// **'Cat(n) — Números de Catalan'**
  String get hlpCatalanTitle;

  /// Catalan params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpCatalanParams;

  /// Catalan description
  ///
  /// In es, this message translates to:
  /// **'Cuenta árboles binarios, triangulaciones, caminos de Dyck, paréntesis balanceados.'**
  String get hlpCatalanDesc;

  /// Catalan formula
  ///
  /// In es, this message translates to:
  /// **'Cₙ = C(2n,n)/(n+1)'**
  String get hlpCatalanFormula;

  /// Catalan example 1
  ///
  /// In es, this message translates to:
  /// **'C₀ = 1, C₁ = 1, C₂ = 2'**
  String get hlpCatalanEx1;

  /// Catalan example 2
  ///
  /// In es, this message translates to:
  /// **'C₃ = 5, C₄ = 14, C₅ = 42'**
  String get hlpCatalanEx2;

  /// Derangements title
  ///
  /// In es, this message translates to:
  /// **'D(n) — Derangements (Desarreglos)'**
  String get hlpDerangementTitle;

  /// Derangements params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpDerangementParams;

  /// Derangements description
  ///
  /// In es, this message translates to:
  /// **'Permutaciones donde ningún elemento queda en su posición original.'**
  String get hlpDerangementDesc;

  /// Derangements formula
  ///
  /// In es, this message translates to:
  /// **'D(n) = n! × Σ(−1)^k/k! = (n−1)(D(n−1)+D(n−2))'**
  String get hlpDerangementFormula;

  /// Derangements example 1
  ///
  /// In es, this message translates to:
  /// **'D(3) = 2 → [231, 312]'**
  String get hlpDerangementEx1;

  /// Derangements example 2
  ///
  /// In es, this message translates to:
  /// **'D(4) = 9'**
  String get hlpDerangementEx2;

  /// Derangements example 3
  ///
  /// In es, this message translates to:
  /// **'D(n)/n! → 1/e ≈ 0.3679'**
  String get hlpDerangementEx3;

  /// Bell numbers title
  ///
  /// In es, this message translates to:
  /// **'B(n) — Números de Bell'**
  String get hlpBellTitle;

  /// Bell params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpBellParams;

  /// Bell description
  ///
  /// In es, this message translates to:
  /// **'Número total de particiones de un conjunto de n elementos.'**
  String get hlpBellDesc;

  /// Bell formula
  ///
  /// In es, this message translates to:
  /// **'B(n) = Σ S₂(n,k) para k=0..n'**
  String get hlpBellFormula;

  /// Bell example 1
  ///
  /// In es, this message translates to:
  /// **'B(3) = 5'**
  String get hlpBellEx1;

  /// Bell example 2
  ///
  /// In es, this message translates to:
  /// **'B(4) = 15'**
  String get hlpBellEx2;

  /// Bell example 3
  ///
  /// In es, this message translates to:
  /// **'B(5) = 52'**
  String get hlpBellEx3;

  /// Integer partitions title
  ///
  /// In es, this message translates to:
  /// **'p(n) — Particiones de Enteros'**
  String get hlpPartitionTitle;

  /// Integer partitions params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpPartitionParams;

  /// Integer partitions description
  ///
  /// In es, this message translates to:
  /// **'Formas de escribir n como suma de enteros positivos (orden no importa).'**
  String get hlpPartitionDesc;

  /// Integer partitions formula
  ///
  /// In es, this message translates to:
  /// **'Calculado con programación dinámica'**
  String get hlpPartitionFormula;

  /// Integer partitions example 1
  ///
  /// In es, this message translates to:
  /// **'p(4) = 5 → [4, 3+1, 2+2, 2+1+1, 1+1+1+1]'**
  String get hlpPartitionEx1;

  /// Integer partitions example 2
  ///
  /// In es, this message translates to:
  /// **'p(10) = 42'**
  String get hlpPartitionEx2;

  /// Integer partitions example 3
  ///
  /// In es, this message translates to:
  /// **'p(100) = 190,569,292,356'**
  String get hlpPartitionEx3;

  /// Stirling 2nd kind title
  ///
  /// In es, this message translates to:
  /// **'S₂(n,k) — Stirling 2da Especie'**
  String get hlpStirling2Title;

  /// Stirling 2nd kind params
  ///
  /// In es, this message translates to:
  /// **'2 params: n → S₂ → k → ='**
  String get hlpStirling2Params;

  /// Stirling 2nd kind description
  ///
  /// In es, this message translates to:
  /// **'Formas de particionar n elementos en exactamente k subconjuntos no vacíos.'**
  String get hlpStirling2Desc;

  /// Stirling 2nd kind formula
  ///
  /// In es, this message translates to:
  /// **'S₂(n,k) = k·S₂(n−1,k) + S₂(n−1,k−1)'**
  String get hlpStirling2Formula;

  /// Stirling 2nd kind example 1
  ///
  /// In es, this message translates to:
  /// **'S₂(4,2) = 7'**
  String get hlpStirling2Ex1;

  /// Stirling 2nd kind example 2
  ///
  /// In es, this message translates to:
  /// **'S₂(5,3) = 25'**
  String get hlpStirling2Ex2;

  /// Stirling 2nd kind example 3
  ///
  /// In es, this message translates to:
  /// **'B(n) = Σ S₂(n,k)'**
  String get hlpStirling2Ex3;

  /// Stirling 1st kind title
  ///
  /// In es, this message translates to:
  /// **'s₁(n,k) — Stirling 1ra Especie (sin signo)'**
  String get hlpStirling1Title;

  /// Stirling 1st kind params
  ///
  /// In es, this message translates to:
  /// **'2 params: n → s₁ → k → ='**
  String get hlpStirling1Params;

  /// Stirling 1st kind description
  ///
  /// In es, this message translates to:
  /// **'Permutaciones de n elementos con exactamente k ciclos.'**
  String get hlpStirling1Desc;

  /// Stirling 1st kind formula
  ///
  /// In es, this message translates to:
  /// **'|s₁(n,k)| = (n−1)·|s₁(n−1,k)| + |s₁(n−1,k−1)|'**
  String get hlpStirling1Formula;

  /// Stirling 1st kind example 1
  ///
  /// In es, this message translates to:
  /// **'s₁(4,2) = 11'**
  String get hlpStirling1Ex1;

  /// Stirling 1st kind example 2
  ///
  /// In es, this message translates to:
  /// **'s₁(4,1) = 6'**
  String get hlpStirling1Ex2;

  /// Fibonacci title
  ///
  /// In es, this message translates to:
  /// **'F(n) — n-ésimo Fibonacci'**
  String get hlpFibTitle;

  /// Fibonacci params
  ///
  /// In es, this message translates to:
  /// **'1 param'**
  String get hlpFibParams;

  /// Fibonacci description
  ///
  /// In es, this message translates to:
  /// **'Calcula F(n) con duplicación rápida O(log n). Soporta n muy grandes.'**
  String get hlpFibDesc;

  /// Fibonacci formula
  ///
  /// In es, this message translates to:
  /// **'F(0)=0, F(1)=1, F(n)=F(n−1)+F(n−2)'**
  String get hlpFibFormula;

  /// Fibonacci example 1
  ///
  /// In es, this message translates to:
  /// **'F(10) = 55'**
  String get hlpFibEx1;

  /// Fibonacci example 2
  ///
  /// In es, this message translates to:
  /// **'F(50) = 12,586,269,025'**
  String get hlpFibEx2;

  /// Fibonacci example 3
  ///
  /// In es, this message translates to:
  /// **'F(100) = 354,224,848,179,261,915,075'**
  String get hlpFibEx3;

  /// Fibonacci tip 1
  ///
  /// In es, this message translates to:
  /// **'F(n) mod m es periódico (período de Pisano)'**
  String get hlpFibTip1;

  /// Fibonacci tip 2
  ///
  /// In es, this message translates to:
  /// **'MCD(F(m), F(n)) = F(MCD(m,n))'**
  String get hlpFibTip2;

  /// Digit sum in base b title
  ///
  /// In es, this message translates to:
  /// **'ΣdígB — Suma de Dígitos en Base b'**
  String get hlpDigitSumBaseTitle;

  /// Digit sum in base b params
  ///
  /// In es, this message translates to:
  /// **'2 params: n → ΣdígB → b → ='**
  String get hlpDigitSumBaseParams;

  /// Digit sum in base b description
  ///
  /// In es, this message translates to:
  /// **'Suma los dígitos de n escritos en base b.'**
  String get hlpDigitSumBaseDesc;

  /// Digit sum in base b formula
  ///
  /// In es, this message translates to:
  /// **'Si n = Σ dᵢ × bⁱ, entonces ΣdígB = Σ dᵢ'**
  String get hlpDigitSumBaseFormula;

  /// Digit sum base b example 1
  ///
  /// In es, this message translates to:
  /// **'ΣdígB(255, 2) = 8 → 11111111₂'**
  String get hlpDigitSumBaseEx1;

  /// Digit sum base b example 2
  ///
  /// In es, this message translates to:
  /// **'ΣdígB(100, 10) = 1'**
  String get hlpDigitSumBaseEx2;

  /// Digit sum base b example 3
  ///
  /// In es, this message translates to:
  /// **'ΣdígB(100, 16) = 10 → 64₁₆'**
  String get hlpDigitSumBaseEx3;

  /// Statistics section header
  ///
  /// In es, this message translates to:
  /// **'Estadística'**
  String get hlpStatisticsHeader;

  /// Arithmetic mean title
  ///
  /// In es, this message translates to:
  /// **'Media Aritmética — Med A'**
  String get hlpArithMeanTitle;

  /// Arithmetic mean params
  ///
  /// In es, this message translates to:
  /// **'N params (variable, mín. 2)'**
  String get hlpArithMeanParams;

  /// Arithmetic mean description
  ///
  /// In es, this message translates to:
  /// **'Promedio clásico de N números.'**
  String get hlpArithMeanDesc;

  /// Arithmetic mean formula
  ///
  /// In es, this message translates to:
  /// **'MA = (x₁ + x₂ + ... + xₙ) / n'**
  String get hlpArithMeanFormula;

  /// Arithmetic mean example 1
  ///
  /// In es, this message translates to:
  /// **'MA(3, 7) = 5'**
  String get hlpArithMeanEx1;

  /// Arithmetic mean example 2
  ///
  /// In es, this message translates to:
  /// **'MA(2, 4, 6) = 4'**
  String get hlpArithMeanEx2;

  /// Arithmetic mean tip 1
  ///
  /// In es, this message translates to:
  /// **'Flujo: 3 → Med A → 7 → Med A (ejecuta)'**
  String get hlpArithMeanTip1;

  /// Arithmetic mean tip 2
  ///
  /// In es, this message translates to:
  /// **'Para 3+ nums: 2 → Med A → 4 → = → 6 → Med A'**
  String get hlpArithMeanTip2;

  /// Geometric mean title
  ///
  /// In es, this message translates to:
  /// **'Media Geométrica — Med G'**
  String get hlpGeoMeanTitle;

  /// Geometric mean params
  ///
  /// In es, this message translates to:
  /// **'N params (variable, mín. 2)'**
  String get hlpGeoMeanParams;

  /// Geometric mean description
  ///
  /// In es, this message translates to:
  /// **'Raíz n-ésima del producto. Solo valores positivos.'**
  String get hlpGeoMeanDesc;

  /// Geometric mean formula
  ///
  /// In es, this message translates to:
  /// **'MG = (x₁ × x₂ × ... × xₙ)^(1/n)'**
  String get hlpGeoMeanFormula;

  /// Geometric mean example 1
  ///
  /// In es, this message translates to:
  /// **'MG(2, 8) = 4'**
  String get hlpGeoMeanEx1;

  /// Geometric mean example 2
  ///
  /// In es, this message translates to:
  /// **'MG(1, 4, 9) ≈ 3.30'**
  String get hlpGeoMeanEx2;

  /// Harmonic mean title
  ///
  /// In es, this message translates to:
  /// **'Media Armónica — Med H'**
  String get hlpHarmMeanTitle;

  /// Harmonic mean params
  ///
  /// In es, this message translates to:
  /// **'N params (variable, mín. 2)'**
  String get hlpHarmMeanParams;

  /// Harmonic mean description
  ///
  /// In es, this message translates to:
  /// **'Inverso de la media aritmética de los inversos. Solo valores positivos.'**
  String get hlpHarmMeanDesc;

  /// Harmonic mean formula
  ///
  /// In es, this message translates to:
  /// **'MH = n / (1/x₁ + 1/x₂ + ... + 1/xₙ)'**
  String get hlpHarmMeanFormula;

  /// Harmonic mean example 1
  ///
  /// In es, this message translates to:
  /// **'MH(2, 8) = 3.2'**
  String get hlpHarmMeanEx1;

  /// Harmonic mean example 2
  ///
  /// In es, this message translates to:
  /// **'MH(1, 4, 9) ≈ 2.08'**
  String get hlpHarmMeanEx2;

  /// Quadratic mean title
  ///
  /// In es, this message translates to:
  /// **'Media Cuadrática — Med C'**
  String get hlpQuadMeanTitle;

  /// Quadratic mean params
  ///
  /// In es, this message translates to:
  /// **'N params (variable, mín. 2)'**
  String get hlpQuadMeanParams;

  /// Quadratic mean description
  ///
  /// In es, this message translates to:
  /// **'Raíz de la media de los cuadrados (RMS).'**
  String get hlpQuadMeanDesc;

  /// Quadratic mean formula
  ///
  /// In es, this message translates to:
  /// **'MC = √((x₁² + x₂² + ... + xₙ²) / n)'**
  String get hlpQuadMeanFormula;

  /// Quadratic mean example 1
  ///
  /// In es, this message translates to:
  /// **'MC(3, 4) ≈ 3.54'**
  String get hlpQuadMeanEx1;

  /// Quadratic mean example 2
  ///
  /// In es, this message translates to:
  /// **'MC(1, 2, 3) ≈ 2.16'**
  String get hlpQuadMeanEx2;

  /// Min/max title
  ///
  /// In es, this message translates to:
  /// **'min / max — Mínimo y Máximo'**
  String get hlpMinMaxTitle;

  /// Min/max params
  ///
  /// In es, this message translates to:
  /// **'N params (variable, mín. 2)'**
  String get hlpMinMaxParams;

  /// Min/max description
  ///
  /// In es, this message translates to:
  /// **'Encuentra el menor/mayor valor de un conjunto de N números.'**
  String get hlpMinMaxDesc;

  /// Min/max formula
  ///
  /// In es, this message translates to:
  /// **'min(a₁,...,aₙ) y max(a₁,...,aₙ)'**
  String get hlpMinMaxFormula;

  /// Min/max example 1
  ///
  /// In es, this message translates to:
  /// **'min(3, 7, 1) = 1'**
  String get hlpMinMaxEx1;

  /// Min/max example 2
  ///
  /// In es, this message translates to:
  /// **'max(3, 7, 1) = 7'**
  String get hlpMinMaxEx2;

  /// Min/max tip 1
  ///
  /// In es, this message translates to:
  /// **'Mismo flujo variable: presiona min/max otra vez para ejecutar'**
  String get hlpMinMaxTip1;

  /// Mean inequality info card title
  ///
  /// In es, this message translates to:
  /// **'Desigualdad de Medias (AM-GM-HM)'**
  String get hlpMeanInequalityTitle;

  /// Mean inequality info card content
  ///
  /// In es, this message translates to:
  /// **'Para números positivos siempre se cumple:\n\nMH ≤ MG ≤ MA ≤ MC\n\nLa igualdad se da solo cuando todos los valores son iguales.\nEsta desigualdad es fundamental en olimpiadas.'**
  String get hlpMeanInequalityContent;

  /// Analysis panel section header
  ///
  /// In es, this message translates to:
  /// **'Panel de Análisis Numérico'**
  String get hlpAnalysisPanelHeader;

  /// Auto analysis info card title
  ///
  /// In es, this message translates to:
  /// **'Análisis Automático'**
  String get hlpAutoAnalysisTitle;

  /// Auto analysis info card content
  ///
  /// In es, this message translates to:
  /// **'Al ingresar cualquier número, el panel derecho (tablet) o inferior (móvil) muestra automáticamente:\n\n• Propiedades: dígitos, paridad, signo\n• Representaciones: binario, octal, hexadecimal\n• Primalidad: test Miller-Rabin, factorización completa\n• Primos vecinos: anterior y siguiente\n• Divisores: lista completa, suma, cantidad\n• Clasificaciones: cuadrado/cubo perfecto, potencia perfecta, Fibonacci, triangular, palíndromo\n\nPara números ≤ 15 dígitos, también muestra:\n\n• Funciones aritméticas: φ, λ, μ, ω, Ω, sopfr, sopf, rad, dr\n• Clasificaciones: libre de cuadrados, poderoso, Harshad, semiprimo, abundante/deficiente/perfecto'**
  String get hlpAutoAnalysisContent;

  /// Olympiad formulas section header
  ///
  /// In es, this message translates to:
  /// **'Fórmulas Clave para Olimpiadas'**
  String get hlpOlympiadHeader;

  /// Fundamental identities info card title
  ///
  /// In es, this message translates to:
  /// **'Identidades Fundamentales'**
  String get hlpIdentitiesTitle;

  /// Fundamental identities info card content
  ///
  /// In es, this message translates to:
  /// **'• Teorema de Euler: a^φ(n) ≡ 1 (mod n) si MCD(a,n)=1\n• Pequeño Fermat: a^(p−1) ≡ 1 (mod p) si p primo\n• Wilson: (p−1)! ≡ −1 (mod p) ⟺ p es primo\n• Fórmula de Legendre: Vₚ(n!) = Σᵢ ⌊n/pⁱ⌋\n• Lucas: C(n,k) mod p = ∏ C(nᵢ,kᵢ) mod p\n• Σ φ(d) para d|n = n\n• Σ μ(d) para d|n = [n=1]\n• φ(mn) = φ(m)φ(n)·MCD(m,n)/φ(MCD(m,n))\n• MCD(F(m),F(n)) = F(MCD(m,n))\n• AM ≥ GM ≥ HM (desigualdad de medias)'**
  String get hlpIdentitiesContent;

  /// Reference table info card title
  ///
  /// In es, this message translates to:
  /// **'Tabla de Referencia Rápida'**
  String get hlpRefTableTitle;

  /// Reference table info card content
  ///
  /// In es, this message translates to:
  /// **'n    φ(n)  λ(n)  μ(n)  σ(n)  ω  Ω\n1    1     1     1     1     0  0\n6    2     2     1     12    2  2\n12   4     2     0     28    2  3\n30   8     4     −1    72    3  3\n60   16    4     0     168   3  4\n100  40    20    0     217   2  4'**
  String get hlpRefTableContent;

  /// Examples label in collapsible sections
  ///
  /// In es, this message translates to:
  /// **'Ejemplos:'**
  String get hlpExamplesLabel;

  /// Tips label in collapsible sections
  ///
  /// In es, this message translates to:
  /// **'Tips:'**
  String get hlpTipsLabel;

  /// Error when expression is empty
  ///
  /// In es, this message translates to:
  /// **'Error: Expresión vacía'**
  String get errExprEmpty;

  /// Error when expression is malformed
  ///
  /// In es, this message translates to:
  /// **'Error: Expresión malformada'**
  String get errExprMalformed;

  /// Error division by zero in expression
  ///
  /// In es, this message translates to:
  /// **'Error: División por cero'**
  String get errExprDivZero;

  /// Error when result is NaN or Infinite
  ///
  /// In es, this message translates to:
  /// **'Error: Resultado no válido'**
  String get errResultInvalid;

  /// Power/operation result would have too many digits
  ///
  /// In es, this message translates to:
  /// **'El resultado es demasiado grande para calcularse exactamente'**
  String get errResultTooLarge;

  /// Error when number is invalid for analysis
  ///
  /// In es, this message translates to:
  /// **'Error: número inválido para análisis'**
  String get errAnalysisInvalid;

  /// Error when analysis fails
  ///
  /// In es, this message translates to:
  /// **'No se puede analizar el número'**
  String get errAnalysisFail;

  /// No solution exists for the equation
  ///
  /// In es, this message translates to:
  /// **'Sin solución'**
  String get errNoSolution;

  /// CRT system is incompatible
  ///
  /// In es, this message translates to:
  /// **'Sistema incompatible'**
  String get errIncompatibleSystem;

  /// CRT requires pairs of values
  ///
  /// In es, this message translates to:
  /// **'TCR necesita pares (aᵢ, mᵢ)'**
  String get errCRTNeedPairs;

  /// Unknown operation error
  ///
  /// In es, this message translates to:
  /// **'Operación desconocida: {op}'**
  String errUnknownOp(String op);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
