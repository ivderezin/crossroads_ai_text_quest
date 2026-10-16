import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/llm/llm_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/settings_cubit.dart';
import 'narrator_selector.dart';

class ProviderStatusChip extends StatelessWidget {
  const ProviderStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.select((SettingsCubit c) => c.state.settings);
    final config = settings.activeConfig;
    final label = switch (config) {
      RemoteLlmConfig(:final provider, :final model) => l10n.providerReady(
        provider.displayName,
        model,
      ),
      LocalLlmConfig(:final model) => l10n.providerReady(
        settings.narrator.label(l10n),
        model.name,
      ),
      null => l10n.providerMissing,
    };
    return TextButton(
      onPressed: () => context.push(AppRoutes.settings),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 160),
        child: Text(
          '${config != null ? '●' : '○'} $label'.toUpperCase(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1,
            color: config != null
                ? context.colors.primary
                : context.colors.error,
          ),
        ),
      ),
    );
  }
}
