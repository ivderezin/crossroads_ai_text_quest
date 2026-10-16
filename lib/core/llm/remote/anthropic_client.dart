import 'package:dio/dio.dart';

import '../../network/dio_error_mapper.dart';
import '../llm_client.dart';
import '../llm_config.dart';
import '../llm_exception.dart';
import 'anthropic_api.dart';
import 'remote_dtos.dart';

final class AnthropicClient implements LlmClient {
  AnthropicClient(this._config, Dio dio)
    : _api = AnthropicApi(dio, baseUrl: _config.normalizedBaseUrl);

  final RemoteLlmConfig _config;
  final AnthropicApi _api;

  static const apiVersion = '2023-06-01';
  static const _fallbackBeta = 'server-side-fallback-2026-07-01';

  static const _fallbackModels = {
    'claude-fable-5-1',
    'claude-opus-5-5',
    'claude-opus-5',
    'claude-sonnet-5-5',
  };

  @override
  Future<String> complete(LlmRequest request) async {
    // `fallbacks` is a beta of the official API; proxies may reject it.
    final useFallbacks =
        _config.usesDefaultBaseUrl && _fallbackModels.contains(_config.model);
    final response = await guardRemoteCall(
      () => _api.createMessage(
        _config.apiKey,
        apiVersion,
        AnthropicMessageRequest(
          model: _config.model,
          maxTokens: request.maxTokens,
          system: request.system,
          messages: [ChatMessageDto(role: 'user', content: request.user)],
          fallbacks: useFallbacks ? 'default' : null,
        ),
        beta: useFallbacks ? _fallbackBeta : null,
      ),
    );

    switch (response.stopReason) {
      case 'refusal':
        throw const LlmRefusalException();
      case 'max_tokens':
        throw const LlmInvalidResponseException('Response was truncated');
    }
    final text = response.content
        .where((block) => block.type == 'text')
        .map((block) => block.text ?? '')
        .join();
    if (text.trim().isEmpty) {
      throw const LlmInvalidResponseException('Empty response');
    }
    return text;
  }

  @override
  Future<List<String>> listModels() async {
    final response = await guardRemoteCall(
      () => _api.listModels(_config.apiKey, apiVersion),
    );
    return [for (final model in response.data) model.id];
  }
}
