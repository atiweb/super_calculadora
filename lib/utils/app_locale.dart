/// UI-language plumbing for code that has no [BuildContext].
///
/// Most of the app is translated through the generated `AppLocalizations`
/// (see `lib/l10n/*.arb`). Two areas cannot use it:
///
///  * services (`NumberAnalysisService`, `CalculatorService`, …) compute
///    fallback and status strings at input time, before any widget rebuilds,
///    and some of them run inside an `Isolate`;
///  * the Olympiad Tools keep their strings co-located with the tools.
///
/// Both go through [trLang], so there is a single place that decides what
/// happens when a language is missing: it falls back to English rather than
/// showing an empty string. That is what lets a new language ship one piece
/// at a time — an untranslated tool reads in English instead of breaking.
library;

/// Text for [lang], falling back to English when that language has no
/// translation yet.
///
/// To add a language: give it an optional parameter here and at the two
/// call-site helpers (`OlympiadStrings.pick`, `StepsService`/`QuizService`),
/// then fill it in at the call sites, gradually if needed.
///
/// The switch is deliberate: this runs for every string on every rebuild, so
/// it must not allocate a lookup map on each call.
String trLang(String lang, String spanish, String english,
    {String? pt, String? fr, String? it, String? ru, String? vi, String? id}) {
  switch (lang) {
    case 'es':
      return spanish;
    case 'pt':
      return pt ?? english;
    case 'fr':
      return fr ?? english;
    case 'it':
      return it ?? english;
    case 'ru':
      return ru ?? english;
    case 'vi':
      return vi ?? english;
    case 'id':
      return id ?? english;
    default:
      return english;
  }
}

/// Active UI language code ('en', 'es', 'pt', …), published by the widget
/// tree — see `CalculatorScreen.build`, which sets it from
/// `Localizations.localeOf`.
///
/// Defaults to English so headless and unit contexts are language-stable.
String appLanguage = 'en';

/// [trLang] for the active UI language.
String trLocale(String es, String en, {String? pt, String? fr, String? it, String? ru, String? vi,
          String? id}) =>
    trLang(appLanguage, es, en, pt: pt, fr: fr, it: it, ru: ru, vi: vi, id: id);
