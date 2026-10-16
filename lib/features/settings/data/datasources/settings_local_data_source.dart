import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/llm/llm_provider.dart';

@lazySingleton
class SettingsLocalDataSource {
  SettingsLocalDataSource(this._preferences, this._secure);

  final SharedPreferencesAsync _preferences;
  final FlutterSecureStorage _secure;

  static const _appLanguage = 'settings.appLanguage';
  static const _narrator = 'settings.narrator';
  static const _localModelId = 'settings.local.modelId';
  static const _customLocalModel = 'settings.local.custom';
  static const _installedLocalModels = 'settings.local.installed';
  static String _model(LlmProvider p) => 'settings.${p.name}.model';
  static String _baseUrl(LlmProvider p) => 'settings.${p.name}.baseUrl';
  static String _apiKey(LlmProvider p) => 'apiKey.${p.name}';

  Future<String?> _read(String key) => _preferences.getString(key);

  Future<void> _write(String key, String? value) => value == null
      ? _preferences.remove(key)
      : _preferences.setString(key, value);

  Future<String?> readAppLanguage() => _read(_appLanguage);
  Future<void> writeAppLanguage(String? v) => _write(_appLanguage, v);

  Future<String?> readNarrator() => _read(_narrator);
  Future<void> writeNarrator(String v) => _write(_narrator, v);

  Future<String?> readModel(LlmProvider p) => _read(_model(p));
  Future<void> writeModel(LlmProvider p, String v) => _write(_model(p), v);

  Future<String?> readBaseUrl(LlmProvider p) => _read(_baseUrl(p));
  Future<void> writeBaseUrl(LlmProvider p, String v) => _write(_baseUrl(p), v);

  Future<String?> readApiKey(LlmProvider p) => _secure.read(key: _apiKey(p));
  Future<void> writeApiKey(LlmProvider p, String v) => v.isEmpty
      ? _secure.delete(key: _apiKey(p))
      : _secure.write(key: _apiKey(p), value: v);

  Future<String?> readLocalModelId() => _read(_localModelId);
  Future<void> writeLocalModelId(String v) => _write(_localModelId, v);

  Future<String?> readCustomLocalModel() => _read(_customLocalModel);
  Future<void> writeCustomLocalModel(String? v) => _write(_customLocalModel, v);

  Future<String?> readInstalledLocalModels() => _read(_installedLocalModels);
  Future<void> writeInstalledLocalModels(String v) =>
      _write(_installedLocalModels, v);
}
