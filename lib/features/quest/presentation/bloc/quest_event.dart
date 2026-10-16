part of 'quest_bloc.dart';

@freezed
sealed class QuestEvent with _$QuestEvent {
  const factory QuestEvent.loadRequested() = QuestLoadRequested;

  const factory QuestEvent.started(String prompt) = QuestStarted;

  // sceneNumber lets the bloc drop taps from a scene that's already gone.
  const factory QuestEvent.actionSubmitted({
    required String action,
    required int sceneNumber,
  }) = QuestActionSubmitted;
}
