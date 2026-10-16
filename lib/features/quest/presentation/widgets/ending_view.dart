import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';

class EndingView extends StatelessWidget {
  const EndingView({super.key, required this.onNewStory});
  final VoidCallback onNewStory;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Divider(),
      const SizedBox(height: 12),
      Text(context.l10n.endingTitle, style: context.textStyles.titleLarge),
      const SizedBox(height: 8),
      Text(context.l10n.endingBody),
      const SizedBox(height: 20),
      FilledButton(onPressed: onNewStory, child: Text(context.l10n.newStory)),
    ],
  );
}
