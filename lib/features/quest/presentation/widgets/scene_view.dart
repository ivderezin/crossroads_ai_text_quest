import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/quest.dart';

class SceneView extends StatelessWidget {
  const SceneView({super.key, required this.quest});
  final Quest quest;

  @override
  Widget build(BuildContext context) {
    final scene = quest.current;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Overline(
          context.l10n.sceneCounter(
            quest.sceneNumber.toString().padLeft(2, '0'),
            Quest.maxScenes,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          scene.title,
          style: context.textStyles.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        SelectableText(
          scene.text,
          style: const TextStyle(fontSize: 18, height: 1.75),
        ),
      ],
    );
  }
}
