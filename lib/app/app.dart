import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import '../core/l10n/l10n.dart';
import '../core/language/languages.dart';
import '../core/theme/app_theme.dart';
import '../features/quest/presentation/bloc/quest_bloc.dart';
import '../features/settings/presentation/cubit/local_model_cubit.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import 'di/injection.dart';
import 'router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<SettingsCubit>()..load()),
      BlocProvider(create: (_) => getIt<LocalModelCubit>()),
      BlocProvider(
        create: (_) => getIt<QuestBloc>()..add(const QuestLoadRequested()),
      ),
    ],
    child: const _AppView(),
  );
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  // Created once, otherwise switching the language would reset navigation.
  final _router = AppRoutes.createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.select(
      (SettingsCubit cubit) => cubit.state.settings.appLocale,
    );
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: locale,
      supportedLocales: Languages.appLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        LocaleNamesLocalizationsDelegate(),
      ],
      localeResolutionCallback: (device, supported) => supported.firstWhere(
        (l) => l.languageCode == device?.languageCode,
        orElse: () => supported.first,
      ),
      routerConfig: _router,
    );
  }
}
