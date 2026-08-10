// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Kalkulator Super';

  @override
  String get appVersion => 'Versi 1.3.0';

  @override
  String get appDeveloped => 'Dikembangkan dengan Flutter';

  @override
  String get appDynamicThemes => 'Dengan dukungan tema dinamis';

  @override
  String get navStandard => 'Standar';

  @override
  String get navStandardSub => 'Operasi dasar';

  @override
  String get navScientific => 'Ilmiah';

  @override
  String get navScientificSub => 'Fungsi lanjutan';

  @override
  String get navSpecial => 'Fungsi khusus';

  @override
  String get navSpecialSub => 'Teori bilangan';

  @override
  String get navHistory => 'Riwayat';

  @override
  String get navHistorySub => 'Lihat operasi sebelumnya';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get navSettingsSub => 'Pengaturan aplikasi';

  @override
  String get navHelp => 'Bantuan';

  @override
  String get navHelpSub => 'Panduan fungsi khusus';

  @override
  String get navAbout => 'Tentang';

  @override
  String get navAboutSub => 'Kalkulator Super v1.3.0';

  @override
  String get navCalculator => 'Kalkulator';

  @override
  String get navSelectType => 'Pilih mode';

  @override
  String navAngleMode(String mode) {
    return 'Mode: $mode';
  }

  @override
  String get navRadians => 'Radian';

  @override
  String get navDegrees => 'Derajat';

  @override
  String get calcAnalysis => 'Analisis';

  @override
  String get calcExpressions => 'Ekspresi';

  @override
  String get calcScientific => 'Kalkulator ilmiah';

  @override
  String get calcSpecialFunctions => 'Fungsi khusus';

  @override
  String get calcSuperCalculator => 'Kalkulator Super';

  @override
  String get calcNumericAnalysis => 'Analisis numerik';

  @override
  String get calcMathExpressions => 'Ekspresi matematika';

  @override
  String get calcResult => 'Hasil:';

  @override
  String get calcProcessing => 'Memproses bilangan besar…';

  @override
  String get calcHighPrecision => 'Menghitung (presisi tinggi)…';

  @override
  String get calcCancel => 'Batal';

  @override
  String get displayPaste => 'Tempel';

  @override
  String get displayCopy => 'Salin';

  @override
  String displayCopied(String text) {
    return 'Disalin: $text';
  }

  @override
  String get displayCopyResult => 'Salin hasil';

  @override
  String get displayPasteNumber => 'Tempel bilangan';

  @override
  String get displayClearDisplay => 'Bersihkan layar';

  @override
  String get displayInvalidNumber =>
      'Kesalahan: teks yang ditempel bukan bilangan yang sah';

  @override
  String get displayNothingToPaste => 'Tidak ada yang bisa ditempel';

  @override
  String displayPasteError(String error) {
    return 'Kesalahan saat menempel: $error';
  }

  @override
  String displayPasted(String text) {
    return 'Ditempel: $text';
  }

  @override
  String get histTitle => 'Riwayat';

  @override
  String get histClearAll => 'Hapus riwayat';

  @override
  String get histClearAllTooltip => 'Hapus seluruh riwayat';

  @override
  String get histConfirmClear => 'Yakin ingin menghapus seluruh riwayat?';

  @override
  String histConfirmClearN(String count) {
    return 'Yakin ingin menghapus seluruh $count operasi dari riwayat? Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String get histCleared => 'Riwayat dihapus';

  @override
  String get histDeleted => 'Riwayat dihapus';

  @override
  String get histOperationDeleted => 'Operasi dihapus';

  @override
  String get histCopiedToClipboard => 'Disalin ke papan klip';

  @override
  String histCopiedClipboardText(String text) {
    return 'Disalin ke papan klip: $text';
  }

  @override
  String get histFullResult => 'Hasil lengkap';

  @override
  String get histClose => 'Tutup';

  @override
  String get histExpression => 'Ekspresi:';

  @override
  String get histResult => 'Hasil:';

  @override
  String get histCopyResult => 'Salin hasil';

  @override
  String get histCopyAll => 'Salin semua';

  @override
  String get histCopyExpression => 'Salin ekspresi';

  @override
  String get histUseResult => 'Gunakan hasil';

  @override
  String get histViewResult => 'Lihat hasil';

  @override
  String get histDelete => 'Hapus';

  @override
  String get histEmpty => 'Belum ada operasi dalam riwayat';

  @override
  String get histEmptyHint =>
      'Lakukan beberapa perhitungan untuk melihat riwayat di sini';

  @override
  String get histEmptyHintAlt =>
      'Operasi yang Anda lakukan akan muncul di sini';

  @override
  String get histOperations => 'operasi';

  @override
  String get histNow => 'Sekarang';

  @override
  String histErrorLoading(String error) {
    return 'Kesalahan saat memuat riwayat: $error';
  }

  @override
  String histErrorClearing(String error) {
    return 'Kesalahan saat menghapus riwayat: $error';
  }

  @override
  String histErrorDeleting(String error) {
    return 'Kesalahan saat menghapus operasi: $error';
  }

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsNumberFormat => 'Format bilangan';

  @override
  String get settingsScientificNotation => 'Gunakan notasi ilmiah';

  @override
  String get settingsScientificHint =>
      'Jika dimatikan, bilangan ditampilkan utuh (mis. 123000)';

  @override
  String get settingsHighPrecision => 'Mode presisi tinggi';

  @override
  String get settingsHighPrecisionHint =>
      'Menghitung sin, cos, tan, ln, √… dengan bilangan real konstruktif yang eksak (lebih lambat). Titik singular seperti tan 90° dilaporkan sebagai tak terdefinisi.';

  @override
  String settingsPrecisionDigits(int digits) {
    return 'Digit presisi: $digits';
  }

  @override
  String get settingsOpenSourceLicenses => 'Lisensi sumber terbuka';

  @override
  String get settingsFormatExamples => 'Contoh format';

  @override
  String get settingsLargeNumber => 'Bilangan besar:';

  @override
  String get settingsSmallNumber => 'Bilangan kecil:';

  @override
  String get settingsNormal => 'Biasa:';

  @override
  String get settingsScientific => 'Ilmiah:';

  @override
  String get settingsAboutApp => 'Tentang aplikasi';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeAuto => 'Otomatis';

  @override
  String get themeLightDesc => 'Selalu gunakan tema terang';

  @override
  String get themeDarkDesc => 'Selalu gunakan tema gelap';

  @override
  String get themeAutoDesc => 'Ikuti pengaturan sistem';

  @override
  String get aboutTitle => 'Kalkulator Super';

  @override
  String get aboutDescription =>
      'Kalkulator canggih dengan kemampuan ilmiah dan analisis numerik lengkap.';

  @override
  String get aboutFeatures => 'Fitur:';

  @override
  String get aboutClose => 'Tutup';

  @override
  String get aboutFeature1 => 'Bilangan hingga 1024 bit';

  @override
  String get aboutFeature2 => 'Presisi desimal 64 bit';

  @override
  String get aboutFeature3 => 'Mode kalkulator standar dan ilmiah';

  @override
  String get aboutFeature4 => 'Fungsi trigonometri (sin, cos, tan)';

  @override
  String get aboutFeature5 => 'Fungsi trigonometri invers (asin, acos, atan)';

  @override
  String get aboutFeature6 => 'Logaritma natural (ln) dan basis 10 (log)';

  @override
  String get aboutFeature7 => 'Fungsi eksponensial (eˣ, 10ˣ)';

  @override
  String get aboutFeature8 => 'Perhitungan faktorial (n!)';

  @override
  String get aboutFeature9 => 'Konstanta matematika (π, e)';

  @override
  String get aboutFeature10 => 'Pangkat dan akar (x², x³, √, ∛)';

  @override
  String get aboutFeature11 => 'Konversi derajat dan radian';

  @override
  String get aboutFeature12 => 'Analisis bilangan prima';

  @override
  String get aboutFeature13 => 'Faktorisasi prima';

  @override
  String get aboutFeature14 => 'Konversi biner dan desimal';

  @override
  String get aboutFeature15 => 'Analisis sifat matematis';

  @override
  String get aboutFeature16 => 'Operasi dengan bilangan yang sangat besar';

  @override
  String get aboutFeature17 => 'Perhitungan berat pada utas terpisah (isolate)';

  @override
  String get aboutFeature18 => 'Penanganan kesalahan domain dan ukuran';

  @override
  String get aboutFeature19 =>
      'Alat Olimpiade: 11 kategori eksak (pecahan, bentuk akar, geometri, polinomial, aljabar, teori bilangan, matriks…)';

  @override
  String get aboutFeature20 =>
      'Aljabar simbolik: penjabaran dan identitas dengan beberapa variabel';

  @override
  String get exprMathExpression => 'Ekspresi matematika';

  @override
  String get exprHideHistory => 'Sembunyikan riwayat';

  @override
  String get exprShowHistory => 'Tampilkan riwayat';

  @override
  String get exprClearExpression => 'Bersihkan ekspresi';

  @override
  String get exprHint => 'Mis.: (5 + 3) * sqrt(9) - 2^3';

  @override
  String get exprDelete => 'Hapus';

  @override
  String get exprEvaluate => 'Hitung (Enter)';

  @override
  String get exprParenthesis => 'Tanda kurung';

  @override
  String get exprSquareRoot => 'Akar kuadrat';

  @override
  String get exprPower => 'Pangkat';

  @override
  String get exprSin => 'Sinus';

  @override
  String get exprCos => 'Kosinus';

  @override
  String get exprTan => 'Tangen';

  @override
  String get exprLog => 'Logaritma';

  @override
  String get exprLn => 'Logaritma natural';

  @override
  String get exprPi => 'Pi';

  @override
  String get exprEuler => 'Euler';

  @override
  String get analysisEnterNumber =>
      'Masukkan bilangan untuk melihat analisisnya';

  @override
  String get analysisLoading => 'Menganalisis bilangan…';

  @override
  String get analysisLoadingHint =>
      'Untuk bilangan besar ini bisa memakan waktu sejenak';

  @override
  String get analysisLimited => 'Analisis terbatas';

  @override
  String get analysisExtremelyLarge => 'Bilangan sangat besar';

  @override
  String analysisDigitsCount(String count) {
    return 'Digit: $count';
  }

  @override
  String get analysisPrimalityNote => 'Catatan tentang uji keprimaan';

  @override
  String analysisOriginalInput(String original, String analyzed) {
    return 'Masukan asli: $original → Dianalisis: $analyzed';
  }

  @override
  String get analysisCalculatingPrimes => 'Menghitung bilangan prima…';

  @override
  String get analysisSearchingPrimes => 'Mencari prima sebelum dan sesudahnya';

  @override
  String get analysisBasicProperties => 'Sifat dasar';

  @override
  String get analysisValue => 'Nilai';

  @override
  String get analysisIsPrime => 'Bilangan prima';

  @override
  String get analysisDigits => 'Digit';

  @override
  String get analysisNextPrime => 'Prima berikutnya';

  @override
  String get analysisPrevPrime => 'Prima sebelumnya';

  @override
  String get analysisDigitSum => 'Jumlah digit';

  @override
  String get analysisBinary => 'Biner';

  @override
  String get analysisYes => 'Ya';

  @override
  String get analysisNo => 'Tidak';

  @override
  String get analysisRepresentations => 'Representasi';

  @override
  String get analysisOctal => 'Oktal';

  @override
  String get analysisHex => 'Heksadesimal';

  @override
  String get analysisMathAnalysis => 'Analisis matematis';

  @override
  String get analysisIsPerfect => 'Bilangan sempurna';

  @override
  String get analysisIsPalindrome => 'Palindrom';

  @override
  String get analysisIsFibonacci => 'Bilangan Fibonacci';

  @override
  String get analysisIsTriangular => 'Bilangan segitiga';

  @override
  String get analysisPrimeFactors => 'Faktorisasi prima';

  @override
  String get analysisPrimeFactorsLabel => 'Faktor prima';

  @override
  String get analysisDivisors => 'Pembagi';

  @override
  String get analysisAllDivisors => 'Semua pembagi';

  @override
  String get analysisDivisorCount => 'Banyak pembagi';

  @override
  String get analysisArithmeticFunctions => 'Fungsi aritmetika';

  @override
  String get analysisEulerPhi => 'φ(n) Euler';

  @override
  String get analysisCarmichael => 'λ(n) Carmichael';

  @override
  String get analysisMobius => 'μ(n) Möbius';

  @override
  String get analysisSmallOmega => 'ω(n) prima berbeda';

  @override
  String get analysisBigOmega => 'Ω(n) prima dgn multiplisitas';

  @override
  String get analysisSopfr => 'sopfr(n) Σprima berulang';

  @override
  String get analysisSopf => 'sopf(n) Σprima berbeda';

  @override
  String get analysisRadical => 'rad(n) radikal';

  @override
  String get analysisDigitalRoot => 'Akar digital';

  @override
  String get analysisClassification => 'Klasifikasi';

  @override
  String get analysisSquareFree => 'Bebas kuadrat';

  @override
  String get analysisPowerful => 'Bilangan kuat';

  @override
  String get analysisHarshad => 'Harshad';

  @override
  String get analysisSemiprime => 'Semiprima';

  @override
  String get analysisAbundant => 'Berlebih';

  @override
  String get analysisDeficient => 'Kurang';

  @override
  String get analysisOperations => 'Operasi';

  @override
  String get analysisSquare => 'Kuadrat';

  @override
  String get analysisCube => 'Pangkat tiga';

  @override
  String get analysisSquareRootLabel => 'Akar kuadrat';

  @override
  String get analysisIsPerfectSquare => 'Kuadrat sempurna';

  @override
  String get analysisCubeRoot => 'Akar pangkat tiga';

  @override
  String get analysisIsPerfectCube => 'Kubik sempurna';

  @override
  String get analysisPerfectPower => 'Pangkat sempurna';

  @override
  String get analysisExpression => 'Ekspresi';

  @override
  String get analysisBase => 'Basis';

  @override
  String get analysisExponent => 'Eksponen';

  @override
  String get cardPrime => 'Prima';

  @override
  String get cardPerfect => 'Sempurna';

  @override
  String get cardPalindrome => 'Palindrom';

  @override
  String get cardFibonacci => 'Fibonacci';

  @override
  String get cardTriangular => 'Segitiga';

  @override
  String get cardEven => 'Genap';

  @override
  String get cardOdd => 'Ganjil';

  @override
  String get cardQuickProperties => 'Sifat singkat:';

  @override
  String get cardConvert => 'Konversi:';

  @override
  String get cardToDecimal => 'Ke desimal';

  @override
  String get cardToBinary => 'Ke biner';

  @override
  String get cardAdvancedOps => 'Operasi lanjutan:';

  @override
  String get cardDigits => 'digit';

  @override
  String get kbdNumberTheory => 'Teori bilangan';

  @override
  String get kbdModularArith => 'Aritmetika modular';

  @override
  String get kbdCombinatorics => 'Kombinatorika';

  @override
  String get kbdStatistics => 'Statistika';

  @override
  String errPower(String error) {
    return 'Kesalahan pemangkatan: $error';
  }

  @override
  String errSquareRoot(String error) {
    return 'Kesalahan akar kuadrat: $error';
  }

  @override
  String get errNegativeSqrt =>
      'Tidak dapat menarik akar kuadrat dari bilangan negatif';

  @override
  String errCubeRoot(String error) {
    return 'Kesalahan akar pangkat tiga: $error';
  }

  @override
  String errBinaryConversion(String error) {
    return 'Kesalahan konversi ke biner: $error';
  }

  @override
  String get errEmptyBinary => 'Bilangan biner kosong';

  @override
  String get errInvalidBinary =>
      'Bilangan hanya boleh berisi digit biner (0 dan 1)';

  @override
  String errBinaryFromConversion(String error) {
    return 'Kesalahan konversi dari biner: $error';
  }

  @override
  String get errTrigTooLarge =>
      'Bilangan terlalu besar untuk fungsi trigonometri';

  @override
  String errSin(String error) {
    return 'Kesalahan sinus: $error';
  }

  @override
  String errCos(String error) {
    return 'Kesalahan kosinus: $error';
  }

  @override
  String get errTanUndefined => 'Tangen tak terdefinisi untuk sudut ini';

  @override
  String errTan(String error) {
    return 'Kesalahan tangen: $error';
  }

  @override
  String get errAsinDomain =>
      'Arcsin hanya terdefinisi untuk nilai antara -1 dan 1';

  @override
  String errAsin(String error) {
    return 'Kesalahan arcsin: $error';
  }

  @override
  String get errAcosDomain =>
      'Arccos hanya terdefinisi untuk nilai antara -1 dan 1';

  @override
  String errAcos(String error) {
    return 'Kesalahan arccos: $error';
  }

  @override
  String errAtan(String error) {
    return 'Kesalahan arctan: $error';
  }

  @override
  String get errLnDomain =>
      'Logaritma natural hanya terdefinisi untuk bilangan positif';

  @override
  String get errLnTooLarge => 'Bilangan terlalu besar untuk logaritma natural';

  @override
  String errLn(String error) {
    return 'Kesalahan logaritma natural: $error';
  }

  @override
  String get errLogDomain =>
      'Logaritma hanya terdefinisi untuk bilangan positif';

  @override
  String get errLogTooLarge =>
      'Bilangan terlalu besar untuk logaritma basis 10';

  @override
  String errLog(String error) {
    return 'Kesalahan logaritma: $error';
  }

  @override
  String get errExpTooLarge =>
      'Bilangan terlalu besar untuk fungsi eksponensial';

  @override
  String errExp(String error) {
    return 'Kesalahan eksponensial: $error';
  }

  @override
  String get errTenPowTooLarge => 'Bilangan terlalu besar untuk 10^x';

  @override
  String errTenPow(String error) {
    return 'Kesalahan 10^x: $error';
  }

  @override
  String get errFactorialInvalid => 'Bilangan tidak sah untuk faktorial';

  @override
  String get errFactorialNonNeg =>
      'Faktorial hanya terdefinisi untuk bilangan bulat tak negatif';

  @override
  String get errFactorialTooLarge =>
      'Bilangan terlalu besar untuk faktorial (maksimum 170)';

  @override
  String errFactorial(String error) {
    return 'Kesalahan faktorial: $error';
  }

  @override
  String get errOperationCancelled => 'Operasi dibatalkan';

  @override
  String errGeneric(String error) {
    return 'Kesalahan: $error';
  }

  @override
  String get errPhiDomain => 'φ(n) hanya terdefinisi untuk n > 0';

  @override
  String errPhi(String error) {
    return 'Kesalahan φ(n): $error';
  }

  @override
  String get errPrimorialDomain => 'Primorial hanya terdefinisi untuk n ≥ 0';

  @override
  String errPrimorial(String error) {
    return 'Kesalahan primorial: $error';
  }

  @override
  String get errSigma0Domain => 'σ₀(n) hanya terdefinisi untuk n > 0';

  @override
  String errSigma0(String error) {
    return 'Kesalahan σ₀(n): $error';
  }

  @override
  String get errSigmaDomain => 'σ(m,n) hanya terdefinisi untuk n > 0';

  @override
  String errSigma(String error) {
    return 'Kesalahan σ(m,n): $error';
  }

  @override
  String errFloorCeil(String error) {
    return 'Kesalahan lantai/langit-langit: $error';
  }

  @override
  String get errMobiusDomain => 'μ(n) hanya terdefinisi untuk n > 0';

  @override
  String errMobius(String error) {
    return 'Kesalahan μ(n): $error';
  }

  @override
  String get errFactorialNeg =>
      'Faktorial tidak terdefinisi untuk bilangan negatif';

  @override
  String get errFactorialMax => 'n! terlalu besar (maks. n=10000)';

  @override
  String errFactorialN(String error) {
    return 'Kesalahan n!: $error';
  }

  @override
  String get errDoubleFactorialNeg =>
      'Faktorial ganda tidak terdefinisi untuk bilangan negatif';

  @override
  String errDoubleFactorial(String error) {
    return 'Kesalahan n!!: $error';
  }

  @override
  String get errFibonacciNeg => 'F(n) tidak terdefinisi untuk n < 0';

  @override
  String errFibonacci(String error) {
    return 'Kesalahan F(n): $error';
  }

  @override
  String get errCatalanNeg => 'Bilangan Catalan tidak terdefinisi untuk n < 0';

  @override
  String errCatalan(String error) {
    return 'Kesalahan bilangan Catalan: $error';
  }

  @override
  String get errDerangementNeg => 'D(n) tidak terdefinisi untuk n < 0';

  @override
  String errDerangement(String error) {
    return 'Kesalahan D(n): $error';
  }

  @override
  String get errPartitionNeg => 'p(n) tidak terdefinisi untuk n < 0';

  @override
  String errPartition(String error) {
    return 'Kesalahan p(n): $error';
  }

  @override
  String get errBellNeg => 'B(n) tidak terdefinisi untuk n < 0';

  @override
  String errBell(String error) {
    return 'Kesalahan Bell(n): $error';
  }

  @override
  String errDigitalRoot(String error) {
    return 'Kesalahan akar digital: $error';
  }

  @override
  String get errPrimitiveRootDomain => 'Diperlukan n > 1';

  @override
  String errNoPrimitiveRoot(String n) {
    return 'Tidak ada akar primitif modulo $n';
  }

  @override
  String get errLiouvilleDomain => 'λ_L(n) hanya terdefinisi untuk n > 0';

  @override
  String errLiouville(String error) {
    return 'Kesalahan λ_L(n): $error';
  }

  @override
  String errPrimeCounting(String error) {
    return 'Kesalahan π(n): $error';
  }

  @override
  String get errRadDomain => 'rad(n) hanya terdefinisi untuk n > 0';

  @override
  String errRad(String error) {
    return 'Kesalahan rad(n): $error';
  }

  @override
  String get errOmegaDomain => 'ω(n) hanya terdefinisi untuk n > 0';

  @override
  String errOmega(String error) {
    return 'Kesalahan ω(n): $error';
  }

  @override
  String get errBigOmegaDomain => 'Ω(n) hanya terdefinisi untuk n > 0';

  @override
  String errBigOmega(String error) {
    return 'Kesalahan Ω(n): $error';
  }

  @override
  String get errCarmichaelDomain => 'λ(n) hanya terdefinisi untuk n > 0';

  @override
  String errCarmichael(String error) {
    return 'Kesalahan λ(n): $error';
  }

  @override
  String get errSopfrDomain => 'sopfr(n) hanya terdefinisi untuk n > 0';

  @override
  String errSopfr(String error) {
    return 'Kesalahan sopfr(n): $error';
  }

  @override
  String get errSopfDomain => 'sopf(n) hanya terdefinisi untuk n > 0';

  @override
  String errSopf(String error) {
    return 'Kesalahan sopf(n): $error';
  }

  @override
  String errPercentage(String error) {
    return 'Kesalahan persentase: $error';
  }

  @override
  String get errDivisionByZero => 'Pembagian dengan nol';

  @override
  String errReciprocal(String error) {
    return 'Kesalahan kebalikan: $error';
  }

  @override
  String errNoInverse(String a, String n) {
    return 'Tidak ada invers modular dari $a mod $n';
  }

  @override
  String errModPow(String error) {
    return 'Kesalahan pemangkatan modular: $error';
  }

  @override
  String errDiophantine(String error) {
    return 'Kesalahan persamaan Diophantine: $error';
  }

  @override
  String errCRT(String error) {
    return 'Kesalahan CRT: $error';
  }

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLangAuto => 'Otomatis (sistem)';

  @override
  String get settingsLangAutoDesc => 'Gunakan bahasa perangkat';

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
  String get hlpTitle => 'Panduan fungsi khusus';

  @override
  String get hlpQuickStartHeader => 'Mulai cepat';

  @override
  String get hlpQuickStartWelcome => 'Selamat datang di kalkulator olimpiade';

  @override
  String get hlpQuickStartStep1 =>
      'Buka menu samping (☰) dan pilih «Fungsi khusus»';

  @override
  String get hlpQuickStartStep2 =>
      'Papan tombol atas (dapat digulir) memuat sekitar 40 fungsi dalam 4 bagian';

  @override
  String get hlpQuickStartStep3 =>
      'Masukkan bilangan lalu tekan tombol fungsi mana pun';

  @override
  String get hlpQuickStartStep4 =>
      'Jika fungsi memerlukan nilai lain, indikator operasi tertunda akan muncul';

  @override
  String get hlpQuickStartStep5 =>
      'Panel samping menampilkan analisis otomatis atas bilangan yang dimasukkan';

  @override
  String get hlpQuickStartNote =>
      'Fungsi dengan 1 parameter langsung dijalankan.\nFungsi dengan 2 parameter atau lebih menampilkan indikator dan menunggu nilai berikutnya.';

  @override
  String get hlpParamHeader => 'Sistem parameter';

  @override
  String get hlpParamTypesTitle => 'Jenis fungsi menurut jumlah parameter';

  @override
  String get hlpParam1Title => '1 parameter (langsung)';

  @override
  String get hlpParam1Desc => 'Masukkan bilangan → Tekan fungsi → Hasil';

  @override
  String get hlpParam1Example =>
      'Mis.: φ(12) → masukkan 12, tekan φ → muncul 4';

  @override
  String get hlpParam2Title => '2-3-4 parameter (tetap)';

  @override
  String get hlpParam2Desc =>
      'Masukkan nilai → Fungsi → Nilai → = → (ulangi bila perlu)\nDijalankan sendiri setelah semua parameter terisi.';

  @override
  String get hlpParam2Example => 'Mis.: C(10,3) → masukkan 10 → C(n,k) → 3 → =';

  @override
  String get hlpParamNTitle => 'N parameter (berubah-ubah)';

  @override
  String get hlpParamNDesc =>
      'Masukkan nilai → Fungsi → Nilai → = (tambahkan lagi)\nTekan FUNGSI YANG SAMA sekali lagi untuk menjalankan.';

  @override
  String get hlpParamNExample =>
      'Mis.: FPB(12,18,24) → 12 → FPB → 18 → = → 24 → FPB';

  @override
  String get hlpPendingOpTitle => 'Indikator operasi tertunda';

  @override
  String get hlpPendingOpDesc =>
      'Ketika sebuah fungsi masih menunggu nilai, di layar muncul indikator berwarna yang menunjukkan operasi apa yang sedang berjalan dan apa yang masih kurang.\n\nContoh: «C(10, _)» berarti k belum diisi untuk melengkapi C(n,k).\n«FPB(12, 18, _) [= tambah, FPB hitung]» adalah operasi dengan jumlah parameter berubah-ubah.';

  @override
  String get hlpNumberTheoryHeader => 'Teori bilangan';

  @override
  String get hlpEulerPhiTitle => 'φ(n) — fungsi Euler';

  @override
  String get hlpEulerPhiParams => '1 parameter';

  @override
  String get hlpEulerPhiDesc =>
      'Menghitung banyaknya bilangan bulat dari 1 sampai n yang relatif prima dengan n (yaitu FPB(k,n)=1).';

  @override
  String get hlpEulerPhiFormula =>
      'φ(n) = n × ∏(1 − 1/p) untuk setiap prima p | n';

  @override
  String get hlpEulerPhiEx1 => 'φ(1) = 1';

  @override
  String get hlpEulerPhiEx2 => 'φ(9) = 6 → [1,2,4,5,7,8]';

  @override
  String get hlpEulerPhiEx3 => 'φ(12) = 4 → [1,5,7,11]';

  @override
  String get hlpEulerPhiEx4 => 'φ(p) = p−1 untuk p prima';

  @override
  String get hlpEulerPhiTip1 =>
      'Multiplikatif: φ(mn) = φ(m)φ(n) jika FPB(m,n)=1';

  @override
  String get hlpEulerPhiTip2 =>
      'Teorema Euler: a^φ(n) ≡ 1 (mod n) jika FPB(a,n)=1';

  @override
  String get hlpEulerPhiTip3 => 'Σ φ(d) untuk d|n = n';

  @override
  String get hlpCarmichaelTitle => 'λ(n) — fungsi λ Carmichael';

  @override
  String get hlpCarmichaelParams => '1 parameter';

  @override
  String get hlpCarmichaelDesc =>
      'Bilangan m > 0 terkecil sehingga a^m ≡ 1 (mod n) untuk SEMUA a yang relatif prima dengan n. Selalu membagi φ(n).';

  @override
  String get hlpCarmichaelFormula =>
      'λ(p^k) = φ(p^k) jika p ganjil\nλ(2)=1, λ(4)=2, λ(2^k)=2^(k−2) jika k≥3\nλ(n) = KPK dari bagian-bagiannya';

  @override
  String get hlpCarmichaelEx1 => 'λ(8) = 2';

  @override
  String get hlpCarmichaelEx2 => 'λ(15) = KPK(λ(3),λ(5)) = KPK(2,4) = 4';

  @override
  String get hlpCarmichaelEx3 => 'λ(p) = p−1 untuk p prima';

  @override
  String get hlpCarmichaelTip1 => 'λ(n) | φ(n) selalu berlaku';

  @override
  String get hlpCarmichaelTip2 =>
      'λ(n) = φ(n) jika dan hanya jika n punya akar primitif';

  @override
  String get hlpMobiusTitle => 'μ(n) — fungsi Möbius';

  @override
  String get hlpMobiusParams => '1 parameter';

  @override
  String get hlpMobiusDesc =>
      'Mendeteksi apakah n bebas kuadrat dan menghitung faktor primanya.';

  @override
  String get hlpMobiusFormula =>
      'μ(1) = 1\nμ(n) = (−1)^k jika n = p₁·p₂·...·pₖ (berbeda)\nμ(n) = 0 jika p² | n';

  @override
  String get hlpMobiusEx1 => 'μ(1) = 1';

  @override
  String get hlpMobiusEx2 => 'μ(6) = μ(2×3) = (−1)² = 1';

  @override
  String get hlpMobiusEx3 => 'μ(30) = μ(2×3×5) = (−1)³ = −1';

  @override
  String get hlpMobiusEx4 => 'μ(12) = 0 (memuat 2²)';

  @override
  String get hlpMobiusTip1 =>
      'Inversi Möbius: jika g(n) = Σ f(d) untuk d|n, maka f(n) = Σ μ(d)g(n/d)';

  @override
  String get hlpMobiusTip2 => 'Σ μ(d) untuk d|n = [n=1]';

  @override
  String get hlpLiouvilleTitle => 'λL(n) — fungsi Liouville';

  @override
  String get hlpLiouvilleParams => '1 parameter';

  @override
  String get hlpLiouvilleDesc => 'Multiplikatif sepenuhnya: λL(n) = (−1)^Ω(n).';

  @override
  String get hlpLiouvilleFormula => 'λL(n) = (−1)^Ω(n)';

  @override
  String get hlpLiouvilleEx1 => 'λL(12) = (−1)³ = −1 (Ω(12)=3)';

  @override
  String get hlpLiouvilleEx2 => 'λL(36) = (−1)⁴ = 1 (Ω(36)=4)';

  @override
  String get hlpLiouvilleTip1 =>
      'Σ λL(d) untuk d|n = 1 jika n kuadrat sempurna, selain itu 0';

  @override
  String get hlpSmallOmegaTitle => 'ω(n) — faktor prima yang berbeda';

  @override
  String get hlpSmallOmegaParams => '1 parameter';

  @override
  String get hlpSmallOmegaDesc =>
      'Menghitung banyaknya prima berbeda yang membagi n.';

  @override
  String get hlpSmallOmegaFormula => 'ω(n) = k jika n = p₁^a₁ × ... × pₖ^aₖ';

  @override
  String get hlpSmallOmegaEx1 => 'ω(12) = 2 → [2, 3]';

  @override
  String get hlpSmallOmegaEx2 => 'ω(30) = 3 → [2, 3, 5]';

  @override
  String get hlpSmallOmegaEx3 => 'ω(p^k) = 1';

  @override
  String get hlpBigOmegaTitle => 'Ω(n) — faktor prima dengan multiplisitas';

  @override
  String get hlpBigOmegaParams => '1 parameter';

  @override
  String get hlpBigOmegaDesc =>
      'Jumlah seluruh faktor prima termasuk pengulangan.';

  @override
  String get hlpBigOmegaFormula => 'Ω(n) = a₁ + a₂ + ... + aₖ';

  @override
  String get hlpBigOmegaEx1 => 'Ω(12) = 3 → 2×2×3';

  @override
  String get hlpBigOmegaEx2 => 'Ω(72) = 5 → 2³×3² → 3+2';

  @override
  String get hlpBigOmegaEx3 => 'Ω(p) = 1, Ω(p²) = 2';

  @override
  String get hlpSigma0Title => 'σ₀(n) — banyak pembagi';

  @override
  String get hlpSigma0Params => '1 parameter';

  @override
  String get hlpSigma0Desc => 'Jumlah seluruh pembagi positif dari n.';

  @override
  String get hlpSigma0Formula =>
      'Jika n = p₁^a₁ × ... × pₖ^aₖ\nσ₀(n) = (a₁+1)(a₂+1)...(aₖ+1)';

  @override
  String get hlpSigma0Ex1 => 'σ₀(12) = 6 → [1,2,3,4,6,12]';

  @override
  String get hlpSigma0Ex2 => 'σ₀(p) = 2';

  @override
  String get hlpSigma0Ex3 => 'σ₀(p²) = 3';

  @override
  String get hlpSigmaTitle => 'σ(n) — jumlah pembagi';

  @override
  String get hlpSigmaParams => '1 parameter';

  @override
  String get hlpSigmaDesc => 'Jumlah semua pembagi positif dari n.';

  @override
  String get hlpSigmaFormula => 'σ(n) = Σ d untuk d | n';

  @override
  String get hlpSigmaEx1 => 'σ(6) = 1+2+3+6 = 12 (6 bilangan sempurna)';

  @override
  String get hlpSigmaEx2 => 'σ(12) = 1+2+3+4+6+12 = 28';

  @override
  String get hlpSigmaEx3 => 'σ(p) = p+1';

  @override
  String get hlpSigmaTip1 => 'n sempurna ⟺ σ(n) = 2n';

  @override
  String get hlpSigmaTip2 => 'n berlebih ⟺ σ(n) > 2n';

  @override
  String get hlpSopfrTitle => 'sopfr(n) — jumlah prima dengan pengulangan';

  @override
  String get hlpSopfrParams => '1 parameter';

  @override
  String get hlpSopfrDesc =>
      'Menjumlahkan faktor prima dengan memperhitungkan multiplisitas.';

  @override
  String get hlpSopfrFormula => 'sopfr(n) = a₁p₁ + a₂p₂ + ... + aₖpₖ';

  @override
  String get hlpSopfrEx1 => 'sopfr(12) = 2+2+3 = 7';

  @override
  String get hlpSopfrEx2 => 'sopfr(60) = 2+2+3+5 = 12';

  @override
  String get hlpSopfTitle => 'sopf(n) — jumlah prima yang berbeda';

  @override
  String get hlpSopfParams => '1 parameter';

  @override
  String get hlpSopfDesc => 'Jumlah prima berbeda yang membagi n.';

  @override
  String get hlpSopfFormula => 'sopf(n) = p₁ + p₂ + ... + pₖ';

  @override
  String get hlpSopfEx1 => 'sopf(12) = 2+3 = 5';

  @override
  String get hlpSopfEx2 => 'sopf(60) = 2+3+5 = 10';

  @override
  String get hlpRadTitle => 'rad(n) — Radikal';

  @override
  String get hlpRadParams => '1 parameter';

  @override
  String get hlpRadDesc =>
      'Hasil kali prima berbeda yang membagi n (fungsi dalam konjektur abc).';

  @override
  String get hlpRadFormula => 'rad(n) = ∏ p untuk p prima, p | n';

  @override
  String get hlpRadEx1 => 'rad(72) = rad(2³×3²) = 2×3 = 6';

  @override
  String get hlpRadEx2 => 'rad(480) = rad(2⁵×3×5) = 30';

  @override
  String get hlpRadEx3 => 'rad(p) = p';

  @override
  String get hlpPrimorialTitle => 'n# — Primorial';

  @override
  String get hlpPrimorialParams => '1 parameter';

  @override
  String get hlpPrimorialDesc => 'Hasil kali semua bilangan prima ≤ n.';

  @override
  String get hlpPrimorialFormula => 'n# = ∏ p untuk p prima, p ≤ n';

  @override
  String get hlpPrimorialEx1 => '5# = 2×3×5 = 30';

  @override
  String get hlpPrimorialEx2 => '7# = 210';

  @override
  String get hlpPrimorialEx3 => '11# = 2310';

  @override
  String get hlpPrimeCountTitle => 'π(n) — fungsi pencacah prima';

  @override
  String get hlpPrimeCountParams => '1 parameter';

  @override
  String get hlpPrimeCountDesc =>
      'Menghitung prima ≤ n. Eksak untuk n ≤ 1 000 000; di atas itu memakai hampiran Li(x).';

  @override
  String get hlpPrimeCountFormula => 'π(n) ~ n/ln(n) (teorema bilangan prima)';

  @override
  String get hlpPrimeCountEx1 => 'π(10) = 4';

  @override
  String get hlpPrimeCountEx2 => 'π(100) = 25';

  @override
  String get hlpPrimeCountEx3 => 'π(1 000 000) = 78 498';

  @override
  String get hlpDigitalRootTitle => 'dr(n) — akar digital';

  @override
  String get hlpDigitalRootParams => '1 parameter';

  @override
  String get hlpDigitalRootDesc =>
      'Penjumlahan digit berulang sampai tersisa satu digit.';

  @override
  String get hlpDigitalRootFormula => 'dr(n) = 1 + (n−1) mod 9  (untuk n > 0)';

  @override
  String get hlpDigitalRootEx1 => 'dr(493) → 4+9+3=16 → 1+6 = 7';

  @override
  String get hlpDigitalRootEx2 => 'dr(999) = 9';

  @override
  String get hlpDigitalRootEx3 => 'dr(n) ≡ n (mod 9)';

  @override
  String get hlpFloorCeilTitle => '⌊x⌋ / ⌈x⌉ — lantai dan langit-langit';

  @override
  String get hlpFloorCeilParams => '1 parameter';

  @override
  String get hlpFloorCeilDesc =>
      'Lantai: bilangan bulat terbesar ≤ x. Langit-langit: bilangan bulat terkecil ≥ x. Tombolnya bergantian antara keduanya.';

  @override
  String get hlpFloorCeilFormula => '⌊x⌋ ≤ x < ⌊x⌋+1\n⌈x⌉−1 < x ≤ ⌈x⌉';

  @override
  String get hlpFloorCeilEx1 => '⌊3.7⌋ = 3, ⌈3.7⌉ = 4';

  @override
  String get hlpFloorCeilEx2 => '⌊−2.3⌋ = −3, ⌈−2.3⌉ = −2';

  @override
  String get hlpFloorCeilEx3 => '⌊5⌋ = ⌈5⌉ = 5';

  @override
  String get hlpPadicTitle => 'Vₚ(n) — valuasi p-adik';

  @override
  String get hlpPadicParams => '2 parameter: n → Vₚ → p → =';

  @override
  String get hlpPadicDesc => 'Pangkat tertinggi dari prima p yang membagi n.';

  @override
  String get hlpPadicFormula => 'Vₚ(n) = max[k : p^k | n]';

  @override
  String get hlpPadicEx1 => 'V₂(24) = 3 → 24 = 2³×3';

  @override
  String get hlpPadicEx2 => 'V₃(81) = 4 → 81 = 3⁴';

  @override
  String get hlpPadicEx3 => 'V₅(100) = 2 → 100 = 2²×5²';

  @override
  String get hlpPadicTip1 => 'Rumus Legendre: Vₚ(n!) = Σ ⌊n/pⁱ⌋';

  @override
  String get hlpPadicTip2 => 'Vₚ(ab) = Vₚ(a) + Vₚ(b)';

  @override
  String get hlpModArithHeader => 'Aritmetika modular';

  @override
  String get hlpModTitle => 'a mod b — sisa pembagian';

  @override
  String get hlpModParams => '2 parameter: a → mod → b → =';

  @override
  String get hlpModDesc => 'Sisa pembagian a oleh b.';

  @override
  String get hlpModFormula => 'a mod b = a − b × ⌊a/b⌋';

  @override
  String get hlpModEx1 => '17 mod 5 = 2';

  @override
  String get hlpModEx2 => '23 mod 7 = 2';

  @override
  String get hlpModEx3 => '−8 mod 3 = 1';

  @override
  String get hlpModPowTitle => 'a^b mod n — pemangkatan modular';

  @override
  String get hlpModPowParams => '3 parameter: a → a%n → b → = → n → =';

  @override
  String get hlpModPowDesc =>
      'Menghitung a^b mod n secara efisien dengan pengkuadratan berulang, O(log b).';

  @override
  String get hlpModPowFormula =>
      'Uraikan b dalam biner lalu kuadratkan berturut-turut';

  @override
  String get hlpModPowEx1 => '2¹⁰⁰ mod 7 = 2';

  @override
  String get hlpModPowEx2 => '3¹³ mod 11 = 5';

  @override
  String get hlpModPowEx3 => 'Mendasari RSA dan uji keprimaan';

  @override
  String get hlpModPowTip1 =>
      'Urutan: masukkan a → tekan a%n → masukkan b → tekan = → masukkan n → tekan =';

  @override
  String get hlpModInvTitle => 'a⁻¹ mod n — invers modular';

  @override
  String get hlpModInvParams => '2 parameter: a → a⁻¹ → n → =';

  @override
  String get hlpModInvDesc =>
      'Mencari b sehingga a×b ≡ 1 (mod n). Hanya ada jika FPB(a,n) = 1.';

  @override
  String get hlpModInvFormula => 'Algoritma Euclid yang diperluas';

  @override
  String get hlpModInvEx1 => '3⁻¹ mod 7 = 5 → 3×5=15≡1';

  @override
  String get hlpModInvEx2 => '5⁻¹ mod 11 = 9 → 5×9=45≡1';

  @override
  String get hlpModInvEx3 => 'Tidak ada jika FPB(a,n) ≠ 1';

  @override
  String get hlpOrdTitle => 'ord_n(a) — orde multiplikatif';

  @override
  String get hlpOrdParams => '2 parameter: a → ord → n → =';

  @override
  String get hlpOrdDesc =>
      'Bilangan k > 0 terkecil dengan a^k ≡ 1 (mod n). Memerlukan FPB(a,n)=1.';

  @override
  String get hlpOrdFormula => 'ord_n(a) = min[k > 0 : a^k ≡ 1 (mod n)]';

  @override
  String get hlpOrdEx1 => 'ord₇(2) = 3 → 2³=8≡1';

  @override
  String get hlpOrdEx2 => 'ord₁₀(3) = 4 → 3⁴=81≡1';

  @override
  String get hlpOrdTip1 => 'ord_n(a) selalu membagi φ(n)';

  @override
  String get hlpOrdTip2 => 'a adalah akar primitif ⟺ ord_n(a) = φ(n)';

  @override
  String get hlpLegendreTitle => '(a/p) — simbol Legendre';

  @override
  String get hlpLegendreParams => '2 parameter: a → (a/p) → p → =';

  @override
  String get hlpLegendreDesc =>
      'Bernilai 1 jika a residu kuadratik mod p, −1 jika bukan, 0 jika p|a. Memerlukan p prima ganjil.';

  @override
  String get hlpLegendreFormula =>
      '(a/p) ≡ a^((p−1)/2) (mod p) — kriteria Euler';

  @override
  String get hlpLegendreEx1 => '(2/7) = 1 → 3²≡2 (mod 7)';

  @override
  String get hlpLegendreEx2 => '(3/7) = −1 → tidak ada x²≡3';

  @override
  String get hlpLegendreEx3 => '(5/5) = 0';

  @override
  String get hlpJacobiTitle => '(a/n)ⱼ — simbol Jacobi';

  @override
  String get hlpJacobiParams => '2 parameter: a → (a/n)ⱼ → n → =';

  @override
  String get hlpJacobiDesc =>
      'Perumuman simbol Legendre untuk n ganjil komposit. Memakai resiprositas kuadratik.';

  @override
  String get hlpJacobiFormula => '(a/n) = ∏(a/pᵢ)^eᵢ dengan n = ∏pᵢ^eᵢ';

  @override
  String get hlpJacobiEx1 => '(2/15) = (2/3)(2/5) = (−1)(−1) = 1';

  @override
  String get hlpJacobiEx2 => '(a/n) = −1 ⟹ a BUKAN residu kuadratik';

  @override
  String get hlpJacobiEx3 => '(a/n) = 1 TIDAK menjamin sebaliknya';

  @override
  String get hlpPrimRootTitle => 'g — akar primitif';

  @override
  String get hlpPrimRootParams => '1 parameter';

  @override
  String get hlpPrimRootDesc =>
      'Akar primitif terkecil modulo n (bila ada). g disebut primitif jika ord_n(g) = φ(n).';

  @override
  String get hlpPrimRootFormula => '[g, g², ..., g^φ(n)] = (Z/nZ)*';

  @override
  String get hlpPrimRootEx1 => 'g(7) = 3 → [3,2,6,4,5,1]';

  @override
  String get hlpPrimRootEx2 => 'g(11) = 2';

  @override
  String get hlpPrimRootEx3 => 'Hanya ada untuk n = 1,2,4,p^k,2p^k';

  @override
  String get hlpGcdTitle => 'FPB — faktor persekutuan terbesar';

  @override
  String get hlpGcdParams => 'N parameter (berubah-ubah, min. 2)';

  @override
  String get hlpGcdDesc =>
      'Bilangan bulat terbesar yang membagi semua nilai. Menerima 2 bilangan atau lebih.';

  @override
  String get hlpGcdFormula => 'FPB(a,b) dengan algoritma Euclid';

  @override
  String get hlpGcdEx1 => 'FPB(12,18) = 6';

  @override
  String get hlpGcdEx2 => 'FPB(12,18,24) = 6';

  @override
  String get hlpGcdEx3 => 'FPB(a,b) × KPK(a,b) = a×b';

  @override
  String get hlpGcdTip1 => 'Urutan: 12 → FPB → 18 → FPB (dijalankan)';

  @override
  String get hlpGcdTip2 =>
      'Untuk 3 bilangan atau lebih: 12 → FPB → 18 → = → 24 → FPB';

  @override
  String get hlpGcdTip3 =>
      'Tekan = untuk menambah, tekan FPB untuk menjalankan';

  @override
  String get hlpLcmTitle => 'KPK — kelipatan persekutuan terkecil';

  @override
  String get hlpLcmParams => 'N parameter (berubah-ubah, min. 2)';

  @override
  String get hlpLcmDesc =>
      'Bilangan bulat positif terkecil yang habis dibagi semua nilai.';

  @override
  String get hlpLcmFormula => 'KPK(a,b) = a×b / FPB(a,b)';

  @override
  String get hlpLcmEx1 => 'KPK(4,6) = 12';

  @override
  String get hlpLcmEx2 => 'KPK(3,5,7) = 105';

  @override
  String get hlpLcmTip1 =>
      'Urutannya sama seperti FPB: tekan KPK sekali lagi untuk menjalankan';

  @override
  String get hlpDiophTitle => 'Dioph — persamaan Diophantine linear';

  @override
  String get hlpDiophParams => '3 parameter: a → Dioph → b → = → c → =';

  @override
  String get hlpDiophDesc =>
      'Menyelesaikan ax + by = c. Memberikan solusi khusus dan solusi umum.';

  @override
  String get hlpDiophFormula =>
      'ax + by = c punya solusi ⟺ FPB(a,b) | c\nx = x₀ + (b/g)t,  y = y₀ − (a/g)t';

  @override
  String get hlpDiophEx1 => '3x + 5y = 1 → x=2+5t, y=−1−3t';

  @override
  String get hlpDiophEx2 => '6x + 9y = 12 → x=2+3t, y=0−2t';

  @override
  String get hlpDiophEx3 => '4x + 6y = 3 → Tidak ada solusi';

  @override
  String get hlpDiophTip1 => 'Langkah 1: masukkan a (koefisien x)';

  @override
  String get hlpDiophTip2 => 'Langkah 2: tekan Dioph';

  @override
  String get hlpDiophTip3 => 'Langkah 3: masukkan b (koefisien y), tekan =';

  @override
  String get hlpDiophTip4 => 'Langkah 4: masukkan c (suku tetap), tekan =';

  @override
  String get hlpCrtTitle => 'CRT — Teorema Sisa Tiongkok';

  @override
  String get hlpCrtParams => 'Berubah-ubah (4+ parameter berpasangan a,m)';

  @override
  String get hlpCrtDesc => 'Menyelesaikan sistem kongruensi x ≡ aᵢ (mod mᵢ).';

  @override
  String get hlpCrtFormula =>
      'x ≡ a₁ (mod m₁)\nx ≡ a₂ (mod m₂)\n→ x ≡ r (mod KPK(m₁,m₂))';

  @override
  String get hlpCrtEx1 => 'x≡2(mod 3), x≡3(mod 5) → x≡8(mod 15)';

  @override
  String get hlpCrtEx2 => 'x≡1(mod 4), x≡2(mod 3) → x≡5(mod 12)';

  @override
  String get hlpCrtTip1 => 'Urutan: a₁ → CRT → m₁ → = → a₂ → = → m₂ → CRT';

  @override
  String get hlpCrtTip2 => 'Modulusnya harus saling cocok';

  @override
  String get hlpCombinatoricsHeader => 'Kombinatorika';

  @override
  String get hlpFactorialTitle => 'n! — Faktorial';

  @override
  String get hlpFactorialParams => '1 parameter';

  @override
  String get hlpFactorialDesc =>
      'Hasil kali dari 1 sampai n. Presisi sembarang.';

  @override
  String get hlpFactorialFormula => 'n! = 1 × 2 × ... × n,  0! = 1';

  @override
  String get hlpFactorialEx1 => '5! = 120';

  @override
  String get hlpFactorialEx2 => '10! = 3 628 800';

  @override
  String get hlpFactorialEx3 => '20! = 2 432 902 008 176 640 000';

  @override
  String get hlpDblFactorialTitle => 'n!! — faktorial ganda';

  @override
  String get hlpDblFactorialParams => '1 parameter';

  @override
  String get hlpDblFactorialDesc =>
      'Hasil kali bilangan bulat dengan paritas yang sama.';

  @override
  String get hlpDblFactorialFormula => 'n!! = n × (n−2) × (n−4) × ...';

  @override
  String get hlpDblFactorialEx1 => '7!! = 7×5×3×1 = 105';

  @override
  String get hlpDblFactorialEx2 => '8!! = 8×6×4×2 = 384';

  @override
  String get hlpDblFactorialEx3 => '0!! = 1!! = 1';

  @override
  String get hlpCombTitle => 'C(n,k) — kombinasi';

  @override
  String get hlpCombParams => '2 parameter: n → C(n,k) → k → =';

  @override
  String get hlpCombDesc =>
      'Banyak cara memilih k dari n tanpa memperhatikan urutan.';

  @override
  String get hlpCombFormula => 'C(n,k) = n! / (k!(n−k)!)';

  @override
  String get hlpCombEx1 => 'C(5,2) = 10';

  @override
  String get hlpCombEx2 => 'C(10,3) = 120';

  @override
  String get hlpCombEx3 => 'C(n,0) = C(n,n) = 1';

  @override
  String get hlpCombTip1 => 'Identitas Pascal: C(n,k) = C(n−1,k−1) + C(n−1,k)';

  @override
  String get hlpCombTip2 => 'C(n,k) = C(n, n−k)';

  @override
  String get hlpVarTitle => 'V(n,k) — permutasi parsial';

  @override
  String get hlpVarParams => '2 parameter: n → V(n,k) → k → =';

  @override
  String get hlpVarDesc =>
      'Banyak cara memilih k dari n DENGAN memperhatikan urutan.';

  @override
  String get hlpVarFormula => 'V(n,k) = n! / (n−k)!';

  @override
  String get hlpVarEx1 => 'V(5,2) = 20';

  @override
  String get hlpVarEx2 => 'V(10,3) = 720';

  @override
  String get hlpCatalanTitle => 'Cat(n) — bilangan Catalan';

  @override
  String get hlpCatalanParams => '1 parameter';

  @override
  String get hlpCatalanDesc =>
      'Menghitung pohon biner, triangulasi, lintasan Dyck, pasangan kurung yang seimbang.';

  @override
  String get hlpCatalanFormula => 'Cₙ = C(2n,n)/(n+1)';

  @override
  String get hlpCatalanEx1 => 'C₀ = 1, C₁ = 1, C₂ = 2';

  @override
  String get hlpCatalanEx2 => 'C₃ = 5, C₄ = 14, C₅ = 42';

  @override
  String get hlpDerangementTitle => 'D(n) — permutasi tanpa titik tetap';

  @override
  String get hlpDerangementParams => '1 parameter';

  @override
  String get hlpDerangementDesc =>
      'Permutasi yang tidak menyisakan satu pun unsur di posisi semula.';

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
  String get hlpBellTitle => 'B(n) — bilangan Bell';

  @override
  String get hlpBellParams => '1 parameter';

  @override
  String get hlpBellDesc =>
      'Jumlah seluruh partisi dari himpunan dengan n unsur.';

  @override
  String get hlpBellFormula => 'B(n) = Σ S₂(n,k) untuk k=0..n';

  @override
  String get hlpBellEx1 => 'B(3) = 5';

  @override
  String get hlpBellEx2 => 'B(4) = 15';

  @override
  String get hlpBellEx3 => 'B(5) = 52';

  @override
  String get hlpPartitionTitle => 'p(n) — partisi bilangan bulat';

  @override
  String get hlpPartitionParams => '1 parameter';

  @override
  String get hlpPartitionDesc =>
      'Banyak cara menulis n sebagai jumlah bilangan bulat positif (urutan tidak diperhatikan).';

  @override
  String get hlpPartitionFormula => 'Dihitung dengan pemrograman dinamis';

  @override
  String get hlpPartitionEx1 => 'p(4) = 5 → [4, 3+1, 2+2, 2+1+1, 1+1+1+1]';

  @override
  String get hlpPartitionEx2 => 'p(10) = 42';

  @override
  String get hlpPartitionEx3 => 'p(100) = 190 569 292 356';

  @override
  String get hlpStirling2Title => 'S₂(n,k) — bilangan Stirling jenis kedua';

  @override
  String get hlpStirling2Params => '2 parameter: n → S₂ → k → =';

  @override
  String get hlpStirling2Desc =>
      'Banyak cara mempartisi n unsur menjadi tepat k himpunan bagian tak kosong.';

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
      's₁(n,k) — bilangan Stirling jenis pertama (tanpa tanda)';

  @override
  String get hlpStirling1Params => '2 parameter: n → s₁ → k → =';

  @override
  String get hlpStirling1Desc => 'Permutasi n unsur dengan tepat k siklus.';

  @override
  String get hlpStirling1Formula =>
      '|s₁(n,k)| = (n−1)·|s₁(n−1,k)| + |s₁(n−1,k−1)|';

  @override
  String get hlpStirling1Ex1 => 's₁(4,2) = 11';

  @override
  String get hlpStirling1Ex2 => 's₁(4,1) = 6';

  @override
  String get hlpFibTitle => 'F(n) — bilangan Fibonacci ke-n';

  @override
  String get hlpFibParams => '1 parameter';

  @override
  String get hlpFibDesc =>
      'Menghitung F(n) dengan penggandaan cepat O(log n). Menerima n yang sangat besar.';

  @override
  String get hlpFibFormula => 'F(0)=0, F(1)=1, F(n)=F(n−1)+F(n−2)';

  @override
  String get hlpFibEx1 => 'F(10) = 55';

  @override
  String get hlpFibEx2 => 'F(50) = 12 586 269 025';

  @override
  String get hlpFibEx3 => 'F(100) = 354 224 848 179 261 915 075';

  @override
  String get hlpFibTip1 => 'F(n) mod m bersifat periodik (periode Pisano)';

  @override
  String get hlpFibTip2 => 'FPB(F(m), F(n)) = F(FPB(m,n))';

  @override
  String get hlpDigitSumBaseTitle => 'ΣdigB — jumlah digit dalam basis b';

  @override
  String get hlpDigitSumBaseParams => '2 parameter: n → ΣdigB → b → =';

  @override
  String get hlpDigitSumBaseDesc =>
      'Menjumlahkan digit n yang ditulis dalam basis b.';

  @override
  String get hlpDigitSumBaseFormula => 'Jika n = Σ dᵢ × bⁱ, maka ΣdigB = Σ dᵢ';

  @override
  String get hlpDigitSumBaseEx1 => 'ΣdigB(255, 2) = 8 → 11111111₂';

  @override
  String get hlpDigitSumBaseEx2 => 'ΣdigB(100, 10) = 1';

  @override
  String get hlpDigitSumBaseEx3 => 'ΣdigB(100, 16) = 10 → 64₁₆';

  @override
  String get hlpStatisticsHeader => 'Statistika';

  @override
  String get hlpArithMeanTitle => 'Rata-rata hitung — AM';

  @override
  String get hlpArithMeanParams => 'N parameter (berubah-ubah, min. 2)';

  @override
  String get hlpArithMeanDesc => 'Rata-rata biasa dari N bilangan.';

  @override
  String get hlpArithMeanFormula => 'AM = (x₁ + x₂ + ... + xₙ) / n';

  @override
  String get hlpArithMeanEx1 => 'AM(3, 7) = 5';

  @override
  String get hlpArithMeanEx2 => 'AM(2, 4, 6) = 4';

  @override
  String get hlpArithMeanTip1 => 'Urutan: 3 → AM → 7 → AM (dijalankan)';

  @override
  String get hlpArithMeanTip2 =>
      'Untuk 3 bilangan atau lebih: 2 → AM → 4 → = → 6 → AM';

  @override
  String get hlpGeoMeanTitle => 'Rata-rata ukur — GM';

  @override
  String get hlpGeoMeanParams => 'N parameter (berubah-ubah, min. 2)';

  @override
  String get hlpGeoMeanDesc =>
      'Akar pangkat n dari hasil kali. Hanya nilai positif.';

  @override
  String get hlpGeoMeanFormula => 'GM = (x₁ × x₂ × ... × xₙ)^(1/n)';

  @override
  String get hlpGeoMeanEx1 => 'GM(2, 8) = 4';

  @override
  String get hlpGeoMeanEx2 => 'GM(1, 4, 9) ≈ 3.30';

  @override
  String get hlpHarmMeanTitle => 'Rata-rata harmonik — HM';

  @override
  String get hlpHarmMeanParams => 'N parameter (berubah-ubah, min. 2)';

  @override
  String get hlpHarmMeanDesc =>
      'Kebalikan dari rata-rata hitung atas kebalikan nilainya. Hanya nilai positif.';

  @override
  String get hlpHarmMeanFormula => 'HM = n / (1/x₁ + 1/x₂ + ... + 1/xₙ)';

  @override
  String get hlpHarmMeanEx1 => 'HM(2, 8) = 3.2';

  @override
  String get hlpHarmMeanEx2 => 'HM(1, 4, 9) ≈ 2.08';

  @override
  String get hlpQuadMeanTitle => 'Rata-rata kuadratik — QM';

  @override
  String get hlpQuadMeanParams => 'N parameter (berubah-ubah, min. 2)';

  @override
  String get hlpQuadMeanDesc => 'Akar dari rata-rata kuadrat (RMS).';

  @override
  String get hlpQuadMeanFormula => 'QM = √((x₁² + x₂² + ... + xₙ²) / n)';

  @override
  String get hlpQuadMeanEx1 => 'QM(3, 4) ≈ 3.54';

  @override
  String get hlpQuadMeanEx2 => 'QM(1, 2, 3) ≈ 2.16';

  @override
  String get hlpMinMaxTitle => 'min / max — minimum dan maksimum';

  @override
  String get hlpMinMaxParams => 'N parameter (berubah-ubah, min. 2)';

  @override
  String get hlpMinMaxDesc =>
      'Mencari nilai terkecil/terbesar dari sekumpulan N bilangan.';

  @override
  String get hlpMinMaxFormula => 'min(a₁,...,aₙ) dan max(a₁,...,aₙ)';

  @override
  String get hlpMinMaxEx1 => 'min(3, 7, 1) = 1';

  @override
  String get hlpMinMaxEx2 => 'max(3, 7, 1) = 7';

  @override
  String get hlpMinMaxTip1 =>
      'Urutan berubah-ubah yang sama: tekan min/max sekali lagi untuk menjalankan';

  @override
  String get hlpMeanInequalityTitle => 'Ketaksamaan rata-rata (AM-GM-HM)';

  @override
  String get hlpMeanInequalityContent =>
      'Untuk bilangan positif selalu berlaku:\n\nHM ≤ GM ≤ AM ≤ QM\n\nKesamaan hanya terjadi bila semua nilainya sama.\nKetaksamaan ini mendasar dalam olimpiade.';

  @override
  String get hlpAnalysisPanelHeader => 'Panel analisis numerik';

  @override
  String get hlpAutoAnalysisTitle => 'Analisis otomatis';

  @override
  String get hlpAutoAnalysisContent =>
      'Begitu sebuah bilangan dimasukkan, panel kanan (tablet) atau panel bawah (ponsel) otomatis menampilkan:\n\n• Sifat: banyak digit, paritas, tanda\n• Representasi: biner, oktal, heksadesimal\n• Keprimaan: uji Miller-Rabin, faktorisasi lengkap\n• Prima tetangga: sebelum dan sesudah\n• Pembagi: daftar lengkap, jumlah, banyaknya\n• Klasifikasi: kuadrat/kubik sempurna, pangkat sempurna, Fibonacci, segitiga, palindrom\n\nUntuk bilangan sampai 15 digit, juga ditampilkan:\n\n• Fungsi aritmetika: φ, λ, μ, ω, Ω, sopfr, sopf, rad, dr\n• Klasifikasi: bebas kuadrat, bilangan kuat, Harshad, semiprima, berlebih/kurang/sempurna';

  @override
  String get hlpHighPrecHeader => 'Presisi tinggi dan alat';

  @override
  String get hlpHighPrecTitle => 'Mode presisi tinggi';

  @override
  String get hlpHighPrecContent =>
      'Aktifkan di Pengaturan. Menghitung sin, cos, tan, ln, log, exp, √ dan ∛ dengan bilangan real konstruktif yang EKSAK dan membulatkan hanya saat ditampilkan (5–100 digit). Tanpa galat titik-mengambang: √2 sampai 30 digit = 1.41421356237309504880168872421. Titik singular terdeteksi secara konstruktif (tan 90° = tak terdefinisi). Semuanya berjalan di latar belakang dengan indikator pemuatan, sehingga aplikasi tidak pernah membeku.';

  @override
  String get hlpNewToolsTitle => 'Alat Olimpiade';

  @override
  String get hlpNewToolsContent =>
      'Dari menu samping → Alat Olimpiade: Pecahan, Bentuk akar, Geometri (dengan gambar: segitiga, Pick, titik-titik istimewa dan garis Euler), Polinomial (grafik, skema Horner, sistem n×n), Aljabar (penjabaran dan identitas beberapa variabel), Teori bilangan (saringan, jam modular, residu), Prosedur langkah demi langkah, Bilangan kompleks (lingkaran satuan, Sierpiński — pada presisi tinggi), Statistika, Matriks (eksak), Kalkulus (turunan/integral/limit) dan Latihan dengan pemeriksaan jawaban.';

  @override
  String get hlpOlympiadHeader => 'Rumus olimpiade penting';

  @override
  String get hlpIdentitiesTitle => 'Identitas dasar';

  @override
  String get hlpIdentitiesContent =>
      '• Teorema Euler: a^φ(n) ≡ 1 (mod n) jika FPB(a,n)=1\n• Teorema kecil Fermat: a^(p−1) ≡ 1 (mod p) jika p prima\n• Wilson: (p−1)! ≡ −1 (mod p) ⟺ p prima\n• Rumus Legendre: Vₚ(n!) = Σᵢ ⌊n/pⁱ⌋\n• Lucas: C(n,k) mod p = ∏ C(nᵢ,kᵢ) mod p\n• Σ φ(d) untuk d|n = n\n• Σ μ(d) untuk d|n = [n=1]\n• φ(mn) = φ(m)φ(n)·FPB(m,n)/φ(FPB(m,n))\n• FPB(F(m),F(n)) = F(FPB(m,n))\n• AM ≥ GM ≥ HM (ketaksamaan rata-rata)';

  @override
  String get hlpRefTableTitle => 'Tabel rujukan singkat';

  @override
  String get hlpRefTableContent =>
      'n    φ(n)  λ(n)  μ(n)  σ(n)  ω  Ω\n1    1     1     1     1     0  0\n6    2     2     1     12    2  2\n12   4     2     0     28    2  3\n30   8     4     −1    72    3  3\n60   16    4     0     168   3  4\n100  40    20    0     217   2  4';

  @override
  String get hlpExamplesLabel => 'Contoh:';

  @override
  String get hlpTipsLabel => 'Tips:';

  @override
  String get errExprEmpty => 'Kesalahan: ekspresi kosong';

  @override
  String get errExprMalformed => 'Kesalahan: ekspresi tidak berbentuk sah';

  @override
  String get errExprDivZero => 'Kesalahan: pembagian dengan nol';

  @override
  String get errResultInvalid => 'Kesalahan: hasil tidak sah';

  @override
  String get errResultTooLarge =>
      'Hasilnya terlalu besar untuk dihitung secara eksak';

  @override
  String get errAnalysisInvalid =>
      'Kesalahan: bilangan tidak sah untuk dianalisis';

  @override
  String get errAnalysisFail => 'Bilangan tidak dapat dianalisis';

  @override
  String get errNoSolution => 'Tidak ada solusi';

  @override
  String get errIncompatibleSystem => 'Sistem tidak konsisten';

  @override
  String get errCRTNeedPairs => 'CRT memerlukan pasangan (aᵢ, mᵢ)';

  @override
  String errUnknownOp(String op) {
    return 'Operasi tidak dikenal: $op';
  }
}
