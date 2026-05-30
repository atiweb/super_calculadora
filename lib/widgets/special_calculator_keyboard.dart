import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/calculator_service.dart';
import '../models/button_type.dart';

class SpecialCalculatorKeyboard extends StatelessWidget {
  const SpecialCalculatorKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        final l = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              // Zona de funciones especiales (scrollable)
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // === TEORÍA DE NÚMEROS ===
                      _buildSectionLabel(context, l.kbdNumberTheory),
                      Row(children: [
                        _buildButton(context, 'φ', () => calculator.eulerPhi(), ButtonType.function),
                        _buildButton(context, 'λ', () => calculator.carmichaelLambda(), ButtonType.function),
                        _buildButton(context, 'μ', () => calculator.moebiusMu(), ButtonType.function),
                        _buildButton(context, 'λL', () => calculator.liouvilleFunction(), ButtonType.function),
                      ]),
                      Row(children: [
                        _buildButton(context, 'ω', () => calculator.smallOmega(), ButtonType.function),
                        _buildButton(context, 'Ω', () => calculator.bigOmega(), ButtonType.function),
                        _buildButton(context, 'σ₀', () => calculator.divisorCount(), ButtonType.function),
                        _buildButton(context, 'σ', () => calculator.divisorSum(), ButtonType.function),
                      ]),
                      Row(children: [
                        _buildButton(context, 'sopfr', () => calculator.sopfrFunction(), ButtonType.function),
                        _buildButton(context, 'sopf', () => calculator.sopfFunction(), ButtonType.function),
                        _buildButton(context, 'rad', () => calculator.radical(), ButtonType.function),
                        _buildButton(context, '#', () => calculator.primorial(), ButtonType.function),
                      ]),
                      Row(children: [
                        _buildButton(context, 'π(n)', () => calculator.primeCountingFunction(), ButtonType.function),
                        _buildButton(context, 'dr', () => calculator.digitalRoot(), ButtonType.function),
                        _buildButton(context, '⌊⌉', () => calculator.floorCeil(), ButtonType.function),
                        _buildButton(context, 'Vₚ', () => calculator.pAdicValuation(), ButtonType.function),
                      ]),

                      // === ARITMÉTICA MODULAR ===
                      _buildSectionLabel(context, l.kbdModularArith),
                      Row(children: [
                        _buildButton(context, 'mod', () => calculator.modFunction(), ButtonType.function),
                        _buildButton(context, 'a%n', () => calculator.modPowFunction(), ButtonType.function),
                        _buildButton(context, 'a⁻¹', () => calculator.modularInverse(), ButtonType.function),
                        _buildButton(context, 'ord', () => calculator.multiplicativeOrder(), ButtonType.function),
                      ]),
                      Row(children: [
                        _buildButton(context, '(a/p)', () => calculator.legendreSymbol(), ButtonType.function),
                        _buildButton(context, '(a/n)ⱼ', () => calculator.jacobiSymbol(), ButtonType.function),
                        _buildButton(context, 'g', () => calculator.primitiveRoot(), ButtonType.function),
                        _buildButton(context, 'MCD', () => calculator.gcdFunction(), ButtonType.function),
                      ]),
                      Row(children: [
                        _buildButton(context, 'MCM', () => calculator.lcmFunction(), ButtonType.function),
                        _buildButton(context, 'Diof', () => calculator.diophantineFunction(), ButtonType.function),
                        _buildButton(context, 'TCR', () => calculator.crtFunction(), ButtonType.function),
                        _buildButton(context, '', () {}, ButtonType.function),
                      ]),

                      // === COMBINATORIA ===
                      _buildSectionLabel(context, l.kbdCombinatorics),
                      Row(children: [
                        _buildButton(context, 'n!', () => calculator.factorialFunction(), ButtonType.function),
                        _buildButton(context, 'n!!', () => calculator.doubleFactorialFunction(), ButtonType.function),
                        _buildButton(context, 'C(n,k)', () => calculator.combinations(), ButtonType.function),
                        _buildButton(context, 'V(n,k)', () => calculator.variations(), ButtonType.function),
                      ]),
                      Row(children: [
                        _buildButton(context, 'Cat', () => calculator.catalanNumber(), ButtonType.function),
                        _buildButton(context, 'D(n)', () => calculator.derangementFunction(), ButtonType.function),
                        _buildButton(context, 'Bell', () => calculator.bellNumber(), ButtonType.function),
                        _buildButton(context, 'p(n)', () => calculator.partitionFunction(), ButtonType.function),
                      ]),
                      Row(children: [
                        _buildButton(context, 'S₂(n,k)', () => calculator.stirlingSecond(), ButtonType.function),
                        _buildButton(context, 's₁(n,k)', () => calculator.stirlingFirst(), ButtonType.function),
                        _buildButton(context, 'F(n)', () => calculator.fibonacciN(), ButtonType.function),
                        _buildButton(context, 'ΣdígB', () => calculator.digitSumBase(), ButtonType.function),
                      ]),

