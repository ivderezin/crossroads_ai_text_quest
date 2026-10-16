import '../../../../core/llm/local/local_model.dart';

abstract interface class LocalModelRepository {
  Future<String> download(
    LocalModel model, {
    String? token,
    required void Function(int percent) onProgress,
  });

  void cancelDownload();

  Future<void> delete(String installId);

  Future<Map<String, String>> verify(Map<String, String> installed);
}
