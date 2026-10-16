import '../../../../core/llm/llm_config.dart';
import '../../../../core/llm/llm_provider.dart';
import '../../../../core/llm/local/local_model.dart';
import '../entities/app_settings.dart';
import '../entities/narrator.dart';
import '../entities/provider_settings.dart';

abstract interface class SettingsRepository implements LlmConfigSource {
  Future<AppSettings> load();
  Future<void> saveAppLanguage(String? code);
  Future<void> saveNarrator(Narrator narrator);
  Future<void> saveProviderSettings(
    LlmProvider provider,
    ProviderSettings settings,
  );
  Future<void> saveLocalModelId(String id);
  Future<void> saveCustomLocalModel(LocalModel? model);
  Future<void> saveInstalledLocalModels(Map<String, String> installed);
}
