import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/llm/llm_config.dart';
import '../../domain/repositories/model_catalog_repository.dart';

part 'model_catalog_cubit.freezed.dart';

@freezed
sealed class ModelCatalogState with _$ModelCatalogState {
  const factory ModelCatalogState.idle() = ModelCatalogIdle;
  const factory ModelCatalogState.loading() = ModelCatalogLoading;
  const factory ModelCatalogState.loaded(List<String> models) =
      ModelCatalogLoaded;
  const factory ModelCatalogState.failed(Failure failure) = ModelCatalogFailed;
}

@injectable
class ModelCatalogCubit extends Cubit<ModelCatalogState> {
  ModelCatalogCubit(this._repository) : super(const ModelCatalogIdle());

  final ModelCatalogRepository _repository;
  RemoteLlmConfig? _requested;

  Future<void> fetch(RemoteLlmConfig config) async {
    if (state is ModelCatalogLoading) return;
    _requested = config;
    emit(const ModelCatalogLoading());
    try {
      final models = await _repository.fetchModels(config);
      if (_requested == config && !isClosed) emit(ModelCatalogLoaded(models));
    } on Failure catch (failure) {
      if (_requested == config && !isClosed) emit(ModelCatalogFailed(failure));
    }
  }

  void reset() {
    _requested = null;
    emit(const ModelCatalogIdle());
  }
}
