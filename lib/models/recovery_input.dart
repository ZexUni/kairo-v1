class RecoveryInput {
  final double sleepHours;

  final double soreness;

  final double stress;

  RecoveryInput({
    required this.sleepHours,

    required this.soreness,

    required this.stress,
  });

  Map<String, dynamic> toMap() {
    return {'sleepHours': sleepHours, 'soreness': soreness, 'stress': stress};
  }

  factory RecoveryInput.fromMap(Map<String, dynamic> map) {
    return RecoveryInput(
      sleepHours: (map['sleepHours'] ?? 0).toDouble(),

      soreness: (map['soreness'] ?? 0).toDouble(),

      stress: (map['stress'] ?? 0).toDouble(),
    );
  }

  RecoveryInput copyWith({
    double? sleepHours,

    double? soreness,

    double? stress,
  }) {
    return RecoveryInput(
      sleepHours: sleepHours ?? this.sleepHours,

      soreness: soreness ?? this.soreness,

      stress: stress ?? this.stress,
    );
  }
}
