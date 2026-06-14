class UserPreferences {
  final bool notificationsEnabled;

  final bool adaptiveCoaching;

  final bool darkMode;

  final bool autoRecoveryAdjustments;

  final String measurementUnit;

  UserPreferences({
    required this.notificationsEnabled,

    required this.adaptiveCoaching,

    required this.darkMode,

    required this.autoRecoveryAdjustments,

    required this.measurementUnit,
  });

  factory UserPreferences.initial() {
    return UserPreferences(
      notificationsEnabled: true,

      adaptiveCoaching: true,

      darkMode: true,

      autoRecoveryAdjustments: true,

      measurementUnit: 'Metric',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,

      'adaptiveCoaching': adaptiveCoaching,

      'darkMode': darkMode,

      'autoRecoveryAdjustments': autoRecoveryAdjustments,

      'measurementUnit': measurementUnit,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      notificationsEnabled: map['notificationsEnabled'] ?? true,

      adaptiveCoaching: map['adaptiveCoaching'] ?? true,

      darkMode: map['darkMode'] ?? true,

      autoRecoveryAdjustments: map['autoRecoveryAdjustments'] ?? true,

      measurementUnit: map['measurementUnit'] ?? 'Metric',
    );
  }

  UserPreferences copyWith({
    bool? notificationsEnabled,

    bool? adaptiveCoaching,

    bool? darkMode,

    bool? autoRecoveryAdjustments,

    String? measurementUnit,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,

      adaptiveCoaching: adaptiveCoaching ?? this.adaptiveCoaching,

      darkMode: darkMode ?? this.darkMode,

      autoRecoveryAdjustments:
          autoRecoveryAdjustments ?? this.autoRecoveryAdjustments,

      measurementUnit: measurementUnit ?? this.measurementUnit,
    );
  }
}
