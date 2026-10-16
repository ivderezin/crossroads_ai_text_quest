import '../../../../core/llm/llm_config.dart';

abstract interface class ModelCatalogRepository {
  Future<List<String>> fetchModels(RemoteLlmConfig config);
}
