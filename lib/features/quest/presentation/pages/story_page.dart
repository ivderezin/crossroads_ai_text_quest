import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../bloc/quest_bloc.dart';
import '../widgets/choice_list.dart';
import '../widgets/custom_action_field.dart';
import '../widgets/ending_view.dart';
import '../widgets/generation_progress.dart';
import '../widgets/quest_failure_listener.dart';
import '../widgets/quest_journal.dart';
import '../widgets/scene_view.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final _customAction = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _customAction.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _act(QuestState state, String action) {
    context.read<QuestBloc>().add(
      QuestActionSubmitted(
        action: action,
        sceneNumber: state.quest!.sceneNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final configured = context.select(
      (SettingsCubit cubit) => cubit.state.isConfigured,
    );
    return QuestFailureListener(
      child: BlocConsumer<QuestBloc, QuestState>(
        listenWhen: (previous, current) => previous.quest != current.quest,
        listener: (context, state) {
          _customAction.clear();
          if (_scroll.hasClients) _scroll.jumpTo(0);
        },
        builder: (context, state) {
          final quest = state.quest;
          final canAct = !state.isGenerating && configured;
          return PopScope(
            canPop: !state.isGenerating,
            child: Scaffold(
              appBar: AppBar(),
              body: quest == null
                  ? const SizedBox.shrink()
                  : PageBody(
                      controller: _scroll,
                      children: [
                        SceneView(quest: quest),
                        const SizedBox(height: 28),
                        if (quest.completed)
                          EndingView(onNewStory: context.pop)
                        else ...[
                          Text(
                            context.l10n.whatWillYouDo,
                            style: context.textStyles.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          ChoiceList(
                            choices: quest.current.choices,
                            onChosen: canAct
                                ? (choice) => _act(state, choice)
                                : null,
                          ),
                          if (quest.current.allowCustom) ...[
                            const SizedBox(height: 12),
                            CustomActionField(
                              controller: _customAction,
                              onSubmitted: canAct
                                  ? (action) => _act(state, action)
                                  : null,
                            ),
                          ],
                          if (!configured)
                            OutlinedButton(
                              onPressed: () =>
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.settings),
                              child: Text(context.l10n.configureToContinue),
                            ),
                          if (state.isGenerating) const GenerationProgress(),
                          const SizedBox(height: 12),
                          MutedText(
                            context.l10n.autosaved,
                            textAlign: TextAlign.center,
                            fontSize: 12,
                          ),
                        ],
                        if (quest.scenes.length > 1) ...[
                          const SizedBox(height: 28),
                          QuestJournal(
                            pastScenes: quest.scenes.sublist(
                              0,
                              quest.scenes.length - 1,
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
