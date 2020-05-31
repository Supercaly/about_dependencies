
class UnknownYamlFileException implements Exception {
  final String message;

  const UnknownYamlFileException(this.message);

  @override
  String toString() => "UnknownYamlFileException: $message)";
}