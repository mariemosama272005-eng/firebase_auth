import 'package:flutter/material.dart';
import 'package:new_app/core/theme/app_colors.dart';
import 'package:new_app/core/theme/app_spacing.dart';
import 'package:new_app/core/theme/app_text_styles.dart';

class AuthSocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthSocialButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.inputBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 24, color: AppColors.textPrimary),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
      ),
    );
  }
}
