import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/section_card.dart';

class SetupCard extends StatelessWidget {
  const SetupCard({super.key});

  @override
  Widget build(BuildContext context) => SectionCard(
    title: context.l10n.setupTitle,
    children: [
      MutedText(context.l10n.setupBody),
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: () => context.push(AppRoutes.settings),
        icon: const Icon(Icons.key_rounded),
        label: Text(context.l10n.openSettings),
      ),
    ],
  );
}
