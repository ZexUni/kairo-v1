class ProgressionEngine {
  static List<String> generateRecommendations(String experienceLevel) {
    // =========================
    // Beginner
    // =========================

    if (experienceLevel == 'Beginner') {
      return [
        'Focus on exercise form progression',

        'Increase repetitions gradually',

        'Train consistently before increasing intensity',

        'Prioritize movement quality over load',
      ];
    }

    // =========================
    // Intermediate
    // =========================

    if (experienceLevel == 'Intermediate') {
      return [
        'Increase training load weekly',

        'Track volume carefully',

        'Optimize recovery between sessions',

        'Introduce progressive overload systematically',
      ];
    }

    // =========================
    // Advanced
    // =========================

    return [
      'Use structured periodization',

      'Rotate intensity and volume blocks',

      'Monitor systemic fatigue carefully',

      'Implement strategic deload phases',

      'Optimize neurological recovery',
    ];
  }

  static String progressionState(int streakDays) {
    if (streakDays >= 60) {
      return 'ELITE CONSISTENCY';
    }

    if (streakDays >= 30) {
      return 'HIGH MOMENTUM';
    }

    if (streakDays >= 14) {
      return 'BUILDING ADAPTATION';
    }

    if (streakDays >= 7) {
      return 'EARLY CONSISTENCY';
    }

    return 'FOUNDATION PHASE';
  }

  static double recommendedLoadIncrease(String experienceLevel) {
    if (experienceLevel == 'Beginner') {
      return 5;
    }

    if (experienceLevel == 'Intermediate') {
      return 2.5;
    }

    return 1.25;
  }

  static String overloadStrategy(String goal) {
    if (goal == 'Bulk') {
      return 'Prioritize load and volume progression.';
    }

    if (goal == 'Slim') {
      return 'Prioritize caloric expenditure and training density.';
    }

    return 'Balance intensity, recovery, and volume.';
  }

  static String deloadRecommendation({
    required double readiness,

    required double fatigue,
  }) {
    if (readiness < 40 || fatigue > 75) {
      return 'Deload strongly recommended.';
    }

    if (readiness < 60 || fatigue > 60) {
      return 'Monitor recovery closely.';
    }

    return 'No deload currently required.';
  }
}
