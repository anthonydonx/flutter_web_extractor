class WebExtractorException implements Exception {
  var _message;
  WebExtractorException(String message) {
    _message = message;
  }
  String errorMessage() {
    return _message;
  }
}
