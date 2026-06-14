class SplitEngine {
  static String generateSplit(String experienceLevel) {
    // =========================
    // Experience-Based Split
    // =========================

    if (experienceLevel == 'Beginner') {
      return 'Full Body';
    }

    if (experienceLevel == 'Intermediate') {
      return 'Push Pull Legs';
    }

    return 'Arnold Split';
  }

  static List<String> generateSchedule(String split) {
    // =========================
    // Full Body
    // =========================

    if (split == 'Full Body') {
      return [
        'Monday - Full Body',

        'Wednesday - Full Body',

        'Friday - Full Body',
      ];
    }

    // =========================
    // Push Pull Legs
    // =========================

    if (split == 'Push Pull Legs') {
      return [
        'Monday - Push',

        'Tuesday - Pull',

        'Wednesday - Legs',

        'Thursday - Push',

        'Friday - Pull',

        'Saturday - Legs',
      ];
    }

    // =========================
    // Arnold Split
    // =========================

    return [
      'Monday - Chest / Back',

      'Tuesday - Shoulders / Arms',

      'Wednesday - Legs',

      'Thursday - Chest / Back',

      'Friday - Shoulders / Arms',

      'Saturday - Legs',
    ];
  }

  static int recommendedDays(String split) {
    if (split == 'Full Body') {
      return 3;
    }

    if (split == 'Push Pull Legs') {
      return 6;
    }

    return 6;
  }

  static String splitFocus(String split) {
    if (split == 'Full Body') {
      return 'Foundational strength and movement development.';
    }

    if (split == 'Push Pull Legs') {
      return 'Balanced hypertrophy and recovery distribution.';
    }

    return 'High-volume specialization and advanced adaptation.';
  }

  static String recoveryDemand(String split) {
    if (split == 'Full Body') {
      return 'LOW';
    }

    if (split == 'Push Pull Legs') {
      return 'MODERATE';
    }

    return 'HIGH';
  }

  static String progressionStyle(String split) {
    if (split == 'Full Body') {
      return 'Linear progression.';
    }

    if (split == 'Push Pull Legs') {
      return 'Volume-based progression.';
    }

    return 'Periodized progression.';
  }
}
