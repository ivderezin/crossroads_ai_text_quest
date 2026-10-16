part of 'quest_bloc.dart';

enum QuestStatus { loading, ready }

@freezed
abstract class QuestState with _$QuestState {
  const factory QuestState({
    @Default(QuestStatus.loading) QuestStatus status,
    Quest? quest,
    @Default(false) bool isGenerating,
    // Reset when the next operation starts, so the same error shows again.
    Failure? failure,
  }) = _QuestState;
}
