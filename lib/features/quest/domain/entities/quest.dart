import 'package:freezed_annotation/freezed_annotation.dart';

import 'quest_scene.dart';

part 'quest.freezed.dart';

@freezed
abstract class Quest with _$Quest {
  @Assert('scenes.length > 0', 'A quest has at least one scene')
  const factory Quest({
    required String prompt,
    required DateTime createdAt,
    required List<QuestScene> scenes,
  }) = _Quest;

  const Quest._();

  static const maxScenes = 12;
  static const maxPromptLength = 1000;

  QuestScene get current => scenes.last;
  bool get completed => current.isEnding;
  int get sceneNumber => scenes.length;

  bool get mustEndNext => scenes.length >= maxScenes - 1;

  Quest advance(String action, QuestScene next) => copyWith(
    scenes: [
      ...scenes.take(scenes.length - 1),
      current.copyWith(action: action),
      next,
    ],
  );
}
