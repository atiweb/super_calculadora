/// UI-language flag for the service layer, which has no [BuildContext].
///
/// Services (e.g. `NumberAnalysisService`, `CalculatorService`) compute
/// fallback/status strings (for very large numbers or errors) at input time,
/// before any widget rebuilds. They cannot reach `AppLocalizations`, so the
/// widget tree publishes the current UI language here — see
/// `CalculatorScreen.build`, which sets it from `Localizations.localeOf`.
///
/// Defaults to English (Spanish off) so headless/unit contexts are language-
/// stable.
bool appIsSpanish = false;

/// Returns [es] when the UI language is Spanish, otherwise [en].
String trLocale(String es, String en) => appIsSpanish ? es : en;
