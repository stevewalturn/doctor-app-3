/// Exception parent class when an unwanted exception is
/// needed to throw from the API service
class APIException implements Exception {
  const APIException([this.message]);

  /// Message
  final dynamic message;

  @override
  String toString() {
    // ignore: no_runtimetype_tostring
    return '$runtimeType($message)';
  }
}
