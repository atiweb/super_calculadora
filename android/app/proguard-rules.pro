# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**

# Kotlin
-keep class kotlin.** { *; }
-dontwarn kotlin.**

# SharedPreferences (flutter plugin)
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# math_expressions – keep the expression parser classes
-keep class org.mathparser.** { *; }
-dontwarn org.mathparser.**

# Keep Dart entry points
-keep class com.diego.supercalculadora.** { *; }

# General Android
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
