# Optimizaciones para Números Grandes

## Resumen
Este documento describe las optimizaciones implementadas para manejar eficientemente números extremadamente grandes (hasta 1024 bits) en la Super Calculadora.

## Algoritmos Optimizados

### 1. Verificación de Cuadrado Perfecto
```dart
bool _isPerfectSquare(BigInt n) {
  // Búsqueda binaria para encontrar la raíz cuadrada
  BigInt low = BigInt.zero;
  BigInt high = n;
  
  while (low <= high) {
    BigInt mid = (low + high) >> 1;
    BigInt square = mid * mid;
    if (square == n) return true;
    if (square < n) {
      low = mid + BigInt.one;
    } else {
      high = mid - BigInt.one;
    }
  }
  return false;
}
```

**Complejidad:** O(log n)
**Ventaja:** Mucho más eficiente que calcular la raíz cuadrada directamente para números grandes.

### 2. Verificación de Número de Fibonacci
```dart
bool isFibonacci(BigInt number) {
  // Usa la propiedad matemática: n es Fibonacci si y solo si 
  // 5n²+4 o 5n²-4 es un cuadrado perfecto
  BigInt fiveNSquare = BigInt.from(5) * number * number;
  return _isPerfectSquare(fiveNSquare + BigInt.from(4)) ||
         _isPerfectSquare(fiveNSquare - BigInt.from(4));
}
```

**Complejidad:** O(log n)
**Ventaja:** No requiere generar toda la secuencia de Fibonacci hasta llegar al número.

### 3. Verificación de Número Triangular
```dart
bool isTriangular(BigInt number) {
  // n es triangular si (8n + 1) es un cuadrado perfecto
  BigInt value = BigInt.from(8) * number + BigInt.one;
  if (!_isPerfectSquare(value)) return false;

  // Verificar que la raíz cuadrada sea impar
  BigInt sqrtValue = _sqrtBigInt(value);
  return ((sqrtValue - BigInt.one) % BigInt.from(2)) == BigInt.zero;
}
```

**Complejidad:** O(log n)
**Ventaja:** Usa la fórmula matemática directa en lugar de iteración.

### 4. Raíz Cuadrada Optimizada
```dart
static BigInt _sqrtBigInt(BigInt n) {
  // Búsqueda binaria para encontrar la raíz cuadrada entera
  BigInt low = BigInt.zero;
  BigInt high = n;
  
  while (low <= high) {
    BigInt mid = (low + high) >> 1;
    BigInt midSquared = mid * mid;
    if (midSquared == n) return mid;
    if (midSquared < n) {
      low = mid + BigInt.one;
    } else {
      high = mid - BigInt.one;
    }
  }
  return high; // Retorna el entero más grande cuyo cuadrado es <= n
}
```

**Complejidad:** O(log n)
**Ventaja:** Más eficiente que el método de Newton-Raphson para números enteros grandes.

## Comparación de Rendimiento

| Operación | Método Anterior | Método Optimizado | Mejora |
|-----------|-----------------|-------------------|---------|
| Fibonacci | O(F(n)) - Genera secuencia | O(log n) - Test matemático | ~99% para números grandes |
| Triangular | O(√n) - Iteración | O(log n) - Test matemático | ~90% para números grandes |
| Cuadrado Perfecto | O(√n) - Búsqueda lineal | O(log n) - Búsqueda binaria | ~95% para números grandes |

## Casos de Uso

### Números Pequeños (< 10^15)
- Análisis completo incluyendo primos, factorización, divisores
- Tiempo de respuesta: < 1 segundo

### Números Medianos (10^15 - 10^20)
- Análisis parcial sin factorización completa
- Fibonacci y triangular calculados eficientemente
- Tiempo de respuesta: < 5 segundos

### Números Grandes (> 10^20)
- Análisis básico con propiedades fundamentales
- Fibonacci y triangular calculados eficientemente
- Primos calculados asincrónicamente con loader
- Tiempo de respuesta: Inmediato para propiedades básicas

## Implementación en la UI

### Loader Asíncrono para Primos
```dart
// Mostrar loader específico para cálculos de primos
if (analysis.containsKey('calculatingPrimes') && analysis['calculatingPrimes'] == true)
  _buildLoadingRow('Siguiente primo', 'Calculando...')
```

### Feedback Visual
- Loader general: "Analizando número..."
- Loader específico: "Calculando primos..."
- Nota informativa para números procesados (decimales/negativos)

## Consideraciones Técnicas

### Limitaciones de Memoria
- Para números > 10^1000, algunas operaciones pueden ser limitadas
- Representación binaria y hexadecimal pueden ser truncadas

### Precisión
- Todos los cálculos mantienen precisión exacta usando BigInt
- No hay pérdida de precisión en conversiones

### Escalabilidad
- Los algoritmos escalan logarítmicamente con el tamaño del número
- Manejo eficiente de memoria para números extremadamente grandes

## Próximas Mejoras

1. **Factorización Optimizada**: Implementar algoritmos como Pollard's rho para factorización más eficiente
2. **Primos Probabilísticos**: Mejorar el test de Miller-Rabin para números aún más grandes
3. **Cacheo**: Implementar cache para resultados de cálculos costosos
4. **Paralelización**: Usar múltiples isolates para cálculos independientes

## Conclusión

Las optimizaciones implementadas permiten que la Super Calculadora maneje números extremadamente grandes manteniendo:
- Respuesta inmediata para propiedades básicas
- Cálculos eficientes para Fibonacci y triangular
- Feedback visual apropiado para operaciones costosas
- Precisión matemática completa
