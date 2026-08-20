import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../navigation_shell.dart';

abstract class AppRoutes {
  static const String initial = '/';
  static const String shift = '/guard/today-shift';
  static const String checkIn = '/guard/check-in';
  static const String incidents = '/guard/incidents';
  static const String profile = '/guard/profile';
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.initial,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.initial,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        return NavigationShell(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.shift,
              builder: (BuildContext context, GoRouterState state) =>
                  const PlaceholderPage(
                      title: 'Shift', icon: Icons.shield_outlined),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.checkIn,
              builder: (BuildContext context, GoRouterState state) =>
                  const PlaceholderPage(
                      title: 'Check-In', icon: Icons.location_on_outlined),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.incidents,
              builder: (BuildContext context, GoRouterState state) =>
                  const PlaceholderPage(
                      title: 'Incidents', icon: Icons.warning_amber_outlined),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.profile,
              builder: (BuildContext context, GoRouterState state) =>
                  const PlaceholderPage(
                      title: 'Profile', icon: Icons.person_outline),
            ),
          ],
        ),
      ],
    ),
  ],
);
