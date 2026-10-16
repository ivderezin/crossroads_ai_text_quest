import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/quest.dart';
import '../../domain/repositories/quest_repository.dart';
import '../../domain/usecases/continue_quest.dart';
import '../../domain/usecases/start_quest.dart';

part 'quest_bloc.freezed.dart';
part 'quest_event.dart';
part 'quest_state.dart';

@injectable
class QuestBloc extends Bloc<QuestEvent, QuestState> {
  QuestBloc(this._repository, this._startQuest, this._continueQuest)
    : super(const QuestState()) {
    // droppable: taps while a scene is being generated are ignored.
    on<QuestEvent>(
      (event, emit) => switch (event) {
        QuestLoadRequested() => _onLoad(emit),
        QuestStarted() => _onStarted(event, emit),
        QuestActionSubmitted() => _onActionSubmitted(event, emit),
      },
      transformer: droppable(),
    );
  }

  final QuestRepository _repository;
  final StartQuest _startQuest;
  final ContinueQuest _continueQuest;

  Future<void> _onLoad(Emitter<QuestState> emit) async {
    try {
      final quest = await _repository.load();
      emit(QuestState(status: QuestStatus.ready, quest: quest));
    } on Failure catch (failure) {
      emit(state.copyWith(status: QuestStatus.ready, failure: failure));
    }
  }

  Future<void> _onStarted(QuestStarted event, Emitter<QuestState> emit) =>
      _generate(emit, () => _startQuest(event.prompt));

  Future<void> _onActionSubmitted(
    QuestActionSubmitted event,
    Emitter<QuestState> emit,
  ) async {
    final quest = state.quest;
    if (quest == null ||
        quest.completed ||
        event.sceneNumber != quest.sceneNumber) {
      return;
    }
    await _generate(emit, () => _continueQuest(quest, event.action));
  }

  Future<void> _generate(
    Emitter<QuestState> emit,
    Future<Quest> Function() run,
  ) async {
    if (state.status != QuestStatus.ready) return;
    emit(state.copyWith(isGenerating: true, failure: null));
    try {
      final quest = await run();
      emit(state.copyWith(isGenerating: false, quest: quest));
    } catch (e) {
      emit(state.copyWith(isGenerating: false, failure: Failure.fromError(e)));
    }
  }
}
