import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/widgets/primary_button.dart';

import 'package:kairo/features/onboarding/presentation/screens/identity_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(28),

              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Center(
                          child: Container(
                            height: 140,

                            width: 140,

                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,

                              borderRadius: BorderRadius.circular(40),

                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.35),

                                  blurRadius: 40,

                                  spreadRadius: 4,
                                ),
                              ],
                            ),

                            child: const Icon(
                              Icons.psychology,

                              color: Colors.black,

                              size: 72,
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        const Text(
                          'KAIRO',

                          style: TextStyle(
                            color: AppColors.primary,

                            fontSize: 16,

                            fontWeight: FontWeight.bold,

                            letterSpacing: 4,
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'The Adaptive\nPerformance System',

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: 42,

                            fontWeight: FontWeight.bold,

                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          'An intelligent ecosystem for physiology, training, recovery, nutrition, and self-evolution.',

                          style: TextStyle(
                            color: AppColors.textSecondary,

                            fontSize: 16,

                            height: 1.7,
                          ),
                        ),

                        const SizedBox(height: 50),

                        featureTile(
                          icon: Icons.fitness_center,

                          title: 'Adaptive Training',

                          subtitle:
                              'AI-generated workouts and progression systems.',
                        ),

                        const SizedBox(height: 16),

                        featureTile(
                          icon: Icons.favorite,

                          title: 'Recovery Intelligence',

                          subtitle:
                              'Real-time physiological readiness analysis.',
                        ),

                        const SizedBox(height: 16),

                        featureTile(
                          icon: Icons.restaurant,

                          title: 'Nutrition System',

                          subtitle:
                              'Dynamic meal generation and macro optimization.',
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        PrimaryButton(
                          text: 'ENTER KAIRO',

                          icon: Icons.arrow_forward,

                          onPressed: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (context) => const IdentityScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget featureTile({
    required IconData icon,

    required String title,

    required String subtitle,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white10, width: 1),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),

              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(icon, color: AppColors.primary, size: 28),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    color: Colors.white,

                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  subtitle,

                  style: const TextStyle(
                    color: AppColors.textSecondary,

                    fontSize: 14,

                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
