import 'package:dio/dio.dart';

import '../llm/llm_exception.dart';

Future<T> guardRemoteCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on LlmException {
    rethrow;
  } on DioException catch (e) {
    throw _fromDio(e);
  } on Object {
    // JSON that doesn't match the DTOs.
    throw const LlmInvalidResponseException('Unexpected response shape');
  }
}

LlmException _fromDio(DioException e) => switch (e.type) {
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout ||
  DioExceptionType.transformTimeout => LlmTimeoutException(e.message),
  DioExceptionType.badResponse => _fromStatus(
    e.response?.statusCode ?? 0,
    _errorMessage(e.response?.data),
  ),
  DioExceptionType.badCertificate ||
  DioExceptionType.connectionError ||
  DioExceptionType.cancel => LlmNetworkException(e.message),
  DioExceptionType.unknown =>
    e.error is ArgumentError || e.error is FormatException
        ? const LlmRequestException(0, 'Invalid API base URL')
        : LlmNetworkException(e.message),
};

LlmException _fromStatus(int status, String? message) => switch (status) {
  401 || 403 => LlmAuthException(message),
  408 => LlmTimeoutException(message),
  429 => LlmRateLimitException(message),
  >= 500 => LlmServerException(message),
  _ => LlmRequestException(status, message),
};

String? _errorMessage(Object? data) {
  if (data case {'error': {'message': final String message}}) return message;
  return null;
}
