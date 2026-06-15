import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:kairo/core/theme/app_theme.dart';
import 'package:kairo/router/app_router.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/services/physiology_engine.dart';
import 'package:kairo/services/workout_engine.dart';
import 'package:kairo/services/nutrition_engine.dart';
import 'package:kairo/features/onboarding/onboarding_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to initialize Firebase, catch any exceptions (e.g. unsupported platform, no config)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e. Running in offline/local-only mode.");
  }

  runApp(const KairoApp());
}

class KairoApp extends StatelessWidget {
  const KairoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<PhysiologyEngine>(create: (_) => PhysiologyEngine()),
        ChangeNotifierProvider<WorkoutEngine>(create: (_) => WorkoutEngine()),
        ChangeNotifierProvider<NutritionEngine>(create: (_) => NutritionEngine()),
        ChangeNotifierProvider<OnboardingController>(create: (_) => OnboardingController()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'KAIRO',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}