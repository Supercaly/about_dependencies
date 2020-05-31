
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import 'src/code_writer.dart';
import 'src/dependencies_extractor.dart';
import 'src/unknown_yaml_file_exception.dart';

void main(List<String> args) async {
  if (_isHelpCommand(args))
    _printHelperDisplay();
  else
    handleLangFiles(_generateOption(args));
}

Future<void> handleLangFiles(GenerateOptions options) async {
  // Extract the dependencies into a list
  try {
    final depList = await DependenciesExtractor().extract();

    // Generate dart code from the dependency list
    final outputFile = File(
      path.join(Directory.current.path, options.outputDir, options.outputFile));

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

bool _isHelpCommand(List<String> args) {
  return args.length == 1 && (args[0] == '--help' || args[0] == '-h');
}

GenerateOptions _generateOption(List<String> args) {
  var generateOptions = GenerateOptions();
  var parser = _generateArgParser(generateOptions);
  parser.parse(args);
  return generateOptions;
}

ArgParser _generateArgParser(GenerateOptions generateOptions) {
  var parser = ArgParser();

  parser.addOption('output-dir',
    abbr: 'O',
    defaultsTo: 'lib/generated',
    callback: (String x) => generateOptions.outputDir = x,
    help: 'Output folder stores for the generated file');

  parser.addOption('output-file',
    abbr: 'o',
    defaultsTo: 'dependencies.g.dart',
    callback: (String x) => generateOptions.outputFile = x,
    help: 'Output file name');

  return parser;
}

void _printHelperDisplay() {
  var parser = _generateArgParser(null);
  print(parser.usage);
}

class GenerateOptions {
  String outputDir;
  String outputFile;

  @override
  String toString() {
    return 'outputDir: $outputDir outputFile: $outputFile';
  }
}