import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

class DashboardSectionTitle extends StatelessWidget {
  final String title;

  final String? actionText;

  final VoidCallback? onTap;

  const DashboardSectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Text(
          title,

          style: const TextStyle(
            color: AppColors.textPrimary,

            fontSize: 22,

            fontWeight: FontWeight.bold,
          ),
        ),

        if (actionText != null)
          GestureDetector(
            onTap: onTap,

            child: Text(
              actionText!,

              style: const TextStyle(
                color: AppColors.primary,

                fontSize: 14,

                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
