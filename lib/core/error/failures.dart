import 'package:freezed_annotation/freezed_annotation.dart';

import '../llm/llm_exception.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure implements Exception {
  const factory Failure.notConfigured() = NotConfiguredFailure;
  const factory Failure.unauthorized() = UnauthorizedFailure;
  const factory Failure.rateLimit() = RateLimitFailure;
  const factory Failure.server() = ServerFailure;
  const factory Failure.providerRequest([String? details]) =
      ProviderRequestFailure;
  const factory Failure.network() = NetworkFailure;
  const factory Failure.timeout() = TimeoutFailure;
  const factory Failure.refusal() = RefusalFailure;

  const factory Failure.invalidResponse() = InvalidResponseFailure;
  const factory Failure.storage() = StorageFailure;
  const factory Failure.corruptedSave() = CorruptedSaveFailure;
  const factory Failure.invalidPrompt() = InvalidPromptFailure;
  const factory Failure.invalidAction() = InvalidActionFailure;
  const factory Failure.modelNotInstalled() = ModelNotInstalledFailure;

  const factory Failure.modelAccessDenied() = ModelAccessDeniedFailure;
  const factory Failure.modelNotFound() = ModelNotFoundFailure;
  const factory Failure.downloadCancelled() = DownloadCancelledFailure;

  const factory Failure.onDevice() = OnDeviceFailure;
  const factory Failure.unexpected() = UnexpectedFailure;

  static Failure fromError(Object error) => switch (error) {
    Failure() => error,
    LlmAuthException() => const UnauthorizedFailure(),
    LlmRateLimitException() => const RateLimitFailure(),
    LlmServerException() => const ServerFailure(),
    LlmRequestException(:final message) => ProviderRequestFailure(message),
    LlmNetworkException() => const NetworkFailure(),
    LlmTimeoutException() => const TimeoutFailure(),
    LlmRefusalException() => const RefusalFailure(),
    LlmInvalidResponseException() => const InvalidResponseFailure(),
    LlmModelNotInstalledException() => const ModelNotInstalledFailure(),
    LlmModelAccessException() => const ModelAccessDeniedFailure(),
    LlmModelNotFoundException() => const ModelNotFoundFailure(),
    LlmDownloadCancelledException() => const DownloadCancelledFailure(),
    LlmOnDeviceException() => const OnDeviceFailure(),
    _ => const UnexpectedFailure(),
  };
}
