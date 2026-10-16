import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'llm_client.dart';
import 'llm_config.dart';
import 'llm_provider.dart';
import 'local/local_llm_client.dart';
import 'local/on_device_engine.dart';
import 'remote/anthropic_client.dart';
import 'remote/openai_client.dart';

@lazySingleton
class LlmClientFactory {
  LlmClientFactory(this._dio, this._engine);

  final Dio _dio;
  final OnDeviceEngine _engine;

  LlmClient create(LlmConfig config) => switch (config) {
    RemoteLlmConfig(provider: LlmProvider.anthropic) => AnthropicClient(
      config,
      _dio,
    ),
    RemoteLlmConfig(provider: LlmProvider.openai) => OpenAiClient(config, _dio),
    LocalLlmConfig() => LocalLlmClient(config, _engine),
  };
}
