
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

class CodeWriter {
  /// Generate a const [List<Map<String, String>>] from the
  /// given input
  static String write(List<Map<String, String>> input) {
    var mapsList = [];
    for (var m in input) {
      mapsList.add(literalConstMap(m, Reference("String"), Reference("String")));
    }

    final dependencies = Field((f) => f
      ..name = "dependencies"
      ..modifier = FieldModifier.constant
      ..assignment = literalConstList(mapsList).code
      ..type = Reference("List<Map<String, String>>")
    );
    return DartFormatter().format('${dependencies.accept(DartEmitter())}');
  }
}