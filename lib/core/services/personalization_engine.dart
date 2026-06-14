import 'package:kairo/models/onboarding_data.dart';

class PersonalizationEngine {
  static String generateMessage({
    required int streak,

    required double readiness,
  }) {
    // Elite State

    if (streak >= 30 && readiness >= 80) {
      return 'Elite momentum detected. Your system is adapting exceptionally well.';
    }

    // Strong Consistency

    if (streak >= 14) {
      return 'Consistency is reshaping your physiology.';
    }

    // Recovery Warning

    if (readiness < 40) {
      return 'Recovery priority detected. Reduce stress and optimize sleep.';
    }

    // Moderate State

    if (readiness < 60) {
      return 'Your body is accumulating fatigue. Train intelligently today.';
    }

    // Default

    return 'Small disciplined actions compound into massive transformation.';
  }

  static String preferredTrainingFocus(OnboardingData data) {
    if (data.physiqueGoal == 'Bulk') {
      return 'Hypertrophy and progressive overload.';
    }

    if (data.physiqueGoal == 'Slim') {
      return 'Fat loss optimization and conditioning.';
    }

    return 'Balanced athletic development.';
  }

  static String userIdentity(OnboardingData data) {
    if (data.experienceLevel == 'Advanced' && data.readinessScore >= 80) {
      return 'HIGH PERFORMANCE';
    }

    if (data.experienceLevel == 'Intermediate') {
      return 'ADAPTING ATHLETE';
    }

    return 'FOUNDATION BUILDER';
  }

  static String adaptiveRecommendation(OnboardingData data) {
    if (data.readinessScore < 40) {
      return 'Today should prioritize recovery, hydration, and mobility.';
    }

    if (data.dailyCompletion < 50) {
      return 'Behavior consistency needs reinforcement.';
    }

    if (data.streakDays >= 21) {
      return 'Your habits are becoming neurologically reinforced.';
    }

    return 'Continue structured progression.';
  }
}
