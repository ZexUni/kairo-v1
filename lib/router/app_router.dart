import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:kairo/services/auth_service.dart';
import 'package:kairo/data/repositories/user_repository.dart';

import 'package:kairo/features/onboarding/splash_screen.dart';
import 'package:kairo/features/auth/login_screen.dart';
import 'package:kairo/features/auth/signup_screen.dart';
import 'package:kairo/features/auth/forgot_password_screen.dart';
import 'package:kairo/features/onboarding/onboarding_flow.dart';
import 'package:kairo/features/dashboard/dashboard_screen.dart';
import 'package:kairo/features/workout/workout_home_screen.dart';
import 'package:kairo/features/workout/active_workout_screen.dart';
import 'package:kairo/features/workout/exercise_picker_screen.dart';
import 'package:kairo/features/nutrition/nutrition_home_screen.dart';
import 'package:kairo/features/nutrition/meal_log_screen.dart';
import 'package:kairo/features/nutrition/nutrition_dashboard_screen.dart';
import 'package:kairo/features/analytics/analytics_screen.dart';
import 'package:kairo/features/analytics/muscle_radar_screen.dart';
import 'package:kairo/features/analytics/body_distribution_screen.dart';
import 'package:kairo/features/analytics/monthly_report_screen.dart';
import 'package:kairo/features/recovery/recovery_checkin_screen.dart';
import 'package:kairo/features/profile/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;
      
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot';

      // If not authenticated, force login
      if (user == null) {
        return isLoggingIn ? null : '/login';
      }

      // If authenticated and trying to access auth pages, check profile
      if (isLoggingIn || state.matchedLocation == '/') {
        final profile = await UserRepository().getProfile(user.uid);
        if (profile == null) {
          return '/onboarding';
        }
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingFlow(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/workout',
        builder: (context, state) => const WorkoutHomeScreen(),
      ),
      GoRoute(
        path: '/workout/active',
        builder: (context, state) {
          final loadPlan = state.uri.queryParameters['loadPlan'] == 'true';
          return ActiveWorkoutScreen(loadPlan: loadPlan);
        },
      ),
      GoRoute(
        path: '/workout/pick',
        builder: (context, state) => const ExercisePickerScreen(),
      ),
      GoRoute(
        path: '/nutrition',
        builder: (context, state) => const NutritionHomeScreen(),
      ),
      GoRoute(
        path: '/nutrition/log',
        builder: (context, state) {
          final mealType = state.uri.queryParameters['mealType'];
          return MealLogScreen(initialMealType: mealType);
        },
      ),
      GoRoute(
        path: '/nutrition/dashboard',
        builder: (context, state) => const NutritionDashboardScreen(),
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/analytics/radar',
        builder: (context, state) => const MuscleRadarScreen(),
      ),
      GoRoute(
        path: '/analytics/body',
        builder: (context, state) => const BodyDistributionScreen(),
      ),
      GoRoute(
        path: '/analytics/report',
        builder: (context, state) => const MonthlyReportScreen(),
      ),
      GoRoute(
        path: '/recovery',
        builder: (context, state) => const RecoveryCheckinScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
