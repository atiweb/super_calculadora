import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

/// Translates error keys stored in CalculatorService into localized strings.
///
/// The service stores error identifiers (keys) and optional arguments.
/// This utility resolves them to user-facing translated strings using
/// the current locale's AppLocalizations.
String localizeError(BuildContext context, String key, [Map<String, String> args = const {}]) {
  final l = AppLocalizations.of(context)!;
  final err = args['error'] ?? '';
  final a = args['a'] ?? '';
  final n = args['n'] ?? '';
  final op = args['op'] ?? '';

  switch (key) {
    // === Generic ===
    case 'errGeneric': return l.errGeneric(err);
    case 'errOperationCancelled': return l.errOperationCancelled;

    // === Expression evaluation ===
    case 'errExprEmpty': return l.errExprEmpty;
    case 'errExprMalformed': return l.errExprMalformed;
    case 'errExprDivZero': return l.errExprDivZero;
    case 'errResultInvalid': return l.errResultInvalid;
    case 'errResultTooLarge': return l.errResultTooLarge;

    // === Analysis ===
    case 'errAnalysisInvalid': return l.errAnalysisInvalid;
    case 'errAnalysisFail': return l.errAnalysisFail;

    // === Power / Roots ===
    case 'errPower': return l.errPower(err);
    case 'errSquareRoot': return l.errSquareRoot(err);
    case 'errNegativeSqrt': return l.errNegativeSqrt;
    case 'errCubeRoot': return l.errCubeRoot(err);

    // === Binary conversion ===
    case 'errBinaryConversion': return l.errBinaryConversion(err);
    case 'errEmptyBinary': return l.errEmptyBinary;
    case 'errInvalidBinary': return l.errInvalidBinary;
    case 'errBinaryFromConversion': return l.errBinaryFromConversion(err);

    // === Trigonometric ===
    case 'errTrigTooLarge': return l.errTrigTooLarge;
    case 'errSin': return l.errSin(err);
    case 'errCos': return l.errCos(err);
    case 'errTanUndefined': return l.errTanUndefined;
    case 'errTan': return l.errTan(err);
    case 'errAsinDomain': return l.errAsinDomain;
    case 'errAsin': return l.errAsin(err);
    case 'errAcosDomain': return l.errAcosDomain;
    case 'errAcos': return l.errAcos(err);
    case 'errAtan': return l.errAtan(err);

    // === Logarithm / Exponential ===
    case 'errLnDomain': return l.errLnDomain;
    case 'errLnTooLarge': return l.errLnTooLarge;
    case 'errLn': return l.errLn(err);
    case 'errLogDomain': return l.errLogDomain;
    case 'errLogTooLarge': return l.errLogTooLarge;
    case 'errLog': return l.errLog(err);
    case 'errExpTooLarge': return l.errExpTooLarge;
    case 'errExp': return l.errExp(err);
    case 'errTenPowTooLarge': return l.errTenPowTooLarge;
    case 'errTenPow': return l.errTenPow(err);

    // === Factorial (scientific keyboard) ===
    case 'errFactorialInvalid': return l.errFactorialInvalid;
    case 'errFactorialNonNeg': return l.errFactorialNonNeg;
    case 'errFactorialTooLarge': return l.errFactorialTooLarge;
    case 'errFactorial': return l.errFactorial(err);

    // === Number theory ===
    case 'errPhiDomain': return l.errPhiDomain;
    case 'errPhi': return l.errPhi(err);
    case 'errPrimorialDomain': return l.errPrimorialDomain;
    case 'errPrimorial': return l.errPrimorial(err);
    case 'errSigma0Domain': return l.errSigma0Domain;
    case 'errSigma0': return l.errSigma0(err);
    case 'errSigmaDomain': return l.errSigmaDomain;
    case 'errSigma': return l.errSigma(err);
    case 'errFloorCeil': return l.errFloorCeil(err);
    case 'errMobiusDomain': return l.errMobiusDomain;
    case 'errMobius': return l.errMobius(err);
    case 'errLiouvilleDomain': return l.errLiouvilleDomain;
    case 'errLiouville': return l.errLiouville(err);
    case 'errPrimeCounting': return l.errPrimeCounting(err);
    case 'errRadDomain': return l.errRadDomain;
    case 'errRad': return l.errRad(err);
    case 'errOmegaDomain': return l.errOmegaDomain;
    case 'errOmega': return l.errOmega(err);
    case 'errBigOmegaDomain': return l.errBigOmegaDomain;
    case 'errBigOmega': return l.errBigOmega(err);
    case 'errCarmichaelDomain': return l.errCarmichaelDomain;
    case 'errCarmichael': return l.errCarmichael(err);
    case 'errSopfrDomain': return l.errSopfrDomain;
    case 'errSopfr': return l.errSopfr(err);
    case 'errSopfDomain': return l.errSopfDomain;
    case 'errSopf': return l.errSopf(err);

    // === Special combinatorics (special keyboard) ===
    case 'errFactorialNeg': return l.errFactorialNeg;
    case 'errFactorialMax': return l.errFactorialMax;
    case 'errFactorialN': return l.errFactorialN(err);
    case 'errDoubleFactorialNeg': return l.errDoubleFactorialNeg;
    case 'errDoubleFactorial': return l.errDoubleFactorial(err);
    case 'errFibonacciNeg': return l.errFibonacciNeg;
    case 'errFibonacci': return l.errFibonacci(err);
    case 'errCatalanNeg': return l.errCatalanNeg;
    case 'errCatalan': return l.errCatalan(err);
    case 'errDerangementNeg': return l.errDerangementNeg;
    case 'errDerangement': return l.errDerangement(err);
    case 'errPartitionNeg': return l.errPartitionNeg;
    case 'errPartition': return l.errPartition(err);
    case 'errBellNeg': return l.errBellNeg;
    case 'errBell': return l.errBell(err);
    case 'errDigitalRoot': return l.errDigitalRoot(err);
    case 'errPrimitiveRootDomain': return l.errPrimitiveRootDomain;
    case 'errNoPrimitiveRoot': return l.errNoPrimitiveRoot(n);

    // === Modular arithmetic ===
    case 'errNoInverse': return l.errNoInverse(a, n);
    case 'errModPow': return l.errModPow(err);
    case 'errDiophantine': return l.errDiophantine(err);
    case 'errCRT': return l.errCRT(err);
    case 'errNoSolution': return l.errNoSolution;
    case 'errIncompatibleSystem': return l.errIncompatibleSystem;
    case 'errCRTNeedPairs': return l.errCRTNeedPairs;
    case 'errUnknownOp': return l.errUnknownOp(op);

    // === Basic operations ===
    case 'errPercentage': return l.errPercentage(err);
    case 'errDivisionByZero': return l.errDivisionByZero;
    case 'errReciprocal': return l.errReciprocal(err);

    // Fallback: return key as-is (useful during development)
    default: return key;
  }
}
