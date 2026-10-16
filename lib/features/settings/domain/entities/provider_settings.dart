import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/llm/llm_config.dart';
import '../../../../core/llm/llm_provider.dart';

part 'provider_settings.freezed.dart';

@freezed
abstract class ProviderSettings with _$ProviderSettings {
  const factory ProviderSettings({
    required String apiKey,
    required String model,
    required String baseUrl,
  }) = _ProviderSettings;

  const ProviderSettings._();

  factory ProviderSettings.defaults(LlmProvider provider) => ProviderSettings(
    apiKey: '',
    model: provider.defaultModel,
    baseUrl: provider.defaultBaseUrl,
  );
  bool get hasValidBaseUrl {
    final uri = Uri.tryParse(baseUrl.trim());
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }

  bool get isConfigured =>
      apiKey.trim().isNotEmpty && model.trim().isNotEmpty && hasValidBaseUrl;
  RemoteLlmConfig toConfig(LlmProvider provider) => RemoteLlmConfig(
    provider: provider,
    apiKey: apiKey.trim(),
    model: model.trim(),
    baseUrl: baseUrl.trim(),
  );
}
