import 'package:dio/dio.dart';

import '../../network/dio_error_mapper.dart';
import '../llm_client.dart';
import '../llm_config.dart';
import '../llm_exception.dart';
import 'openai_api.dart';
import 'remote_dtos.dart';

final class OpenAiClient implements LlmClient {
  OpenAiClient(this._config, Dio dio)
    : _api = OpenAiApi(dio, baseUrl: _config.normalizedBaseUrl);

  final RemoteLlmConfig _config;
  final OpenAiApi _api;

  static final _chatModel = RegExp(r'^(gpt-|o\d|chatgpt-)');
  static final _nonChatModel = RegExp(
    r'(audio|realtime|transcribe|tts|image|embedding|search|instruct|moderation)',
  );

  String get _authorization => 'Bearer ${_config.apiKey}';

  @override
  Future<String> complete(LlmRequest request) async {
    final response = await guardRemoteCall(
      () => _api.createChatCompletion(
        _authorization,
        ChatCompletionRequest(
          model: _config.model,
          messages: [
            ChatMessageDto(role: 'system', content: request.system),
            ChatMessageDto(role: 'user', content: request.user),
          ],
          maxCompletionTokens: request.maxTokens,
          responseFormat: request.jsonOutput
              ? const ResponseFormatDto(type: 'json_object')
              : null,
        ),
      ),
    );

    final choice = response.choices.firstOrNull;
    if (choice == null) {
      throw const LlmInvalidResponseException('No choices in response');
    }
    if (choice.finishReason == 'content_filter' ||
        choice.message?.refusal != null) {
      throw const LlmRefusalException();
    }
    if (choice.finishReason == 'length') {
      throw const LlmInvalidResponseException('Response was truncated');
    }
    final text = choice.message?.content;
    if (text == null || text.trim().isEmpty) {
      throw const LlmInvalidResponseException('Empty response');
    }
    return text;
  }

  @override
  Future<List<String>> listModels() async {
    final response = await guardRemoteCall(
      () => _api.listModels(_authorization),
    );
    final ids = response.data.map((model) => model.id);
    // The official list also includes embedding, audio and image models.
    final filtered = _config.usesDefaultBaseUrl
        ? ids.where(
            (id) => _chatModel.hasMatch(id) && !_nonChatModel.hasMatch(id),
          )
        : ids;
    return filtered.toList()..sort((a, b) => b.compareTo(a));
  }
}
