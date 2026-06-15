import 'dart:convert';
import 'dart:math';

class PerformanceAssessment {
  final String userId;
  final DateTime assessedAt;
  final int maxPushups;
  final int maxPullups;
  final int maxSquats;
  final int plankSeconds;

  const PerformanceAssessment({
    required this.userId,
    required this.assessedAt,
    required this.maxPushups,
    required this.maxPullups,
    required this.maxSquats,
    required this.plankSeconds,
  });

  double get pushupScore => min(maxPushups / 40.0, 1.0);
  double get squatScore => min(maxSquats / 50.0, 1.0);
  double get plankScore => min(plankSeconds / 120.0, 1.0);
  double get overallScore =>
      (pushupScore * 0.4) + (squatScore * 0.3) + (plankScore * 0.3);

  PerformanceAssessment copyWith({
    String? userId,
    DateTime? assessedAt,
    int? maxPushups,
    int? maxPullups,
    int? maxSquats,
    int? plankSeconds,
  }) {
    return PerformanceAssessment(
      userId: userId ?? this.userId,
      assessedAt: assessedAt ?? this.assessedAt,
      maxPushups: maxPushups ?? this.maxPushups,
      maxPullups: maxPullups ?? this.maxPullups,
      maxSquats: maxSquats ?? this.maxSquats,
      plankSeconds: plankSeconds ?? this.plankSeconds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'assessedAt': assessedAt.toIso8601String(),
      'maxPushups': maxPushups,
      'maxPullups': maxPullups,
      'maxSquats': maxSquats,
      'plankSeconds': plankSeconds,
    };
  }

  factory PerformanceAssessment.fromMap(Map<String, dynamic> map) {
    return PerformanceAssessment(
      userId: map['userId'] ?? '',
      assessedAt: map['assessedAt'] != null
          ? DateTime.parse(map['assessedAt'])
          : DateTime.now(),
      maxPushups: map['maxPushups'] ?? 0,
      maxPullups: map['maxPullups'] ?? 0,
      maxSquats: map['maxSquats'] ?? 0,
      plankSeconds: map['plankSeconds'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PerformanceAssessment.fromJson(String source) =>
      PerformanceAssessment.fromMap(json.decode(source));
}
