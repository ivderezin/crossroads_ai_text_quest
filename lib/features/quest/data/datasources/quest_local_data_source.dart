import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class QuestLocalDataSource {
  QuestLocalDataSource(this._preferences);

  final SharedPreferencesAsync _preferences;

  static const key = 'quest.save';

  Future<String?> read() => _preferences.getString(key);

  Future<void> write(String json) => _preferences.setString(key, json);
}
