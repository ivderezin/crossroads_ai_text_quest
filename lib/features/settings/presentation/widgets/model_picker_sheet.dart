import 'package:flutter/material.dart';

import '../../../../core/widgets/section_card.dart';

class ModelPickerSheet extends StatelessWidget {
  const ModelPickerSheet({
    super.key,
    required this.title,
    required this.models,
    required this.selected,
  });

  final String title;
  final List<String> models;
  final String selected;

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required List<String> models,
    required String selected,
  }) => showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) =>
        ModelPickerSheet(title: title, models: models, selected: selected),
  );

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.6,
    maxChildSize: 0.9,
    builder: (context, controller) => ListView(
      controller: controller,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Overline(title),
        ),
        for (final model in models)
          ListTile(
            title: Text(model),
            trailing: model == selected ? const Icon(Icons.check) : null,
            onTap: () => Navigator.pop(context, model),
          ),
      ],
    ),
  );
}
