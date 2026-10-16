import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/llm/local/local_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_card.dart';
import '../cubit/local_model_cubit.dart';
import '../cubit/settings_cubit.dart';
import 'custom_model_form.dart';
import 'local_model_tile.dart';

class LocalModelsPanel extends StatefulWidget {
  const LocalModelsPanel({super.key});

  @override
  State<LocalModelsPanel> createState() => _LocalModelsPanelState();
}

class _LocalModelsPanelState extends State<LocalModelsPanel> {
  final _token = TextEditingController();
  var _obscure = true;

  @override
  void dispose() {
    _token.dispose();
    super.dispose();
  }

  Future<void> _download(LocalModel model) async {
    // Read before the await: the download keeps going if the page is closed.
    final settings = context.read<SettingsCubit>();
    final downloads = context.read<LocalModelCubit>();
    final installId = await downloads.download(model, token: _token.text);
    if (installId == null) return;
    await settings.registerInstalledModel(model, installId);
    if (mounted) _token.clear();
  }

  Future<void> _delete(LocalModel model, String installId) async {
    final settings = context.read<SettingsCubit>();
    final downloads = context.read<LocalModelCubit>();
    if (!await _confirmDelete(model)) return;
    if (await downloads.delete(model, installId)) {
      await settings.forgetInstalledModel(model);
    }
  }

  Future<bool> _confirmDelete(LocalModel model) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteModelTitle(model.name)),
        content: Text(l10n.deleteModelBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteModel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.select((SettingsCubit c) => c.state.settings);
    final downloads = context.watch<LocalModelCubit>().state;
    final settingsCubit = context.read<SettingsCubit>();
    final custom = settings.customLocalModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MutedText(l10n.localModelsNote, fontSize: 12),
        const SizedBox(height: 16),
        TextField(
          controller: _token,
          obscureText: _obscure,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            labelText: l10n.hfTokenLabel,
            helperText: l10n.hfTokenHelper,
            helperMaxLines: 3,
            suffixIcon: IconButton(
              tooltip: _obscure ? l10n.showKey : l10n.hideKey,
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (final model in settings.localModels)
          LocalModelTile(
            model: model,
            installed: settings.installIdOf(model) != null,
            selected: settings.selectedLocalModel.id == model.id,
            progress: downloads.downloadingUrl == model.url
                ? downloads.progress
                : null,
            busy: downloads.isBusy,
            onSelect: () => settingsCubit.selectLocalModel(model),
            onDownload: () => _download(model),
            onCancel: context.read<LocalModelCubit>().cancelDownload,
            onDelete: () => _delete(model, settings.installIdOf(model)!),
          ),
        if (downloads.failure case final failure?)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              failure.message(l10n),
              style: TextStyle(color: context.colors.error),
            ),
          ),
        const SizedBox(height: 16),
        Overline(l10n.customModelTitle),
        const SizedBox(height: 12),
        CustomModelForm(
          current: custom,
          locked: custom != null && settings.installIdOf(custom) != null,
          onSubmit: settingsCubit.setCustomLocalModel,
        ),
      ],
    );
  }
}
