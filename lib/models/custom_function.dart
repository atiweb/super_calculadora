import 'dart:convert';

/// A user-defined function: a name, a parameter list and a body expression.
///
/// The body is stored exactly as the user typed it; it is expanded textually
/// into the expression before evaluation (see CustomFunctionService), so it
/// may use anything the expression engine understands, including other
/// custom functions.
class CustomFunction {
  final String name;
  final List<String> params;
  final String body;

  const CustomFunction({
    required this.name,
    required this.params,
    required this.body,
  });

  /// "name(x, y)"
  String get signature => '$name(${params.join(', ')})';

  /// "name(x, y) = body"
  String get definition => '$signature = $body';

  Map<String, dynamic> toJson() => {
        'name': name,
        'params': params,
        'body': body,
      };

  factory CustomFunction.fromJson(Map<String, dynamic> json) => CustomFunction(
        name: json['name'] as String,
        // Eager: a lazy cast() let a corrupt entry ([1]) load fine and then
        // throw inside build() the first time signature was read.
        params: [for (final p in json['params'] as List<dynamic>) p as String],
        body: json['body'] as String,
      );

  String toStorageString() => jsonEncode(toJson());

  factory CustomFunction.fromStorageString(String s) =>
      CustomFunction.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
