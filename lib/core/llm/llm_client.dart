import 'package:freezed_annotation/freezed_annotation.dart';

part 'llm_client.freezed.dart';

@freezed
abstract class LlmRequest with _$LlmRequest {
  const factory LlmRequest({
    required String system,
    required String user,
    @Default(16000) int maxTokens,
    @Default(true) bool jsonOutput,
  }) = _LlmRequest;
}

abstract interface class LlmClient {
  Future<String> complete(LlmRequest request);

  Future<List<String>> listModels();
}
