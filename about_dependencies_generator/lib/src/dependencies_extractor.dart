
import 'dart:io';

import 'package:about_dependencies/src/description_getter.dart';
import 'package:about_dependencies/src/unknown_yaml_file_exception.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:path/path.dart' as path;

class DependenciesExtractor {
  final DescriptionGetter descriptionGetter;

  DependenciesExtractor():
      descriptionGetter = DescriptionGetter();

  /// Extract the needed information about the dependencies
  ///
  /// This method will read the project pubspec.yaml file and
  /// create a list with the informations about every dependency
  /// contained in it.
  /// In case the pubspec.yaml file can't be located this method will
  /// throw and [UnknownYamlFileException]
  Future<List<Map<String, String>>> extract() async {
    // Read the pubspec.yaml file
    final packageDirectory = Directory.current;
    final pubspecFile = File(path.join(packageDirectory.path, "pubspec.yaml"));

    // If the file doesn't exist throw and exception
    if (!pubspecFile.existsSync())
      throw UnknownYamlFileException("cannot find pubspec.yaml file under $packageDirectory");

    // The pubspec.yaml file exist... extract his dependencies
    final pubspecString = await pubspecFile.readAsString();
    final pubspecYaml = Pubspec.parse(pubspecString);

    // Read all dependencies from pubspec.yaml
    return await _extractDependency(pubspecYaml).toList();
  }

  /// Async generator to loop every dependency in the yaml file
  Stream<Map<String, String>> _extractDependency(Pubspec yaml) async*{
    for (var entry in yaml.dependencies.entries) {
      final name = entry.key;
      final dep = entry.value;

      if (dep is SdkDependency)
        yield await _extractSdk(dep, name);
      if (dep is GitDependency)
        yield await _extractGit(dep, name);
      if (dep is PathDependency)
        yield await _extractPath(dep, name);
      if (dep is HostedDependency)
        yield await _extractHosted(dep, name);
    }
  }

  /// Extract informations form sdk dependency
  Future<Map<String, String>> _extractSdk(SdkDependency spec, String name) async{
    String version = spec.version != null
      ? "${spec.sdk} - ${spec.version.toString()}"
      : spec.sdk;

    return {
      "name": name,
      "version": version,
      "description": null,
    };
  }

  /// Extract informations form git dependency
  Future<Map<String, String>> _extractGit(GitDependency spec, String name) async{
    return {
      "name": name,
      "version": "git",
      "description": null,
    };
  }

  /// Extract informations form path dependency
  Future<Map<String, String>> _extractPath(PathDependency spec, String name) async{
    final info = await descriptionGetter.pathDescription(spec.path);

    return {
      "name": name,
      "version": info != null ? info["version"]: null,
      "description": info != null ? info["description"]: null,
    };
  }

  /// Extract informations form hosted dependency
  Future<Map<String, String>> _extractHosted(HostedDependency spec, String name) async{
    return {
      "name": name,
      "version": spec.version.toString(),
      "description": await descriptionGetter.onlineDescription(name),
    };
  }
}