
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

class DescriptionGetter {
  final Dio _dio;

  DescriptionGetter():
    _dio = Dio(BaseOptions(baseUrl: "https://pub.dartlang.org/api/packages"));

  /// Get the description of the given package from online pub.dev
  /// [packageName]: name of the package to search
  Future<String> onlineDescription(String packageName) async {
    final result = await _dio.get("/$packageName");

    String description;
    if (
      result.statusCode == 200 &&
      result.headers.value("Content-Type") != null &&
      result.headers.value("Content-Type").contains("application/json")
    ) {
      try {
        description = result.data["latest"]["pubspec"]["description"];
      } catch(e) {
        print("Error getting description of package $packageName");
      }
    }
    return description;
  }

  /// Get the description and the version given a path pointing
  /// to a locally stored package
  /// [packagePath]: path to a locally stored package
  ///
  /// returns a map with version and description
  Future<Map<String, String>> pathDescription(String packagePath) async {
    final file = File(path.join(Directory(packagePath).path, "pubspec.yaml"));

    // File doesn't exist
    if (!file.existsSync()) {
      print("Error getting description of package under $packagePath");
      return null;
    }

    // Read the description of pubspec.yaml file
    final pubspec = Pubspec.parse(await file.readAsString());
    return {
      "version": pubspec.version.toString(),
      "description": pubspec.description,
    };
  }
}