import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController controller;

  final String hintText;

  final TextInputType keyboardType;

  final bool obscureText;

  final IconData? prefixIcon;

  final int maxLines;

  const PrimaryTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      keyboardType: keyboardType,

      obscureText: obscureText,

      maxLines: maxLines,

      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: const TextStyle(
          color: AppColors.textSecondary,

          fontSize: 15,
        ),

        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textSecondary)
            : null,

        filled: true,

        fillColor: AppColors.card,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,

          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),

          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),

          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
