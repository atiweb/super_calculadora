# Architecture — Super Calculadora

## Overview

Super Calculadora is a Flutter application for Android. All computation runs on-device; there is no network access, no backend, and no analytics. Persistent state is limited to SharedPreferences.

---

## State Management

The app uses the `provider` package with two `ChangeNotifier` classes registered at the root:

| Provider | Responsibility |
|---|---|
| `CalculatorService` | Calculator state: display value, pending operations, history, analysis results, error state |
| `ThemeProvider` | Theme selection, locale override, scientific notation toggle |

Both providers are created in `main.dart` via `MultiProvider` and are available to the entire widget tree.

---

## Layer Structure

```
lib/
├── main.dart                        # App entry point, providers, routes, localization
├── constants/
│   └── numeric_precision.dart       # Shared precision constant (15 decimal places)
├── models/                          # Pure data classes, no logic
│   ├── calculator_config.dart       # CalculatorType enum (standard, scientific, special)
│   ├── operation_entry.dart         # History entry: expression + result + timestamp
│   ├── pending_operation.dart       # Generic N-parameter pending operation
│   ├── button_type.dart             # Button type enum
│   ├── theme_mode.dart              # App theme enum
│   ├── fraction.dart                # Exact rational p/q (arbitrary precision)
│   ├── surd.dart                    # Simplified radical coefficient·√radicand
│   ├── point.dart                   # 2D point with rational coordinates
│   ├── polynomial.dart              # Polynomial with rational coefficients
│   ├── complex.dart                 # Complex number (De Moivre, roots of unity)
│   └── step_result.dart            # Result + human-readable steps
├── services/                        # Business logic, all static or ChangeNotifier
│   ├── calculator_service.dart      # Main engine (see below)
│   ├── big_decimal.dart             # Custom arbitrary-precision type
│   ├── number_analysis_service.dart # Real-time number analysis
│   ├── special_functions_service.dart # Number theory functions
│   ├── prime_utils.dart             # Miller-Rabin + isolate-based prime search
│   ├── history_service.dart         # SharedPreferences persistence for history
│   ├── settings_service.dart        # SharedPreferences persistence for settings
│   ├── surd_service.dart            # Radical simplification / rationalization
│   ├── geometry_service.dart        # Heron, triangle classification, triples, shoelace
│   ├── polynomial_service.dart      # Parse, gcd, Vieta, discriminant, roots
│   ├── number_theory_advanced_service.dart # Tonelli-Shanks, Pell, CF, sums of squares…
│   ├── combinatorics_extra_service.dart # Pascal rows, multinomials
│   ├── sequence_service.dart        # Linear recurrence generator
│   └── steps_service.dart          # Worked-steps Euclid / CRT / factorization
├── providers/
│   └── theme_provider.dart          # ThemeProvider ChangeNotifier
├── screens/
│   ├── calculator_screen.dart       # Main 3-tab screen
│   ├── history_screen.dart          # Full history list
│   ├── settings_screen.dart         # Theme / locale / notation settings
│   ├── help_screen.dart             # General help
│   ├── special_functions_help_screen.dart
│   └── olympiad/                    # Olympiad Tools subsystem (see below)
│       ├── olympiad_tools_screen.dart   # Hub: a card per category
│       ├── olympiad_tool_screens.dart   # The 7 category screens
│       ├── calc_tool.dart               # Reusable input-form/result widget
│       └── olympiad_strings.dart        # Co-located ES/EN strings
├── widgets/                         # Stateless/stateful UI components
│   ├── calculator_display.dart      # Display with copy/paste and large-number handling
│   ├── calculator_keyboard.dart     # Standard keypad
│   ├── scientific_calculator_keyboard.dart
│   ├── special_calculator_keyboard.dart
│   ├── number_analysis_panel.dart   # Live analysis sidebar
│   ├── expression_input.dart        # Free-text expression entry
│   ├── history_panel.dart           # Inline history widget
│   └── calculator_drawer.dart       # Navigation drawer
├── utils/
│   └── error_localizer.dart         # Maps error keys to localized strings
└── l10n/                            # Localizations (English + Spanish)
    ├── app_localizations.dart
    ├── app_localizations_en.dart
    └── app_localizations_es.dart
```

---

## Key Services

### `CalculatorService`

The central `ChangeNotifier`. It owns the display string, pending operation, memory registers, history list, and the current number analysis result. It delegates:

- Arithmetic → `BigDecimal`
- Expression parsing → `math_expressions` package
- Special functions → `SpecialFunctionsService`
- Number analysis → `NumberAnalysisService`
- History reads/writes → `HistoryService`

### `BigDecimal`

A custom arbitrary-precision type implemented as two `BigInt` values (integer part + fractional part) with a fixed scale of up to 20 decimal places. It exists because Dart's built-in `double` loses precision for integers beyond 2⁵³ and there is no standard `Decimal` type in the SDK. All arithmetic operations in standard and scientific modes go through this class.

### `NumberAnalysisService`

Static methods that compute the full analysis panel for a given number: primality, prime factorization, divisors, Euler φ, Carmichael λ, Möbius μ, ω, Ω, sopf, sopfr, radical, number classifications (perfect, abundant, squarefree, Harshad, …), and base representations (binary, octal, hex).

