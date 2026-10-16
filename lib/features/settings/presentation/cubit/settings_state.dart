part of 'settings_cubit.dart';

enum SettingsStatus { loading, ready }

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsStatus.loading) SettingsStatus status,
    @Default(AppSettings()) AppSettings settings,
    Failure? failure,
  }) = _SettingsState;

  const SettingsState._();

  bool get isConfigured => settings.activeConfig != null;
}
