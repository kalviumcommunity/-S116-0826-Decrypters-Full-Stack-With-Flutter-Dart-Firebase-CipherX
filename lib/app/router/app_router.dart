import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../navigation_shell.dart';

abstract class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.initial,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const NavigationShell();
      },
    ),
  ],
);
