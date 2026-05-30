import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/calculator_service.dart';

class LargeNumberTestWidget extends StatefulWidget {
  const LargeNumberTestWidget({super.key});

  @override
  State<LargeNumberTestWidget> createState() => _LargeNumberTestWidgetState();
}

class _LargeNumberTestWidgetState extends State<LargeNumberTestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de Números Grandes'),
      ),
      body: Consumer<CalculatorService>(
        builder: (context, calculator, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Prueba de Visualización de Números Grandes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                
                // Botones de prueba
                ElevatedButton(
                  onPressed: () {
                    // Número mediano (30 dígitos)
                    calculator.setDisplay('123456789012345678901234567890');
                  },
                  child: const Text('Número Mediano (30 dígitos)'),
                ),
                
                const SizedBox(height: 10),
                
                ElevatedButton(
                  onPressed: () {
                    // Número grande (100 dígitos)
                    calculator.setDisplay('1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890');
                  },
                  child: const Text('Número Grande (100 dígitos)'),
                ),
                
                const SizedBox(height: 10),
                
                ElevatedButton(
                  onPressed: () {
                    // Número extremadamente grande (300 dígitos)
                    calculator.setDisplay('123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890');
                  },
                  child: const Text('Número Extremadamente Grande (300 dígitos)'),
                ),
                
                const SizedBox(height: 10),
                
                ElevatedButton(
                  onPressed: () {
                    // Número con miles de dígitos
                    String largeNumber = '1${'0' * 1000}'; // 1 seguido de 1000 ceros
                    calculator.setDisplay(largeNumber);
                  },
                  child: const Text('Número Gigante (1001 dígitos)'),
                ),
                
                const SizedBox(height: 10),
                
                ElevatedButton(
                  onPressed: () => calculator.setDisplay('0'),
                  child: const Text('Limpiar'),
                ),
                
                const SizedBox(height: 20),
                
                const Text(
                  'Estado actual:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                
                Text(
                  'Longitud: ${calculator.display.length} dígitos',
                  style: const TextStyle(fontSize: 14),
                ),
                
                const SizedBox(height: 10),
                
                Text(
                  'Tipo de visualización: ${_getDisplayType(calculator.display)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  String _getDisplayType(String display) {
    if (display.length <= 30) {
      return 'Una línea o scroll horizontal';
    } else if (display.length <= 100) {
      return 'Multilínea con scroll vertical';
    } else {
      return 'Formato especial para números extremadamente grandes';
    }
  }
}
