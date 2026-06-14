import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;

  final VoidCallback onPressed;

  final bool loading;

  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        onPressed: loading ? null : onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,

          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),

          elevation: 0,

          padding: const EdgeInsets.symmetric(vertical: 18),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        child: loading
            ? const SizedBox(
                height: 24,

                width: 24,

                child: CircularProgressIndicator(
                  strokeWidth: 2.5,

                  color: Colors.black,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),

                      child: Icon(icon, color: Colors.black),
                    ),

                  Text(
                    text,

                    style: const TextStyle(
                      color: Colors.black,

                      fontSize: 16,

                      fontWeight: FontWeight.bold,

                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
