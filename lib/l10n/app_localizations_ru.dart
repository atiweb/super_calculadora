// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Супер Калькулятор';

  @override
  String get appVersion => 'Версия 1.2.1';

  @override
  String get appDeveloped => 'Разработано на Flutter';

  @override
  String get appDynamicThemes => 'С поддержкой динамических тем';

  @override
  String get navStandard => 'Стандартный';

  @override
  String get navStandardSub => 'Основные операции';

  @override
  String get navScientific => 'Инженерный';

  @override
  String get navScientificSub => 'Расширенные функции';

  @override
  String get navSpecial => 'Специальные функции';

  @override
  String get navSpecialSub => 'Теория чисел';

  @override
  String get navHistory => 'История';

  @override
  String get navHistorySub => 'Посмотреть предыдущие операции';

  @override
  String get navSettings => 'Настройки';

  @override
  String get navSettingsSub => 'Настройки приложения';

  @override
  String get navHelp => 'Справка';

  @override
  String get navHelpSub => 'Руководство по специальным функциям';

  @override
  String get navAbout => 'О приложении';

  @override
  String get navAboutSub => 'Супер Калькулятор v1.2.1';

  @override
  String get navCalculator => 'Калькулятор';

  @override
  String get navSelectType => 'Выберите режим';

  @override
  String navAngleMode(String mode) {
    return 'Режим: $mode';
  }

  @override
  String get navRadians => 'Радианы';

  @override
  String get navDegrees => 'Градусы';

  @override
  String get calcAnalysis => 'Анализ';

  @override
  String get calcExpressions => 'Выражения';

  @override
  String get calcScientific => 'Инженерный калькулятор';

  @override
  String get calcSpecialFunctions => 'Специальные функции';

  @override
  String get calcSuperCalculator => 'Супер Калькулятор';

  @override
  String get calcNumericAnalysis => 'Числовой анализ';

  @override
  String get calcMathExpressions => 'Математические выражения';

  @override
  String get calcResult => 'Результат:';

  @override
  String get calcProcessing => 'Обработка больших чисел…';

  @override
  String get calcHighPrecision => 'Вычисление (высокая точность)…';

  @override
  String get calcCancel => 'Отмена';

  @override
  String get displayPaste => 'Вставить';

  @override
  String get displayCopy => 'Копировать';

  @override
  String displayCopied(String text) {
    return 'Скопировано: $text';
  }

  @override
  String get displayCopyResult => 'Копировать результат';

  @override
  String get displayPasteNumber => 'Вставить число';

  @override
  String get displayClearDisplay => 'Очистить дисплей';

  @override
  String get displayInvalidNumber =>
      'Ошибка: вставленный текст не является числом';

  @override
  String get displayNothingToPaste => 'Нечего вставлять';

  @override
  String displayPasteError(String error) {
    return 'Ошибка вставки: $error';
  }

  @override
  String displayPasted(String text) {
    return 'Вставлено: $text';
  }

  @override
  String get histTitle => 'История';

  @override
  String get histClearAll => 'Очистить историю';

  @override
  String get histClearAllTooltip => 'Очистить всю историю';

  @override
  String get histConfirmClear => 'Удалить всю историю?';

  @override
  String histConfirmClearN(String count) {
    return 'Удалить все операции из истории ($count)? Это действие нельзя отменить.';
  }

  @override
  String get histCleared => 'История очищена';

  @override
  String get histDeleted => 'История удалена';

  @override
  String get histOperationDeleted => 'Операция удалена';

  @override
  String get histCopiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String histCopiedClipboardText(String text) {
    return 'Скопировано в буфер обмена: $text';
  }

  @override
  String get histFullResult => 'Полный результат';

  @override
  String get histClose => 'Закрыть';

  @override
  String get histExpression => 'Выражение:';

  @override
  String get histResult => 'Результат:';

  @override
  String get histCopyResult => 'Копировать результат';

  @override
  String get histCopyAll => 'Копировать всё';

  @override
  String get histCopyExpression => 'Копировать выражение';

  @override
  String get histUseResult => 'Использовать результат';

  @override
  String get histViewResult => 'Показать результат';

  @override
  String get histDelete => 'Удалить';

  @override
  String get histEmpty => 'В истории нет операций';

  @override
  String get histEmptyHint =>
      'Выполните несколько вычислений, чтобы увидеть здесь историю';

  @override
  String get histEmptyHintAlt => 'Выполненные операции появятся здесь';

  @override
  String get histOperations => 'операций';

  @override
  String get histNow => 'Сейчас';

  @override
  String histErrorLoading(String error) {
    return 'Ошибка загрузки истории: $error';
  }

  @override
  String histErrorClearing(String error) {
    return 'Ошибка очистки истории: $error';
  }

  @override
  String histErrorDeleting(String error) {
    return 'Ошибка удаления операции: $error';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsNumberFormat => 'Формат чисел';

  @override
  String get settingsScientificNotation => 'Использовать научную запись';

  @override
  String get settingsScientificHint =>
      'Если выключено, числа показываются целиком (напр. 123000)';

  @override
  String get settingsHighPrecision => 'Режим высокой точности';

  @override
  String get settingsHighPrecisionHint =>
      'Вычисляет sin, cos, tan, ln, √… через точные конструктивные вещественные числа (медленнее). Особые точки, например tan 90°, помечаются как неопределённые.';

  @override
  String settingsPrecisionDigits(int digits) {
    return 'Знаков точности: $digits';
  }

  @override
  String get settingsOpenSourceLicenses => 'Лицензии открытого кода';

  @override
  String get settingsFormatExamples => 'Примеры формата';

  @override
  String get settingsLargeNumber => 'Большое число:';

  @override
  String get settingsSmallNumber => 'Маленькое число:';

  @override
  String get settingsNormal => 'Обычная:';

  @override
  String get settingsScientific => 'Научная:';

  @override
  String get settingsAboutApp => 'О приложении';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeAuto => 'Автоматически';

  @override
  String get themeLightDesc => 'Всегда использовать светлую тему';

  @override
  String get themeDarkDesc => 'Всегда использовать тёмную тему';

  @override
  String get themeAutoDesc => 'Следовать настройкам системы';

  @override
  String get aboutTitle => 'Супер Калькулятор';

  @override
  String get aboutDescription =>
      'Продвинутый калькулятор с инженерными возможностями и полным числовым анализом.';

  @override
  String get aboutFeatures => 'Возможности:';

  @override
  String get aboutClose => 'Закрыть';

  @override
  String get aboutFeature1 => 'Числа до 1024 бит';

  @override
  String get aboutFeature2 => '64-битная десятичная точность';

  @override
  String get aboutFeature3 => 'Стандартный и инженерный режимы калькулятора';

  @override
  String get aboutFeature4 => 'Тригонометрические функции (sin, cos, tan)';

  @override
  String get aboutFeature5 =>
      'Обратные тригонометрические функции (asin, acos, atan)';

  @override
  String get aboutFeature6 => 'Натуральный (ln) и десятичный (log) логарифмы';

  @override
  String get aboutFeature7 => 'Показательные функции (eˣ, 10ˣ)';

  @override
  String get aboutFeature8 => 'Вычисление факториала (n!)';

  @override
  String get aboutFeature9 => 'Математические константы (π, e)';

  @override
  String get aboutFeature10 => 'Степени и корни (x², x³, √, ∛)';

  @override
  String get aboutFeature11 => 'Перевод градусов в радианы и обратно';

  @override
  String get aboutFeature12 => 'Анализ простых чисел';

  @override
  String get aboutFeature13 => 'Разложение на простые множители';

  @override
  String get aboutFeature14 => 'Двоичное и десятичное представление';

  @override
  String get aboutFeature15 => 'Анализ математических свойств';

  @override
  String get aboutFeature16 => 'Операции с чрезвычайно большими числами';

  @override
  String get aboutFeature17 =>
      'Тяжёлые вычисления в отдельных потоках (isolate)';

  @override
  String get aboutFeature18 => 'Обработка ошибок области определения и размера';

  @override
  String get aboutFeature19 =>
      'Олимпиадные инструменты: 11 точных разделов (дроби, радикалы, геометрия, многочлены, алгебра, теория чисел, матрицы…)';

  @override
  String get aboutFeature20 =>
      'Символьная алгебра: раскрытие скобок и тождества от нескольких переменных';

  @override
  String get exprMathExpression => 'Математическое выражение';

  @override
  String get exprHideHistory => 'Скрыть историю';

  @override
  String get exprShowHistory => 'Показать историю';

  @override
  String get exprClearExpression => 'Очистить выражение';

  @override
  String get exprHint => 'Напр.: (5 + 3) * sqrt(9) - 2^3';

  @override
  String get exprDelete => 'Стереть';

  @override
  String get exprEvaluate => 'Вычислить (Enter)';

  @override
  String get exprParenthesis => 'Скобки';

  @override
  String get exprSquareRoot => 'Квадратный корень';

  @override
  String get exprPower => 'Степень';

  @override
  String get exprSin => 'Синус';

  @override
  String get exprCos => 'Косинус';

  @override
  String get exprTan => 'Тангенс';

  @override
  String get exprLog => 'Логарифм';

  @override
  String get exprLn => 'Натуральный логарифм';

  @override
  String get exprPi => 'Pi';

  @override
  String get exprEuler => 'Euler';

  @override
  String get analysisEnterNumber => 'Введите число, чтобы увидеть его анализ';

  @override
  String get analysisLoading => 'Анализ числа…';

  @override
  String get analysisLoadingHint =>
      'Для больших чисел это может занять некоторое время';

  @override
  String get analysisLimited => 'Ограниченный анализ';

  @override
  String get analysisExtremelyLarge => 'Чрезвычайно большое число';

  @override
  String analysisDigitsCount(String count) {
    return 'Цифр: $count';
  }

  @override
  String get analysisPrimalityNote => 'Примечание о проверке простоты';

  @override
  String analysisOriginalInput(String original, String analyzed) {
    return 'Исходный ввод: $original → Проанализировано: $analyzed';
  }

  @override
  String get analysisCalculatingPrimes => 'Вычисление простых чисел…';

  @override
  String get analysisSearchingPrimes =>
      'Поиск предыдущего и следующего простого';

  @override
  String get analysisBasicProperties => 'Основные свойства';

  @override
  String get analysisValue => 'Значение';

  @override
  String get analysisIsPrime => 'Простое';

  @override
  String get analysisDigits => 'Цифры';

  @override
  String get analysisNextPrime => 'Следующее простое';

  @override
  String get analysisPrevPrime => 'Предыдущее простое';

  @override
  String get analysisDigitSum => 'Сумма цифр';

  @override
  String get analysisBinary => 'Двоичное';

  @override
  String get analysisYes => 'Да';

  @override
  String get analysisNo => 'No';

  @override
  String get analysisRepresentations => 'Представления';

  @override
  String get analysisOctal => 'Восьмеричное';

  @override
  String get analysisHex => 'Шестнадцатеричное';

  @override
  String get analysisMathAnalysis => 'Математический анализ';

  @override
  String get analysisIsPerfect => 'Совершенное';

  @override
  String get analysisIsPalindrome => 'Палиндром';

  @override
  String get analysisIsFibonacci => 'Число Фибоначчи';

  @override
  String get analysisIsTriangular => 'Треугольное';

  @override
  String get analysisPrimeFactors => 'Разложение на простые множители';

  @override
  String get analysisPrimeFactorsLabel => 'Простые множители';

  @override
  String get analysisDivisors => 'Делители';

  @override
  String get analysisAllDivisors => 'Все делители';

  @override
  String get analysisDivisorCount => 'Количество делителей';

  @override
  String get analysisArithmeticFunctions => 'Арифметические функции';

  @override
  String get analysisEulerPhi => 'φ(n) Euler';

  @override
  String get analysisCarmichael => 'λ(n) Carmichael';

  @override
  String get analysisMobius => 'μ(n) Möbius';

  @override
  String get analysisSmallOmega => 'ω(n) различных простых';

  @override
  String get analysisBigOmega => 'Ω(n) простых с кратн.';

  @override
  String get analysisSopfr => 'sopfr(n) Σпростых с повт.';

  @override
  String get analysisSopf => 'sopf(n) Σразличных простых';

  @override
  String get analysisRadical => 'rad(n) радикал';

  @override
  String get analysisDigitalRoot => 'Цифровой корень';

  @override
  String get analysisClassification => 'Классификация';

  @override
  String get analysisSquareFree => 'Свободное от квадратов';

  @override
  String get analysisPowerful => 'Мощное';

  @override
  String get analysisHarshad => 'Harshad';

  @override
  String get analysisSemiprime => 'Полупростое';

  @override
  String get analysisAbundant => 'Избыточное';

  @override
  String get analysisDeficient => 'Недостаточное';

  @override
  String get analysisOperations => 'Операции';

  @override
  String get analysisSquare => 'Квадрат';

  @override
  String get analysisCube => 'Куб';

  @override
  String get analysisSquareRootLabel => 'Квадратный корень';

  @override
  String get analysisIsPerfectSquare => 'Точный квадрат';

  @override
  String get analysisCubeRoot => 'Кубический корень';

  @override
  String get analysisIsPerfectCube => 'Точный куб';

  @override
  String get analysisPerfectPower => 'Точная степень';

  @override
  String get analysisExpression => 'Выражение';

  @override
  String get analysisBase => 'Основание';

  @override
  String get analysisExponent => 'Показатель';

  @override
  String get cardPrime => 'Простое';

  @override
  String get cardPerfect => 'Совершенное';

  @override
  String get cardPalindrome => 'Палиндром';

  @override
  String get cardFibonacci => 'Fibonacci';

  @override
  String get cardTriangular => 'Треугольное';

  @override
  String get cardEven => 'Чётное';

  @override
  String get cardOdd => 'Нечётное';

  @override
  String get cardQuickProperties => 'Быстрые свойства:';

  @override
  String get cardConvert => 'Преобразовать:';

  @override
  String get cardToDecimal => 'В десятичное';

  @override
  String get cardToBinary => 'В двоичное';

  @override
  String get cardAdvancedOps => 'Расширенные операции:';

  @override
  String get cardDigits => 'цифр';

  @override
  String get kbdNumberTheory => 'Теория чисел';

  @override
  String get kbdModularArith => 'Модульная арифметика';

  @override
  String get kbdCombinatorics => 'Комбинаторика';

  @override
  String get kbdStatistics => 'Статистика';

  @override
  String errPower(String error) {
    return 'Ошибка возведения в степень: $error';
  }

  @override
  String errSquareRoot(String error) {
    return 'Ошибка квадратного корня: $error';
  }

  @override
  String get errNegativeSqrt =>
      'Нельзя извлечь квадратный корень из отрицательного числа';

  @override
  String errCubeRoot(String error) {
    return 'Ошибка кубического корня: $error';
  }

  @override
  String errBinaryConversion(String error) {
    return 'Ошибка перевода в двоичную систему: $error';
  }

  @override
  String get errEmptyBinary => 'Пустое двоичное число';

  @override
  String get errInvalidBinary =>
      'Число должно содержать только двоичные цифры (0 и 1)';

  @override
  String errBinaryFromConversion(String error) {
    return 'Ошибка перевода из двоичной системы: $error';
  }

  @override
  String get errTrigTooLarge =>
      'Число слишком велико для тригонометрических функций';

  @override
  String errSin(String error) {
    return 'Ошибка синуса: $error';
  }

  @override
  String errCos(String error) {
    return 'Ошибка косинуса: $error';
  }

  @override
  String get errTanUndefined => 'Тангенс не определён для этого угла';

  @override
  String errTan(String error) {
    return 'Ошибка тангенса: $error';
  }

  @override
  String get errAsinDomain =>
      'Арксинус определён только для значений от -1 до 1';

  @override
  String errAsin(String error) {
    return 'Ошибка арксинуса: $error';
  }

  @override
  String get errAcosDomain =>
      'Арккосинус определён только для значений от -1 до 1';

  @override
  String errAcos(String error) {
    return 'Ошибка арккосинуса: $error';
  }

  @override
  String errAtan(String error) {
    return 'Ошибка арктангенса: $error';
  }

  @override
  String get errLnDomain =>
      'Натуральный логарифм определён только для положительных чисел';

  @override
  String get errLnTooLarge => 'Число слишком велико для натурального логарифма';

  @override
  String errLn(String error) {
    return 'Ошибка натурального логарифма: $error';
  }

  @override
  String get errLogDomain =>
      'Логарифм определён только для положительных чисел';

  @override
  String get errLogTooLarge => 'Число слишком велико для десятичного логарифма';

  @override
  String errLog(String error) {
    return 'Ошибка логарифма: $error';
  }

  @override
  String get errExpTooLarge => 'Число слишком велико для экспоненты';

  @override
  String errExp(String error) {
    return 'Ошибка экспоненты: $error';
  }

  @override
  String get errTenPowTooLarge => 'Число слишком велико для 10^x';

  @override
  String errTenPow(String error) {
    return 'Ошибка 10^x: $error';
  }

  @override
  String get errFactorialInvalid => 'Недопустимое число для факториала';

  @override
  String get errFactorialNonNeg =>
      'Факториал определён только для неотрицательных целых чисел';

  @override
  String get errFactorialTooLarge =>
      'Число слишком велико для факториала (максимум 170)';

  @override
  String errFactorial(String error) {
    return 'Ошибка факториала: $error';
  }

  @override
  String get errOperationCancelled => 'Операция отменена';

  @override
  String errGeneric(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get errPhiDomain => 'φ(n) определена только при n > 0';

  @override
  String errPhi(String error) {
    return 'Ошибка φ(n): $error';
  }

  @override
  String get errPrimorialDomain => 'Праймориал определён только при n ≥ 0';

  @override
  String errPrimorial(String error) {
    return 'Ошибка праймориала: $error';
  }

  @override
  String get errSigma0Domain => 'σ₀(n) определена только при n > 0';

  @override
  String errSigma0(String error) {
    return 'Ошибка σ₀(n): $error';
  }

  @override
  String get errSigmaDomain => 'σ(m,n) определена только при n > 0';

  @override
  String errSigma(String error) {
    return 'Ошибка σ(m,n): $error';
  }

  @override
  String errFloorCeil(String error) {
    return 'Ошибка целой части (пол/потолок): $error';
  }

  @override
  String get errMobiusDomain => 'μ(n) определена только при n > 0';

  @override
  String errMobius(String error) {
    return 'Ошибка μ(n): $error';
  }

  @override
  String get errFactorialNeg =>
      'Факториал не определён для отрицательных чисел';

  @override
  String get errFactorialMax => 'n! слишком велик (макс. n=10000)';

  @override
  String errFactorialN(String error) {
    return 'Ошибка n!: $error';
  }

  @override
  String get errDoubleFactorialNeg =>
      'Двойной факториал не определён для отрицательных чисел';

  @override
  String errDoubleFactorial(String error) {
    return 'Ошибка n!!: $error';
  }

  @override
  String get errFibonacciNeg => 'F(n) не определено при n < 0';

  @override
  String errFibonacci(String error) {
    return 'Ошибка F(n): $error';
  }

  @override
  String get errCatalanNeg => 'Число Каталана не определено при n < 0';

  @override
  String errCatalan(String error) {
    return 'Ошибка числа Каталана: $error';
  }

  @override
  String get errDerangementNeg => 'D(n) не определено при n < 0';

  @override
  String errDerangement(String error) {
    return 'Ошибка D(n): $error';
  }

  @override
  String get errPartitionNeg => 'p(n) не определено при n < 0';

  @override
  String errPartition(String error) {
    return 'Ошибка p(n): $error';
  }

  @override
  String get errBellNeg => 'B(n) не определено при n < 0';

  @override
  String errBell(String error) {
    return 'Ошибка Bell(n): $error';
  }

  @override
  String errDigitalRoot(String error) {
    return 'Ошибка цифрового корня: $error';
  }

  @override
  String get errPrimitiveRootDomain => 'Требуется n > 1';

  @override
  String errNoPrimitiveRoot(String n) {
    return 'Первообразного корня по модулю $n не существует';
  }

  @override
  String get errLiouvilleDomain => 'λ_L(n) определена только при n > 0';

  @override
  String errLiouville(String error) {
    return 'Ошибка λ_L(n): $error';
  }

  @override
  String errPrimeCounting(String error) {
    return 'Ошибка π(n): $error';
  }

  @override
  String get errRadDomain => 'rad(n) определена только при n > 0';

  @override
  String errRad(String error) {
    return 'Ошибка rad(n): $error';
  }

  @override
  String get errOmegaDomain => 'ω(n) определена только при n > 0';

  @override
  String errOmega(String error) {
    return 'Ошибка ω(n): $error';
  }

  @override
  String get errBigOmegaDomain => 'Ω(n) определена только при n > 0';

  @override
  String errBigOmega(String error) {
    return 'Ошибка Ω(n): $error';
  }

  @override
  String get errCarmichaelDomain => 'λ(n) определена только при n > 0';

  @override
  String errCarmichael(String error) {
    return 'Ошибка λ(n): $error';
  }

  @override
  String get errSopfrDomain => 'sopfr(n) определена только при n > 0';

  @override
  String errSopfr(String error) {
    return 'Ошибка sopfr(n): $error';
  }

  @override
  String get errSopfDomain => 'sopf(n) определена только при n > 0';

  @override
  String errSopf(String error) {
    return 'Ошибка sopf(n): $error';
  }

  @override
  String errPercentage(String error) {
    return 'Ошибка процента: $error';
  }

  @override
  String get errDivisionByZero => 'Деление на ноль';

  @override
  String errReciprocal(String error) {
    return 'Ошибка обратного числа: $error';
  }

  @override
  String errNoInverse(String a, String n) {
    return 'Обратного по модулю для $a mod $n не существует';
  }

  @override
  String errModPow(String error) {
    return 'Ошибка возведения в степень по модулю: $error';
  }

  @override
  String errDiophantine(String error) {
    return 'Ошибка диофантова уравнения: $error';
  }

  @override
  String errCRT(String error) {
    return 'Ошибка КТО: $error';
  }

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLangAuto => 'Автоматически (системный)';

  @override
  String get settingsLangAutoDesc => 'Использовать язык устройства';

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
  String get hlpTitle => 'Руководство по специальным функциям';

  @override
  String get hlpQuickStartHeader => 'Быстрый старт';

  @override
  String get hlpQuickStartWelcome =>
      'Добро пожаловать в олимпиадный калькулятор';

  @override
  String get hlpQuickStartStep1 =>
      'Откройте боковое меню (☰) и выберите «Специальные функции»';

  @override
  String get hlpQuickStartStep2 =>
      'На верхней клавиатуре (прокручивается) около 40 функций в 4 разделах';

  @override
  String get hlpQuickStartStep3 =>
      'Введите число и нажмите любую кнопку функции';

  @override
  String get hlpQuickStartStep4 =>
      'Если функции нужны ещё значения, появится индикатор незавершённой операции';

  @override
  String get hlpQuickStartStep5 =>
      'Боковая панель показывает автоматический анализ введённого числа';

  @override
  String get hlpQuickStartNote =>
      'Функции с 1 параметром выполняются сразу.\nФункции с 2 и более параметрами показывают индикатор и ждут остальные значения.';

  @override
  String get hlpParamHeader => 'Система параметров';

  @override
  String get hlpParamTypesTitle => 'Типы функций по числу параметров';

  @override
  String get hlpParam1Title => '1 параметр (сразу)';

  @override
  String get hlpParam1Desc => 'Введите число → Нажмите функцию → Результат';

  @override
  String get hlpParam1Example =>
      'Напр.: φ(12) → введите 12, нажмите φ → покажет 4';

  @override
  String get hlpParam2Title => '2-3-4 параметра (фиксированное число)';

  @override
  String get hlpParam2Desc =>
      'Введите значение → Функция → Значение → = → (повторите, если нужно ещё)\nВыполняется само, когда заполнены все параметры.';

  @override
  String get hlpParam2Example => 'Напр.: C(10,3) → введите 10 → C(n,k) → 3 → =';

  @override
  String get hlpParamNTitle => 'N параметров (переменное число)';

  @override
  String get hlpParamNDesc =>
      'Введите значение → Функция → Значение → = (добавьте ещё)\nНажмите ТУ ЖЕ ФУНКЦИЮ ещё раз, чтобы выполнить.';

  @override
  String get hlpParamNExample =>
      'Напр.: НОД(12,18,24) → 12 → НОД → 18 → = → 24 → НОД';

  @override
  String get hlpPendingOpTitle => 'Индикатор незавершённой операции';

  @override
  String get hlpPendingOpDesc =>
      'Когда функция ждёт новых значений, на экране появляется цветной индикатор: он показывает, какая операция выполняется и чего не хватает.\n\nПример: «C(10, _)» означает, что не хватает k для C(n,k).\n«НОД(12, 18, _) [= добавить, НОД решить]» — операция переменной длины.';

  @override
  String get hlpNumberTheoryHeader => 'Теория чисел';

  @override
  String get hlpEulerPhiTitle => 'φ(n) — функция Эйлера';

  @override
  String get hlpEulerPhiParams => '1 парам.';

  @override
  String get hlpEulerPhiDesc =>
      'Считает, сколько целых чисел от 1 до n взаимно просты с n (то есть НОД(k,n)=1).';

  @override
  String get hlpEulerPhiFormula =>
      'φ(n) = n × ∏(1 − 1/p) по каждому простому p | n';

  @override
  String get hlpEulerPhiEx1 => 'φ(1) = 1';

  @override
  String get hlpEulerPhiEx2 => 'φ(9) = 6 → [1,2,4,5,7,8]';

  @override
  String get hlpEulerPhiEx3 => 'φ(12) = 4 → [1,5,7,11]';

  @override
  String get hlpEulerPhiEx4 => 'φ(p) = p−1 для простого p';

  @override
  String get hlpEulerPhiTip1 =>
      'Мультипликативна: φ(mn) = φ(m)φ(n), если НОД(m,n)=1';

  @override
  String get hlpEulerPhiTip2 =>
      'Теорема Эйлера: a^φ(n) ≡ 1 (mod n), если НОД(a,n)=1';

  @override
  String get hlpEulerPhiTip3 => 'Σ φ(d) по d|n = n';

  @override
  String get hlpCarmichaelTitle => 'λ(n) — функция Кармайкла';

  @override
  String get hlpCarmichaelParams => '1 парам.';

  @override
  String get hlpCarmichaelDesc =>
      'Наименьшее m > 0, при котором a^m ≡ 1 (mod n) для ВСЕХ a, взаимно простых с n. Всегда делит φ(n).';

  @override
  String get hlpCarmichaelFormula =>
      'λ(p^k) = φ(p^k), если p нечётное\nλ(2)=1, λ(4)=2, λ(2^k)=2^(k−2) при k≥3\nλ(n) = НОК частей';

  @override
  String get hlpCarmichaelEx1 => 'λ(8) = 2';

  @override
  String get hlpCarmichaelEx2 => 'λ(15) = НОК(λ(3),λ(5)) = НОК(2,4) = 4';

  @override
  String get hlpCarmichaelEx3 => 'λ(p) = p−1 для простого p';

  @override
  String get hlpCarmichaelTip1 => 'λ(n) | φ(n) всегда';

  @override
  String get hlpCarmichaelTip2 =>
      'λ(n) = φ(n) тогда и только тогда, когда у n есть первообразный корень';

  @override
  String get hlpMobiusTitle => 'μ(n) — функция Мёбиуса';

  @override
  String get hlpMobiusParams => '1 парам.';

  @override
  String get hlpMobiusDesc =>
      'Определяет, свободно ли n от квадратов, и считает простые множители.';

  @override
  String get hlpMobiusFormula =>
      'μ(1) = 1\nμ(n) = (−1)^k, если n = p₁·p₂·...·pₖ (различные)\nμ(n) = 0, если p² | n';

  @override
  String get hlpMobiusEx1 => 'μ(1) = 1';

  @override
  String get hlpMobiusEx2 => 'μ(6) = μ(2×3) = (−1)² = 1';

  @override
  String get hlpMobiusEx3 => 'μ(30) = μ(2×3×5) = (−1)³ = −1';

  @override
  String get hlpMobiusEx4 => 'μ(12) = 0 (содержит 2²)';

  @override
  String get hlpMobiusTip1 =>
      'Обращение Мёбиуса: если g(n) = Σ f(d) по d|n, то f(n) = Σ μ(d)g(n/d)';

  @override
  String get hlpMobiusTip2 => 'Σ μ(d) по d|n = [n=1]';

  @override
  String get hlpLiouvilleTitle => 'λL(n) — функция Лиувилля';

  @override
  String get hlpLiouvilleParams => '1 парам.';

  @override
  String get hlpLiouvilleDesc => 'Вполне мультипликативна: λL(n) = (−1)^Ω(n).';

  @override
  String get hlpLiouvilleFormula => 'λL(n) = (−1)^Ω(n)';

  @override
  String get hlpLiouvilleEx1 => 'λL(12) = (−1)³ = −1 (Ω(12)=3)';

  @override
  String get hlpLiouvilleEx2 => 'λL(36) = (−1)⁴ = 1 (Ω(36)=4)';

  @override
  String get hlpLiouvilleTip1 =>
      'Σ λL(d) по d|n = 1, если n — точный квадрат, иначе 0';

  @override
  String get hlpSmallOmegaTitle => 'ω(n) — различные простые множители';

  @override
  String get hlpSmallOmegaParams => '1 парам.';

  @override
  String get hlpSmallOmegaDesc =>
      'Считает количество различных простых, делящих n.';

  @override
  String get hlpSmallOmegaFormula => 'ω(n) = k, если n = p₁^a₁ × ... × pₖ^aₖ';

  @override
  String get hlpSmallOmegaEx1 => 'ω(12) = 2 → [2, 3]';

  @override
  String get hlpSmallOmegaEx2 => 'ω(30) = 3 → [2, 3, 5]';

  @override
  String get hlpSmallOmegaEx3 => 'ω(p^k) = 1';

  @override
  String get hlpBigOmegaTitle => 'Ω(n) — простые множители с кратностью';

  @override
  String get hlpBigOmegaParams => '1 парам.';

  @override
  String get hlpBigOmegaDesc =>
      'Общее число простых множителей с учётом повторений.';

  @override
  String get hlpBigOmegaFormula => 'Ω(n) = a₁ + a₂ + ... + aₖ';

  @override
  String get hlpBigOmegaEx1 => 'Ω(12) = 3 → 2×2×3';

  @override
  String get hlpBigOmegaEx2 => 'Ω(72) = 5 → 2³×3² → 3+2';

  @override
  String get hlpBigOmegaEx3 => 'Ω(p) = 1, Ω(p²) = 2';

  @override
  String get hlpSigma0Title => 'σ₀(n) — количество делителей';

  @override
  String get hlpSigma0Params => '1 парам.';

  @override
  String get hlpSigma0Desc => 'Общее число положительных делителей n.';

  @override
  String get hlpSigma0Formula =>
      'Если n = p₁^a₁ × ... × pₖ^aₖ\nσ₀(n) = (a₁+1)(a₂+1)...(aₖ+1)';

  @override
  String get hlpSigma0Ex1 => 'σ₀(12) = 6 → [1,2,3,4,6,12]';

  @override
  String get hlpSigma0Ex2 => 'σ₀(p) = 2';

  @override
  String get hlpSigma0Ex3 => 'σ₀(p²) = 3';

  @override
  String get hlpSigmaTitle => 'σ(n) — сумма делителей';

  @override
  String get hlpSigmaParams => '1 парам.';

  @override
  String get hlpSigmaDesc => 'Сумма всех положительных делителей n.';

  @override
  String get hlpSigmaFormula => 'σ(n) = Σ d по d | n';

  @override
  String get hlpSigmaEx1 => 'σ(6) = 1+2+3+6 = 12 (6 совершенное)';

  @override
  String get hlpSigmaEx2 => 'σ(12) = 1+2+3+4+6+12 = 28';

  @override
  String get hlpSigmaEx3 => 'σ(p) = p+1';

  @override
  String get hlpSigmaTip1 => 'n совершенное ⟺ σ(n) = 2n';

  @override
  String get hlpSigmaTip2 => 'n избыточное ⟺ σ(n) > 2n';

  @override
  String get hlpSopfrTitle => 'sopfr(n) — сумма простых с повторениями';

  @override
  String get hlpSopfrParams => '1 парам.';

  @override
  String get hlpSopfrDesc => 'Складывает простые множители с учётом кратности.';

  @override
  String get hlpSopfrFormula => 'sopfr(n) = a₁p₁ + a₂p₂ + ... + aₖpₖ';

  @override
  String get hlpSopfrEx1 => 'sopfr(12) = 2+2+3 = 7';

  @override
  String get hlpSopfrEx2 => 'sopfr(60) = 2+2+3+5 = 12';

  @override
  String get hlpSopfTitle => 'sopf(n) — сумма различных простых';

  @override
  String get hlpSopfParams => '1 парам.';

  @override
  String get hlpSopfDesc => 'Сумма различных простых, делящих n.';

  @override
  String get hlpSopfFormula => 'sopf(n) = p₁ + p₂ + ... + pₖ';

  @override
  String get hlpSopfEx1 => 'sopf(12) = 2+3 = 5';

  @override
  String get hlpSopfEx2 => 'sopf(60) = 2+3+5 = 10';

  @override
  String get hlpRadTitle => 'rad(n) — Радикал';

  @override
  String get hlpRadParams => '1 парам.';

  @override
  String get hlpRadDesc =>
      'Произведение различных простых, делящих n (функция из abc-гипотезы).';

  @override
  String get hlpRadFormula => 'rad(n) = ∏ p по простым p, p | n';

  @override
  String get hlpRadEx1 => 'rad(72) = rad(2³×3²) = 2×3 = 6';

  @override
  String get hlpRadEx2 => 'rad(480) = rad(2⁵×3×5) = 30';

  @override
  String get hlpRadEx3 => 'rad(p) = p';

  @override
  String get hlpPrimorialTitle => 'n# — Праймориал';

  @override
  String get hlpPrimorialParams => '1 парам.';

  @override
  String get hlpPrimorialDesc => 'Произведение всех простых ≤ n.';

  @override
  String get hlpPrimorialFormula => 'n# = ∏ p по простым p, p ≤ n';

  @override
  String get hlpPrimorialEx1 => '5# = 2×3×5 = 30';

  @override
  String get hlpPrimorialEx2 => '7# = 210';

  @override
  String get hlpPrimorialEx3 => '11# = 2310';

  @override
  String get hlpPrimeCountTitle => 'π(n) — функция распределения простых чисел';

  @override
  String get hlpPrimeCountParams => '1 парам.';

  @override
  String get hlpPrimeCountDesc =>
      'Считает простые ≤ n. Точно при n ≤ 1 000 000; далее приближение Li(x).';

  @override
  String get hlpPrimeCountFormula =>
      'π(n) ~ n/ln(n) (теорема о распределении простых чисел)';

  @override
  String get hlpPrimeCountEx1 => 'π(10) = 4';

  @override
  String get hlpPrimeCountEx2 => 'π(100) = 25';

  @override
  String get hlpPrimeCountEx3 => 'π(1 000 000) = 78 498';

  @override
  String get hlpDigitalRootTitle => 'dr(n) — цифровой корень';

  @override
  String get hlpDigitalRootParams => '1 парам.';

  @override
  String get hlpDigitalRootDesc =>
      'Повторная сумма цифр, пока не останется одна цифра.';

  @override
  String get hlpDigitalRootFormula => 'dr(n) = 1 + (n−1) mod 9  (при n > 0)';

  @override
  String get hlpDigitalRootEx1 => 'dr(493) → 4+9+3=16 → 1+6 = 7';

  @override
  String get hlpDigitalRootEx2 => 'dr(999) = 9';

  @override
  String get hlpDigitalRootEx3 => 'dr(n) ≡ n (mod 9)';

  @override
  String get hlpFloorCeilTitle => '⌊x⌋ / ⌈x⌉ — пол и потолок';

  @override
  String get hlpFloorCeilParams => '1 парам.';

  @override
  String get hlpFloorCeilDesc =>
      'Пол: наибольшее целое ≤ x. Потолок: наименьшее целое ≥ x. Кнопка переключает их.';

  @override
  String get hlpFloorCeilFormula => '⌊x⌋ ≤ x < ⌊x⌋+1\n⌈x⌉−1 < x ≤ ⌈x⌉';

  @override
  String get hlpFloorCeilEx1 => '⌊3.7⌋ = 3, ⌈3.7⌉ = 4';

  @override
  String get hlpFloorCeilEx2 => '⌊−2.3⌋ = −3, ⌈−2.3⌉ = −2';

  @override
  String get hlpFloorCeilEx3 => '⌊5⌋ = ⌈5⌉ = 5';

  @override
  String get hlpPadicTitle => 'Vₚ(n) — p-адическое нормирование';

  @override
  String get hlpPadicParams => '2 парам.: n → Vₚ → p → =';

  @override
  String get hlpPadicDesc => 'Наибольшая степень простого p, делящая n.';

  @override
  String get hlpPadicFormula => 'Vₚ(n) = max[k : p^k | n]';

  @override
  String get hlpPadicEx1 => 'V₂(24) = 3 → 24 = 2³×3';

  @override
  String get hlpPadicEx2 => 'V₃(81) = 4 → 81 = 3⁴';

  @override
  String get hlpPadicEx3 => 'V₅(100) = 2 → 100 = 2²×5²';

  @override
  String get hlpPadicTip1 => 'Формула Лежандра: Vₚ(n!) = Σ ⌊n/pⁱ⌋';

  @override
  String get hlpPadicTip2 => 'Vₚ(ab) = Vₚ(a) + Vₚ(b)';

  @override
  String get hlpModArithHeader => 'Модульная арифметика';

  @override
  String get hlpModTitle => 'a mod b — остаток от деления';

  @override
  String get hlpModParams => '2 парам.: a → mod → b → =';

  @override
  String get hlpModDesc => 'Остаток от деления a на b.';

  @override
  String get hlpModFormula => 'a mod b = a − b × ⌊a/b⌋';

  @override
  String get hlpModEx1 => '17 mod 5 = 2';

  @override
  String get hlpModEx2 => '23 mod 7 = 2';

  @override
  String get hlpModEx3 => '−8 mod 3 = 1';

  @override
  String get hlpModPowTitle => 'a^b mod n — возведение в степень по модулю';

  @override
  String get hlpModPowParams => '3 парам.: a → a%n → b → = → n → =';

  @override
  String get hlpModPowDesc =>
      'Быстро вычисляет a^b mod n последовательным возведением в квадрат за O(log b).';

  @override
  String get hlpModPowFormula =>
      'Разложить b в двоичной системе и последовательно возводить в квадрат';

  @override
  String get hlpModPowEx1 => '2¹⁰⁰ mod 7 = 2';

  @override
  String get hlpModPowEx2 => '3¹³ mod 11 = 5';

  @override
  String get hlpModPowEx3 => 'Основа RSA и тестов простоты';

  @override
  String get hlpModPowTip1 =>
      'Порядок: введите a → нажмите a%n → введите b → нажмите = → введите n → нажмите =';

  @override
  String get hlpModInvTitle => 'a⁻¹ mod n — обратный элемент по модулю';

  @override
  String get hlpModInvParams => '2 парам.: a → a⁻¹ → n → =';

  @override
  String get hlpModInvDesc =>
      'Находит b, при котором a×b ≡ 1 (mod n). Существует только если НОД(a,n) = 1.';

  @override
  String get hlpModInvFormula => 'Расширенный алгоритм Евклида';

  @override
  String get hlpModInvEx1 => '3⁻¹ mod 7 = 5 → 3×5=15≡1';

  @override
  String get hlpModInvEx2 => '5⁻¹ mod 11 = 9 → 5×9=45≡1';

  @override
  String get hlpModInvEx3 => 'Не существует, если НОД(a,n) ≠ 1';

  @override
  String get hlpOrdTitle => 'ord_n(a) — мультипликативный порядок';

  @override
  String get hlpOrdParams => '2 парам.: a → ord → n → =';

  @override
  String get hlpOrdDesc =>
      'Наименьшее k > 0, при котором a^k ≡ 1 (mod n). Требуется НОД(a,n)=1.';

  @override
  String get hlpOrdFormula => 'ord_n(a) = min[k > 0 : a^k ≡ 1 (mod n)]';

  @override
  String get hlpOrdEx1 => 'ord₇(2) = 3 → 2³=8≡1';

  @override
  String get hlpOrdEx2 => 'ord₁₀(3) = 4 → 3⁴=81≡1';

  @override
  String get hlpOrdTip1 => 'ord_n(a) всегда делит φ(n)';

  @override
  String get hlpOrdTip2 => 'a — первообразный корень ⟺ ord_n(a) = φ(n)';

  @override
  String get hlpLegendreTitle => '(a/p) — символ Лежандра';

  @override
  String get hlpLegendreParams => '2 парам.: a → (a/p) → p → =';

  @override
  String get hlpLegendreDesc =>
      '1, если a — квадратичный вычет по модулю p, −1 если нет, 0 если p|a. Требуется нечётное простое p.';

  @override
  String get hlpLegendreFormula =>
      '(a/p) ≡ a^((p−1)/2) (mod p) — критерий Эйлера';

  @override
  String get hlpLegendreEx1 => '(2/7) = 1 → 3²≡2 (mod 7)';

  @override
  String get hlpLegendreEx2 => '(3/7) = −1 → решения x²≡3 нет';

  @override
  String get hlpLegendreEx3 => '(5/5) = 0';

  @override
  String get hlpJacobiTitle => '(a/n)ⱼ — символ Якоби';

  @override
  String get hlpJacobiParams => '2 парам.: a → (a/n)ⱼ → n → =';

  @override
  String get hlpJacobiDesc =>
      'Обобщение символа Лежандра на нечётное составное n. Использует квадратичный закон взаимности.';

  @override
  String get hlpJacobiFormula => '(a/n) = ∏(a/pᵢ)^eᵢ, где n = ∏pᵢ^eᵢ';

  @override
  String get hlpJacobiEx1 => '(2/15) = (2/3)(2/5) = (−1)(−1) = 1';

  @override
  String get hlpJacobiEx2 => '(a/n) = −1 ⟹ a НЕ является квадратичным вычетом';

  @override
  String get hlpJacobiEx3 => '(a/n) = 1 НЕ гарантирует, что является';

  @override
  String get hlpPrimRootTitle => 'g — первообразный корень';

  @override
  String get hlpPrimRootParams => '1 парам.';

  @override
  String get hlpPrimRootDesc =>
      'Наименьший первообразный корень по модулю n (если он есть). g первообразный, если ord_n(g) = φ(n).';

  @override
  String get hlpPrimRootFormula => '[g, g², ..., g^φ(n)] = (Z/nZ)*';

  @override
  String get hlpPrimRootEx1 => 'g(7) = 3 → [3,2,6,4,5,1]';

  @override
  String get hlpPrimRootEx2 => 'g(11) = 2';

  @override
  String get hlpPrimRootEx3 => 'Существует только при n = 1,2,4,p^k,2p^k';

  @override
  String get hlpGcdTitle => 'НОД — наибольший общий делитель';

  @override
  String get hlpGcdParams => 'N парам. (переменное, мин. 2)';

  @override
  String get hlpGcdDesc =>
      'Наибольшее целое, делящее все значения. Принимает 2 и более чисел.';

  @override
  String get hlpGcdFormula => 'НОД(a,b) по алгоритму Евклида';

  @override
  String get hlpGcdEx1 => 'НОД(12,18) = 6';

  @override
  String get hlpGcdEx2 => 'НОД(12,18,24) = 6';

  @override
  String get hlpGcdEx3 => 'НОД(a,b) × НОК(a,b) = a×b';

  @override
  String get hlpGcdTip1 => 'Порядок: 12 → НОД → 18 → НОД (выполняет)';

  @override
  String get hlpGcdTip2 => 'Для 3 и более чисел: 12 → НОД → 18 → = → 24 → НОД';

  @override
  String get hlpGcdTip3 =>
      'Нажмите =, чтобы добавить ещё, и НОД, чтобы выполнить';

  @override
  String get hlpLcmTitle => 'НОК — наименьшее общее кратное';

  @override
  String get hlpLcmParams => 'N парам. (переменное, мин. 2)';

  @override
  String get hlpLcmDesc =>
      'Наименьшее положительное целое, делящееся на все значения.';

  @override
  String get hlpLcmFormula => 'НОК(a,b) = a×b / НОД(a,b)';

  @override
  String get hlpLcmEx1 => 'НОК(4,6) = 12';

  @override
  String get hlpLcmEx2 => 'НОК(3,5,7) = 105';

  @override
  String get hlpLcmTip1 =>
      'Тот же порядок, что и у НОД: нажмите НОК ещё раз, чтобы выполнить';

  @override
  String get hlpDiophTitle => 'Диоф — линейное диофантово уравнение';

  @override
  String get hlpDiophParams => '3 парам.: a → Диоф → b → = → c → =';

  @override
  String get hlpDiophDesc =>
      'Решает ax + by = c. Даёт частное и общее решение.';

  @override
  String get hlpDiophFormula =>
      'ax + by = c разрешимо ⟺ НОД(a,b) | c\nx = x₀ + (b/g)t,  y = y₀ − (a/g)t';

  @override
  String get hlpDiophEx1 => '3x + 5y = 1 → x=2+5t, y=−1−3t';

  @override
  String get hlpDiophEx2 => '6x + 9y = 12 → x=2+3t, y=0−2t';

  @override
  String get hlpDiophEx3 => '4x + 6y = 3 → Решений нет';

  @override
  String get hlpDiophTip1 => 'Шаг 1: введите a (коэффициент при x)';

  @override
  String get hlpDiophTip2 => 'Шаг 2: нажмите Диоф';

  @override
  String get hlpDiophTip3 => 'Шаг 3: введите b (коэффициент при y), нажмите =';

  @override
  String get hlpDiophTip4 => 'Шаг 4: введите c (свободный член), нажмите =';

  @override
  String get hlpCrtTitle => 'КТО — китайская теорема об остатках';

  @override
  String get hlpCrtParams => 'Переменное число (4+ парам. парами a,m)';

  @override
  String get hlpCrtDesc => 'Решает систему сравнений x ≡ aᵢ (mod mᵢ).';

  @override
  String get hlpCrtFormula =>
      'x ≡ a₁ (mod m₁)\nx ≡ a₂ (mod m₂)\n→ x ≡ r (mod НОК(m₁,m₂))';

  @override
  String get hlpCrtEx1 => 'x≡2(mod 3), x≡3(mod 5) → x≡8(mod 15)';

  @override
  String get hlpCrtEx2 => 'x≡1(mod 4), x≡2(mod 3) → x≡5(mod 12)';

  @override
  String get hlpCrtTip1 => 'Порядок: a₁ → КТО → m₁ → = → a₂ → = → m₂ → КТО';

  @override
  String get hlpCrtTip2 => 'Модули должны быть согласованы';

  @override
  String get hlpCombinatoricsHeader => 'Комбинаторика';

  @override
  String get hlpFactorialTitle => 'n! — Факториал';

  @override
  String get hlpFactorialParams => '1 парам.';

  @override
  String get hlpFactorialDesc =>
      'Произведение от 1 до n. Произвольная точность.';

  @override
  String get hlpFactorialFormula => 'n! = 1 × 2 × ... × n,  0! = 1';

  @override
  String get hlpFactorialEx1 => '5! = 120';

  @override
  String get hlpFactorialEx2 => '10! = 3 628 800';

  @override
  String get hlpFactorialEx3 => '20! = 2 432 902 008 176 640 000';

  @override
  String get hlpDblFactorialTitle => 'n!! — двойной факториал';

  @override
  String get hlpDblFactorialParams => '1 парам.';

  @override
  String get hlpDblFactorialDesc => 'Произведение целых чисел той же чётности.';

  @override
  String get hlpDblFactorialFormula => 'n!! = n × (n−2) × (n−4) × ...';

  @override
  String get hlpDblFactorialEx1 => '7!! = 7×5×3×1 = 105';

  @override
  String get hlpDblFactorialEx2 => '8!! = 8×6×4×2 = 384';

  @override
  String get hlpDblFactorialEx3 => '0!! = 1!! = 1';

  @override
  String get hlpCombTitle => 'C(n,k) — сочетания';

  @override
  String get hlpCombParams => '2 парам.: n → C(n,k) → k → =';

  @override
  String get hlpCombDesc => 'Способы выбрать k из n без учёта порядка.';

  @override
  String get hlpCombFormula => 'C(n,k) = n! / (k!(n−k)!)';

  @override
  String get hlpCombEx1 => 'C(5,2) = 10';

  @override
  String get hlpCombEx2 => 'C(10,3) = 120';

  @override
  String get hlpCombEx3 => 'C(n,0) = C(n,n) = 1';

  @override
  String get hlpCombTip1 => 'Тождество Паскаля: C(n,k) = C(n−1,k−1) + C(n−1,k)';

  @override
  String get hlpCombTip2 => 'C(n,k) = C(n, n−k)';

  @override
  String get hlpVarTitle => 'V(n,k) — размещения';

  @override
  String get hlpVarParams => '2 парам.: n → V(n,k) → k → =';

  @override
  String get hlpVarDesc => 'Способы выбрать k из n С УЧЁТОМ порядка.';

  @override
  String get hlpVarFormula => 'V(n,k) = n! / (n−k)!';

  @override
  String get hlpVarEx1 => 'V(5,2) = 20';

  @override
  String get hlpVarEx2 => 'V(10,3) = 720';

  @override
  String get hlpCatalanTitle => 'Cat(n) — числа Каталана';

  @override
  String get hlpCatalanParams => '1 парам.';

  @override
  String get hlpCatalanDesc =>
      'Считают двоичные деревья, триангуляции, пути Дика, правильные скобочные последовательности.';

  @override
  String get hlpCatalanFormula => 'Cₙ = C(2n,n)/(n+1)';

  @override
  String get hlpCatalanEx1 => 'C₀ = 1, C₁ = 1, C₂ = 2';

  @override
  String get hlpCatalanEx2 => 'C₃ = 5, C₄ = 14, C₅ = 42';

  @override
  String get hlpDerangementTitle => 'D(n) — беспорядки';

  @override
  String get hlpDerangementParams => '1 парам.';

  @override
  String get hlpDerangementDesc =>
      'Перестановки, в которых ни один элемент не остался на своём месте.';

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
  String get hlpBellTitle => 'B(n) — числа Белла';

  @override
  String get hlpBellParams => '1 парам.';

  @override
  String get hlpBellDesc => 'Общее число разбиений множества из n элементов.';

  @override
  String get hlpBellFormula => 'B(n) = Σ S₂(n,k) при k=0..n';

  @override
  String get hlpBellEx1 => 'B(3) = 5';

  @override
  String get hlpBellEx2 => 'B(4) = 15';

  @override
  String get hlpBellEx3 => 'B(5) = 52';

  @override
  String get hlpPartitionTitle => 'p(n) — разбиения числа';

  @override
  String get hlpPartitionParams => '1 парам.';

  @override
  String get hlpPartitionDesc =>
      'Способы записать n суммой натуральных чисел (порядок не важен).';

  @override
  String get hlpPartitionFormula =>
      'Вычисляется динамическим программированием';

  @override
  String get hlpPartitionEx1 => 'p(4) = 5 → [4, 3+1, 2+2, 2+1+1, 1+1+1+1]';

  @override
  String get hlpPartitionEx2 => 'p(10) = 42';

  @override
  String get hlpPartitionEx3 => 'p(100) = 190 569 292 356';

  @override
  String get hlpStirling2Title => 'S₂(n,k) — числа Стирлинга второго рода';

  @override
  String get hlpStirling2Params => '2 парам.: n → S₂ → k → =';

  @override
  String get hlpStirling2Desc =>
      'Способы разбить n элементов ровно на k непустых подмножеств.';

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
      's₁(n,k) — числа Стирлинга первого рода (без знака)';

  @override
  String get hlpStirling1Params => '2 парам.: n → s₁ → k → =';

  @override
  String get hlpStirling1Desc => 'Перестановки n элементов ровно с k циклами.';

  @override
  String get hlpStirling1Formula =>
      '|s₁(n,k)| = (n−1)·|s₁(n−1,k)| + |s₁(n−1,k−1)|';

  @override
  String get hlpStirling1Ex1 => 's₁(4,2) = 11';

  @override
  String get hlpStirling1Ex2 => 's₁(4,1) = 6';

  @override
  String get hlpFibTitle => 'F(n) — n-е число Фибоначчи';

  @override
  String get hlpFibParams => '1 парам.';

  @override
  String get hlpFibDesc =>
      'Вычисляет F(n) быстрым удвоением за O(log n). Принимает очень большие n.';

  @override
  String get hlpFibFormula => 'F(0)=0, F(1)=1, F(n)=F(n−1)+F(n−2)';

  @override
  String get hlpFibEx1 => 'F(10) = 55';

  @override
  String get hlpFibEx2 => 'F(50) = 12 586 269 025';

  @override
  String get hlpFibEx3 => 'F(100) = 354 224 848 179 261 915 075';

  @override
  String get hlpFibTip1 => 'F(n) mod m периодично (период Пизано)';

  @override
  String get hlpFibTip2 => 'НОД(F(m), F(n)) = F(НОД(m,n))';

  @override
  String get hlpDigitSumBaseTitle =>
      'ΣцифB — сумма цифр в системе с основанием b';

  @override
  String get hlpDigitSumBaseParams => '2 парам.: n → ΣцифB → b → =';

  @override
  String get hlpDigitSumBaseDesc =>
      'Складывает цифры числа n, записанного в системе с основанием b.';

  @override
  String get hlpDigitSumBaseFormula => 'Если n = Σ dᵢ × bⁱ, то ΣцифB = Σ dᵢ';

  @override
  String get hlpDigitSumBaseEx1 => 'ΣцифB(255, 2) = 8 → 11111111₂';

  @override
  String get hlpDigitSumBaseEx2 => 'ΣцифB(100, 10) = 1';

  @override
  String get hlpDigitSumBaseEx3 => 'ΣцифB(100, 16) = 10 → 64₁₆';

  @override
  String get hlpStatisticsHeader => 'Статистика';

  @override
  String get hlpArithMeanTitle => 'Среднее арифметическое — Ср ариф';

  @override
  String get hlpArithMeanParams => 'N парам. (переменное, мин. 2)';

  @override
  String get hlpArithMeanDesc => 'Обычное среднее N чисел.';

  @override
  String get hlpArithMeanFormula => 'СА = (x₁ + x₂ + ... + xₙ) / n';

  @override
  String get hlpArithMeanEx1 => 'СА(3, 7) = 5';

  @override
  String get hlpArithMeanEx2 => 'СА(2, 4, 6) = 4';

  @override
  String get hlpArithMeanTip1 =>
      'Порядок: 3 → Ср ариф → 7 → Ср ариф (выполняет)';

  @override
  String get hlpArithMeanTip2 =>
      'Для 3 и более чисел: 2 → Ср ариф → 4 → = → 6 → Ср ариф';

  @override
  String get hlpGeoMeanTitle => 'Среднее геометрическое — Ср геом';

  @override
  String get hlpGeoMeanParams => 'N парам. (переменное, мин. 2)';

  @override
  String get hlpGeoMeanDesc =>
      'Корень n-й степени из произведения. Только положительные значения.';

  @override
  String get hlpGeoMeanFormula => 'СГ = (x₁ × x₂ × ... × xₙ)^(1/n)';

  @override
  String get hlpGeoMeanEx1 => 'СГ(2, 8) = 4';

  @override
  String get hlpGeoMeanEx2 => 'СГ(1, 4, 9) ≈ 3.30';

  @override
  String get hlpHarmMeanTitle => 'Среднее гармоническое — Ср гарм';

  @override
  String get hlpHarmMeanParams => 'N парам. (переменное, мин. 2)';

  @override
  String get hlpHarmMeanDesc =>
      'Число, обратное среднему арифметическому обратных. Только положительные значения.';

  @override
  String get hlpHarmMeanFormula => 'СГарм = n / (1/x₁ + 1/x₂ + ... + 1/xₙ)';

  @override
  String get hlpHarmMeanEx1 => 'СГарм(2, 8) = 3.2';

  @override
  String get hlpHarmMeanEx2 => 'СГарм(1, 4, 9) ≈ 2.08';

  @override
  String get hlpQuadMeanTitle => 'Среднее квадратическое — Ср квад';

  @override
  String get hlpQuadMeanParams => 'N парам. (переменное, мин. 2)';

  @override
  String get hlpQuadMeanDesc => 'Корень из среднего квадратов (RMS).';

  @override
  String get hlpQuadMeanFormula => 'СК = √((x₁² + x₂² + ... + xₙ²) / n)';

  @override
  String get hlpQuadMeanEx1 => 'СК(3, 4) ≈ 3.54';

  @override
  String get hlpQuadMeanEx2 => 'СК(1, 2, 3) ≈ 2.16';

  @override
  String get hlpMinMaxTitle => 'min / max — минимум и максимум';

  @override
  String get hlpMinMaxParams => 'N парам. (переменное, мин. 2)';

  @override
  String get hlpMinMaxDesc =>
      'Находит наименьшее/наибольшее значение среди N чисел.';

  @override
  String get hlpMinMaxFormula => 'min(a₁,...,aₙ) и max(a₁,...,aₙ)';

  @override
  String get hlpMinMaxEx1 => 'min(3, 7, 1) = 1';

  @override
  String get hlpMinMaxEx2 => 'max(3, 7, 1) = 7';

  @override
  String get hlpMinMaxTip1 =>
      'Тот же переменный порядок: нажмите min/max ещё раз, чтобы выполнить';

  @override
  String get hlpMeanInequalityTitle => 'Неравенство о средних (СА-СГ-СГарм)';

  @override
  String get hlpMeanInequalityContent =>
      'Для положительных чисел всегда верно:\n\nСГарм ≤ СГ ≤ СА ≤ СК\n\nРавенство достигается, только когда все значения равны.\nЭто неравенство — одно из основных на олимпиадах.';

  @override
  String get hlpAnalysisPanelHeader => 'Панель числового анализа';

  @override
  String get hlpAutoAnalysisTitle => 'Автоматический анализ';

  @override
  String get hlpAutoAnalysisContent =>
      'Как только введено число, правая панель (планшет) или нижняя (телефон) автоматически показывает:\n\n• Свойства: цифры, чётность, знак\n• Представления: двоичное, восьмеричное, шестнадцатеричное\n• Простоту: тест Миллера — Рабина, полное разложение\n• Соседние простые: предыдущее и следующее\n• Делители: полный список, сумма, количество\n• Классификации: точный квадрат/куб, точная степень, число Фибоначчи, треугольное, палиндром\n\nДля чисел не длиннее 15 цифр показывает также:\n\n• Арифметические функции: φ, λ, μ, ω, Ω, sopfr, sopf, rad, dr\n• Классификации: свободное от квадратов, мощное, число Харшад, полупростое, избыточное/недостаточное/совершенное';

  @override
  String get hlpHighPrecHeader => 'Высокая точность и инструменты';

  @override
  String get hlpHighPrecTitle => 'Режим высокой точности';

  @override
  String get hlpHighPrecContent =>
      'Включается в настройках. Вычисляет sin, cos, tan, ln, log, exp, √ и ∛ на ТОЧНЫХ конструктивных вещественных числах и округляет только при выводе (от 5 до 100 знаков). Без ошибок с плавающей точкой: √2 до 30 знаков = 1.41421356237309504880168872421. Особые точки распознаются по построению (tan 90° = не определён). Всё считается в фоне с индикатором загрузки, приложение не зависает.';

  @override
  String get hlpNewToolsTitle => 'Олимпиадные инструменты';

  @override
  String get hlpNewToolsContent =>
      'Из бокового меню → Олимпиадные инструменты: Дроби, Радикалы, Геометрия (с чертежами: треугольник, Пик, замечательные точки и прямая Эйлера), Многочлены (график, схема Горнера, системы n×n), Алгебра (раскрытие скобок и тождества от нескольких переменных), Теория чисел (решето, модульные часы, вычеты), Пошаговые процедуры, Комплексные числа (единичная окружность, Серпинский — в высокой точности), Статистика, Матрицы (точные), Анализ (производная/интеграл/предел) и Тренировка с проверкой.';

  @override
  String get hlpOlympiadHeader => 'Ключевые олимпиадные формулы';

  @override
  String get hlpIdentitiesTitle => 'Основные тождества';

  @override
  String get hlpIdentitiesContent =>
      '• Теорема Эйлера: a^φ(n) ≡ 1 (mod n), если НОД(a,n)=1\n• Малая теорема Ферма: a^(p−1) ≡ 1 (mod p), если p простое\n• Вильсон: (p−1)! ≡ −1 (mod p) ⟺ p простое\n• Формула Лежандра: Vₚ(n!) = Σᵢ ⌊n/pⁱ⌋\n• Люка: C(n,k) mod p = ∏ C(nᵢ,kᵢ) mod p\n• Σ φ(d) по d|n = n\n• Σ μ(d) по d|n = [n=1]\n• φ(mn) = φ(m)φ(n)·НОД(m,n)/φ(НОД(m,n))\n• НОД(F(m),F(n)) = F(НОД(m,n))\n• СА ≥ СГ ≥ СГарм (неравенство о средних)';

  @override
  String get hlpRefTableTitle => 'Краткая таблица-справочник';

  @override
  String get hlpRefTableContent =>
      'n    φ(n)  λ(n)  μ(n)  σ(n)  ω  Ω\n1    1     1     1     1     0  0\n6    2     2     1     12    2  2\n12   4     2     0     28    2  3\n30   8     4     −1    72    3  3\n60   16    4     0     168   3  4\n100  40    20    0     217   2  4';

  @override
  String get hlpExamplesLabel => 'Примеры:';

  @override
  String get hlpTipsLabel => 'Советы:';

  @override
  String get errExprEmpty => 'Ошибка: пустое выражение';

  @override
  String get errExprMalformed => 'Ошибка: неверно составленное выражение';

  @override
  String get errExprDivZero => 'Ошибка: деление на ноль';

  @override
  String get errResultInvalid => 'Ошибка: недопустимый результат';

  @override
  String get errResultTooLarge =>
      'Результат слишком велик, чтобы вычислить его точно';

  @override
  String get errAnalysisInvalid => 'Ошибка: недопустимое число для анализа';

  @override
  String get errAnalysisFail => 'Не удаётся проанализировать число';

  @override
  String get errNoSolution => 'Решений нет';

  @override
  String get errIncompatibleSystem => 'Несовместная система';

  @override
  String get errCRTNeedPairs => 'Для КТО нужны пары (aᵢ, mᵢ)';

  @override
  String errUnknownOp(String op) {
    return 'Неизвестная операция: $op';
  }
}
