import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kairo/core/constants/app_colors.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/data/repositories/user_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> fadeAnimation;

  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1800),
    );

    fadeAnimation = Tween<double>(
      begin: 0,

      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    scaleAnimation = Tween<double>(
      begin: 0.8,

      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

    controller.forward();

    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;

      final auth = Provider.of<AuthService>(context, listen: false);
      final user = auth.currentUser;

      if (!mounted) return;

      if (user == null) {
        context.go('/login');
      } else {
        final profile = await UserRepository().getProfile(user.uid);
        if (!mounted) return;
        if (profile == null) {
          context.go('/onboarding');
        } else {
          context.go('/dashboard');
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),

              child: Center(
                child: FadeTransition(
                  opacity: fadeAnimation,

                  child: ScaleTransition(
                    scale: scaleAnimation,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                // =========================
                // LOGO
                // =========================
                Container(
                  height: 150,

                  width: 150,

                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,

                    borderRadius: BorderRadius.circular(42),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),

                        blurRadius: 45,

                        spreadRadius: 6,
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.psychology,

                    color: Colors.black,

                    size: 78,
                  ),
                ),

                const SizedBox(height: 40),

                // =========================
                // TITLE
                // =========================
                const Text(
                  'KAIRO',

                  style: TextStyle(
                    color: AppColors.primary,

                    fontSize: 38,

                    fontWeight: FontWeight.bold,

                    letterSpacing: 6,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Adaptive Performance System',

                  style: TextStyle(
                    color: AppColors.textSecondary,

                    fontSize: 16,

                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 50),

                // =========================
                // LOADING
                // =========================
                SizedBox(
                  width: 180,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: const LinearProgressIndicator(
                      minHeight: 8,

                      backgroundColor: Colors.white10,

                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
