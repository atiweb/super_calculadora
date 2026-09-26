import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_calculadora/models/custom_function.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/custom_function_service.dart';

void main() {
  group('parseDefinition', () {
    test('definición simple', () {
      final fn = CustomFunctionService.parseDefinition('f(x) = x^2 + 1');
      expect(fn.name, 'f');
      expect(fn.params, ['x']);
      expect(fn.body, 'x^2 + 1');
      expect(fn.definition, 'f(x) = x^2 + 1');
    });

    test('varios parámetros', () {
      final fn =
          CustomFunctionService.parseDefinition('d(a, b) = sqrt(a^2 + b^2)');
      expect(fn.name, 'd');
      expect(fn.params, ['a', 'b']);
    });

    test('sin parámetros (constante)', () {
      final fn = CustomFunctionService.parseDefinition('tau() = 2*π');
      expect(fn.params, isEmpty);
    });

    test('nombre arbitrario como el de Diego', () {
      final fn =
          CustomFunctionService.parseDefinition('qjsjdbej(x) = x + 1');
      expect(fn.name, 'qjsjdbej');
    });

    void expectProblem(String text, String code) {
      expect(
        () => CustomFunctionService.parseDefinition(text),
        throwsA(isA<CustomFunctionException>()
            .having((e) => e.code, 'code', code)),
      );
    }

    test('formatos inválidos', () {
      expectProblem('f = 2', 'cfErrBadSignature');
      expectProblem('f(x) = x = 2', 'cfErrBadSignature');
      expectProblem('sin(x) = x', 'cfErrReservedName');
      expectProblem('mod(x) = x', 'cfErrReservedName');
      expectProblem('f(2x) = x', 'cfErrBadParam');
      expectProblem('f(sin) = 1', 'cfErrBadParam');
      expectProblem('f(x, x) = x', 'cfErrDupParam');
      expectProblem('f(x) = ', 'cfErrEmptyBody');
    });
  });

  group('expandCalls', () {
    Map<String, CustomFunction> fns(List<String> defs) => {
          for (final d in defs)
            CustomFunctionService.parseDefinition(d).name:
                CustomFunctionService.parseDefinition(d),
        };

    test('no toca las funciones integradas con nombres parecidos', () {
      // La 'g' dentro de 'log(' no es una llamada a la función custom 'g'.
      final expanded = CustomFunctionService.expandCalls(
          'log(2)+g(1)', fns(['g(x) = x*3']));
      expect(expanded, startsWith('log(2)+'));
      expect(expanded, contains('(1)'));
    });

    test('aridad incorrecta', () {
      expect(
        () => CustomFunctionService.expandCalls('f(1,2)', fns(['f(x) = x'])),
        throwsA(isA<CustomFunctionException>()
            .having((e) => e.code, 'code', 'errCustomFnArgs')
            .having((e) => e.arg, 'arg', 'f(x)')),
      );
    });

    test('recursión directa', () {
      expect(
        () => CustomFunctionService.expandCalls(
            'f(1)', fns(['f(x) = f(x) + 1'])),
        throwsA(isA<CustomFunctionException>()
            .having((e) => e.code, 'code', 'errCustomFnRecursion')),
      );
    });

    test('recursión mutua', () {
      expect(
        () => CustomFunctionService.expandCalls(
            'a(1)', fns(['a(x) = b(x)', 'b(x) = a(x)'])),
        throwsA(isA<CustomFunctionException>()
            .having((e) => e.code, 'code', 'errCustomFnRecursion')),
      );
    });
  });

  group('evaluación con funciones personalizadas', () {
    late CalculatorService calc;

    CustomFunction def(String text) =>
        CustomFunctionService.parseDefinition(text);

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      calc = CalculatorService();
    });

    test('llamada simple', () {
      calc.debugSetCustomFunctions([def('f(x) = x^2 + 1')]);
      expect(calc.evaluateCompleteExpression('f(3)'), '10');
    });

    test('composición entre funciones custom', () {
      calc.debugSetCustomFunctions([
        def('f(x) = x^2 + 1'),
        def('g(x) = f(x + 1) * 2'),
      ]);
      // g(2) = f(3)*2 = 10*2
      expect(calc.evaluateCompleteExpression('g(2)'), '20');
    });

    test('llamada anidada en el argumento', () {
      calc.debugSetCustomFunctions([def('f(x) = x^2 + 1')]);
      // f(f(2)) = f(5) = 26
      expect(calc.evaluateCompleteExpression('f(f(2))'), '26');
    });

    test('varios parámetros', () {
      calc.debugSetCustomFunctions([def('d(a, b) = a*b + a')]);
      expect(calc.evaluateCompleteExpression('d(3, 4)'), '15');
    });

    test('parámetro usado varias veces', () {
      calc.debugSetCustomFunctions([def('p(x) = x*2 + x^2')]);
      expect(calc.evaluateCompleteExpression('p(3)'), '15');
    });

    test('el argumento se sustituye entre paréntesis', () {
      calc.debugSetCustomFunctions([def('sq(x) = x^2')]);
      // Sin paréntesis en la sustitución, 1+2^2 daría 5.
      expect(calc.evaluateCompleteExpression('sq(1+2)'), '9');
    });

    test('funciones integradas dentro del cuerpo', () {
      calc.debugSetCustomFunctions([def('r(x) = sqrt(x) + 1')]);
      expect(calc.evaluateCompleteExpression('r(9)'), '4');
    });

    test('nombre que empieza como una integrada', () {
      // 'sinc' disparaba el patrón "sin sin paréntesis" antes de expandir.
      calc.debugSetCustomFunctions([def('sinc(x) = x + 1')]);
      expect(calc.evaluateCompleteExpression('sinc(2)'), '3');
    });

    test('función sin parámetros', () {
      calc.debugSetCustomFunctions([def('seis() = 2*3')]);
      expect(calc.evaluateCompleteExpression('seis() + 1'), '7');
    });

    test('errores de aridad y recursión llegan como err:', () {
      calc.debugSetCustomFunctions([def('f(x) = x')]);
      expect(calc.evaluateCompleteExpression('f(1, 2)'),
          'err:errCustomFnArgs:f(x)');

      calc.debugSetCustomFunctions([def('f(x) = f(x) + 1')]);
      expect(calc.evaluateCompleteExpression('f(1)'),
          'err:errCustomFnRecursion');
    });

    test('sin funciones definidas todo sigue igual', () {
      expect(calc.evaluateCompleteExpression('2 + 3 * 4'), '14');
      expect(calc.evaluateCompleteExpression('sqrt(16) + 1'), '5');
    });
  });

  group('validateCustomFunction', () {
    late CalculatorService calc;

    CustomFunction def(String text) =>
        CustomFunctionService.parseDefinition(text);

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      calc = CalculatorService();
    });

    test('definición válida', () {
      expect(calc.validateCustomFunction(def('f(x) = x^2 + 1')), isNull);
    });

    test('puede usar otra función ya guardada', () {
      calc.debugSetCustomFunctions([def('f(x) = x^2 + 1')]);
      expect(calc.validateCustomFunction(def('g(x) = f(x) * 2')), isNull);
    });

    test('nombre desconocido en el cuerpo', () {
      expect(calc.validateCustomFunction(def('q(x) = sinn(x)')),
          'cfErrUnknownName:sinn');
    });

    test('cuerpo que no parsea', () {
      expect(calc.validateCustomFunction(def('q(x) = x*/2')),
          'cfErrBodyInvalid');
    });

    test('autorreferencia detectada', () {
      expect(calc.validateCustomFunction(def('f(x) = f(x) + 1')),
          'errCustomFnRecursion');
    });

    test('parámetro que taparía otra función', () {
      calc.debugSetCustomFunctions([def('f(x) = x + 1')]);
      expect(calc.validateCustomFunction(def('g(f) = f + 1')),
          'cfErrBadParam:f');
    });

    test('al editar, la función puede seguir usándose a sí no — renombrar', () {
      calc.debugSetCustomFunctions([def('f(x) = x + 1')]);
      // Renombrar f a h: la nueva h no referencia a f, y validar con
      // replacesName excluye la antigua definición.
      expect(
          calc.validateCustomFunction(def('h(x) = x + 2'),
              replacesName: 'f'),
          isNull);
    });
  });

  group('regresiones de la caza de bugs (2026-08-12)', () {
    late CalculatorService calc;

    CustomFunction def(String text) =>
        CustomFunctionService.parseDefinition(text);

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      calc = CalculatorService();
    });

    double num(String expr) {
      final String r = calc.evaluateCompleteExpression(expr);
      expect(r, isNot(startsWith('err:')), reason: 'evaluando "$expr" → $r');
      return double.parse(r.replaceAll(',', '.'));
    }

    test('2π ya no concatena dígitos (daba 23.14…)', () {
      expect(num('2π'), closeTo(6.283185307179586, 1e-9));
    });

    test('π2 ya no pega el 2 al final (daba 3.14…2)', () {
      expect(num('π2'), closeTo(6.283185307179586, 1e-9));
    });

    test('πe ya no lanza error crudo', () {
      expect(num('πe'), closeTo(8.539734222673566, 1e-9));
    });

    test('π y e solos siguen funcionando', () {
      expect(num('π'), closeTo(3.141592653589793, 1e-9));
      expect(num('e'), closeTo(2.718281828459045, 1e-9));
      // Modo por defecto: grados. El π entre paréntesis no debe
      // romper la conversión de los argumentos trigonométricos.
      expect(num('sin(180)'), closeTo(0, 1e-9));
      expect(num('sin(π)'), closeTo(0.05480366514879, 1e-9));
    });

    test('producto implícito dígito-función integrada', () {
      expect(num('2sqrt(9)'), closeTo(6, 1e-9));
      expect(num('3abs(0-2)'), closeTo(6, 1e-9));
    });

    test('producto implícito dígito-función custom', () {
      calc.debugSetCustomFunctions([def('f(x) = x^2 + 1')]);
      // 2f(3) = 2*10
      expect(num('2f(3)'), closeTo(20, 1e-9));
      calc.debugSetCustomFunctions([def('g(x) = x*2')]);
      expect(num('2.5g(2)'), closeTo(10, 1e-9));
    });

    test('un identificador con dígito en medio no es un producto', () {
      calc.debugSetCustomFunctions([def('f(x) = x + 1')]);
      // 'x2f' es un nombre desconocido, no 'x2 * f'
      expect(calc.evaluateCompleteExpression('x2f(3)'), startsWith('err:'));
    });

    test('referencesFunction detecta llamadas con frontera de palabra', () {
      expect(CustomFunctionService.referencesFunction('f(x) + 1', 'f'), isTrue);
      expect(CustomFunctionService.referencesFunction('f (x)', 'f'), isTrue);
      expect(CustomFunctionService.referencesFunction('ff(x)', 'f'), isFalse);
      expect(CustomFunctionService.referencesFunction('f + 1', 'f'), isFalse);
    });

    test('customFunctionsBrokenBy: renombrar rompe a quien la usa', () {
      calc.debugSetCustomFunctions([
        def('f(x) = x + 1'),
        def('g(x) = f(x) * 2'),
      ]);
      // Renombrar f a h dejaría a g llamando a una f inexistente
      expect(
        calc.customFunctionsBrokenBy(def('h(x) = x + 1'), replacesName: 'f'),
        ['g'],
      );
    });

    test('customFunctionsBrokenBy: cambiar la aridad rompe a quien la usa', () {
      calc.debugSetCustomFunctions([
        def('f(x) = x + 1'),
        def('g(x) = f(x) * 2'),
      ]);
      expect(
        calc.customFunctionsBrokenBy(def('f(a, b) = a + b'),
            replacesName: 'f'),
        ['g'],
      );
    });

    test('customFunctionsBrokenBy: un cambio compatible no rompe nada', () {
      calc.debugSetCustomFunctions([
        def('f(x) = x + 1'),
        def('g(x) = f(x) * 2'),
      ]);
      expect(
        calc.customFunctionsBrokenBy(def('f(x) = x * 3'), replacesName: 'f'),
        isEmpty,
      );
    });
  });

  group('persistencia', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
    });

    test('guardar, listar, actualizar y borrar', () async {
      final f = CustomFunctionService.parseDefinition('f(x) = x^2');
      final g = CustomFunctionService.parseDefinition('g(x) = f(x) + 1');

      await CustomFunctionService.add(f);
      await CustomFunctionService.add(g);

      var all = await CustomFunctionService.getAll();
      expect(all.map((e) => e.name), ['f', 'g']);

      // Renombrar f a h manteniendo su posición
      final h = CustomFunctionService.parseDefinition('h(x) = x^3');
      await CustomFunctionService.update('f', h);
      all = await CustomFunctionService.getAll();
      expect(all.map((e) => e.name), ['h', 'g']);

      await CustomFunctionService.remove('h');
      all = await CustomFunctionService.getAll();
      expect(all.map((e) => e.name), ['g']);
    });

    test('roundtrip JSON del modelo', () {
      final fn = CustomFunctionService.parseDefinition('d(a, b) = a*b + 1');
      final restored =
          CustomFunction.fromStorageString(fn.toStorageString());
      expect(restored.name, fn.name);
      expect(restored.params, fn.params);
      expect(restored.body, fn.body);
    });
  });
}
