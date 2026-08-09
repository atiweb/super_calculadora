// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Máy tính Siêu việt';

  @override
  String get appVersion => 'Phiên bản 1.2.1';

  @override
  String get appDeveloped => 'Được phát triển bằng Flutter';

  @override
  String get appDynamicThemes => 'Có hỗ trợ giao diện động';

  @override
  String get navStandard => 'Chuẩn';

  @override
  String get navStandardSub => 'Các phép tính cơ bản';

  @override
  String get navScientific => 'Khoa học';

  @override
  String get navScientificSub => 'Các hàm nâng cao';

  @override
  String get navSpecial => 'Hàm đặc biệt';

  @override
  String get navSpecialSub => 'Số học';

  @override
  String get navHistory => 'Lịch sử';

  @override
  String get navHistorySub => 'Xem các phép tính trước';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get navSettingsSub => 'Cài đặt ứng dụng';

  @override
  String get navHelp => 'Trợ giúp';

  @override
  String get navHelpSub => 'Hướng dẫn các hàm đặc biệt';

  @override
  String get navAbout => 'Giới thiệu';

  @override
  String get navAboutSub => 'Máy tính Siêu việt v1.2.1';

  @override
  String get navCalculator => 'Máy tính';

  @override
  String get navSelectType => 'Chọn chế độ';

  @override
  String navAngleMode(String mode) {
    return 'Chế độ: $mode';
  }

  @override
  String get navRadians => 'Radian';

  @override
  String get navDegrees => 'Độ';

  @override
  String get calcAnalysis => 'Phân tích';

  @override
  String get calcExpressions => 'Biểu thức';

  @override
  String get calcScientific => 'Máy tính khoa học';

  @override
  String get calcSpecialFunctions => 'Hàm đặc biệt';

  @override
  String get calcSuperCalculator => 'Máy tính Siêu việt';

  @override
  String get calcNumericAnalysis => 'Phân tích số';

  @override
  String get calcMathExpressions => 'Biểu thức toán học';

  @override
  String get calcResult => 'Kết quả:';

  @override
  String get calcProcessing => 'Đang xử lý số lớn…';

  @override
  String get calcHighPrecision => 'Đang tính (độ chính xác cao)…';

  @override
  String get calcCancel => 'Huỷ';

  @override
  String get displayPaste => 'Dán';

  @override
  String get displayCopy => 'Sao chép';

  @override
  String displayCopied(String text) {
    return 'Đã sao chép: $text';
  }

  @override
  String get displayCopyResult => 'Sao chép kết quả';

  @override
  String get displayPasteNumber => 'Dán số';

  @override
  String get displayClearDisplay => 'Xoá màn hình';

  @override
  String get displayInvalidNumber =>
      'Lỗi: văn bản đã dán không phải là số hợp lệ';

  @override
  String get displayNothingToPaste => 'Không có gì để dán';

  @override
  String displayPasteError(String error) {
    return 'Lỗi khi dán: $error';
  }

  @override
  String displayPasted(String text) {
    return 'Đã dán: $text';
  }

  @override
  String get histTitle => 'Lịch sử';

  @override
  String get histClearAll => 'Xoá lịch sử';

  @override
  String get histClearAllTooltip => 'Xoá toàn bộ lịch sử';

  @override
  String get histConfirmClear => 'Bạn có chắc muốn xoá toàn bộ lịch sử không?';

  @override
  String histConfirmClearN(String count) {
    return 'Bạn có chắc muốn xoá cả $count phép tính trong lịch sử không? Thao tác này không thể hoàn tác.';
  }

  @override
  String get histCleared => 'Đã xoá lịch sử';

  @override
  String get histDeleted => 'Đã xoá lịch sử';

  @override
  String get histOperationDeleted => 'Đã xoá phép tính';

  @override
  String get histCopiedToClipboard => 'Đã sao chép vào bộ nhớ tạm';

  @override
  String histCopiedClipboardText(String text) {
    return 'Đã sao chép vào bộ nhớ tạm: $text';
  }

  @override
  String get histFullResult => 'Kết quả đầy đủ';

  @override
  String get histClose => 'Đóng';

  @override
  String get histExpression => 'Biểu thức:';

  @override
  String get histResult => 'Kết quả:';

  @override
  String get histCopyResult => 'Sao chép kết quả';

  @override
  String get histCopyAll => 'Sao chép tất cả';

  @override
  String get histCopyExpression => 'Sao chép biểu thức';

  @override
  String get histUseResult => 'Dùng kết quả';

  @override
  String get histViewResult => 'Xem kết quả';

  @override
  String get histDelete => 'Xoá';

  @override
  String get histEmpty => 'Chưa có phép tính nào trong lịch sử';

  @override
  String get histEmptyHint =>
      'Hãy thực hiện vài phép tính để thấy lịch sử ở đây';

  @override
  String get histEmptyHintAlt => 'Các phép tính bạn thực hiện sẽ hiện ở đây';

  @override
  String get histOperations => 'phép tính';

  @override
  String get histNow => 'Bây giờ';

  @override
  String histErrorLoading(String error) {
    return 'Lỗi khi tải lịch sử: $error';
  }

  @override
  String histErrorClearing(String error) {
    return 'Lỗi khi xoá lịch sử: $error';
  }

  @override
  String histErrorDeleting(String error) {
    return 'Lỗi khi xoá phép tính: $error';
  }

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsTheme => 'Giao diện';

  @override
  String get settingsNumberFormat => 'Định dạng số';

  @override
  String get settingsScientificNotation => 'Dùng ký hiệu khoa học';

  @override
  String get settingsScientificHint =>
      'Khi tắt, số sẽ hiển thị đầy đủ (vd: 123000)';

  @override
  String get settingsHighPrecision => 'Chế độ độ chính xác cao';

  @override
  String get settingsHighPrecisionHint =>
      'Tính sin, cos, tan, ln, √… bằng số thực kiến thiết chính xác (chậm hơn). Các điểm kỳ dị như tan 90° được báo là không xác định.';

  @override
  String settingsPrecisionDigits(int digits) {
    return 'Số chữ số chính xác: $digits';
  }

  @override
  String get settingsOpenSourceLicenses => 'Giấy phép nguồn mở';

  @override
  String get settingsFormatExamples => 'Ví dụ về định dạng';

  @override
  String get settingsLargeNumber => 'Số lớn:';

  @override
  String get settingsSmallNumber => 'Số nhỏ:';

  @override
  String get settingsNormal => 'Thường:';

  @override
  String get settingsScientific => 'Khoa học:';

  @override
  String get settingsAboutApp => 'Giới thiệu ứng dụng';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeAuto => 'Tự động';

  @override
  String get themeLightDesc => 'Luôn dùng giao diện sáng';

  @override
  String get themeDarkDesc => 'Luôn dùng giao diện tối';

  @override
  String get themeAutoDesc => 'Theo cài đặt hệ thống';

  @override
  String get aboutTitle => 'Máy tính Siêu việt';

  @override
  String get aboutDescription =>
      'Một máy tính nâng cao với đầy đủ chức năng khoa học và phân tích số.';

  @override
  String get aboutFeatures => 'Tính năng:';

  @override
  String get aboutClose => 'Đóng';

  @override
  String get aboutFeature1 => 'Số lên tới 1024 bit';

  @override
  String get aboutFeature2 => 'Độ chính xác thập phân 64 bit';

  @override
  String get aboutFeature3 => 'Chế độ máy tính chuẩn và khoa học';

  @override
  String get aboutFeature4 => 'Hàm lượng giác (sin, cos, tan)';

  @override
  String get aboutFeature5 => 'Hàm lượng giác ngược (asin, acos, atan)';

  @override
  String get aboutFeature6 => 'Lôgarit tự nhiên (ln) và cơ số 10 (log)';

  @override
  String get aboutFeature7 => 'Hàm mũ (eˣ, 10ˣ)';

  @override
  String get aboutFeature8 => 'Tính giai thừa (n!)';

  @override
  String get aboutFeature9 => 'Hằng số toán học (π, e)';

  @override
  String get aboutFeature10 => 'Luỹ thừa và căn (x², x³, √, ∛)';

  @override
  String get aboutFeature11 => 'Chuyển đổi độ và radian';

  @override
  String get aboutFeature12 => 'Phân tích số nguyên tố';

  @override
  String get aboutFeature13 => 'Phân tích ra thừa số nguyên tố';

  @override
  String get aboutFeature14 => 'Chuyển đổi nhị phân và thập phân';

  @override
  String get aboutFeature15 => 'Phân tích tính chất toán học';

  @override
  String get aboutFeature16 => 'Tính toán với số cực lớn';

  @override
  String get aboutFeature17 => 'Tính toán nặng chạy trên luồng riêng (isolate)';

  @override
  String get aboutFeature18 => 'Xử lý lỗi miền xác định và lỗi kích thước';

  @override
  String get aboutFeature19 =>
      'Công cụ Olympic: 11 nhóm chính xác (phân số, căn thức, hình học, đa thức, đại số, số học, ma trận…)';

  @override
  String get aboutFeature20 =>
      'Đại số ký hiệu: khai triển và hằng đẳng thức nhiều biến';

  @override
  String get exprMathExpression => 'Biểu thức toán học';

  @override
  String get exprHideHistory => 'Ẩn lịch sử';

  @override
  String get exprShowHistory => 'Hiện lịch sử';

  @override
  String get exprClearExpression => 'Xoá biểu thức';

  @override
  String get exprHint => 'Vd: (5 + 3) * sqrt(9) - 2^3';

  @override
  String get exprDelete => 'Xoá';

  @override
  String get exprEvaluate => 'Tính (Enter)';

  @override
  String get exprParenthesis => 'Dấu ngoặc';

  @override
  String get exprSquareRoot => 'Căn bậc hai';

  @override
  String get exprPower => 'Luỹ thừa';

  @override
  String get exprSin => 'Sin';

  @override
  String get exprCos => 'Cosin';

  @override
  String get exprTan => 'Tang';

  @override
  String get exprLog => 'Lôgarit';

  @override
  String get exprLn => 'Lôgarit tự nhiên';

  @override
  String get exprPi => 'Pi';

  @override
  String get exprEuler => 'Euler';

  @override
  String get analysisEnterNumber => 'Nhập một số để xem phân tích';

  @override
  String get analysisLoading => 'Đang phân tích số…';

  @override
  String get analysisLoadingHint => 'Với số lớn, việc này có thể mất một lúc';

  @override
  String get analysisLimited => 'Phân tích rút gọn';

  @override
  String get analysisExtremelyLarge => 'Số cực lớn';

  @override
  String analysisDigitsCount(String count) {
    return 'Số chữ số: $count';
  }

  @override
  String get analysisPrimalityNote => 'Ghi chú về kiểm tra tính nguyên tố';

  @override
  String analysisOriginalInput(String original, String analyzed) {
    return 'Dữ liệu nhập ban đầu: $original → Đã phân tích: $analyzed';
  }

  @override
  String get analysisCalculatingPrimes => 'Đang tìm số nguyên tố…';

  @override
  String get analysisSearchingPrimes =>
      'Đang tìm số nguyên tố liền trước và liền sau';

  @override
  String get analysisBasicProperties => 'Tính chất cơ bản';

  @override
  String get analysisValue => 'Giá trị';

  @override
  String get analysisIsPrime => 'Là số nguyên tố';

  @override
  String get analysisDigits => 'Chữ số';

  @override
  String get analysisNextPrime => 'Nguyên tố liền sau';

  @override
  String get analysisPrevPrime => 'Nguyên tố liền trước';

  @override
  String get analysisDigitSum => 'Tổng các chữ số';

  @override
  String get analysisBinary => 'Nhị phân';

  @override
  String get analysisYes => 'Có';

  @override
  String get analysisNo => 'Không';

  @override
  String get analysisRepresentations => 'Biểu diễn';

  @override
  String get analysisOctal => 'Octal';

  @override
  String get analysisHex => 'Thập lục phân';

  @override
  String get analysisMathAnalysis => 'Phân tích toán học';

  @override
  String get analysisIsPerfect => 'Là số hoàn hảo';

  @override
  String get analysisIsPalindrome => 'Là số đối xứng';

  @override
  String get analysisIsFibonacci => 'Là số Fibonacci';

  @override
  String get analysisIsTriangular => 'Là số tam giác';

  @override
  String get analysisPrimeFactors => 'Phân tích ra thừa số nguyên tố';

  @override
  String get analysisPrimeFactorsLabel => 'Thừa số nguyên tố';

  @override
  String get analysisDivisors => 'Ước số';

  @override
  String get analysisAllDivisors => 'Tất cả các ước';

  @override
  String get analysisDivisorCount => 'Số lượng ước';

  @override
  String get analysisArithmeticFunctions => 'Hàm số học';

  @override
  String get analysisEulerPhi => 'φ(n) Euler';

  @override
  String get analysisCarmichael => 'λ(n) Carmichael';

  @override
  String get analysisMobius => 'μ(n) Möbius';

  @override
  String get analysisSmallOmega => 'ω(n) ước nguyên tố phân biệt';

  @override
  String get analysisBigOmega => 'Ω(n) nguyên tố kể bội';

  @override
  String get analysisSopfr => 'sopfr(n) Σnguyên tố kể bội';

  @override
  String get analysisSopf => 'sopf(n) Σnguyên tố phân biệt';

  @override
  String get analysisRadical => 'rad(n) radical';

  @override
  String get analysisDigitalRoot => 'Căn số chữ số';

  @override
  String get analysisClassification => 'Phân loại';

  @override
  String get analysisSquareFree => 'Không có ước chính phương';

  @override
  String get analysisPowerful => 'Số mạnh';

  @override
  String get analysisHarshad => 'Harshad';

  @override
  String get analysisSemiprime => 'Nửa nguyên tố';

  @override
  String get analysisAbundant => 'Dư thừa';

  @override
  String get analysisDeficient => 'Thiếu hụt';

  @override
  String get analysisOperations => 'Phép tính';

  @override
  String get analysisSquare => 'Bình phương';

  @override
  String get analysisCube => 'Lập phương';

  @override
  String get analysisSquareRootLabel => 'Căn bậc hai';

  @override
  String get analysisIsPerfectSquare => 'Là số chính phương';

  @override
  String get analysisCubeRoot => 'Căn bậc ba';

  @override
  String get analysisIsPerfectCube => 'Là lập phương đúng';

  @override
  String get analysisPerfectPower => 'Luỹ thừa đúng';

  @override
  String get analysisExpression => 'Biểu thức';

  @override
  String get analysisBase => 'Base';

  @override
  String get analysisExponent => 'Số mũ';

  @override
  String get cardPrime => 'Nguyên tố';

  @override
  String get cardPerfect => 'Hoàn hảo';

  @override
  String get cardPalindrome => 'Đối xứng';

  @override
  String get cardFibonacci => 'Fibonacci';

  @override
  String get cardTriangular => 'Tam giác';

  @override
  String get cardEven => 'Chẵn';

  @override
  String get cardOdd => 'Lẻ';

  @override
  String get cardQuickProperties => 'Tính chất nhanh:';

  @override
  String get cardConvert => 'Chuyển đổi:';

  @override
  String get cardToDecimal => 'Sang thập phân';

  @override
  String get cardToBinary => 'Sang nhị phân';

  @override
  String get cardAdvancedOps => 'Phép tính nâng cao:';

  @override
  String get cardDigits => 'chữ số';

  @override
  String get kbdNumberTheory => 'Số học';

  @override
  String get kbdModularArith => 'Số học đồng dư';

  @override
  String get kbdCombinatorics => 'Tổ hợp';

  @override
  String get kbdStatistics => 'Thống kê';

  @override
  String errPower(String error) {
    return 'Lỗi luỹ thừa: $error';
  }

  @override
  String errSquareRoot(String error) {
    return 'Lỗi căn bậc hai: $error';
  }

  @override
  String get errNegativeSqrt => 'Không thể lấy căn bậc hai của số âm';

  @override
  String errCubeRoot(String error) {
    return 'Lỗi căn bậc ba: $error';
  }

  @override
  String errBinaryConversion(String error) {
    return 'Lỗi chuyển sang nhị phân: $error';
  }

  @override
  String get errEmptyBinary => 'Số nhị phân rỗng';

  @override
  String get errInvalidBinary =>
      'Số chỉ được chứa các chữ số nhị phân (0 và 1)';

  @override
  String errBinaryFromConversion(String error) {
    return 'Lỗi chuyển từ nhị phân: $error';
  }

  @override
  String get errTrigTooLarge => 'Số quá lớn cho các hàm lượng giác';

  @override
  String errSin(String error) {
    return 'Lỗi sin: $error';
  }

  @override
  String errCos(String error) {
    return 'Lỗi cosin: $error';
  }

  @override
  String get errTanUndefined => 'Tang không xác định tại góc này';

  @override
  String errTan(String error) {
    return 'Lỗi tang: $error';
  }

  @override
  String get errAsinDomain => 'Arcsin chỉ xác định với giá trị từ -1 đến 1';

  @override
  String errAsin(String error) {
    return 'Lỗi arcsin: $error';
  }

  @override
  String get errAcosDomain => 'Arccos chỉ xác định với giá trị từ -1 đến 1';

  @override
  String errAcos(String error) {
    return 'Lỗi arccos: $error';
  }

  @override
  String errAtan(String error) {
    return 'Lỗi arctan: $error';
  }

  @override
  String get errLnDomain => 'Lôgarit tự nhiên chỉ xác định với số dương';

  @override
  String get errLnTooLarge => 'Số quá lớn cho lôgarit tự nhiên';

  @override
  String errLn(String error) {
    return 'Lỗi lôgarit tự nhiên: $error';
  }

  @override
  String get errLogDomain => 'Lôgarit chỉ xác định với số dương';

  @override
  String get errLogTooLarge => 'Số quá lớn cho lôgarit cơ số 10';

  @override
  String errLog(String error) {
    return 'Lỗi lôgarit: $error';
  }

  @override
  String get errExpTooLarge => 'Số quá lớn cho hàm mũ';

  @override
  String errExp(String error) {
    return 'Lỗi hàm mũ: $error';
  }

  @override
  String get errTenPowTooLarge => 'Số quá lớn cho 10^x';

  @override
  String errTenPow(String error) {
    return 'Lỗi 10^x: $error';
  }

  @override
  String get errFactorialInvalid => 'Số không hợp lệ để tính giai thừa';

  @override
  String get errFactorialNonNeg =>
      'Giai thừa chỉ xác định với số nguyên không âm';

  @override
  String get errFactorialTooLarge =>
      'Số quá lớn để tính giai thừa (tối đa 170)';

  @override
  String errFactorial(String error) {
    return 'Lỗi giai thừa: $error';
  }

  @override
  String get errOperationCancelled => 'Đã huỷ phép tính';

  @override
  String errGeneric(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get errPhiDomain => 'φ(n) chỉ xác định khi n > 0';

  @override
  String errPhi(String error) {
    return 'Lỗi φ(n): $error';
  }

  @override
  String get errPrimorialDomain => 'Nguyên tố giai thừa chỉ xác định khi n ≥ 0';

  @override
  String errPrimorial(String error) {
    return 'Lỗi nguyên tố giai thừa: $error';
  }

  @override
  String get errSigma0Domain => 'σ₀(n) chỉ xác định khi n > 0';

  @override
  String errSigma0(String error) {
    return 'Lỗi σ₀(n): $error';
  }

  @override
  String get errSigmaDomain => 'σ(m,n) chỉ xác định khi n > 0';

  @override
  String errSigma(String error) {
    return 'Lỗi σ(m,n): $error';
  }

  @override
  String errFloorCeil(String error) {
    return 'Lỗi phần nguyên dưới/trên: $error';
  }

  @override
  String get errMobiusDomain => 'μ(n) chỉ xác định khi n > 0';

  @override
  String errMobius(String error) {
    return 'Lỗi μ(n): $error';
  }

  @override
  String get errFactorialNeg => 'Giai thừa không xác định với số âm';

  @override
  String get errFactorialMax => 'n! quá lớn (tối đa n=10000)';

  @override
  String errFactorialN(String error) {
    return 'Lỗi n!: $error';
  }

  @override
  String get errDoubleFactorialNeg => 'Giai thừa kép không xác định với số âm';

  @override
  String errDoubleFactorial(String error) {
    return 'Lỗi n!!: $error';
  }

  @override
  String get errFibonacciNeg => 'F(n) không xác định khi n < 0';

  @override
  String errFibonacci(String error) {
    return 'Lỗi F(n): $error';
  }

  @override
  String get errCatalanNeg => 'Số Catalan không xác định khi n < 0';

  @override
  String errCatalan(String error) {
    return 'Lỗi số Catalan: $error';
  }

  @override
  String get errDerangementNeg => 'D(n) không xác định khi n < 0';

  @override
  String errDerangement(String error) {
    return 'Lỗi D(n): $error';
  }

  @override
  String get errPartitionNeg => 'p(n) không xác định khi n < 0';

  @override
  String errPartition(String error) {
    return 'Lỗi p(n): $error';
  }

  @override
  String get errBellNeg => 'B(n) không xác định khi n < 0';

  @override
  String errBell(String error) {
    return 'Lỗi Bell(n): $error';
  }

  @override
  String errDigitalRoot(String error) {
    return 'Lỗi căn số chữ số: $error';
  }

  @override
  String get errPrimitiveRootDomain => 'Cần n > 1';

  @override
  String errNoPrimitiveRoot(String n) {
    return 'Không tồn tại căn nguyên thuỷ theo mod $n';
  }

  @override
  String get errLiouvilleDomain => 'λ_L(n) chỉ xác định khi n > 0';

  @override
  String errLiouville(String error) {
    return 'Lỗi λ_L(n): $error';
  }

  @override
  String errPrimeCounting(String error) {
    return 'Lỗi π(n): $error';
  }

  @override
  String get errRadDomain => 'rad(n) chỉ xác định khi n > 0';

  @override
  String errRad(String error) {
    return 'Lỗi rad(n): $error';
  }

  @override
  String get errOmegaDomain => 'ω(n) chỉ xác định khi n > 0';

  @override
  String errOmega(String error) {
    return 'Lỗi ω(n): $error';
  }

  @override
  String get errBigOmegaDomain => 'Ω(n) chỉ xác định khi n > 0';

  @override
  String errBigOmega(String error) {
    return 'Lỗi Ω(n): $error';
  }

  @override
  String get errCarmichaelDomain => 'λ(n) chỉ xác định khi n > 0';

  @override
  String errCarmichael(String error) {
    return 'Lỗi λ(n): $error';
  }

  @override
  String get errSopfrDomain => 'sopfr(n) chỉ xác định khi n > 0';

  @override
  String errSopfr(String error) {
    return 'Lỗi sopfr(n): $error';
  }

  @override
  String get errSopfDomain => 'sopf(n) chỉ xác định khi n > 0';

  @override
  String errSopf(String error) {
    return 'Lỗi sopf(n): $error';
  }

  @override
  String errPercentage(String error) {
    return 'Lỗi phần trăm: $error';
  }

  @override
  String get errDivisionByZero => 'Chia cho 0';

  @override
  String errReciprocal(String error) {
    return 'Lỗi nghịch đảo: $error';
  }

  @override
  String errNoInverse(String a, String n) {
    return 'Không tồn tại nghịch đảo modulo của $a mod $n';
  }

  @override
  String errModPow(String error) {
    return 'Lỗi luỹ thừa modulo: $error';
  }

  @override
  String errDiophantine(String error) {
    return 'Lỗi phương trình Diophantine: $error';
  }

  @override
  String errCRT(String error) {
    return 'Lỗi CRT: $error';
  }

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsLangAuto => 'Tự động (theo hệ thống)';

  @override
  String get settingsLangAutoDesc => 'Dùng ngôn ngữ của thiết bị';

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
  String get hlpTitle => 'Hướng dẫn các hàm đặc biệt';

  @override
  String get hlpQuickStartHeader => 'Bắt đầu nhanh';

  @override
  String get hlpQuickStartWelcome =>
      'Chào mừng đến với máy tính dành cho olympic';

  @override
  String get hlpQuickStartStep1 => 'Mở menu bên (☰) và chọn «Hàm đặc biệt»';

  @override
  String get hlpQuickStartStep2 =>
      'Bàn phím phía trên (cuộn được) có khoảng 40 hàm chia thành 4 phần';

  @override
  String get hlpQuickStartStep3 => 'Nhập một số rồi nhấn bất kỳ phím hàm nào';

  @override
  String get hlpQuickStartStep4 =>
      'Nếu hàm cần thêm giá trị, chỉ báo phép tính đang chờ sẽ xuất hiện';

  @override
  String get hlpQuickStartStep5 =>
      'Bảng bên hiển thị phân tích tự động của số vừa nhập';

  @override
  String get hlpQuickStartNote =>
      'Hàm 1 tham số chạy ngay lập tức.\nHàm từ 2 tham số trở lên hiện chỉ báo và chờ thêm giá trị.';

  @override
  String get hlpParamHeader => 'Hệ thống tham số';

  @override
  String get hlpParamTypesTitle => 'Các loại hàm theo số tham số';

  @override
  String get hlpParam1Title => '1 tham số (chạy ngay)';

  @override
  String get hlpParam1Desc => 'Nhập số → Nhấn hàm → Kết quả';

  @override
  String get hlpParam1Example => 'Vd: φ(12) → nhập 12, nhấn φ → hiện 4';

  @override
  String get hlpParam2Title => '2-3-4 tham số (cố định)';

  @override
  String get hlpParam2Desc =>
      'Nhập giá trị → Hàm → Giá trị → = → (lặp lại nếu cần)\nTự chạy khi đã đủ tham số.';

  @override
  String get hlpParam2Example => 'Vd: C(10,3) → nhập 10 → C(n,k) → 3 → =';

  @override
  String get hlpParamNTitle => 'N tham số (thay đổi)';

  @override
  String get hlpParamNDesc =>
      'Nhập giá trị → Hàm → Giá trị → = (thêm nữa)\nNhấn LẠI CHÍNH HÀM ĐÓ để thực hiện.';

  @override
  String get hlpParamNExample =>
      'Vd: ƯCLN(12,18,24) → 12 → ƯCLN → 18 → = → 24 → ƯCLN';

  @override
  String get hlpPendingOpTitle => 'Chỉ báo phép tính đang chờ';

  @override
  String get hlpPendingOpDesc =>
      'Khi một hàm còn chờ giá trị, trên màn hình hiện chỉ báo màu cho biết phép tính nào đang dở và còn thiếu gì.\n\nVí dụ: «C(10, _)» nghĩa là còn thiếu k để hoàn tất C(n,k).\n«ƯCLN(12, 18, _) [= thêm, ƯCLN giải]» là phép tính có số tham số thay đổi.';

  @override
  String get hlpNumberTheoryHeader => 'Số học';

  @override
  String get hlpEulerPhiTitle => 'φ(n) — hàm Euler';

  @override
  String get hlpEulerPhiParams => '1 param';

  @override
  String get hlpEulerPhiDesc =>
      'Đếm xem có bao nhiêu số nguyên từ 1 đến n nguyên tố cùng nhau với n (tức ƯCLN(k,n)=1).';

  @override
  String get hlpEulerPhiFormula =>
      'φ(n) = n × ∏(1 − 1/p) với mỗi số nguyên tố p | n';

  @override
  String get hlpEulerPhiEx1 => 'φ(1) = 1';

  @override
  String get hlpEulerPhiEx2 => 'φ(9) = 6 → [1,2,4,5,7,8]';

  @override
  String get hlpEulerPhiEx3 => 'φ(12) = 4 → [1,5,7,11]';

  @override
  String get hlpEulerPhiEx4 => 'φ(p) = p−1 với p nguyên tố';

  @override
  String get hlpEulerPhiTip1 =>
      'Có tính nhân: φ(mn) = φ(m)φ(n) nếu ƯCLN(m,n)=1';

  @override
  String get hlpEulerPhiTip2 =>
      'Định lý Euler: a^φ(n) ≡ 1 (mod n) nếu ƯCLN(a,n)=1';

  @override
  String get hlpEulerPhiTip3 => 'Σ φ(d) với d|n = n';

  @override
  String get hlpCarmichaelTitle => 'λ(n) — hàm λ Carmichael';

  @override
  String get hlpCarmichaelParams => '1 param';

  @override
  String get hlpCarmichaelDesc =>
      'Số m > 0 nhỏ nhất sao cho a^m ≡ 1 (mod n) với MỌI a nguyên tố cùng nhau với n. Luôn là ước của φ(n).';

  @override
  String get hlpCarmichaelFormula =>
      'λ(p^k) = φ(p^k) nếu p lẻ\nλ(2)=1, λ(4)=2, λ(2^k)=2^(k−2) nếu k≥3\nλ(n) = BCNN của các phần';

  @override
  String get hlpCarmichaelEx1 => 'λ(8) = 2';

  @override
  String get hlpCarmichaelEx2 => 'λ(15) = BCNN(λ(3),λ(5)) = BCNN(2,4) = 4';

  @override
  String get hlpCarmichaelEx3 => 'λ(p) = p−1 với p nguyên tố';

  @override
  String get hlpCarmichaelTip1 => 'λ(n) | φ(n) luôn đúng';

  @override
  String get hlpCarmichaelTip2 =>
      'λ(n) = φ(n) khi và chỉ khi n có căn nguyên thuỷ';

  @override
  String get hlpMobiusTitle => 'μ(n) — hàm Möbius';

  @override
  String get hlpMobiusParams => '1 param';

  @override
  String get hlpMobiusDesc =>
      'Cho biết n có ước chính phương hay không và đếm các thừa số nguyên tố.';

  @override
  String get hlpMobiusFormula =>
      'μ(1) = 1\nμ(n) = (−1)^k nếu n = p₁·p₂·...·pₖ (phân biệt)\nμ(n) = 0 nếu p² | n';

  @override
  String get hlpMobiusEx1 => 'μ(1) = 1';

  @override
  String get hlpMobiusEx2 => 'μ(6) = μ(2×3) = (−1)² = 1';

  @override
  String get hlpMobiusEx3 => 'μ(30) = μ(2×3×5) = (−1)³ = −1';

  @override
  String get hlpMobiusEx4 => 'μ(12) = 0 (có 2²)';

  @override
  String get hlpMobiusTip1 =>
      'Nghịch đảo Möbius: nếu g(n) = Σ f(d) với d|n thì f(n) = Σ μ(d)g(n/d)';

  @override
  String get hlpMobiusTip2 => 'Σ μ(d) với d|n = [n=1]';

  @override
  String get hlpLiouvilleTitle => 'λL(n) — hàm Liouville';

  @override
  String get hlpLiouvilleParams => '1 param';

  @override
  String get hlpLiouvilleDesc => 'Có tính nhân hoàn toàn: λL(n) = (−1)^Ω(n).';

  @override
  String get hlpLiouvilleFormula => 'λL(n) = (−1)^Ω(n)';

  @override
  String get hlpLiouvilleEx1 => 'λL(12) = (−1)³ = −1 (Ω(12)=3)';

  @override
  String get hlpLiouvilleEx2 => 'λL(36) = (−1)⁴ = 1 (Ω(36)=4)';

  @override
  String get hlpLiouvilleTip1 =>
      'Σ λL(d) với d|n = 1 nếu n là số chính phương, ngược lại bằng 0';

  @override
  String get hlpSmallOmegaTitle => 'ω(n) — số ước nguyên tố phân biệt';

  @override
  String get hlpSmallOmegaParams => '1 param';

  @override
  String get hlpSmallOmegaDesc => 'Đếm số lượng ước nguyên tố phân biệt của n.';

  @override
  String get hlpSmallOmegaFormula => 'ω(n) = k nếu n = p₁^a₁ × ... × pₖ^aₖ';

  @override
  String get hlpSmallOmegaEx1 => 'ω(12) = 2 → [2, 3]';

  @override
  String get hlpSmallOmegaEx2 => 'ω(30) = 3 → [2, 3, 5]';

  @override
  String get hlpSmallOmegaEx3 => 'ω(p^k) = 1';

  @override
  String get hlpBigOmegaTitle => 'Ω(n) — số ước nguyên tố kể cả bội';

  @override
  String get hlpBigOmegaParams => '1 param';

  @override
  String get hlpBigOmegaDesc => 'Tổng số thừa số nguyên tố, tính cả lặp lại.';

  @override
  String get hlpBigOmegaFormula => 'Ω(n) = a₁ + a₂ + ... + aₖ';

  @override
  String get hlpBigOmegaEx1 => 'Ω(12) = 3 → 2×2×3';

  @override
  String get hlpBigOmegaEx2 => 'Ω(72) = 5 → 2³×3² → 3+2';

  @override
  String get hlpBigOmegaEx3 => 'Ω(p) = 1, Ω(p²) = 2';

  @override
  String get hlpSigma0Title => 'σ₀(n) — số lượng ước';

  @override
  String get hlpSigma0Params => '1 param';

  @override
  String get hlpSigma0Desc => 'Tổng số ước dương của n.';

  @override
  String get hlpSigma0Formula =>
      'Nếu n = p₁^a₁ × ... × pₖ^aₖ\nσ₀(n) = (a₁+1)(a₂+1)...(aₖ+1)';

  @override
  String get hlpSigma0Ex1 => 'σ₀(12) = 6 → [1,2,3,4,6,12]';

  @override
  String get hlpSigma0Ex2 => 'σ₀(p) = 2';

  @override
  String get hlpSigma0Ex3 => 'σ₀(p²) = 3';

  @override
  String get hlpSigmaTitle => 'σ(n) — tổng các ước';

  @override
  String get hlpSigmaParams => '1 param';

  @override
  String get hlpSigmaDesc => 'Tổng tất cả các ước dương của n.';

  @override
  String get hlpSigmaFormula => 'σ(n) = Σ d với d | n';

  @override
  String get hlpSigmaEx1 => 'σ(6) = 1+2+3+6 = 12 (6 là số hoàn hảo)';

  @override
  String get hlpSigmaEx2 => 'σ(12) = 1+2+3+4+6+12 = 28';

  @override
  String get hlpSigmaEx3 => 'σ(p) = p+1';

  @override
  String get hlpSigmaTip1 => 'n hoàn hảo ⟺ σ(n) = 2n';

  @override
  String get hlpSigmaTip2 => 'n dư thừa ⟺ σ(n) > 2n';

  @override
  String get hlpSopfrTitle => 'sopfr(n) — tổng các nguyên tố kể cả bội';

  @override
  String get hlpSopfrParams => '1 param';

  @override
  String get hlpSopfrDesc => 'Cộng các thừa số nguyên tố có tính bội.';

  @override
  String get hlpSopfrFormula => 'sopfr(n) = a₁p₁ + a₂p₂ + ... + aₖpₖ';

  @override
  String get hlpSopfrEx1 => 'sopfr(12) = 2+2+3 = 7';

  @override
  String get hlpSopfrEx2 => 'sopfr(60) = 2+2+3+5 = 12';

  @override
  String get hlpSopfTitle => 'sopf(n) — tổng các nguyên tố phân biệt';

  @override
  String get hlpSopfParams => '1 param';

  @override
  String get hlpSopfDesc => 'Tổng các số nguyên tố phân biệt chia hết n.';

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
      'Tích các số nguyên tố phân biệt chia hết n (hàm trong giả thuyết abc).';

  @override
  String get hlpRadFormula => 'rad(n) = ∏ p với p nguyên tố, p | n';

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
  String get hlpPrimorialDesc => 'Tích tất cả các số nguyên tố ≤ n.';

  @override
  String get hlpPrimorialFormula => 'n# = ∏ p với p nguyên tố, p ≤ n';

  @override
  String get hlpPrimorialEx1 => '5# = 2×3×5 = 30';

  @override
  String get hlpPrimorialEx2 => '7# = 210';

  @override
  String get hlpPrimorialEx3 => '11# = 2310';

  @override
  String get hlpPrimeCountTitle => 'π(n) — hàm đếm số nguyên tố';

  @override
  String get hlpPrimeCountParams => '1 param';

  @override
  String get hlpPrimeCountDesc =>
      'Đếm số nguyên tố ≤ n. Chính xác khi n ≤ 1.000.000; lớn hơn thì xấp xỉ bằng Li(x).';

  @override
  String get hlpPrimeCountFormula => 'π(n) ~ n/ln(n) (định lý số nguyên tố)';

  @override
  String get hlpPrimeCountEx1 => 'π(10) = 4';

  @override
  String get hlpPrimeCountEx2 => 'π(100) = 25';

  @override
  String get hlpPrimeCountEx3 => 'π(1.000.000) = 78.498';

  @override
  String get hlpDigitalRootTitle => 'dr(n) — căn số chữ số';

  @override
  String get hlpDigitalRootParams => '1 param';

  @override
  String get hlpDigitalRootDesc =>
      'Cộng các chữ số lặp lại cho tới khi còn một chữ số.';

  @override
  String get hlpDigitalRootFormula => 'dr(n) = 1 + (n−1) mod 9  (với n > 0)';

  @override
  String get hlpDigitalRootEx1 => 'dr(493) → 4+9+3=16 → 1+6 = 7';

  @override
  String get hlpDigitalRootEx2 => 'dr(999) = 9';

  @override
  String get hlpDigitalRootEx3 => 'dr(n) ≡ n (mod 9)';

  @override
  String get hlpFloorCeilTitle => '⌊x⌋ / ⌈x⌉ — phần nguyên dưới và trên';

  @override
  String get hlpFloorCeilParams => '1 param';

  @override
  String get hlpFloorCeilDesc =>
      'Phần nguyên dưới: số nguyên lớn nhất ≤ x. Phần nguyên trên: số nguyên nhỏ nhất ≥ x. Phím chuyển qua lại giữa hai hàm.';

  @override
  String get hlpFloorCeilFormula => '⌊x⌋ ≤ x < ⌊x⌋+1\n⌈x⌉−1 < x ≤ ⌈x⌉';

  @override
  String get hlpFloorCeilEx1 => '⌊3,7⌋ = 3, ⌈3,7⌉ = 4';

  @override
  String get hlpFloorCeilEx2 => '⌊−2,3⌋ = −3, ⌈−2,3⌉ = −2';

  @override
  String get hlpFloorCeilEx3 => '⌊5⌋ = ⌈5⌉ = 5';

  @override
  String get hlpPadicTitle => 'Vₚ(n) — định giá p-adic';

  @override
  String get hlpPadicParams => '2 params: n → Vₚ → p → =';

  @override
  String get hlpPadicDesc => 'Luỹ thừa lớn nhất của số nguyên tố p chia hết n.';

  @override
  String get hlpPadicFormula => 'Vₚ(n) = max[k : p^k | n]';

  @override
  String get hlpPadicEx1 => 'V₂(24) = 3 → 24 = 2³×3';

  @override
  String get hlpPadicEx2 => 'V₃(81) = 4 → 81 = 3⁴';

  @override
  String get hlpPadicEx3 => 'V₅(100) = 2 → 100 = 2²×5²';

  @override
  String get hlpPadicTip1 => 'Công thức Legendre: Vₚ(n!) = Σ ⌊n/pⁱ⌋';

  @override
  String get hlpPadicTip2 => 'Vₚ(ab) = Vₚ(a) + Vₚ(b)';

  @override
  String get hlpModArithHeader => 'Số học đồng dư';

  @override
  String get hlpModTitle => 'a mod b — số dư của phép chia';

  @override
  String get hlpModParams => '2 params: a → mod → b → =';

  @override
  String get hlpModDesc => 'Số dư khi chia a cho b.';

  @override
  String get hlpModFormula => 'a mod b = a − b × ⌊a/b⌋';

  @override
  String get hlpModEx1 => '17 mod 5 = 2';

  @override
  String get hlpModEx2 => '23 mod 7 = 2';

  @override
  String get hlpModEx3 => '−8 mod 3 = 1';

  @override
  String get hlpModPowTitle => 'a^b mod n — luỹ thừa modulo';

  @override
  String get hlpModPowParams => '3 params: a → a%n → b → = → n → =';

  @override
  String get hlpModPowDesc =>
      'Tính a^b mod n hiệu quả bằng bình phương liên tiếp, độ phức tạp O(log b).';

  @override
  String get hlpModPowFormula =>
      'Phân tích b theo nhị phân rồi bình phương liên tiếp';

  @override
  String get hlpModPowEx1 => '2¹⁰⁰ mod 7 = 2';

  @override
  String get hlpModPowEx2 => '3¹³ mod 11 = 5';

  @override
  String get hlpModPowEx3 =>
      'Nền tảng của RSA và các phép kiểm tra tính nguyên tố';

  @override
  String get hlpModPowTip1 =>
      'Trình tự: nhập a → nhấn a%n → nhập b → nhấn = → nhập n → nhấn =';

  @override
  String get hlpModInvTitle => 'a⁻¹ mod n — nghịch đảo modulo';

  @override
  String get hlpModInvParams => '2 params: a → a⁻¹ → n → =';

  @override
  String get hlpModInvDesc =>
      'Tìm b sao cho a×b ≡ 1 (mod n). Chỉ tồn tại nếu ƯCLN(a,n) = 1.';

  @override
  String get hlpModInvFormula => 'Thuật toán Euclid mở rộng';

  @override
  String get hlpModInvEx1 => '3⁻¹ mod 7 = 5 → 3×5=15≡1';

  @override
  String get hlpModInvEx2 => '5⁻¹ mod 11 = 9 → 5×9=45≡1';

  @override
  String get hlpModInvEx3 => 'Không tồn tại nếu ƯCLN(a,n) ≠ 1';

  @override
  String get hlpOrdTitle => 'ord_n(a) — cấp của a theo modulo n';

  @override
  String get hlpOrdParams => '2 params: a → ord → n → =';

  @override
  String get hlpOrdDesc =>
      'Số k > 0 nhỏ nhất với a^k ≡ 1 (mod n). Cần ƯCLN(a,n)=1.';

  @override
  String get hlpOrdFormula => 'ord_n(a) = min[k > 0 : a^k ≡ 1 (mod n)]';

  @override
  String get hlpOrdEx1 => 'ord₇(2) = 3 → 2³=8≡1';

  @override
  String get hlpOrdEx2 => 'ord₁₀(3) = 4 → 3⁴=81≡1';

  @override
  String get hlpOrdTip1 => 'ord_n(a) luôn là ước của φ(n)';

  @override
  String get hlpOrdTip2 => 'a là căn nguyên thuỷ ⟺ ord_n(a) = φ(n)';

  @override
  String get hlpLegendreTitle => '(a/p) — ký hiệu Legendre';

  @override
  String get hlpLegendreParams => '2 params: a → (a/p) → p → =';

  @override
  String get hlpLegendreDesc =>
      'Bằng 1 nếu a là thặng dư bậc hai mod p, −1 nếu không, 0 nếu p|a. Cần p nguyên tố lẻ.';

  @override
  String get hlpLegendreFormula =>
      '(a/p) ≡ a^((p−1)/2) (mod p) — tiêu chuẩn Euler';

  @override
  String get hlpLegendreEx1 => '(2/7) = 1 → 3²≡2 (mod 7)';

  @override
  String get hlpLegendreEx2 => '(3/7) = −1 → không tồn tại x²≡3';

  @override
  String get hlpLegendreEx3 => '(5/5) = 0';

  @override
  String get hlpJacobiTitle => '(a/n)ⱼ — ký hiệu Jacobi';

  @override
  String get hlpJacobiParams => '2 params: a → (a/n)ⱼ → n → =';

  @override
  String get hlpJacobiDesc =>
      'Mở rộng ký hiệu Legendre cho n lẻ hợp số. Dùng luật thuận nghịch bậc hai.';

  @override
  String get hlpJacobiFormula => '(a/n) = ∏(a/pᵢ)^eᵢ với n = ∏pᵢ^eᵢ';

  @override
  String get hlpJacobiEx1 => '(2/15) = (2/3)(2/5) = (−1)(−1) = 1';

  @override
  String get hlpJacobiEx2 => '(a/n) = −1 ⟹ a KHÔNG phải thặng dư bậc hai';

  @override
  String get hlpJacobiEx3 => '(a/n) = 1 KHÔNG bảo đảm điều ngược lại';

  @override
  String get hlpPrimRootTitle => 'g — căn nguyên thuỷ';

  @override
  String get hlpPrimRootParams => '1 param';

  @override
  String get hlpPrimRootDesc =>
      'Căn nguyên thuỷ nhỏ nhất theo mod n (nếu có). g là căn nguyên thuỷ khi ord_n(g) = φ(n).';

  @override
  String get hlpPrimRootFormula => '[g, g², ..., g^φ(n)] = (Z/nZ)*';

  @override
  String get hlpPrimRootEx1 => 'g(7) = 3 → [3,2,6,4,5,1]';

  @override
  String get hlpPrimRootEx2 => 'g(11) = 2';

  @override
  String get hlpPrimRootEx3 => 'Chỉ tồn tại với n = 1,2,4,p^k,2p^k';

  @override
  String get hlpGcdTitle => 'ƯCLN — ước chung lớn nhất';

  @override
  String get hlpGcdParams => 'N tham số (thay đổi, tối thiểu 2)';

  @override
  String get hlpGcdDesc =>
      'Số nguyên lớn nhất chia hết mọi giá trị. Nhận từ 2 số trở lên.';

  @override
  String get hlpGcdFormula => 'ƯCLN(a,b) bằng thuật toán Euclid';

  @override
  String get hlpGcdEx1 => 'ƯCLN(12,18) = 6';

  @override
  String get hlpGcdEx2 => 'ƯCLN(12,18,24) = 6';

  @override
  String get hlpGcdEx3 => 'ƯCLN(a,b) × BCNN(a,b) = a×b';

  @override
  String get hlpGcdTip1 => 'Trình tự: 12 → ƯCLN → 18 → ƯCLN (thực hiện)';

  @override
  String get hlpGcdTip2 => 'Với 3 số trở lên: 12 → ƯCLN → 18 → = → 24 → ƯCLN';

  @override
  String get hlpGcdTip3 => 'Nhấn = để thêm số, nhấn ƯCLN để thực hiện';

  @override
  String get hlpLcmTitle => 'BCNN — bội chung nhỏ nhất';

  @override
  String get hlpLcmParams => 'N tham số (thay đổi, tối thiểu 2)';

  @override
  String get hlpLcmDesc => 'Số nguyên dương nhỏ nhất chia hết cho mọi giá trị.';

  @override
  String get hlpLcmFormula => 'BCNN(a,b) = a×b / ƯCLN(a,b)';

  @override
  String get hlpLcmEx1 => 'BCNN(4,6) = 12';

  @override
  String get hlpLcmEx2 => 'BCNN(3,5,7) = 105';

  @override
  String get hlpLcmTip1 =>
      'Cùng trình tự như ƯCLN: nhấn BCNN lần nữa để thực hiện';

  @override
  String get hlpDiophTitle => 'Dioph — phương trình Diophantine bậc nhất';

  @override
  String get hlpDiophParams => '3 tham số: a → Dioph → b → = → c → =';

  @override
  String get hlpDiophDesc =>
      'Giải ax + by = c. Cho nghiệm riêng và nghiệm tổng quát.';

  @override
  String get hlpDiophFormula =>
      'ax + by = c có nghiệm ⟺ ƯCLN(a,b) | c\nx = x₀ + (b/g)t,  y = y₀ − (a/g)t';

  @override
  String get hlpDiophEx1 => '3x + 5y = 1 → x=2+5t, y=−1−3t';

  @override
  String get hlpDiophEx2 => '6x + 9y = 12 → x=2+3t, y=0−2t';

  @override
  String get hlpDiophEx3 => '4x + 6y = 3 → Vô nghiệm';

  @override
  String get hlpDiophTip1 => 'Bước 1: nhập a (hệ số của x)';

  @override
  String get hlpDiophTip2 => 'Bước 2: nhấn Dioph';

  @override
  String get hlpDiophTip3 => 'Bước 3: nhập b (hệ số của y), nhấn =';

  @override
  String get hlpDiophTip4 => 'Bước 4: nhập c (hệ số tự do), nhấn =';

  @override
  String get hlpCrtTitle => 'CRT — định lý thặng dư Trung Hoa';

  @override
  String get hlpCrtParams => 'Thay đổi (từ 4 tham số, theo cặp a,m)';

  @override
  String get hlpCrtDesc => 'Giải hệ đồng dư x ≡ aᵢ (mod mᵢ).';

  @override
  String get hlpCrtFormula =>
      'x ≡ a₁ (mod m₁)\nx ≡ a₂ (mod m₂)\n→ x ≡ r (mod BCNN(m₁,m₂))';

  @override
  String get hlpCrtEx1 => 'x≡2(mod 3), x≡3(mod 5) → x≡8(mod 15)';

  @override
  String get hlpCrtEx2 => 'x≡1(mod 4), x≡2(mod 3) → x≡5(mod 12)';

  @override
  String get hlpCrtTip1 => 'Trình tự: a₁ → CRT → m₁ → = → a₂ → = → m₂ → CRT';

  @override
  String get hlpCrtTip2 => 'Các modulo phải tương thích với nhau';

  @override
  String get hlpCombinatoricsHeader => 'Tổ hợp';

  @override
  String get hlpFactorialTitle => 'n! — Factorial';

  @override
  String get hlpFactorialParams => '1 param';

  @override
  String get hlpFactorialDesc => 'Tích từ 1 đến n. Độ chính xác tuỳ ý.';

  @override
  String get hlpFactorialFormula => 'n! = 1 × 2 × ... × n,  0! = 1';

  @override
  String get hlpFactorialEx1 => '5! = 120';

  @override
  String get hlpFactorialEx2 => '10! = 3.628.800';

  @override
  String get hlpFactorialEx3 => '20! = 2.432.902.008.176.640.000';

  @override
  String get hlpDblFactorialTitle => 'n!! — giai thừa kép';

  @override
  String get hlpDblFactorialParams => '1 param';

  @override
  String get hlpDblFactorialDesc => 'Tích các số nguyên cùng tính chẵn lẻ.';

  @override
  String get hlpDblFactorialFormula => 'n!! = n × (n−2) × (n−4) × ...';

  @override
  String get hlpDblFactorialEx1 => '7!! = 7×5×3×1 = 105';

  @override
  String get hlpDblFactorialEx2 => '8!! = 8×6×4×2 = 384';

  @override
  String get hlpDblFactorialEx3 => '0!! = 1!! = 1';

  @override
  String get hlpCombTitle => 'C(n,k) — tổ hợp';

  @override
  String get hlpCombParams => '2 params: n → C(n,k) → k → =';

  @override
  String get hlpCombDesc => 'Số cách chọn k phần tử từ n, không kể thứ tự.';

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
      'Hằng đẳng thức Pascal: C(n,k) = C(n−1,k−1) + C(n−1,k)';

  @override
  String get hlpCombTip2 => 'C(n,k) = C(n, n−k)';

  @override
  String get hlpVarTitle => 'V(n,k) — chỉnh hợp';

  @override
  String get hlpVarParams => '2 params: n → V(n,k) → k → =';

  @override
  String get hlpVarDesc => 'Số cách chọn k phần tử từ n CÓ kể thứ tự.';

  @override
  String get hlpVarFormula => 'V(n,k) = n! / (n−k)!';

  @override
  String get hlpVarEx1 => 'V(5,2) = 20';

  @override
  String get hlpVarEx2 => 'V(10,3) = 720';

  @override
  String get hlpCatalanTitle => 'Cat(n) — số Catalan';

  @override
  String get hlpCatalanParams => '1 param';

  @override
  String get hlpCatalanDesc =>
      'Đếm cây nhị phân, phép tam giác phân, đường đi Dyck, cách đặt ngoặc hợp lệ.';

  @override
  String get hlpCatalanFormula => 'Cₙ = C(2n,n)/(n+1)';

  @override
  String get hlpCatalanEx1 => 'C₀ = 1, C₁ = 1, C₂ = 2';

  @override
  String get hlpCatalanEx2 => 'C₃ = 5, C₄ = 14, C₅ = 42';

  @override
  String get hlpDerangementTitle => 'D(n) — hoán vị mất thứ tự';

  @override
  String get hlpDerangementParams => '1 param';

  @override
  String get hlpDerangementDesc =>
      'Hoán vị mà không phần tử nào còn ở vị trí ban đầu.';

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
  String get hlpBellTitle => 'B(n) — số Bell';

  @override
  String get hlpBellParams => '1 param';

  @override
  String get hlpBellDesc => 'Tổng số cách phân hoạch một tập n phần tử.';

  @override
  String get hlpBellFormula => 'B(n) = Σ S₂(n,k) với k=0..n';

  @override
  String get hlpBellEx1 => 'B(3) = 5';

  @override
  String get hlpBellEx2 => 'B(4) = 15';

  @override
  String get hlpBellEx3 => 'B(5) = 52';

  @override
  String get hlpPartitionTitle => 'p(n) — phân hoạch số nguyên';

  @override
  String get hlpPartitionParams => '1 param';

  @override
  String get hlpPartitionDesc =>
      'Số cách viết n thành tổng các số nguyên dương (không kể thứ tự).';

  @override
  String get hlpPartitionFormula => 'Tính bằng quy hoạch động';

  @override
  String get hlpPartitionEx1 => 'p(4) = 5 → [4, 3+1, 2+2, 2+1+1, 1+1+1+1]';

  @override
  String get hlpPartitionEx2 => 'p(10) = 42';

  @override
  String get hlpPartitionEx3 => 'p(100) = 190.569.292.356';

  @override
  String get hlpStirling2Title => 'S₂(n,k) — số Stirling loại hai';

  @override
  String get hlpStirling2Params => '2 params: n → S₂ → k → =';

  @override
  String get hlpStirling2Desc =>
      'Số cách chia n phần tử thành đúng k tập con khác rỗng.';

  @override
  String get hlpStirling2Formula => 'S₂(n,k) = k·S₂(n−1,k) + S₂(n−1,k−1)';

  @override
  String get hlpStirling2Ex1 => 'S₂(4,2) = 7';

  @override
  String get hlpStirling2Ex2 => 'S₂(5,3) = 25';

  @override
  String get hlpStirling2Ex3 => 'B(n) = Σ S₂(n,k)';

  @override
  String get hlpStirling1Title => 's₁(n,k) — số Stirling loại một (không dấu)';

  @override
  String get hlpStirling1Params => '2 params: n → s₁ → k → =';

  @override
  String get hlpStirling1Desc =>
      'Số hoán vị của n phần tử có đúng k chu trình.';

  @override
  String get hlpStirling1Formula =>
      '|s₁(n,k)| = (n−1)·|s₁(n−1,k)| + |s₁(n−1,k−1)|';

  @override
  String get hlpStirling1Ex1 => 's₁(4,2) = 11';

  @override
  String get hlpStirling1Ex2 => 's₁(4,1) = 6';

  @override
  String get hlpFibTitle => 'F(n) — số Fibonacci thứ n';

  @override
  String get hlpFibParams => '1 param';

  @override
  String get hlpFibDesc =>
      'Tính F(n) bằng nhân đôi nhanh O(log n). Nhận n rất lớn.';

  @override
  String get hlpFibFormula => 'F(0)=0, F(1)=1, F(n)=F(n−1)+F(n−2)';

  @override
  String get hlpFibEx1 => 'F(10) = 55';

  @override
  String get hlpFibEx2 => 'F(50) = 12.586.269.025';

  @override
  String get hlpFibEx3 => 'F(100) = 354.224.848.179.261.915.075';

  @override
  String get hlpFibTip1 => 'F(n) mod m tuần hoàn (chu kỳ Pisano)';

  @override
  String get hlpFibTip2 => 'ƯCLN(F(m), F(n)) = F(ƯCLN(m,n))';

  @override
  String get hlpDigitSumBaseTitle => 'ΣcsB — tổng chữ số trong cơ số b';

  @override
  String get hlpDigitSumBaseParams => '2 tham số: n → ΣcsB → b → =';

  @override
  String get hlpDigitSumBaseDesc =>
      'Cộng các chữ số của n khi viết trong cơ số b.';

  @override
  String get hlpDigitSumBaseFormula => 'Nếu n = Σ dᵢ × bⁱ thì ΣcsB = Σ dᵢ';

  @override
  String get hlpDigitSumBaseEx1 => 'ΣcsB(255, 2) = 8 → 11111111₂';

  @override
  String get hlpDigitSumBaseEx2 => 'ΣcsB(100, 10) = 1';

  @override
  String get hlpDigitSumBaseEx3 => 'ΣcsB(100, 16) = 10 → 64₁₆';

  @override
  String get hlpStatisticsHeader => 'Thống kê';

  @override
  String get hlpArithMeanTitle => 'Trung bình cộng — AM';

  @override
  String get hlpArithMeanParams => 'N tham số (thay đổi, tối thiểu 2)';

  @override
  String get hlpArithMeanDesc => 'Trung bình quen thuộc của N số.';

  @override
  String get hlpArithMeanFormula => 'AM = (x₁ + x₂ + ... + xₙ) / n';

  @override
  String get hlpArithMeanEx1 => 'AM(3, 7) = 5';

  @override
  String get hlpArithMeanEx2 => 'AM(2, 4, 6) = 4';

  @override
  String get hlpArithMeanTip1 => 'Trình tự: 3 → AM → 7 → AM (thực hiện)';

  @override
  String get hlpArithMeanTip2 => 'Với 3 số trở lên: 2 → AM → 4 → = → 6 → AM';

  @override
  String get hlpGeoMeanTitle => 'Trung bình nhân — GM';

  @override
  String get hlpGeoMeanParams => 'N tham số (thay đổi, tối thiểu 2)';

  @override
  String get hlpGeoMeanDesc => 'Căn bậc n của tích. Chỉ nhận giá trị dương.';

  @override
  String get hlpGeoMeanFormula => 'GM = (x₁ × x₂ × ... × xₙ)^(1/n)';

  @override
  String get hlpGeoMeanEx1 => 'GM(2, 8) = 4';

  @override
  String get hlpGeoMeanEx2 => 'GM(1, 4, 9) ≈ 3,30';

  @override
  String get hlpHarmMeanTitle => 'Trung bình điều hoà — HM';

  @override
  String get hlpHarmMeanParams => 'N tham số (thay đổi, tối thiểu 2)';

  @override
  String get hlpHarmMeanDesc =>
      'Nghịch đảo của trung bình cộng các nghịch đảo. Chỉ nhận giá trị dương.';

  @override
  String get hlpHarmMeanFormula => 'HM = n / (1/x₁ + 1/x₂ + ... + 1/xₙ)';

  @override
  String get hlpHarmMeanEx1 => 'HM(2, 8) = 3,2';

  @override
  String get hlpHarmMeanEx2 => 'HM(1, 4, 9) ≈ 2,08';

  @override
  String get hlpQuadMeanTitle => 'Trung bình bậc hai — QM';

  @override
  String get hlpQuadMeanParams => 'N tham số (thay đổi, tối thiểu 2)';

  @override
  String get hlpQuadMeanDesc => 'Căn của trung bình các bình phương (RMS).';

  @override
  String get hlpQuadMeanFormula => 'QM = √((x₁² + x₂² + ... + xₙ²) / n)';

  @override
  String get hlpQuadMeanEx1 => 'QM(3, 4) ≈ 3,54';

  @override
  String get hlpQuadMeanEx2 => 'QM(1, 2, 3) ≈ 2,16';

  @override
  String get hlpMinMaxTitle => 'min / max — nhỏ nhất và lớn nhất';

  @override
  String get hlpMinMaxParams => 'N tham số (thay đổi, tối thiểu 2)';

  @override
  String get hlpMinMaxDesc => 'Tìm giá trị nhỏ nhất/lớn nhất trong N số.';

  @override
  String get hlpMinMaxFormula => 'min(a₁,...,aₙ) và max(a₁,...,aₙ)';

  @override
  String get hlpMinMaxEx1 => 'min(3, 7, 1) = 1';

  @override
  String get hlpMinMaxEx2 => 'max(3, 7, 1) = 7';

  @override
  String get hlpMinMaxTip1 =>
      'Cùng trình tự thay đổi: nhấn lại min/max để thực hiện';

  @override
  String get hlpMeanInequalityTitle => 'Bất đẳng thức AM-GM (Cauchy)';

  @override
  String get hlpMeanInequalityContent =>
      'Với các số dương ta luôn có:\n\nHM ≤ GM ≤ AM ≤ QM\n\nDấu bằng chỉ xảy ra khi tất cả các giá trị bằng nhau.\nĐây là bất đẳng thức nền tảng trong các kỳ olympic.';

  @override
  String get hlpAnalysisPanelHeader => 'Bảng phân tích số';

  @override
  String get hlpAutoAnalysisTitle => 'Phân tích tự động';

  @override
  String get hlpAutoAnalysisContent =>
      'Khi nhập bất kỳ số nào, bảng bên phải (máy tính bảng) hoặc bảng phía dưới (điện thoại) tự động hiển thị:\n\n• Tính chất: số chữ số, tính chẵn lẻ, dấu\n• Biểu diễn: nhị phân, bát phân, thập lục phân\n• Tính nguyên tố: kiểm tra Miller-Rabin, phân tích đầy đủ\n• Số nguyên tố lân cận: liền trước và liền sau\n• Ước số: danh sách đầy đủ, tổng, số lượng\n• Phân loại: số chính phương/lập phương đúng, luỹ thừa đúng, Fibonacci, tam giác, đối xứng\n\nVới số không quá 15 chữ số, còn hiển thị thêm:\n\n• Hàm số học: φ, λ, μ, ω, Ω, sopfr, sopf, rad, dr\n• Phân loại: không có ước chính phương, số mạnh, Harshad, nửa nguyên tố, dư thừa/thiếu hụt/hoàn hảo';

  @override
  String get hlpHighPrecHeader => 'Độ chính xác cao và công cụ';

  @override
  String get hlpHighPrecTitle => 'Chế độ độ chính xác cao';

  @override
  String get hlpHighPrecContent =>
      'Bật trong phần Cài đặt. Tính sin, cos, tan, ln, log, exp, √ và ∛ bằng số thực kiến thiết CHÍNH XÁC, chỉ làm tròn khi hiển thị (từ 5 đến 100 chữ số). Không có sai số dấu phẩy động: √2 với 30 chữ số = 1,41421356237309504880168872421. Các điểm kỳ dị được phát hiện ngay từ cách xây dựng (tan 90° = không xác định). Mọi thứ chạy nền kèm chỉ báo tải, nên ứng dụng không bao giờ bị treo.';

  @override
  String get hlpNewToolsTitle => 'Công cụ Olympic';

  @override
  String get hlpNewToolsContent =>
      'Từ menu bên → Công cụ Olympic: Phân số, Căn thức, Hình học (có hình vẽ: tam giác, Pick, các điểm đặc biệt và đường thẳng Euler), Đa thức (đồ thị, sơ đồ Horner, hệ n×n), Đại số (khai triển và hằng đẳng thức nhiều biến), Số học (sàng, đồng hồ modulo, thặng dư), Lời giải từng bước, Số phức (đường tròn đơn vị, Sierpiński — ở độ chính xác cao), Thống kê, Ma trận (chính xác), Giải tích (đạo hàm/tích phân/giới hạn) và phần Luyện tập có chấm điểm.';

  @override
  String get hlpOlympiadHeader => 'Các công thức olympic quan trọng';

  @override
  String get hlpIdentitiesTitle => 'Hằng đẳng thức nền tảng';

  @override
  String get hlpIdentitiesContent =>
      '• Định lý Euler: a^φ(n) ≡ 1 (mod n) nếu ƯCLN(a,n)=1\n• Định lý Fermat nhỏ: a^(p−1) ≡ 1 (mod p) nếu p nguyên tố\n• Wilson: (p−1)! ≡ −1 (mod p) ⟺ p nguyên tố\n• Công thức Legendre: Vₚ(n!) = Σᵢ ⌊n/pⁱ⌋\n• Lucas: C(n,k) mod p = ∏ C(nᵢ,kᵢ) mod p\n• Σ φ(d) với d|n = n\n• Σ μ(d) với d|n = [n=1]\n• φ(mn) = φ(m)φ(n)·ƯCLN(m,n)/φ(ƯCLN(m,n))\n• ƯCLN(F(m),F(n)) = F(ƯCLN(m,n))\n• AM ≥ GM ≥ HM (bất đẳng thức AM-GM)';

  @override
  String get hlpRefTableTitle => 'Bảng tra nhanh';

  @override
  String get hlpRefTableContent =>
      'n    φ(n)  λ(n)  μ(n)  σ(n)  ω  Ω\n1    1     1     1     1     0  0\n6    2     2     1     12    2  2\n12   4     2     0     28    2  3\n30   8     4     −1    72    3  3\n60   16    4     0     168   3  4\n100  40    20    0     217   2  4';

  @override
  String get hlpExamplesLabel => 'Ví dụ:';

  @override
  String get hlpTipsLabel => 'Tips:';

  @override
  String get errExprEmpty => 'Lỗi: biểu thức rỗng';

  @override
  String get errExprMalformed => 'Lỗi: biểu thức sai cú pháp';

  @override
  String get errExprDivZero => 'Lỗi: chia cho 0';

  @override
  String get errResultInvalid => 'Lỗi: kết quả không hợp lệ';

  @override
  String get errResultTooLarge => 'Kết quả quá lớn để tính chính xác';

  @override
  String get errAnalysisInvalid => 'Lỗi: số không hợp lệ để phân tích';

  @override
  String get errAnalysisFail => 'Không thể phân tích số này';

  @override
  String get errNoSolution => 'Vô nghiệm';

  @override
  String get errIncompatibleSystem => 'Hệ không tương thích';

  @override
  String get errCRTNeedPairs => 'CRT cần các cặp (aᵢ, mᵢ)';

  @override
  String errUnknownOp(String op) {
    return 'Phép tính không xác định: $op';
  }
}
