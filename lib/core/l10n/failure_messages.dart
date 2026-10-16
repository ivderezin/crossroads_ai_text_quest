import '../error/failures.dart';
import 'gen/app_localizations.dart';

extension FailureMessage on Failure {
  String message(AppLocalizations l10n) => switch (this) {
    NotConfiguredFailure() => l10n.errorNotConfigured,
    UnauthorizedFailure() => l10n.errorUnauthorized,
    RateLimitFailure() => l10n.errorRateLimited,
    ServerFailure() => l10n.errorServer,
    ProviderRequestFailure(:final details) =>
      details == null || details.isEmpty
          ? l10n.errorProviderRequestGeneric
          : l10n.errorProviderRequest(details),
    NetworkFailure() => l10n.errorNetwork,
    TimeoutFailure() => l10n.errorTimeout,
    RefusalFailure() => l10n.errorRefusal,
    InvalidResponseFailure() => l10n.errorInvalidResponse,
    StorageFailure() => l10n.errorStorage,
    CorruptedSaveFailure() => l10n.errorCorruptedSave,
    InvalidPromptFailure() => l10n.errorInvalidPrompt,
    InvalidActionFailure() => l10n.errorInvalidAction,
    ModelNotInstalledFailure() => l10n.errorModelNotInstalled,
    ModelAccessDeniedFailure() => l10n.errorModelAccessDenied,
    ModelNotFoundFailure() => l10n.errorModelNotFound,
    DownloadCancelledFailure() => l10n.errorDownloadCancelled,
    OnDeviceFailure() => l10n.errorOnDevice,
    UnexpectedFailure() => l10n.errorUnexpected,
  };
}
