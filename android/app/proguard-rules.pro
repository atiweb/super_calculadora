# R8 configuration.
#
# The Flutter Gradle plugin already contributes flutter_proguard_rules.pro,
# which keeps every FlutterPlugin implementation (while still allowing R8 to
# shrink and rename it) and silences the engine/plugin warnings, and AGP keeps
# the components declared in the manifest.
#
# What used to live here on top of that were blanket rules —
#   -keep class io.flutter.** { *; }
#   -keep class kotlin.** { *; }
#   -keep class br.dev.ati.supercalculadora.** { *; }
#   -keep class org.mathparser.** { *; }   (a package that does not exist:
#                                           math_expressions is pure Dart)
# — that pinned the whole engine and the entire Kotlin standard library, every
# member included. R8 still ran in full mode, but with nothing left to shrink,
# inline or rename. That is what Play's "improve memory and performance with
# R8" recommendation was pointing at.

# Readable crash reports: line numbers are what make a stack trace useful, and
# the App Bundle already carries the mapping file that deobfuscates them. The
# source file name itself carries no information, so let R8 rename it.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
