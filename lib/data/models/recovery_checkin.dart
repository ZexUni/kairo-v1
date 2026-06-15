import 'dart:convert';

enum RecoveryRecommendation {
  normalTraining,
  reducedVolume,
  deload,
  recoveryDay
}

class RecoveryCheckin {
  final String id;
  final String userId;
  final DateTime checkinAt;
  final double sleepHours;
  final double sleepQuality; // 1-5
  final double energyLevel; // 1-5
  final double stressLevel; // 1-5
  final double hydrationLevel; // 1-5
  final double sorenessLevel; // 1-5
  final String notes;
  final RecoveryRecommendation recommendation;

  const RecoveryCheckin({
    required this.id,
    required this.userId,
    required this.checkinAt,
    required this.sleepHours,
    required this.sleepQuality,
    required this.energyLevel,
    required this.stressLevel,
    required this.hydrationLevel,
    required this.sorenessLevel,
    required this.notes,
    required this.recommendation,
  });

  RecoveryCheckin copyWith({
    String? id,
    String? userId,
    DateTime? checkinAt,
    double? sleepHours,
    double? sleepQuality,
    double? energyLevel,
    double? stressLevel,
    double? hydrationLevel,
    double? sorenessLevel,
    String? notes,
    RecoveryRecommendation? recommendation,
  }) {
    return RecoveryCheckin(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      checkinAt: checkinAt ?? this.checkinAt,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      energyLevel: energyLevel ?? this.energyLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      hydrationLevel: hydrationLevel ?? this.hydrationLevel,
      sorenessLevel: sorenessLevel ?? this.sorenessLevel,
      notes: notes ?? this.notes,
      recommendation: recommendation ?? this.recommendation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'checkinAt': checkinAt.toIso8601String(),
      'sleepHours': sleepHours,
      'sleepQuality': sleepQuality,
      'energyLevel': energyLevel,
      'stressLevel': stressLevel,
      'hydrationLevel': hydrationLevel,
      'sorenessLevel': sorenessLevel,
      'notes': notes,
      'recommendation': recommendation.name,
    };
  }

  factory RecoveryCheckin.fromMap(Map<String, dynamic> map) {
    return RecoveryCheckin(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      checkinAt: map['checkinAt'] != null
          ? DateTime.parse(map['checkinAt'])
          : DateTime.now(),
      sleepHours: (map['sleepHours'] ?? 0.0).toDouble(),
      sleepQuality: (map['sleepQuality'] ?? 0.0).toDouble(),
      energyLevel: (map['energyLevel'] ?? 0.0).toDouble(),
      stressLevel: (map['stressLevel'] ?? 0.0).toDouble(),
      hydrationLevel: (map['hydrationLevel'] ?? 0.0).toDouble(),
      sorenessLevel: (map['sorenessLevel'] ?? 0.0).toDouble(),
      notes: map['notes'] ?? '',
      recommendation: RecoveryRecommendation.values.firstWhere(
        (r) => r.name == map['recommendation'],
        orElse: () => RecoveryRecommendation.normalTraining,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecoveryCheckin.fromJson(String source) =>
      RecoveryCheckin.fromMap(json.decode(source));
}
