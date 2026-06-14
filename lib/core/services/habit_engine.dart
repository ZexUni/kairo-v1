class HabitEngine {
  static int calculateCompletion(List<bool> habits) {
    if (habits.isEmpty) {
      return 0;
    }

    int completed = 0;

    for (bool habit in habits) {
      if (habit) {
        completed++;
      }
    }

    return ((completed / habits.length) * 100).round();
  }

  static String adherenceState(int completion) {
    if (completion >= 90) {
      return 'DISCIPLINED';
    }

    if (completion >= 75) {
      return 'CONSISTENT';
    }

    if (completion >= 50) {
      return 'BUILDING';
    }

    if (completion >= 25) {
      return 'UNSTABLE';
    }

    return 'COLLAPSING';
  }

  static String motivationalMessage(int completion) {
    if (completion >= 90) {
      return 'Elite consistency detected.';
    }

    if (completion >= 75) {
      return 'Momentum is building strongly.';
    }

    if (completion >= 50) {
      return 'You are building the system.';
    }

    if (completion >= 25) {
      return 'Discipline needs reinforcement.';
    }

    return 'Restart the system. Small actions matter.';
  }

  static int updateStreak({
    required int currentStreak,

    required int completion,
  }) {
    if (completion >= 75) {
      return currentStreak + 1;
    }

    return currentStreak;
  }
}
