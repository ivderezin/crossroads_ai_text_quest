import '../entities/quest.dart';
import '../entities/quest_scene.dart';

abstract interface class StoryGenerator {
  Future<QuestScene> generateScene({
    required String prompt,
    Quest? quest,
    String? action,
  });
}
