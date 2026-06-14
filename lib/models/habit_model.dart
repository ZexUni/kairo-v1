class HabitModel {
  final String title;

  final bool completed;

  final DateTime date;

  HabitModel({
    required this.title,

    required this.completed,

    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,

      'completed': completed,

      'date': date.toIso8601String(),
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      title: map['title'] ?? '',

      completed: map['completed'] ?? false,

      date: DateTime.parse(map['date']),
    );
  }

  HabitModel copyWith({String? title, bool? completed, DateTime? date}) {
    return HabitModel(
      title: title ?? this.title,

      completed: completed ?? this.completed,

      date: date ?? this.date,
    );
  }
}
