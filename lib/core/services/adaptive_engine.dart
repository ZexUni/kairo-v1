import 'package:kairo/models/onboarding_data.dart';

class AdaptiveEngine {
  static String generateAdaptiveInsight(OnboardingData data) {
    // Recovery State

    if (data.readinessScore < 40) {
      return 'Your body is heavily fatigued. Reduce intensity and prioritize recovery.';
    }

    if (data.readinessScore < 60) {
      return 'Moderate fatigue detected. Train smart and avoid excessive volume.';
    }

    // Goal Logic

    if (data.physiqueGoal == 'Bulk') {
      return 'Your system is optimized for muscle growth. Prioritize progressive overload.';
    }

    if (data.physiqueGoal == 'Slim') {
      return 'Fat-loss optimization active. Maintain caloric discipline and movement consistency.';
    }

    // Experience Logic

    if (data.experienceLevel == 'Beginner') {
      return 'Focus on consistency, technique, and gradual adaptation.';
    }

    if (data.experienceLevel == 'Advanced') {
      return 'Advanced adaptation detected. Monitor fatigue accumulation carefully.';
    }

    // Default

    return 'Your physiology is stable and ready for balanced progression.';
  }
}
