import '../../../../core/llm/llm_provider.dart';

enum Narrator {
  anthropic(LlmProvider.anthropic),
  openai(LlmProvider.openai),
  onDevice(null);

  const Narrator(this.remoteProvider);
  final LlmProvider? remoteProvider;

  static Narrator? tryParse(String? name) =>
      values.where((n) => n.name == name).firstOrNull;
}
