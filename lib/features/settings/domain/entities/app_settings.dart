import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/llm/llm_config.dart';
import '../../../../core/llm/llm_provider.dart';
import '../../../../core/llm/local/local_model.dart';
import 'narrator.dart';
import 'provider_settings.dart';

part 'app_settings.freezed.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    String? appLanguage,
    @Default(Narrator.anthropic) Narrator narrator,
    @Default({}) Map<LlmProvider, ProviderSettings> providers,
    String? localModelId,
    LocalModel? customLocalModel,
    // Model URL -> install id assigned by the engine.
    @Default({}) Map<String, String> installedLocalModels,
  }) = _AppSettings;

  const AppSettings._();

  Locale? get appLocale => appLanguage == null ? null : Locale(appLanguage!);

  ProviderSettings settingsFor(LlmProvider provider) =>
      providers[provider] ?? ProviderSettings.defaults(provider);

  List<LocalModel> get localModels => [
    ...LocalModel.catalog,
    ?customLocalModel,
  ];

  LocalModel get selectedLocalModel =>
      localModels.where((m) => m.id == localModelId).firstOrNull ??
      LocalModel.catalog.first;

  String? installIdOf(LocalModel model) => installedLocalModels[model.url];

  LlmConfig? get activeConfig {
    if (narrator.remoteProvider case final provider?) {
      final settings = settingsFor(provider);
      return settings.isConfigured ? settings.toConfig(provider) : null;
    }
    final model = selectedLocalModel;
    final installId = installIdOf(model);
    return installId == null
        ? null
        : LocalLlmConfig(model: model, installId: installId);
  }
}
