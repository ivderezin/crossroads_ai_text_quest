import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/quest_scene.dart';

part 'quest_scene_dto.freezed.dart';
part 'quest_scene_dto.g.dart';

@freezed
abstract class QuestSceneDto with _$QuestSceneDto {
  const factory QuestSceneDto({
    required String title,
    required String text,
    required List<String> choices,
    required bool allowCustom,
    required bool isEnding,
    required String summary,
    String? action,
  }) = _QuestSceneDto;

  const QuestSceneDto._();

  factory QuestSceneDto.fromJson(Map<String, dynamic> json) =>
      _$QuestSceneDtoFromJson(json);

  factory QuestSceneDto.fromDomain(QuestScene scene) => QuestSceneDto(
    title: scene.title,
    text: scene.text,
    choices: scene.choices,
    allowCustom: scene.allowCustom,
    isEnding: scene.isEnding,
    summary: scene.summary,
    action: scene.action,
  );
  static QuestSceneDto parse(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Expected a scene object');
    }
    try {
      return QuestSceneDto.fromJson(json);
    } on Object catch (e) {
      throw FormatException('Invalid scene: $e');
    }
  }

  static QuestScene fromModelOutput(String output) {
    // Models sometimes wrap the JSON in markdown or add text around it.
    final start = output.indexOf('{');
    final end = output.lastIndexOf('}');
    if (start < 0 || end < start) {
      throw const FormatException('No JSON object in model output');
    }
    final dto = parse(jsonDecode(output.substring(start, end + 1)));
    // The player's action is never taken from the model.
    return dto.copyWith(action: null).toDomain();
  }

  static const _maxTitle = 100;
  static const _maxText = 2400;
  static const _maxSummary = 1200;
  static const _maxChoice = 180;
  static const _maxChoices = 4;
  QuestScene toDomain() {
    String checked(String value, int limit, String field) {
      final trimmed = value.trim();
      if (trimmed.isEmpty || value.length > limit) {
        throw FormatException('Invalid scene field: $field');
      }
      return trimmed;
    }

    if (choices.length > _maxChoices ||
        choices.any((c) => c.trim().isEmpty || c.length > _maxChoice)) {
      throw const FormatException('Invalid choices');
    }
    if (!isEnding && choices.length < 2) {
      throw const FormatException('A scene needs at least two choices');
    }
    if (action case final action?
        when action.length > QuestScene.maxActionLength) {
      throw const FormatException('Invalid action');
    }
    return QuestScene(
      title: checked(title, _maxTitle, 'title'),
      text: checked(text, _maxText, 'text'),
      choices: isEnding ? const [] : [for (final c in choices) c.trim()],
      allowCustom: !isEnding && allowCustom,
      isEnding: isEnding,
      summary: checked(summary, _maxSummary, 'summary'),
      action: action,
    );
  }
}
