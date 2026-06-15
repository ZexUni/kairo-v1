import 'dart:convert';

enum PhysiqueArchetype {
  vTaper,
  classicBodybuilder,
  powerAthlete,
  massMonster,
  leanWarrior
}

class PhysiologySnapshot {
  final String userId;
  final DateTime snapshotAt;
  final double bodyFatPercent;
  final double leanBodyMassKg;
  final double fatMassKg;
  final double anabolicScore;
  final double metabolicScore;
  final double stressScore;
  final double recoveryScore;
  final PhysiqueArchetype archetype;
  final double physiqueCompletionPercent;

  const PhysiologySnapshot({
    required this.userId,
    required this.snapshotAt,
    required this.bodyFatPercent,
    required this.leanBodyMassKg,
    required this.fatMassKg,
    required this.anabolicScore,
    required this.metabolicScore,
    required this.stressScore,
    required this.recoveryScore,
    required this.archetype,
    required this.physiqueCompletionPercent,
  });

  PhysiologySnapshot copyWith({
    String? userId,
    DateTime? snapshotAt,
    double? bodyFatPercent,
    double? leanBodyMassKg,
    double? fatMassKg,
    double? anabolicScore,
    double? metabolicScore,
    double? stressScore,
    double? recoveryScore,
    PhysiqueArchetype? archetype,
    double? physiqueCompletionPercent,
  }) {
    return PhysiologySnapshot(
      userId: userId ?? this.userId,
      snapshotAt: snapshotAt ?? this.snapshotAt,
      bodyFatPercent: bodyFatPercent ?? this.bodyFatPercent,
      leanBodyMassKg: leanBodyMassKg ?? this.leanBodyMassKg,
      fatMassKg: fatMassKg ?? this.fatMassKg,
      anabolicScore: anabolicScore ?? this.anabolicScore,
      metabolicScore: metabolicScore ?? this.metabolicScore,
      stressScore: stressScore ?? this.stressScore,
      recoveryScore: recoveryScore ?? this.recoveryScore,
      archetype: archetype ?? this.archetype,
      physiqueCompletionPercent:
          physiqueCompletionPercent ?? this.physiqueCompletionPercent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'snapshotAt': snapshotAt.toIso8601String(),
      'bodyFatPercent': bodyFatPercent,
      'leanBodyMassKg': leanBodyMassKg,
      'fatMassKg': fatMassKg,
      'anabolicScore': anabolicScore,
      'metabolicScore': metabolicScore,
      'stressScore': stressScore,
      'recoveryScore': recoveryScore,
      'archetype': archetype.name,
      'physiqueCompletionPercent': physiqueCompletionPercent,
    };
  }

  factory PhysiologySnapshot.fromMap(Map<String, dynamic> map) {
    return PhysiologySnapshot(
      userId: map['userId'] ?? '',
      snapshotAt: map['snapshotAt'] != null
          ? DateTime.parse(map['snapshotAt'])
          : DateTime.now(),
      bodyFatPercent: (map['bodyFatPercent'] ?? 0.0).toDouble(),
      leanBodyMassKg: (map['leanBodyMassKg'] ?? 0.0).toDouble(),
      fatMassKg: (map['fatMassKg'] ?? 0.0).toDouble(),
      anabolicScore: (map['anabolicScore'] ?? 0.0).toDouble(),
      metabolicScore: (map['metabolicScore'] ?? 0.0).toDouble(),
      stressScore: (map['stressScore'] ?? 0.0).toDouble(),
      recoveryScore: (map['recoveryScore'] ?? 0.0).toDouble(),
      archetype: PhysiqueArchetype.values.firstWhere(
        (a) => a.name == map['archetype'],
        orElse: () => PhysiqueArchetype.classicBodybuilder,
      ),
      physiqueCompletionPercent:
          (map['physiqueCompletionPercent'] ?? 0.0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PhysiologySnapshot.fromJson(String source) =>
      PhysiologySnapshot.fromMap(json.decode(source));
}
