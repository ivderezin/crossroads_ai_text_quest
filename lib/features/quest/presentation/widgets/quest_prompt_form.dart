import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/quest.dart';
import '../bloc/quest_bloc.dart';
import 'generation_progress.dart';
import 'replace_quest_dialog.dart';

class QuestPromptForm extends StatefulWidget {
  const QuestPromptForm({super.key});

  @override
  State<QuestPromptForm> createState() => _QuestPromptFormState();
}

class _QuestPromptFormState extends State<QuestPromptForm> {
  final _prompt = TextEditingController();

  @override
  void dispose() {
    _prompt.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final prompt = _prompt.text.trim();
    if (prompt.isEmpty) return;
    final bloc = context.read<QuestBloc>();
    if (bloc.state.quest != null &&
        !await ReplaceQuestDialog.confirm(context)) {
      return;
    }
    if (!mounted) return;
    bloc.add(QuestStarted(prompt));
  }

  void _addTheme(String theme) {
    final text = _prompt.text.trim();
    _prompt.text = text.isEmpty ? '$theme. ' : '$theme. $text';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final generating = context.select(
      (QuestBloc bloc) => bloc.state.isGenerating,
    );
    final configured = context.select(
      (SettingsCubit cubit) => cubit.state.isConfigured,
    );
    final themes = [l10n.themeFantasy, l10n.themeSpace, l10n.themeMystery];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.promptTitle, style: context.textStyles.titleLarge),
        const SizedBox(height: 12),
        TextField(
          controller: _prompt,
          enabled: !generating,
          minLines: 4,
          maxLines: 8,
          maxLength: Quest.maxPromptLength,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(hintText: l10n.promptHint),
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final theme in themes)
              ActionChip(
                label: Text(theme),
                onPressed: generating ? null : () => _addTheme(theme),
              ),
          ],
        ),
        const SizedBox(height: 8),
        MutedText(l10n.promptLanguageNote, fontSize: 12),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: generating || !configured || _prompt.text.trim().isEmpty
              ? null
              : _start,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          icon: const Icon(Icons.auto_awesome_outlined),
          label: Text(l10n.createQuest),
        ),
        if (generating) const GenerationProgress(),
      ],
    );
  }
}
