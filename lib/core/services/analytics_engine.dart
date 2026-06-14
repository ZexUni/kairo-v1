import 'package:kairo/models/workout_session.dart';

class AnalyticsEngine {
  static double calculateTotalVolume(List<WorkoutSession> sessions) {
    double total = 0;

    for (final session in sessions) {
      total += session.totalVolume;
    }

    return total;
  }

  static int calculateTotalWorkouts(List<WorkoutSession> sessions) {
    return sessions.length;
  }

  static double calculateAverageVolume(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) {
      return 0;
    }

    double total = calculateTotalVolume(sessions);

    return total / sessions.length;
  }

  static double calculateBestVolume(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) {
      return 0;
    }

    double best = 0;

    for (final session in sessions) {
      if (session.totalVolume > best) {
        best = session.totalVolume;
      }
    }

    return best;
  }

  static String performanceState(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) {
      return 'NO DATA';
    }

    final average = calculateAverageVolume(sessions);

    if (average < 3000) {
      return 'BEGINNING';
    }

    if (average < 7000) {
      return 'PROGRESSING';
    }

    if (average < 12000) {
      return 'ADVANCED';
    }

    return 'ELITE';
  }

  static List<double> volumeHistory(List<WorkoutSession> sessions) {
    return sessions.map((session) => session.totalVolume).toList();
  }
}
