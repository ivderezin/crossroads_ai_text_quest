import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/quest_scene.dart';

class QuestJournal extends StatelessWidget {
  const QuestJournal({super.key, required this.pastScenes});
  final List<QuestScene> pastScenes;

  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: Text(context.l10n.journalTitle),
    tilePadding: EdgeInsets.zero,
    children: [
      for (final scene in pastScenes)
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MutedText(scene.text),
              const SizedBox(height: 10),
              Text(
                context.l10n.journalChoice(scene.action ?? ''),
                style: TextStyle(color: context.colors.primary),
              ),
            ],
          ),
        ),
    ],
  );
}
