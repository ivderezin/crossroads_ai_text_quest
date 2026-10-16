import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/section_card.dart';

class GenerationProgress extends StatelessWidget {
  const GenerationProgress({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      children: [
        const LinearProgressIndicator(),
        const SizedBox(height: 12),
        MutedText(context.l10n.generating, textAlign: TextAlign.center),
      ],
    ),
  );
}
