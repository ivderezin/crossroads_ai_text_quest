import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/language/languages.dart';
import '../../../../core/widgets/language_flag.dart';
import '../../../../core/widgets/language_picker_sheet.dart';
import '../cubit/settings_cubit.dart';

class AppLanguageTile extends StatelessWidget {
  const AppLanguageTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final code = context.select(
      (SettingsCubit c) => c.state.settings.appLanguage,
    );
    final current = Localizations.localeOf(context).languageCode;
    final system = l10n.languageAutoValue(
      l10n.appLanguageSystem,
      Languages.nativeName(current),
    );
    return _LanguageTile(
      icon: Icons.translate_rounded,
      title: l10n.appLanguageLabel,
      code: code,
      value: code == null ? system : Languages.nativeName(code),
      onTap: () async {
        final cubit = context.read<SettingsCubit>();
        final choice = await LanguagePickerSheet.show(
          context,
          codes: [for (final l in Languages.appLocales) l.languageCode],
          selected: code,
          automaticTitle: l10n.appLanguageSystem,
          automaticSubtitle: Languages.nativeName(current),
        );
        if (choice != null) await cubit.setAppLanguage(choice.code);
      },
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.icon,
    required this.title,
    required this.code,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? code;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(value),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (code case final code?) LanguageFlag(code, width: 24),
        const Icon(Icons.chevron_right_rounded),
      ],
    ),
    onTap: onTap,
  );
}
