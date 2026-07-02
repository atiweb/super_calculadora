import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show LicenseRegistry, LicenseEntryWithLineBreaks;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/calculator_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'screens/special_functions_help_screen.dart';
import 'screens/olympiad/olympiad_tools_screen.dart';
import 'services/calculator_service.dart';
import 'services/settings_service.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Android 15 (SDK 35) fuerza la vista de extremo a extremo. Activamos el
  // modo edge-to-edge de forma explícita con la API vigente (no obsoleta).
  // No fijamos statusBarColor/systemNavigationBarColor: en SDK 35 esos
  // colores se ignoran y, al asignarlos, Flutter llamaría a las APIs
  // obsoletas que reporta Google Play. El contenido respeta los insets vía
  // SafeArea en las pantallas.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // La app está diseñada para retrato (teclados densos). Bloqueamos la
  // orientación para evitar desbordes de layout en horizontal.
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Atribución del paquete vendorizado `computable_reals` (Apache-2.0 + SGI +
  // HP): registramos su licencia para que aparezca en showLicensePage, ya que
  // al estar vendorizado Flutter no la agrega automáticamente.
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('lib/vendor/computable_reals/LICENSE');
    yield LicenseEntryWithLineBreaks(
        const ['computable_reals (vendored)'], license);
  });

  await SettingsService.init();
  runApp(const SuperCalculadoraApp());
}

class SuperCalculadoraApp extends StatelessWidget {
  const SuperCalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CalculatorService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()..init()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Super Calculadora',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            // null → follow device locale; non-null → user override from Settings
            locale: themeProvider.locale,
            localeListResolutionCallback: (deviceLocales, supportedLocales) {
              for (final device in deviceLocales ?? const <Locale>[]) {
                for (final supported in supportedLocales) {
                  if (supported.languageCode == device.languageCode) return supported;
                }
              }
              return const Locale('en');
            },
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
              cardTheme: const CardThemeData(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
              cardTheme: const CardThemeData(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            themeMode: themeProvider.flutterThemeMode,
            home: const CalculatorScreen(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
              '/history': (context) => const HistoryScreen(),
              '/special-help': (context) => const SpecialFunctionsHelpScreen(),
              '/olympiad': (context) => const OlympiadToolsScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
