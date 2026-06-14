import 'package:flutter/material.dart';

import 'package:kairo/core/theme/app_theme.dart';

import 'package:kairo/features/onboarding/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const KairoApp());
}

class KairoApp extends StatelessWidget {
  const KairoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'KAIRO',

      theme: AppTheme.darkTheme,

      home: const SplashScreen(),
    );
  }
}
