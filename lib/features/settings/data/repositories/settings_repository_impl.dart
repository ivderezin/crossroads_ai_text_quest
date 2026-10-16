import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/llm/llm_config.dart';
import '../../../../core/llm/llm_provider.dart';
import '../../../../core/llm/local/local_model.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/narrator.dart';
import '../../domain/entities/provider_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._source);
  final SettingsLocalDataSource _source;

  @override
  Future<AppSettings> load() => _guard(() async {
    return AppSettings(
      appLanguage: await _source.readAppLanguage(),
      narrator:
          Narrator.tryParse(await _source.readNarrator()) ?? Narrator.anthropic,
      providers: {
        for (final provider in LlmProvider.values)
          provider: await _loadProvider(provider),
      },
      localModelId: await _source.readLocalModelId(),
      customLocalModel: _decodeModel(await _source.readCustomLocalModel()),
      installedLocalModels: _decodeInstalled(
        await _source.readInstalledLocalModels(),
      ),
    );
  });

  Future<ProviderSettings> _loadProvider(LlmProvider provider) async =>
      ProviderSettings(
        apiKey: await _source.readApiKey(provider) ?? '',
        model: await _source.readModel(provider) ?? provider.defaultModel,
        baseUrl: await _source.readBaseUrl(provider) ?? provider.defaultBaseUrl,
      );

  static LocalModel? _decodeModel(String? raw) {
    if (raw == null) return null;
    try {
      return LocalModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  static Map<String, String> _decodeInstalled(String? raw) {
    if (raw == null) return const {};
    try {
      return (jsonDecode(raw) as Map<String, dynamic>).cast<String, String>();
    } on Object {
      return const {};
    }
  }

  @override
  Future<LlmConfig?> readActiveConfig() async => (await load()).activeConfig;

  @override
  Future<void> saveAppLanguage(String? code) =>
      _guard(() => _source.writeAppLanguage(code));

  @override
  Future<void> saveNarrator(Narrator narrator) =>
      _guard(() => _source.writeNarrator(narrator.name));

  @override
  Future<void> saveProviderSettings(
    LlmProvider provider,
    ProviderSettings settings,
  ) => _guard(() async {
    await _source.writeApiKey(provider, settings.apiKey.trim());
    await _source.writeModel(provider, settings.model.trim());
    await _source.writeBaseUrl(provider, settings.baseUrl.trim());
  });

  @override
  Future<void> saveLocalModelId(String id) =>
      _guard(() => _source.writeLocalModelId(id));

  @override
  Future<void> saveCustomLocalModel(LocalModel? model) => _guard(
    () => _source.writeCustomLocalModel(
      model == null ? null : jsonEncode(model.toJson()),
    ),
  );

  @override
  Future<void> saveInstalledLocalModels(Map<String, String> installed) =>
      _guard(() => _source.writeInstalledLocalModels(jsonEncode(installed)));

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on Object {
      throw const StorageFailure();
    }
  }
}
