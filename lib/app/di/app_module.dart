import 'package:injectable/injectable.dart';

import '../../core/llm/llm_config.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';

// The quest feature reads the narrator config from settings via core.
@module
abstract class AppModule {
  @lazySingleton
  LlmConfigSource llmConfigSource(SettingsRepository settings) => settings;
}
