import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/calculator_service.dart';

enum ScientificButtonType {
  number,
  operator,
  function,
  constant,
  special,
}

class ScientificCalculatorKeyboard extends StatelessWidget {
  const ScientificCalculatorKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // Fila 1: Funciones de memoria
              Expanded(
                child: Row(
                  children: [
                    _buildButton(context, 'MC', calculator.memoryClear, buttonType: ScientificButtonType.special),
                    _buildButton(context, 'MR', calculator.memoryRecall, buttonType: ScientificButtonType.special),
                    _buildButton(context, 'M+', calculator.memoryPlus, buttonType: ScientificButtonType.special),
                    _buildButton(context, 'M-', calculator.memoryMinus, buttonType: ScientificButtonType.special),
                    _buildButton(context, 'MS', calculator.memoryStore, buttonType: ScientificButtonType.special),
                  ],
                ),
              ),
              
              // Fila 2: Funciones trigonométricas inversas y constantes
              Expanded(
                child: Row(
                  children: [
                    _buildButton(context, 'sin⁻¹', calculator.asin, buttonType: ScientificButtonType.function),
                    _buildButton(context, 'cos⁻¹', calculator.acos, buttonType: ScientificButtonType.function),
                    _buildButton(context, 'tan⁻¹', calculator.atan, buttonType: ScientificButtonType.function),
                    _buildButton(context, 'π', calculator.addPi, buttonType: ScientificButtonType.constant),
                    _buildButton(context, 'e', calculator.addE, buttonType: ScientificButtonType.constant),
                  ],
                ),
              ),
              
              // Fila 3: Funciones trigonométricas
              Expanded(
                child: Row(
                  children: [
                    _buildButton(context, 'sin', calculator.sin, buttonType: ScientificButtonType.function),
                    _buildButton(context, 'cos', calculator.cos, buttonType: ScientificButtonType.function),
                    _buildButton(context, 'tan', calculator.tan, buttonType: ScientificButtonType.function),
                    _buildButton(context, calculator.angleMode, calculator.toggleAngleMode, buttonType: ScientificButtonType.special),
                    _buildButton(context, 'C', calculator.clear, buttonType: ScientificButtonType.operator),
                  ],
                ),
              ),
              
              // Fila 4: Logaritmos y exponenciales
              Expanded(
                child: Row(
                  children: [
                    _buildButton(context, 'ln', calculator.ln, buttonType: ScientificButtonType.function),
                    _buildButton(context, 'log', calculator.log, buttonType: ScientificButtonType.function),
                    _buildButton(context, 'eˣ', calculator.exp, buttonType: ScientificButtonType.function),
                    _buildButton(context, '10ˣ', calculator.pow10, buttonType: ScientificButtonType.function),
                    _buildButton(context, 'CE', calculator.clearEntry, buttonType: ScientificButtonType.operator),
                  ],
                ),
              ),
              
              // Fila 5: Potencias y raíces
              Expanded(
                child: Row(
                  children: [
                    _buildButton(context, 'x²', () => calculator.power('2'), buttonType: ScientificButtonType.function),
                    _buildButton(context, 'x³', () => calculator.power('3'), buttonType: ScientificButtonType.function),
                    _buildButton(context, 'xʸ', () => calculator.addOperator('^'), buttonType: ScientificButtonType.function),
                    _buildButton(context, 'n!', calculator.factorial, buttonType: ScientificButtonType.function),
                    _buildButton(context, '⌫', calculator.backspace, buttonType: ScientificButtonType.operator),
                  ],
                ),
              ),
              
              // Fila 6: Raíces y división
              Expanded(
                child: Row(
                  children: [
                    _buildButton(context, '√', calculator.squareRoot, buttonType: ScientificButtonType.function),
                    _buildButton(context, '∛', calculator.cubeRoot, buttonType: ScientificButtonType.function),
                    _buildButton(context, '(', calculator.addOpenParenthesis, buttonType: ScientificButtonType.operator),
                    _buildButton(context, ')', calculator.addCloseParenthesis, buttonType: ScientificButtonType.operator),
                    _buildButton(context, '÷', () => calculator.addOperator('÷'), buttonType: ScientificButtonType.operator),
                  ],
                ),
              ),
              
              // Fila 7: Números 7-9 y multiplicación
              Expanded(
                child: Row(
                  children: [
                    _buildButton(context, '7', () => calculator.addDigit('7'), buttonType: ScientificButtonType.number),
                    _buildButton(context, '8', () => calculator.addDigit('8'), buttonType: ScientificButtonType.number),
                    _buildButton(context, '9', () => calculator.addDigit('9'), buttonType: ScientificButtonType.number),
                    _buildButton(context, '×', () => calculator.addOperator('×'), buttonType: ScientificButtonType.operator),
                    _buildButton(context, 'mod', () => calculator.addOperator('mod'), buttonType: ScientificButtonType.operator),
                  ],
                ),
              ),
              
              // Fila 8: Números 4-6 y resta
              Expanded(
                child: Row(
                  children: [
                    _buildButton(context, '4', () => calculator.addDigit('4'), buttonType: ScientificButtonType.number),
                    _buildButton(context, '5', () => calculator.addDigit('5'), buttonType: ScientificButtonType.number),
                    _buildButton(context, '6', () => calculator.addDigit('6'), buttonType: ScientificButtonType.number),
                    _buildButton(context, '-', () => calculator.addOperator('-'), buttonType: ScientificButtonType.operator),
                    _buildButton(context, calculator.conversionButtonText, calculator.toggleBinaryDecimal, buttonType: ScientificButtonType.function),
                  ],
                ),
              ),
              
              // Fila 9: Números 1-3 y suma
              Expanded(
                child: Row(
                  children: [
                    _buildButton(context, '1', () => calculator.addDigit('1'), buttonType: ScientificButtonType.number),
                    _buildButton(context, '2', () => calculator.addDigit('2'), buttonType: ScientificButtonType.number),
                    _buildButton(context, '3', () => calculator.addDigit('3'), buttonType: ScientificButtonType.number),
                    _buildButton(context, '+', () => calculator.addOperator('+'), buttonType: ScientificButtonType.operator),
                    _buildButton(context, '±', calculator.toggleSign, buttonType: ScientificButtonType.operator),
                  ],
                ),
              ),
              
              // Fila 10: Cero, punto decimal e igual
              Expanded(
                child: Row(
                  children: [
                    _buildButton(context, '0', () => calculator.addDigit('0'), buttonType: ScientificButtonType.number, flex: 2),
                    _buildButton(context, '.', () => calculator.addDigit('.'), buttonType: ScientificButtonType.number),
                    _buildButton(context, '=', calculator.calculate, buttonType: ScientificButtonType.operator),
                    const Expanded(child: SizedBox()), // Espacio vacío
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    VoidCallback onPressed, {
    ScientificButtonType buttonType = ScientificButtonType.number,
    int flex = 1,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color backgroundColor;
    Color textColor;
    
    switch (buttonType) {
      case ScientificButtonType.number:
        backgroundColor = colorScheme.surface;
        textColor = colorScheme.onSurface;
        break;
      case ScientificButtonType.operator:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        break;
      case ScientificButtonType.function:
        backgroundColor = colorScheme.secondary;
        textColor = colorScheme.onSecondary;
        break;
      case ScientificButtonType.constant:
        backgroundColor = colorScheme.tertiary;
        textColor = colorScheme.onTertiary;
        break;
      case ScientificButtonType.special:
        backgroundColor = colorScheme.surfaceContainerHighest;
        textColor = colorScheme.onSurfaceVariant;
        break;
    }
    
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(2),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