                      // === ESTADÍSTICA ===
                      _buildSectionLabel(context, l.kbdStatistics),
                      Row(children: [
                        _buildButton(context, 'Med\nA', () => calculator.arithmeticMeanN(), ButtonType.function),
                        _buildButton(context, 'Med\nG', () => calculator.geometricMeanN(), ButtonType.function),
                        _buildButton(context, 'Med\nH', () => calculator.harmonicMeanN(), ButtonType.function),
                        _buildButton(context, 'Med\nC', () => calculator.quadraticMeanN(), ButtonType.function),
                      ]),
                      Row(children: [
                        _buildButton(context, 'min', () => calculator.minimumN(), ButtonType.function),
                        _buildButton(context, 'max', () => calculator.maximumN(), ButtonType.function),
                        _buildButton(context, '', () {}, ButtonType.function),
                        _buildButton(context, '', () {}, ButtonType.function),
                      ]),
                    ],
                  ),
                ),
              ),

              // === TECLADO NUMÉRICO (siempre visible) ===
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(children: [
                        _buildButton(context, '7', () => calculator.addDigit('7'), ButtonType.number),
                        _buildButton(context, '8', () => calculator.addDigit('8'), ButtonType.number),
                        _buildButton(context, '9', () => calculator.addDigit('9'), ButtonType.number),
                        _buildButton(context, '÷', () => calculator.addOperator(' ÷ '), ButtonType.operator),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        _buildButton(context, '4', () => calculator.addDigit('4'), ButtonType.number),
                        _buildButton(context, '5', () => calculator.addDigit('5'), ButtonType.number),
                        _buildButton(context, '6', () => calculator.addDigit('6'), ButtonType.number),
                        _buildButton(context, '×', () => calculator.addOperator(' × '), ButtonType.operator),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        _buildButton(context, '1', () => calculator.addDigit('1'), ButtonType.number),
                        _buildButton(context, '2', () => calculator.addDigit('2'), ButtonType.number),
                        _buildButton(context, '3', () => calculator.addDigit('3'), ButtonType.number),
                        _buildButton(context, '-', () => calculator.addOperator(' - '), ButtonType.operator),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        _buildButton(context, '±', () => calculator.toggleSign(), ButtonType.function),
                        _buildButton(context, '0', () => calculator.addDigit('0'), ButtonType.number),
                        _buildButton(context, '.', () => calculator.addDigit('.'), ButtonType.number),
                        _buildButton(context, '+', () => calculator.addOperator(' + '), ButtonType.operator),
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        _buildButton(context, 'CE', () => calculator.clearEntry(), ButtonType.function),
                        _buildButton(context, 'C', () => calculator.clear(), ButtonType.function),
                        _buildButton(context, '⌫', () => calculator.backspace(), ButtonType.function),
                        _buildButton(context, '=', () => calculator.calculate(), ButtonType.equals),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed, ButtonType type) {
    // Botones vacíos (spacers)
    if (text.isEmpty) {
      return Expanded(child: Container(margin: const EdgeInsets.all(1.5)));
    }

    Color backgroundColor;
    Color textColor;
    double fontSize = 11;

    switch (type) {
      case ButtonType.number:
        backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
        textColor = Theme.of(context).colorScheme.onSurfaceVariant;
        fontSize = 16;
        break;
      case ButtonType.operator:
        backgroundColor = Theme.of(context).colorScheme.primary;
        textColor = Theme.of(context).colorScheme.onPrimary;
        fontSize = 14;
        break;
      case ButtonType.function:
        backgroundColor = Theme.of(context).colorScheme.secondary;
        textColor = Theme.of(context).colorScheme.onSecondary;
        fontSize = text.contains('\n') ? 9 : (text.length > 5 ? 9 : 11);
        break;
      case ButtonType.equals:
        backgroundColor = Theme.of(context).colorScheme.tertiary;
        textColor = Theme.of(context).colorScheme.onTertiary;
        fontSize = 14;
        break;
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(1.5),
        height: 36,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(0),
            minimumSize: Size.zero,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
