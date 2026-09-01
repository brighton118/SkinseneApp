class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final String? endpoint;

  ApiException(this.message, {this.statusCode, this.endpoint});

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message, endpoint: $endpoint)';
  }
}
