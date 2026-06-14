class TrainingSplit {
  final String name;

  final List<String> schedule;

  final int trainingDays;

  final String focus;

  final String recoveryDemand;

  TrainingSplit({
    required this.name,

    required this.schedule,

    required this.trainingDays,

    required this.focus,

    required this.recoveryDemand,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,

      'schedule': schedule,

      'trainingDays': trainingDays,

      'focus': focus,

      'recoveryDemand': recoveryDemand,
    };
  }

  factory TrainingSplit.fromMap(Map<String, dynamic> map) {
    return TrainingSplit(
      name: map['name'] ?? '',

      schedule: List<String>.from(map['schedule'] ?? []),

      trainingDays: map['trainingDays'] ?? 0,

      focus: map['focus'] ?? '',

      recoveryDemand: map['recoveryDemand'] ?? '',
    );
  }

  TrainingSplit copyWith({
    String? name,

    List<String>? schedule,

    int? trainingDays,

    String? focus,

    String? recoveryDemand,
  }) {
    return TrainingSplit(
      name: name ?? this.name,

      schedule: schedule ?? this.schedule,

      trainingDays: trainingDays ?? this.trainingDays,

      focus: focus ?? this.focus,

      recoveryDemand: recoveryDemand ?? this.recoveryDemand,
    );
  }
}
