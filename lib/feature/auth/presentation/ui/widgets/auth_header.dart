import 'package:flutter/material.dart';
import 'package:new_app/core/theme/app_colors.dart';
import 'package:new_app/core/theme/app_spacing.dart';
import 'package:new_app/core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: Icon(
            icon,
            size: 36,
            color: AppColors.primary,
          ),
        ),
        AppSpacing.verticalGapLg,
        Text(
          title,
          style: AppTextStyles.heading1,
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalGapSm,
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
