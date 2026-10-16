import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/llm/local/local_model.dart';
import '../../../../core/theme/app_theme.dart';

class LocalModelTile extends StatelessWidget {
  const LocalModelTile({
    super.key,
    required this.model,
    required this.installed,
    required this.selected,
    required this.progress,
    required this.busy,
    required this.onSelect,
    required this.onDownload,
    required this.onCancel,
    required this.onDelete,
  });

  final LocalModel model;
  final bool installed;
  final bool selected;

  final int? progress;

  final bool busy;
  final VoidCallback onSelect;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final details = [
      if (installed) l10n.localModelDownloaded,
      if (model.sizeMb case final size? when !installed)
        l10n.localModelSize(size),
      if (model.gated && !installed) l10n.localModelGated,
      if (model.isCustom) l10n.customModelTitle,
    ].join(' · ');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        selected && installed
            ? Icons.radio_button_checked
            : Icons.radio_button_unchecked,
        color: installed ? context.colors.primary : context.colors.outline,
      ),
      title: Text(model.name),
      subtitle: progress != null
          ? Padding(
              padding: const EdgeInsets.only(top: 6),
              child: LinearProgressIndicator(value: progress! / 100),
            )
          : Text(details),
      onTap: installed && !selected ? onSelect : null,
      trailing: switch ((installed, progress)) {
        (_, final _?) => IconButton(
          tooltip: l10n.cancelDownload,
          icon: const Icon(Icons.close_rounded),
          onPressed: onCancel,
        ),
        (true, _) => IconButton(
          tooltip: l10n.deleteModel,
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: busy ? null : onDelete,
        ),
        (false, _) => IconButton(
          tooltip: l10n.downloadModel,
          icon: const Icon(Icons.download_rounded),
          onPressed: busy ? null : onDownload,
        ),
      },
    );
  }
}
