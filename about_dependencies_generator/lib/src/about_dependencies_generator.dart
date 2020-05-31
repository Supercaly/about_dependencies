
import 'package:about_dependencies/src/dependencies_extractor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';
import 'code_writer.dart';

class AboutDependenciesGenerator extends GeneratorForAnnotation<Dependencies> {
  @override
  Future<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async {

    // Extract the dependencies into a list
    final depList = await DependenciesExtractor().extract();

    // Generate dart code from the dependency list
    return '''
    // Dependencies list
    ${CodeWriter().write(depList)}
    ''';
  }
}