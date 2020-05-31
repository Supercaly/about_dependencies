
library about_dependencies;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/about_dependencies_generator.dart';

Builder aboutDependencies(BuilderOptions options) =>
  SharedPartBuilder([AboutDependenciesGenerator()], "about_dependencies");
