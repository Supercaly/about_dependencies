
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';

import '../annotations.dart';

class AboutDependenciesGenerator extends GeneratorForAnnotation<Dependencies> {
  @override
  Future<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async {
    final packageDirectory = Directory.current;
    final pubspecFile = File("${packageDirectory.path}/pubspec.yaml");

    final existFile = await pubspecFile.exists();
    if (!existFile) {
      throw Exception("cannot find pubspec.yaml file under $packageDirectory");
    }

    final String pubspecString = await pubspecFile.readAsString();
    final pubspecYaml = pubspecString.toPubspecYaml();

    // Extract dependencies keys
    pubspecYaml.dependencies;

    return '''
    final test = 0;
    // ${pubspecYaml.dependencies.toString()}
    ''';
  }
}