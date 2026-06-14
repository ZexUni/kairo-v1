class PhysiologicalState {
  final double recovery;

  final double fatigue;

  final double readiness;

  final double adaptation;

  PhysiologicalState({
    required this.recovery,

    required this.fatigue,

    required this.readiness,

    required this.adaptation,
  });

  Map<String, dynamic> toMap() {
    return {
      'recovery': recovery,

      'fatigue': fatigue,

      'readiness': readiness,

      'adaptation': adaptation,
    };
  }

  factory PhysiologicalState.fromMap(Map<String, dynamic> map) {
    return PhysiologicalState(
      recovery: (map['recovery'] ?? 0).toDouble(),

      fatigue: (map['fatigue'] ?? 0).toDouble(),

      readiness: (map['readiness'] ?? 0).toDouble(),

      adaptation: (map['adaptation'] ?? 0).toDouble(),
    );
  }

  PhysiologicalState copyWith({
    double? recovery,

    double? fatigue,

    double? readiness,

    double? adaptation,
  }) {
    return PhysiologicalState(
      recovery: recovery ?? this.recovery,

      fatigue: fatigue ?? this.fatigue,

      readiness: readiness ?? this.readiness,

      adaptation: adaptation ?? this.adaptation,
    );
  }
}
