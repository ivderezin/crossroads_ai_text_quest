import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/quest.dart';
import '../repositories/quest_repository.dart';
import '../repositories/story_generator.dart';

@injectable
class StartQuest {
  StartQuest(
    this._generator,
    this._repository, {
    @ignoreParam DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final StoryGenerator _generator;
  final QuestRepository _repository;
  final DateTime Function() _clock;

  Future<Quest> call(String prompt) async {
    final wishes = prompt.trim();
    if (wishes.isEmpty || wishes.length > Quest.maxPromptLength) {
      throw const InvalidPromptFailure();
    }
    final scene = await _generator.generateScene(prompt: wishes);
    if (scene.isEnding) throw const InvalidResponseFailure();
    final quest = Quest(prompt: wishes, createdAt: _clock(), scenes: [scene]);
    await _repository.save(quest);
    return quest;
  }
}
