import 'package:kairo/models/onboarding_data.dart';

class DecisionEngine {
  static String generateDailyDecision(OnboardingData data) {
    // Recovery-Based Decisions

    if (data.readinessScore < 40) {
      return 'Recovery priority activated. Perform light mobility or complete rest.';
    }

    if (data.readinessScore < 60) {
      return 'Moderate fatigue detected. Reduce workout intensity today.';
    }

    // Goal Decisions

    if (data.physiqueGoal == 'Bulk') {
      return 'Today’s priority is progressive overload and calorie surplus adherence.';
    }

    if (data.physiqueGoal == 'Slim') {
      return 'Today’s priority is caloric control and high movement output.';
    }

    // Experience Decisions

    if (data.experienceLevel == 'Beginner') {
      return 'Focus on exercise form, consistency, and habit formation.';
    }

    if (data.experienceLevel == 'Advanced') {
      return 'High adaptation capacity detected. Monitor fatigue and optimize performance variables.';
    }

    // Default

    return 'Balanced optimization active. Continue structured progression.';
  }

  static String recommendIntensity(double readinessScore) {
    if (readinessScore >= 85) {
      return 'MAXIMUM';
    }

    if (readinessScore >= 70) {
      return 'HIGH';
    }

    if (readinessScore >= 50) {
      return 'MODERATE';
    }

    if (readinessScore >= 35) {
      return 'LOW';
    }

    return 'RECOVERY';
  }

  static String recommendRecovery(double readinessScore) {
    if (readinessScore >= 80) {
      return 'Recovery systems optimal.';
    }

    if (readinessScore >= 60) {
      return 'Maintain hydration and quality sleep.';
    }

    if (readinessScore >= 40) {
      return 'Increase sleep duration and reduce stress exposure.';
    }

    return 'Full recovery protocol recommended.';
  }
}