Analysis is triggered on every display change in `CalculatorService`.

### `SpecialFunctionsService`

Static methods for the 100+ functions accessible from the Special tab: all number theory functions, combinatorics (factorial, double factorial, C(n,k), V(n,k), Stirling, Bell, Catalan, derangements, partitions), modular arithmetic (modular exponentiation, modular inverse, multiplicative order, primitive roots, Legendre/Jacobi symbols, CRT, linear Diophantine equations), and sequences (Fibonacci, triangular numbers, …).

### `prime_utils.dart`

Miller-Rabin primality test using deterministic bases `[2, 3, 5, 7]`, which gives a correct result for all n < 3.2 × 10¹⁸. For searching next/previous primes on numbers with more than 15 digits, the search loop runs in a Dart `Isolate` to avoid blocking the UI thread.

---

## Olympiad Tools subsystem

A separate feature aimed at IMO (olympiad) training, reachable from the navigation drawer (`/olympiad` route). It deliberately does **not** touch `CalculatorService` or its pending-operation system, which keeps it isolated and low-risk.

### Exact-arithmetic foundation

Olympiad math is exact, never decimal. Two value types underpin the feature:

- **`Fraction`** — an arbitrary-precision rational `p/q` in canonical form (positive denominator, reduced by GCD). All sign handling lives here, so downstream code never juggles signs.
- **`Surd`** — a simplified quadratic radical `coefficient · √radicand` with a `Fraction` coefficient and a squarefree radicand (√72 → 6√2).

`Polynomial` (rational coefficients) and `Point` (rational coordinates) build on `Fraction` so polynomial roots and shoelace areas stay exact. `Complex` uses `double` because roots of unity / De Moivre are inherently transcendental.

### Service map

| Service | Provides |
|---|---|
| `SurdService` | √n and ⁿ√n simplification, denominator rationalization |
| `GeometryService` | Heron area (as a `Surd`), triangle classification, circumradius/inradius, law of cosines (exact), shoelace, Pythagorean/Heronian triples |
| `PolynomialService` | parse, gcd, Vieta, discriminant, rational-root theorem, quadratic/cubic solving |
| `NumberTheoryAdvancedService` | Tonelli-Shanks, linear congruences, Lucas' theorem, continued fractions, Pell, sums of two/four squares, Frobenius, discrete log |
| `CombinatoricsExtraService` | Pascal triangle rows, multinomial coefficients |
| `SequenceService` | linear-recurrence term generation (exact rationals) |
| `StepsService` | worked-step Euclid, CRT and factorization (`StepResult`) |

### UI

The hub (`OlympiadToolsScreen`) lists one card per category; each opens a category screen (`olympiad_tool_screens.dart`) that is just a `ListView` of `CalcTool` widgets. `CalcTool` is a reusable form: a title, text fields, a Compute button, and a result/error box. Each tool supplies a `compute(List<String>) → String` callback that calls into the services; thrown exceptions are caught and shown as errors. Adding a tool is a few lines of configuration — no new widget code.

Strings for this subsystem live in `olympiad_strings.dart` (a small ES/EN helper keyed off the active locale) rather than the shared `.arb` files, keeping the feature self-contained.

---

## Persistence

All persistence uses `SharedPreferences` (no SQLite, no files):

| Key | Type | Service |
|---|---|---|
| Calculation history (up to 100 entries) | JSON list | `HistoryService` |
| Theme selection | String | `SettingsService` |
| Locale override | String | `SettingsService` |
| Scientific notation toggle | bool | `SettingsService` |

Data is scoped to the app sandbox and deleted on uninstall.

---

## Localization

The app ships with English and Spanish translations in `lib/l10n/`. The locale is resolved at startup: device locale is matched against supported locales (`en`, `es`), defaulting to `en`. The user can override the locale from Settings, in which case `ThemeProvider.locale` is set to a non-null value and passed to `MaterialApp`.

---

## Concurrency

Dart is single-threaded by default. Heavy operations that could block the UI run in a separate `Isolate`:

- **Next/previous prime search** for numbers larger than 10¹⁵ (`prime_utils.dart`)

Shorter operations (factorization, divisor lists, analysis panel updates) run on the main isolate because they are fast enough not to cause jank for the number ranges the app targets.

---

## Adding a New Special Function

1. Implement the logic as a static method in `SpecialFunctionsService`.
2. Add the button to `SpecialCalculatorKeyboard` and wire it to `CalculatorService`.
3. Add localized strings for the button label and any error messages to both `app_localizations_en.dart` and `app_localizations_es.dart`.
4. If the function is slow for large inputs, move the computation to an `Isolate` following the pattern in `prime_utils.dart`.

## Adding a New Olympiad Tool

1. Implement the logic as a static method in the relevant service (or add a new service) using `Fraction`/`Surd` for exact results.
2. Add a `CalcTool(...)` entry to the appropriate category screen in `olympiad_tool_screens.dart`, whose `compute` callback parses the input strings and calls your method.
3. Add any new ES/EN labels to `olympiad_strings.dart` (or pass `s.pick('es', 'en')` inline).
4. Add tests for the logic; widget tests for the tool are optional.
