enum LlmProvider {
  anthropic(
    displayName: 'Claude',
    vendor: 'Anthropic',
    defaultBaseUrl: 'https://api.anthropic.com/v1',
    defaultModel: 'claude-opus-5-5',
    suggestedModels: [
      'claude-opus-5-5',
      'claude-sonnet-5-5',
      'claude-haiku-5-5',
      'claude-fable-5-1',
    ],
    consoleUrl: 'https://console.anthropic.com/settings/keys',
  ),
  openai(
    displayName: 'GPT',
    vendor: 'OpenAI',
    defaultBaseUrl: 'https://api.openai.com/v1',
    defaultModel: 'gpt-5',
    suggestedModels: ['gpt-5', 'gpt-5-mini'],
    consoleUrl: 'https://platform.openai.com/api-keys',
  );

  const LlmProvider({
    required this.displayName,
    required this.vendor,
    required this.defaultBaseUrl,
    required this.defaultModel,
    required this.suggestedModels,
    required this.consoleUrl,
  });

  final String displayName;
  final String vendor;
  final String defaultBaseUrl;
  final String defaultModel;
  final List<String> suggestedModels;
  final String consoleUrl;

  static LlmProvider? tryParse(String? name) {
    for (final provider in values) {
      if (provider.name == name) return provider;
    }
    return null;
  }
}
