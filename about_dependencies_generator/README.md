# about_dependencies

Automatically generate dart file with informations about used dependencies in pubspec.yaml.

## Usage

To use this package add `about_dependencies` as a [dependency in your pubspec.yaml file.](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

Add the `@Dependencies` annotation to your class.
Don't forget to add part statement after all the imports `part 'your-file.g.dart`

Use the `dependencies` list of maps where-ever you want.
Import the library.

```dart
import 'package:about_dependencies/annotations.dart';

part 'example_dependencies.g.dart';

@Dependencies()
class ExampleDependencies {
  void use() {
    // Use the generated code like a normal list object
    print(dependencies);
  }
}
```

## Code Generation

To generate the dependencies run the command: `flutter pub run build_runner build`