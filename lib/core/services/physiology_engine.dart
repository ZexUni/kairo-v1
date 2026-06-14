import 'package:kairo/models/physiological_state.dart';

class PhysiologyEngine {
  static PhysiologicalState generateState({required double readiness}) {
    // =========================
    // Core Physiological Metrics
    // =========================

    double recovery = readiness;

    double fatigue = 100 - readiness;

    double adaptation = readiness * 0.9;

    // =========================
    // Clamp Values
    // =========================

    recovery = recovery.clamp(0, 100);

    fatigue = fatigue.clamp(0, 100);

    adaptation = adaptation.clamp(0, 100);

    // =========================
    // Return State
    // =========================

    return PhysiologicalState(
      recovery: recovery,

      fatigue: fatigue,

      readiness: readiness,

      adaptation: adaptation,
    );
  }

  static String recoveryState(double recovery) {
    if (recovery >= 85) {
      return 'FULLY RECOVERED';
    }

    if (recovery >= 65) {
      return 'RECOVERING WELL';
    }

    if (recovery >= 40) {
      return 'PARTIALLY FATIGUED';
    }

    return 'RECOVERY CRITICAL';
  }

  static String fatigueState(double fatigue) {
    if (fatigue <= 20) {
      return 'LOW FATIGUE';
    }

    if (fatigue <= 45) {
      return 'MANAGEABLE FATIGUE';
    }

    if (fatigue <= 70) {
      return 'HIGH FATIGUE';
    }

    return 'OVERREACHED';
  }

  static String adaptationState(double adaptation) {
    if (adaptation >= 85) {
      return 'PEAK ADAPTATION';
    }

    if (adaptation >= 65) {
      return 'STRONG ADAPTATION';
    }

    if (adaptation >= 40) {
      return 'MODERATE ADAPTATION';
    }

    return 'LOW ADAPTATION';
  }

  static String overallState({
    required double recovery,

    required double fatigue,

    required double adaptation,
  }) {
    if (recovery >= 80 && fatigue <= 30 && adaptation >= 75) {
      return 'SYSTEM OPTIMAL';
    }

    if (fatigue >= 75) {
      return 'SYSTEM OVERLOADED';
    }

    if (recovery <= 40) {
      return 'RECOVERY PRIORITY';
    }

    return 'SYSTEM STABLE';
  }
}
