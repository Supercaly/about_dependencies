# about_dependencies

Automatically generate dart file with informations about used dependencies in pubspec.yaml.

## Usage

To use this package add `about_dependencies` as a [dependency in your pubspec.yaml file.](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

Import the generated file `import 'path_to_file';`.

```dart
import 'generated/dependencies.g.dart';

class ExampleDependencies {
  void use() {
    // Use the generated code like a normal list object
    print(dependencies);
  }
}
```

## Code Generation

To generate the dependencies run the command: `flutter pub run about_dependencies:generate`

Use `flutter pub run about_dependencies:generate -h` to get more build options