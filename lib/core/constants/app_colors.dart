import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0A0F1E);

  static const Color card = Color(0xFF151B2D);

  static const Color primary = Color(0xFF4B8BFF);

  static const Color secondary = Color(0xFF7B61FF);

  static const Color accent = Color(0xFF00E5FF);

  static const Color success = Color(0xFF00C853);

  static const Color warning = Color(0xFFFFAB00);

  static const Color danger = Color(0xFFFF5252);

  static const Color textPrimary = Colors.white;

  static const Color textSecondary = Color(0xFF9FA8C3);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4B8BFF), Color(0xFF7B61FF)],

    begin: Alignment.topLeft,

    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF151B2D), Color(0xFF1D2742)],

    begin: Alignment.topLeft,

    end: Alignment.bottomRight,
  );
}
