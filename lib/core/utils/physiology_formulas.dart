import 'dart:math';

class PhysiologyFormulas {
  /// Navy body fat formula for males
  static double calculateMaleBodyFat({
    required double waistCm,
    required double neckCm,
    required double heightCm,
  }) {
    // BF% = 86.010 * log10(waist - neck) - 70.041 * log10(height) + 36.76
    final diff = waistCm - neckCm;
    if (diff <= 0 || heightCm <= 0) return 15.0; // safe fallback
    return 86.010 * (log(diff) / ln10) - 70.041 * (log(heightCm) / ln10) + 36.76;
  }

  /// Navy body fat formula for females
  static double calculateFemaleBodyFat({
    required double waistCm,
    required double hipCm,
    required double neckCm,
    required double heightCm,
  }) {
    // BF% = 163.205 * log10(waist + hip - neck) - 97.684 * log10(height) - 78.387
    final sum = waistCm + hipCm - neckCm;
    if (sum <= 0 || heightCm <= 0) return 22.0; // safe fallback
    return 163.205 * (log(sum) / ln10) - 97.684 * (log(heightCm) / ln10) - 78.387;
  }

  /// Calculates Lean Body Mass (LBM) in Kg
  static double calculateLBM(double weightKg, double bodyFatPercent) {
    return weightKg * (1 - (bodyFatPercent.clamp(0.0, 100.0) / 100.0));
  }

  /// Fat-Free Mass Index (FFMI)
  static double calculateFFMI({
    required double lbmKg,
    required double heightCm,
  }) {
    final heightMeters = heightCm / 100.0;
    if (heightMeters <= 0) return 18.0;
    return (lbmKg / (heightMeters * heightMeters)) + 6.1 * (1.8 - heightMeters);
  }

  /// Mifflin-St Jeor BMR
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int ageYears,
    required bool isMale,
  }) {
    // Male:   BMR = 10W + 6.25H - 5A + 5
    // Female: BMR = 10W + 6.25H - 5A - 161
    if (isMale) {
      return 10.0 * weightKg + 6.25 * heightCm - 5.0 * ageYears + 5.0;
    } else {
      return 10.0 * weightKg + 6.25 * heightCm - 5.0 * ageYears - 161.0;
    }
  }
}
