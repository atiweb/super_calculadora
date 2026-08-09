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

/// Symbols of the special-function keys whose spelling changes with the
/// language.
///
/// Each of them shows up in four places — the key itself, the pending
/// operation indicator, the history label and the in-app guide — and they
/// used to be spelled out at every one of them. The keypad and the guide had
/// already drifted apart: they carried a two-language `es ? 'MCD' : 'GCD'`,
/// so a French or Italian user read PGCD/MCD in the guide and GCD on the key.
/// Defining them once is what keeps the four in step.
String get symGcd => trLocale('MCD', 'GCD', pt: 'MDC', fr: 'PGCD', it: 'MCD');
String get symLcm => trLocale('MCM', 'LCM', pt: 'MMC', fr: 'PPCM', it: 'mcm');
String get symDioph => trLocale('Diof', 'Dioph', pt: 'Diof', fr: 'Dioph', it: 'Dioph');
String get symCrt => trLocale('TCR', 'CRT', pt: 'TCR', fr: 'TRC', it: 'TCR');
String get symDigitSumBase =>
    trLocale('ΣdígB', 'ΣdigB', pt: 'ΣdígB', fr: 'ΣchifB', it: 'ΣcifB');

/// The four mean keys, for the same reason. They were hard-coded as
/// `Med A … Med C` for every language while the guide already called them
/// `Moy A … Moy Q` in French and `Méd A … Méd Q` in Portuguese, so the key
/// and the instructions for pressing it disagreed. The spelling below is the
/// one each guide already uses; the keypad splits the space into a line break.
String get symMeanA => trLocale('Med A', 'Med A', pt: 'Méd A', fr: 'Moy A', it: 'Med A');
String get symMeanG => trLocale('Med G', 'Med G', pt: 'Méd G', fr: 'Moy G', it: 'Med G');
String get symMeanH => trLocale('Med H', 'Med H', pt: 'Méd H', fr: 'Moy H', it: 'Med H');
String get symMeanQ => trLocale('Med C', 'Med C', pt: 'Méd Q', fr: 'Moy Q', it: 'Med Q');
