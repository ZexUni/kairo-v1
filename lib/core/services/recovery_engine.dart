class RecoveryEngine {
  static double calculateReadiness({
    required double sleepHours,

    required double soreness,

    required double stress,
  }) {
    double score = 100;

    // =========================
    // Sleep Impact
    // =========================

    if (sleepHours < 4) {
      score -= 40;
    } else if (sleepHours < 6) {
      score -= 25;
    } else if (sleepHours < 7) {
      score -= 15;
    }

    // =========================
    // Soreness Impact
    // =========================

    score -= soreness * 8;

    // =========================
    // Stress Impact
    // =========================

    score -= stress * 7;

    // =========================
    // Clamp
    // =========================

    score = score.clamp(0, 100);

    return score;
  }

  static String readinessState(double score) {
    if (score >= 85) {
      return 'OPTIMAL';
    }

    if (score >= 70) {
      return 'READY';
    }

    if (score >= 55) {
      return 'MODERATE';
    }

    if (score >= 40) {
      return 'FATIGUED';
    }

    return 'RECOVERY REQUIRED';
  }

  static String recoveryAdvice(double score) {
    if (score >= 85) {
      return 'Your recovery systems are operating optimally.';
    }

    if (score >= 70) {
      return 'You are ready for productive training.';
    }

    if (score >= 55) {
      return 'Moderate fatigue detected. Train intelligently.';
    }

    if (score >= 40) {
      return 'Recovery should become a priority today.';
    }

    return 'Full recovery protocol recommended.';
  }

  static String sleepAdvice(double sleepHours) {
    if (sleepHours >= 8) {
      return 'Excellent sleep duration detected.';
    }

    if (sleepHours >= 7) {
      return 'Adequate sleep for recovery.';
    }

    if (sleepHours >= 5) {
      return 'Increase sleep duration for better performance.';
    }

    return 'Critical sleep deficiency detected.';
  }

  static String stressState(double stress) {
    if (stress <= 2) {
      return 'LOW STRESS';
    }

    if (stress <= 5) {
      return 'MANAGEABLE STRESS';
    }

    if (stress <= 7) {
      return 'HIGH STRESS';
    }

    return 'CRITICAL STRESS';
  }

  static bool deloadRequired({
    required double readiness,

    required double soreness,

    required double stress,
  }) {
    if (readiness < 40 || soreness > 8 || stress > 8) {
      return true;
    }

    return false;
  }
}
