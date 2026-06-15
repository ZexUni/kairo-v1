import 'dart:convert';

enum EquipmentMode { bodyweight, homeGym, fullGym }

enum PrimaryGoal { bulk, cut, recomp, maintenance }

class UserProfile {
  final String id;
  final String name;
  final int age;
  final String gender;
  final double heightCm;
  final double weightKg;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EquipmentMode equipmentMode;
  final PrimaryGoal primaryGoal;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.createdAt,
    required this.updatedAt,
    required this.equipmentMode,
    required this.primaryGoal,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    DateTime? createdAt,
    DateTime? updatedAt,
    EquipmentMode? equipmentMode,
    PrimaryGoal? primaryGoal,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      equipmentMode: equipmentMode ?? this.equipmentMode,
      primaryGoal: primaryGoal ?? this.primaryGoal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'equipmentMode': equipmentMode.name,
      'primaryGoal': primaryGoal.name,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      heightCm: (map['heightCm'] ?? 0.0).toDouble(),
      weightKg: (map['weightKg'] ?? 0.0).toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      equipmentMode: EquipmentMode.values.firstWhere(
        (e) => e.name == map['equipmentMode'],
        orElse: () => EquipmentMode.fullGym,
      ),
      primaryGoal: PrimaryGoal.values.firstWhere(
        (e) => e.name == map['primaryGoal'],
        orElse: () => PrimaryGoal.maintenance,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));
}
