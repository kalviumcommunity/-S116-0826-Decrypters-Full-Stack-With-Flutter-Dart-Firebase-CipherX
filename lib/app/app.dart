import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class CipherXApp extends StatelessWidget {
  const CipherXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
