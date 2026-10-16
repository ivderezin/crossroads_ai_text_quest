import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/llm/local/local_model.dart';
import '../../../../core/llm/local/on_device_engine.dart';
import '../../domain/repositories/local_model_repository.dart';

@LazySingleton(as: LocalModelRepository)
class LocalModelRepositoryImpl implements LocalModelRepository {
  LocalModelRepositoryImpl(this._engine);
  final OnDeviceEngine _engine;

  @override
  Future<String> download(
    LocalModel model, {
    String? token,
    required void Function(int percent) onProgress,
  }) => _guard(
    () => _engine.install(model, token: token, onProgress: onProgress),
  );

  @override
  void cancelDownload() => _engine.cancelInstall();

  @override
  Future<void> delete(String installId) =>
      _guard(() => _engine.uninstall(installId));

  @override
  Future<Map<String, String>> verify(Map<String, String> installed) async {
    final present = <String, String>{};
    for (final MapEntry(:key, :value) in installed.entries) {
      try {
        if (await _engine.isInstalled(value)) present[key] = value;
      } on Object {
        // Can't check right now: better to keep the record than lose a download.
        present[key] = value;
      }
    }
    return present;
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on Object catch (e) {
      throw Failure.fromError(e);
    }
  }
}
