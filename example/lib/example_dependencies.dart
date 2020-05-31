
import 'package:about_dependencies/annotations.dart';

part 'example_dependencies.g.dart';

@Dependencies()
class ExampleDependencies {
  void use() {
    // Use the generated code like a normal list object
    print(dependencies);
  }
}