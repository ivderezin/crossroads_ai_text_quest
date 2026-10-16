import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/llm/local/local_model.dart';
import '../../domain/repositories/local_model_repository.dart';

part 'local_model_cubit.freezed.dart';

@freezed
abstract class LocalModelState with _$LocalModelState {
  const factory LocalModelState({
    String? downloadingUrl,
    @Default(0) int progress,
    String? deletingUrl,
    Failure? failure,
  }) = _LocalModelState;

  const LocalModelState._();

  bool get isBusy => downloadingUrl != null || deletingUrl != null;
}

// Provided app-wide so a download survives leaving the settings screen.
@injectable
class LocalModelCubit extends Cubit<LocalModelState> {
  LocalModelCubit(this._repository) : super(const LocalModelState());

  final LocalModelRepository _repository;

  Future<String?> download(LocalModel model, {String? token}) async {
    if (state.isBusy) return null;
    emit(LocalModelState(downloadingUrl: model.url));
    try {
      final installId = await _repository.download(
        model,
        token: token,
        onProgress: (percent) {
          if (!isClosed) emit(state.copyWith(progress: percent));
        },
      );
      emit(const LocalModelState());
      return installId;
    } on Failure catch (failure) {
      emit(
        LocalModelState(
          failure: failure is DownloadCancelledFailure ? null : failure,
        ),
      );
      return null;
    }
  }

  void cancelDownload() => _repository.cancelDownload();

  Future<bool> delete(LocalModel model, String installId) async {
    if (state.isBusy) return false;
    emit(LocalModelState(deletingUrl: model.url));
    try {
      await _repository.delete(installId);
      emit(const LocalModelState());
      return true;
    } on Failure catch (failure) {
      emit(LocalModelState(failure: failure));
      return false;
    }
  }
}
