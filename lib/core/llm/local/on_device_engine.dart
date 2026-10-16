import 'local_model.dart';

abstract interface class OnDeviceEngine {
  Future<String> install(
    LocalModel model, {
    String? token,
    void Function(int percent)? onProgress,
  });

  void cancelInstall();

  Future<bool> isInstalled(String installId);

  Future<void> uninstall(String installId);

  Future<String> generate(
    LocalModel model, {
    required String installId,
    required String prompt,
  });
}
