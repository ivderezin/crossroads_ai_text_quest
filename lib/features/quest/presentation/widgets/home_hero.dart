import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_card.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Icon(
        Icons.auto_stories_outlined,
        size: 52,
        color: context.colors.primary,
      ),
      const SizedBox(height: 24),
      Text(
        context.l10n.homeHeadline,
        style: context.textStyles.displaySmall?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.15,
        ),
      ),
      const SizedBox(height: 16),
      MutedText(context.l10n.homeSubtitle),
    ],
  );
}
