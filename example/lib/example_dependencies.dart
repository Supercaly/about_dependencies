
import 'package:about_dependencies/annotations.dart';

part 'example_dependencies.g.dart';

@Dependencies()
class ExampleDependencies {
  void use() {
    final a = test;
  }
}