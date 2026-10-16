import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/quest.dart';
import 'quest_scene_dto.dart';

part 'quest_dto.freezed.dart';
part 'quest_dto.g.dart';

@freezed
abstract class QuestDto with _$QuestDto {
  const factory QuestDto({
    required String prompt,
    required DateTime createdAt,
    required List<QuestSceneDto> scenes,
  }) = _QuestDto;

  const QuestDto._();

  factory QuestDto.fromJson(Map<String, dynamic> json) =>
      _$QuestDtoFromJson(json);

  factory QuestDto.fromDomain(Quest quest) => QuestDto(
    prompt: quest.prompt,
    createdAt: quest.createdAt,
    scenes: [for (final s in quest.scenes) QuestSceneDto.fromDomain(s)],
  );
  Quest toDomain() {
    if (prompt.trim().isEmpty || prompt.length > Quest.maxPromptLength) {
      throw const FormatException('Unreadable quest save');
    }
    final domainScenes = [for (final s in scenes) s.toDomain()];
    final past = domainScenes.isEmpty
        ? domainScenes
        : domainScenes.sublist(0, domainScenes.length - 1);
    if (domainScenes.isEmpty ||
        domainScenes.length > Quest.maxScenes ||
        past.any((s) => s.isEnding || s.action == null) ||
        domainScenes.last.action != null) {
      throw const FormatException('Inconsistent quest history');
    }
    return Quest(prompt: prompt, createdAt: createdAt, scenes: domainScenes);
  }
}
