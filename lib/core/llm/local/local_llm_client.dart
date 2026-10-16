import '../llm_client.dart';
import '../llm_config.dart';
import 'on_device_engine.dart';

final class LocalLlmClient implements LlmClient {
  LocalLlmClient(this._config, this._engine);

  final LocalLlmConfig _config;
  final OnDeviceEngine _engine;

  @override
  Future<String> complete(LlmRequest request) => _engine.generate(
    _config.model,
    installId: _config.installId,
    prompt: '${request.system}\nData: ${request.user}',
  );

  @override
  Future<List<String>> listModels() async => [_config.model.name];
}
