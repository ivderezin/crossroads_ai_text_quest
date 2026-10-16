import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/quest.dart';
import '../repositories/quest_repository.dart';
import '../repositories/story_generator.dart';

@injectable
class ContinueQuest {
  const ContinueQuest(this._generator, this._repository);

  final StoryGenerator _generator;
  final QuestRepository _repository;

  Future<Quest> call(Quest quest, String action) async {
    final value = action.trim();
    if (quest.completed || !quest.current.accepts(value)) {
      throw const InvalidActionFailure();
    }
    final scene = await _generator.generateScene(
      prompt: quest.prompt,
      quest: quest,
      action: value,
    );
    if (quest.mustEndNext && !scene.isEnding) {
      throw const InvalidResponseFailure();
    }
    final next = quest.advance(value, scene);
    await _repository.save(next);
    return next;
  }
}
