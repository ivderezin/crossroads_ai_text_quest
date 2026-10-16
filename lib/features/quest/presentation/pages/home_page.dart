import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../../settings/presentation/widgets/provider_status_chip.dart';
import '../bloc/quest_bloc.dart';
import '../widgets/home_hero.dart';
import '../widgets/quest_failure_listener.dart';
import '../widgets/quest_prompt_form.dart';
import '../widgets/resume_card.dart';
import '../widgets/setup_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openStory(BuildContext context) => context.push(AppRoutes.story);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final configured = context.select(
      (SettingsCubit cubit) => cubit.state.isConfigured,
    );
    return QuestFailureListener(
      child: BlocListener<QuestBloc, QuestState>(
        listenWhen: (previous, current) =>
            previous.isGenerating &&
            !current.isGenerating &&
            current.failure == null &&
            current.quest != previous.quest,
        listener: (context, _) {
          if (ModalRoute.of(context)?.isCurrent ?? true) _openStory(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.appTitle.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
            centerTitle: false,
            actions: [
              const ProviderStatusChip(),
              IconButton(
                tooltip: l10n.settingsTooltip,
                onPressed: () => context.push(AppRoutes.settings),
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
          body: BlocBuilder<QuestBloc, QuestState>(
            buildWhen: (previous, current) =>
                previous.status != current.status ||
                previous.quest != current.quest ||
                previous.isGenerating != current.isGenerating,
            builder: (context, state) {
              if (state.status == QuestStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return PageBody(
                children: [
                  const HomeHero(),
                  const SizedBox(height: 28),
                  if (state.quest case final quest?) ...[
                    ResumeCard(
                      quest: quest,
                      onOpen: state.isGenerating
                          ? null
                          : () => _openStory(context),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (!configured) ...[
                    const SetupCard(),
                    const SizedBox(height: 24),
                  ],
                  const QuestPromptForm(),
                  const SizedBox(height: 18),
                  MutedText(
                    l10n.homeFooter,
                    textAlign: TextAlign.center,
                    fontSize: 12,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
