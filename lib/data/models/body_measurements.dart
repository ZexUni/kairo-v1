import 'dart:convert';

class BodyMeasurements {
  final String userId;
  final DateTime measuredAt;
  final double neckCm;
  final double shouldersCm;
  final double chestCm;
  final double backWidthCm;
  final double bicepsCm;
  final double forearmsCm;
  final double waistCm;
  final double glutesCm;
  final double thighsCm;
  final double calvesCm;

  const BodyMeasurements({
    required this.userId,
    required this.measuredAt,
    required this.neckCm,
    required this.shouldersCm,
    required this.chestCm,
    required this.backWidthCm,
    required this.bicepsCm,
    required this.forearmsCm,
    required this.waistCm,
    required this.glutesCm,
    required this.thighsCm,
    required this.calvesCm,
  });

  double get shoulderWaistRatio => waistCm == 0 ? 0.0 : shouldersCm / waistCm;
  double get chestWaistRatio => waistCm == 0 ? 0.0 : chestCm / waistCm;
  double get armWaistRatio => waistCm == 0 ? 0.0 : bicepsCm / waistCm;
  double get legSymmetryRatio => chestCm == 0 ? 0.0 : thighsCm / chestCm;

  BodyMeasurements copyWith({
    String? userId,
    DateTime? measuredAt,
    double? neckCm,
    double? shouldersCm,
    double? chestCm,
    double? backWidthCm,
    double? bicepsCm,
    double? forearmsCm,
    double? waistCm,
    double? glutesCm,
    double? thighsCm,
    double? calvesCm,
  }) {
    return BodyMeasurements(
      userId: userId ?? this.userId,
      measuredAt: measuredAt ?? this.measuredAt,
      neckCm: neckCm ?? this.neckCm,
      shouldersCm: shouldersCm ?? this.shouldersCm,
      chestCm: chestCm ?? this.chestCm,
      backWidthCm: backWidthCm ?? this.backWidthCm,
      bicepsCm: bicepsCm ?? this.bicepsCm,
      forearmsCm: forearmsCm ?? this.forearmsCm,
      waistCm: waistCm ?? this.waistCm,
      glutesCm: glutesCm ?? this.glutesCm,
      thighsCm: thighsCm ?? this.thighsCm,
      calvesCm: calvesCm ?? this.calvesCm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'measuredAt': measuredAt.toIso8601String(),
      'neckCm': neckCm,
      'shouldersCm': shouldersCm,
      'chestCm': chestCm,
      'backWidthCm': backWidthCm,
      'bicepsCm': bicepsCm,
      'forearmsCm': forearmsCm,
      'waistCm': waistCm,
      'glutesCm': glutesCm,
      'thighsCm': thighsCm,
      'calvesCm': calvesCm,
    };
  }

  factory BodyMeasurements.fromMap(Map<String, dynamic> map) {
    return BodyMeasurements(
      userId: map['userId'] ?? '',
      measuredAt: map['measuredAt'] != null
          ? DateTime.parse(map['measuredAt'])
          : DateTime.now(),
      neckCm: (map['neckCm'] ?? 0.0).toDouble(),
      shouldersCm: (map['shouldersCm'] ?? 0.0).toDouble(),
      chestCm: (map['chestCm'] ?? 0.0).toDouble(),
      backWidthCm: (map['backWidthCm'] ?? 0.0).toDouble(),
      bicepsCm: (map['bicepsCm'] ?? 0.0).toDouble(),
      forearmsCm: (map['forearmsCm'] ?? 0.0).toDouble(),
      waistCm: (map['waistCm'] ?? 0.0).toDouble(),
      glutesCm: (map['glutesCm'] ?? 0.0).toDouble(),
      thighsCm: (map['thighsCm'] ?? 0.0).toDouble(),
      calvesCm: (map['calvesCm'] ?? 0.0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BodyMeasurements.fromJson(String source) =>
      BodyMeasurements.fromMap(json.decode(source));
}
