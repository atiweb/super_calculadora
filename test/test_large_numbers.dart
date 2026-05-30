import 'package:flutter/material.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  runApp(TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Super Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final CalculatorService _calculator = CalculatorService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Números Grandes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Probar con número de 17 dígitos
                _calculator.loadNumber('42594539204192285');
              },
              child: Text('Probar número 17 dígitos'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Probar con número de 50 dígitos
                _calculator.loadNumber('12345678901234567890123456789012345678901234567890');
              },
              child: Text('Probar número 50 dígitos'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Probar con número de 100 dígitos
                _calculator.loadNumber('1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890');
              },
              child: Text('Probar número 100 dígitos'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Probar con número de 1000 dígitos
                String largeNumber = '1${'0' * 999}';
                _calculator.loadNumber(largeNumber);
              },
              child: Text('Probar número 1000 dígitos'),
            ),
            SizedBox(height: 16),
            Text(
              'Display: ${_calculator.display}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Análisis: ${_calculator.currentAnalysis.toString()}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
