import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

abstract final class ReplaceQuestDialog {
  static Future<bool> confirm(BuildContext context) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.replaceDialogTitle),
        content: Text(l10n.replaceDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.start),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
