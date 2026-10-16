import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/quest_scene.dart';

class CustomActionField extends StatelessWidget {
  const CustomActionField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  final TextEditingController controller;

  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final enabled = onSubmitted != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          maxLength: QuestScene.maxActionLength,
          minLines: 1,
          maxLines: 4,
          decoration: InputDecoration(labelText: l10n.customActionLabel),
        ),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) => TextButton.icon(
            onPressed: enabled && controller.text.trim().isNotEmpty
                ? () => onSubmitted!(controller.text.trim())
                : null,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(l10n.customActionSubmit),
          ),
        ),
      ],
    );
  }
}
