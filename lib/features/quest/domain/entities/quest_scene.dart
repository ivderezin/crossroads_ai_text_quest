import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest_scene.freezed.dart';

@freezed
abstract class QuestScene with _$QuestScene {
  const factory QuestScene({
    required String title,
    required String text,
    required List<String> choices,
    required bool allowCustom,
    required bool isEnding,
    required String summary,
    String? action,
  }) = _QuestScene;

  const QuestScene._();

  static const maxActionLength = 500;

  bool accepts(String action) =>
      action.isNotEmpty &&
      action.length <= maxActionLength &&
      (allowCustom || choices.contains(action));
}
