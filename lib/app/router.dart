import 'package:go_router/go_router.dart';

import '../features/quest/presentation/pages/home_page.dart';
import '../features/quest/presentation/pages/story_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const story = '/story';
  static const settings = '/settings';

  static GoRouter createRouter() => GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (_, _) => const HomePage(),
        routes: [
          GoRoute(path: 'story', builder: (_, _) => const StoryPage()),
          GoRoute(path: 'settings', builder: (_, _) => const SettingsPage()),
        ],
      ),
    ],
  );
}
