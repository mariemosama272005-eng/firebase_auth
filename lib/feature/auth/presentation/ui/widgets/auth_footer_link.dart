import 'package:flutter/material.dart';
import 'package:new_app/core/theme/app_text_styles.dart';

class AuthFooterLink extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(leadingText, style: AppTextStyles.bodyMedium),
        GestureDetector(
          onTap: onTap,
          child: Text(actionText, style: AppTextStyles.linkText),
        ),
      ],
    );
  }
}
