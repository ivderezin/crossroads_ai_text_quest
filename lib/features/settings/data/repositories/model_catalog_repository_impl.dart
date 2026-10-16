import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/llm/llm_client_factory.dart';
import '../../../../core/llm/llm_config.dart';
import '../../domain/repositories/model_catalog_repository.dart';

@LazySingleton(as: ModelCatalogRepository)
class ModelCatalogRepositoryImpl implements ModelCatalogRepository {
  ModelCatalogRepositoryImpl(this._clients);
  final LlmClientFactory _clients;

  @override
  Future<List<String>> fetchModels(RemoteLlmConfig config) async {
    try {
      return await _clients.create(config).listModels();
    } on Object catch (e) {
      throw Failure.fromError(e);
    }
  }
}
