sealed class LlmException implements Exception {
  const LlmException([this.message]);
  final String? message;

  @override
  String toString() => '$runtimeType: ${message ?? ''}';
}

final class LlmAuthException extends LlmException {
  const LlmAuthException([super.message]);
}

final class LlmRateLimitException extends LlmException {
  const LlmRateLimitException([super.message]);
}

final class LlmServerException extends LlmException {
  const LlmServerException([super.message]);
}

final class LlmRequestException extends LlmException {
  const LlmRequestException(this.statusCode, [super.message]);
  final int statusCode;
}

final class LlmNetworkException extends LlmException {
  const LlmNetworkException([super.message]);
}

final class LlmTimeoutException extends LlmException {
  const LlmTimeoutException([super.message]);
}

final class LlmRefusalException extends LlmException {
  const LlmRefusalException([super.message]);
}

final class LlmInvalidResponseException extends LlmException {
  const LlmInvalidResponseException([super.message]);
}

final class LlmModelNotInstalledException extends LlmException {
  const LlmModelNotInstalledException([super.message]);
}

final class LlmModelAccessException extends LlmException {
  const LlmModelAccessException([super.message]);
}

final class LlmModelNotFoundException extends LlmException {
  const LlmModelNotFoundException([super.message]);
}

final class LlmDownloadCancelledException extends LlmException {
  const LlmDownloadCancelledException([super.message]);
}

final class LlmOnDeviceException extends LlmException {
  const LlmOnDeviceException([super.message]);
}
