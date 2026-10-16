import 'package:freezed_annotation/freezed_annotation.dart';

import 'llm_provider.dart';
import 'local/local_model.dart';

part 'llm_config.freezed.dart';

@freezed
sealed class LlmConfig with _$LlmConfig {
  const factory LlmConfig.remote({
    required LlmProvider provider,
    required String apiKey,
    required String model,
    required String baseUrl,
  }) = RemoteLlmConfig;

  const factory LlmConfig.local({
    required LocalModel model,
    required String installId,
  }) = LocalLlmConfig;
}

extension RemoteLlmConfigX on RemoteLlmConfig {
  String get normalizedBaseUrl => _normalize(baseUrl);

  bool get usesDefaultBaseUrl =>
      normalizedBaseUrl == _normalize(provider.defaultBaseUrl);

  static String _normalize(String url) =>
      url.trim().replaceAll(RegExp(r'/+$'), '');
}

abstract interface class LlmConfigSource {
  Future<LlmConfig?> readActiveConfig();
}
