import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/llm/llm_client_factory.dart';
import '../../../../core/llm/llm_config.dart';
import '../../domain/entities/quest.dart';
import '../../domain/entities/quest_scene.dart';
import '../../domain/repositories/story_generator.dart';
import '../models/quest_scene_dto.dart';
import '../services/quest_prompt_builder.dart';

@LazySingleton(as: StoryGenerator)
class LlmStoryGenerator implements StoryGenerator {
  LlmStoryGenerator(this._configSource, this._clients);

  final LlmConfigSource _configSource;
  final LlmClientFactory _clients;

  @override
  Future<QuestScene> generateScene({
    required String prompt,
    Quest? quest,
    String? action,
  }) async {
    final config = await _configSource.readActiveConfig();
    if (config == null) throw const NotConfiguredFailure();

    final request = QuestPromptBuilder.build(
      prompt: prompt,
      quest: quest,
      action: action,
    );
    final String output;
    try {
      output = await _clients.create(config).complete(request);
    } on Object catch (e) {
      throw Failure.fromError(e);
    }
    try {
      return QuestSceneDto.fromModelOutput(output);
    } on FormatException {
      throw const InvalidResponseFailure();
    }
  }
}
