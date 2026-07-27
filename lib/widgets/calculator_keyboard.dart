import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/calculator_service.dart';

class CalculatorKeyboard extends StatelessWidget {
  const CalculatorKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Row 1: Memory functions
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildButton(context, 'MC', calculator.memoryClear, buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, 'MR', calculator.memoryRecall, buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, 'M+', calculator.memoryPlus, buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, 'M-', calculator.memoryMinus, buttonType: ButtonType.function)),
                  ],
                ),
              ),
              
              // Row 2: Special functions and control
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildButton(context, 'MS', calculator.memoryStore, buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, '%', () async => await calculator.percentage(), buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, 'CE', calculator.clearEntry, buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, 'C', calculator.clear, buttonType: ButtonType.function)),
                  ],
                ),
              ),
              
              // Row 3: Advanced functions and division
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildButton(context, '1/x', () async => await calculator.reciprocal(), buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, 'x²', () async => await calculator.power('2'), buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, '√', () async => await calculator.squareRoot(), buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, '÷', () => calculator.addOperator('÷'), buttonType: ButtonType.operator)),
                  ],
                ),
              ),
              
              // Row 4: Numbers 7-9 and multiplication
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildButton(context, '7', () => calculator.addDigit('7'))),
                    Expanded(child: _buildButton(context, '8', () => calculator.addDigit('8'))),
                    Expanded(child: _buildButton(context, '9', () => calculator.addDigit('9'))),
                    Expanded(child: _buildButton(context, '×', () => calculator.addOperator('×'), buttonType: ButtonType.operator)),
                  ],
                ),
              ),
              
              // Row 5: Numbers 4-6 and subtraction
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildButton(context, '4', () => calculator.addDigit('4'))),
                    Expanded(child: _buildButton(context, '5', () => calculator.addDigit('5'))),
                    Expanded(child: _buildButton(context, '6', () => calculator.addDigit('6'))),
                    Expanded(child: _buildButton(context, '-', () => calculator.addOperator('-'), buttonType: ButtonType.operator)),
                  ],
                ),
              ),
              
              // Row 6: Numbers 1-3 and addition
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildButton(context, '1', () => calculator.addDigit('1'))),
                    Expanded(child: _buildButton(context, '2', () => calculator.addDigit('2'))),
                    Expanded(child: _buildButton(context, '3', () => calculator.addDigit('3'))),
                    Expanded(child: _buildButton(context, '+', () => calculator.addOperator('+'), buttonType: ButtonType.operator)),
                  ],
                ),
              ),
              
              // Row 7: 0, decimal point, sign toggle and equals
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildButton(context, '±', calculator.toggleSign, buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, '0', () => calculator.addDigit('0'))),
                    Expanded(child: _buildButton(context, '.', () => calculator.addDigit('.'))),
                    Expanded(child: _buildButton(context, '=', calculator.calculate, buttonType: ButtonType.equals)),
                  ],
                ),
              ),
              
              // Row 8: Additional functions
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildButton(context, '∛', () async => await calculator.cubeRoot(), buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, 'xⁿ', () => calculator.addOperator('^'), buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, '(', calculator.addOpenParenthesis, buttonType: ButtonType.operator)),
                    Expanded(child: _buildButton(context, ')', calculator.addCloseParenthesis, buttonType: ButtonType.operator)),
                  ],
                ),
              ),
              
              // Row 9: Conversions and backspace
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildButton(context, calculator.conversionButtonText, calculator.toggleBinaryDecimal, buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, 'n!', calculator.factorial, buttonType: ButtonType.function)),
                    Expanded(child: _buildButton(context, '⌫', calculator.backspace, buttonType: ButtonType.function)),
                    Expanded(child: Container()), // Empty space
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
    ButtonType buttonType = ButtonType.number,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color backgroundColor;
    Color textColor;
    
    switch (buttonType) {
      case ButtonType.number:
        backgroundColor = colorScheme.surface;
        textColor = colorScheme.onSurface;
        break;
      case ButtonType.operator:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        break;
      case ButtonType.function:
        backgroundColor = colorScheme.secondary;
        textColor = colorScheme.onSecondary;
        break;
      case ButtonType.equals:
        backgroundColor = colorScheme.tertiary;
        textColor = colorScheme.onTertiary;
        break;
    }
    
    return Container(
      margin: const EdgeInsets.all(4),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

}

enum ButtonType {
  number,
  operator,
  function,
  equals,
}
