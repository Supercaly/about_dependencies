
import 'dart:io';

import 'package:path/path.dart' as path;

import 'src/code_writer.dart';
import 'src/dependencies_extractor.dart';
import 'src/unknown_yaml_file_exception.dart';

void main(List<String> args) async {
  handleLangFiles();
}

Future<void> handleLangFiles() async {
  // Extract the dependencies into a list
  try {
    final depList = await DependenciesExtractor().extract();

    // Generate dart code from the dependency list
    final outputFile = File(
      path.join(Directory.current.path, "lib/generated", "dependencies.g.dart"));

    if (!outputFile.existsSync())
      await outputFile.create(recursive: true);

    await outputFile.writeAsString(
  '''
// DO NOT EDIT. This is code generated via package:about_dependencies/generate.dart
  
// Dependencies list
${CodeWriter.write(depList)}
  '''
    );
  } on UnknownYamlFileException catch(e) {
    print('\u001b[31m[ERROR] about dependencies: ${e.message}\u001b[0m');
  }
}