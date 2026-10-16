import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/narrator.dart';

extension NarratorLabel on Narrator {
  String label(AppLocalizations l10n) =>
      remoteProvider?.displayName ?? l10n.narratorOnDevice;
}

class NarratorSelector extends StatelessWidget {
  const NarratorSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Narrator selected;
  final ValueChanged<Narrator> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<Narrator>(
    segments: [
      for (final narrator in Narrator.values)
        ButtonSegment(
          value: narrator,
          label: Text(narrator.label(context.l10n)),
          icon: Icon(
            narrator == Narrator.onDevice
                ? Icons.phone_iphone_rounded
                : Icons.cloud_outlined,
          ),
        ),
    ],
    selected: {selected},
    showSelectedIcon: false,
    onSelectionChanged: (selection) => onChanged(selection.single),
  );
}
