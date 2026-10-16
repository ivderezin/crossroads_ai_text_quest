import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/quest.dart';

class ResumeCard extends StatelessWidget {
  const ResumeCard({super.key, required this.quest, required this.onOpen});

  final Quest quest;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SectionCard(
      overline: quest.completed ? l10n.resumeCompleted : l10n.resumeOngoing,
      children: [
        Text(quest.scenes.first.title, style: context.textStyles.titleLarge),
        const SizedBox(height: 8),
        Text(
          quest.completed
              ? l10n.resumeProgressCompleted(quest.sceneNumber)
              : l10n.resumeProgressSaved(quest.sceneNumber),
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: onOpen,
          icon: const Icon(Icons.play_arrow_rounded),
          label: Text(quest.completed ? l10n.resumeRead : l10n.resumeContinue),
        ),
      ],
    );
  }
}
