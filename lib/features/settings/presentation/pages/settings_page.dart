import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/section_card.dart';
import '../cubit/model_catalog_cubit.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/language_tiles.dart';
import '../widgets/local_models_panel.dart';
import '../widgets/narrator_selector.dart';
import '../widgets/provider_form.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<ModelCatalogCubit>(),
    child: const _SettingsView(),
  );
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();
    final narrator = context.select(
      (SettingsCubit c) => c.state.settings.narrator,
    );
    final status = context.select((SettingsCubit c) => c.state.status);
    final remote = narrator.remoteProvider;

    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          current.failure != null && previous.failure != current.failure,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.failure!.message(l10n)))),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: PageBody(
          children: [
            SectionCard(
              title: l10n.sectionNarrator,
              children: [
                NarratorSelector(
                  selected: narrator,
                  onChanged: (next) {
                    context.read<ModelCatalogCubit>().reset();
                    cubit.selectNarrator(next);
                  },
                ),
                const SizedBox(height: 20),
                if (remote != null) ...[
                  MutedText(l10n.providerVendor(remote.vendor), fontSize: 12),
                  const SizedBox(height: 12),
                  ProviderForm(
                    // Fresh form per provider and once saved values have loaded.
                    key: ValueKey((remote, status)),
                    provider: remote,
                    initial: cubit.state.settings.settingsFor(remote),
                  ),
                ] else
                  const LocalModelsPanel(),
              ],
            ),
            const SizedBox(height: 20),
            SectionCard(
              title: l10n.sectionLanguage,
              children: const [AppLanguageTile()],
            ),
            const SizedBox(height: 20),
            MutedText(
              remote != null ? l10n.privacyNote : l10n.privacyNoteLocal,
              fontSize: 12,
            ),
            const SizedBox(height: 8),
            MutedText(l10n.themeNote, fontSize: 12),
          ],
        ),
      ),
    );
  }
}
