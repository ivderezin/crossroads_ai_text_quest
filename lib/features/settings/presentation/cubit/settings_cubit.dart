import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/llm/llm_provider.dart';
import '../../../../core/llm/local/local_model.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/narrator.dart';
import '../../domain/entities/provider_settings.dart';
import '../../domain/repositories/local_model_repository.dart';
import '../../domain/repositories/settings_repository.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository, this._localModels)
    : super(const SettingsState());

  final SettingsRepository _repository;
  final LocalModelRepository _localModels;

  Future<void> load() async {
    try {
      var settings = await _repository.load();
      final installed = await _localModels.verify(
        settings.installedLocalModels,
      );
      if (installed.length != settings.installedLocalModels.length) {
        await _repository.saveInstalledLocalModels(installed);
        settings = settings.copyWith(installedLocalModels: installed);
      }
      emit(SettingsState(status: SettingsStatus.ready, settings: settings));
    } on Failure catch (failure) {
      emit(state.copyWith(status: SettingsStatus.ready, failure: failure));
    }
  }

  Future<void> setAppLanguage(String? code) => _update(
    state.settings.copyWith(appLanguage: code),
    () => _repository.saveAppLanguage(code),
  );

  Future<void> selectNarrator(Narrator narrator) => _update(
    state.settings.copyWith(narrator: narrator),
    () => _repository.saveNarrator(narrator),
  );

  Future<bool> saveProviderSettings(
    LlmProvider provider,
    ProviderSettings settings,
  ) => _update(
    state.settings.copyWith(
      providers: {...state.settings.providers, provider: settings},
    ),
    () => _repository.saveProviderSettings(provider, settings),
  );

  Future<void> selectLocalModel(LocalModel model) => _update(
    state.settings.copyWith(localModelId: model.id),
    () => _repository.saveLocalModelId(model.id),
  );

  Future<bool> setCustomLocalModel(LocalModel model) => _update(
    state.settings.copyWith(customLocalModel: model, localModelId: model.id),
    () async {
      await _repository.saveCustomLocalModel(model);
      await _repository.saveLocalModelId(model.id);
    },
  );

  Future<void> registerInstalledModel(LocalModel model, String installId) {
    final installed = {
      ...state.settings.installedLocalModels,
      model.url: installId,
    };
    return _update(
      state.settings.copyWith(
        installedLocalModels: installed,
        localModelId: model.id,
      ),
      () async {
        await _repository.saveInstalledLocalModels(installed);
        await _repository.saveLocalModelId(model.id);
      },
    );
  }

  Future<void> forgetInstalledModel(LocalModel model) {
    final installed = {...state.settings.installedLocalModels}
      ..remove(model.url);
    return _update(
      state.settings.copyWith(installedLocalModels: installed),
      () => _repository.saveInstalledLocalModels(installed),
    );
  }

  Future<bool> _update(AppSettings next, Future<void> Function() save) async {
    final previous = state.settings;
    emit(state.copyWith(settings: next, failure: null));
    try {
      await save();
      return true;
    } on Failure catch (failure) {
      emit(state.copyWith(settings: previous, failure: failure));
      return false;
    }
  }
}
