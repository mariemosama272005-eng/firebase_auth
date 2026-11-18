import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/core/theme/app_colors.dart';
import 'package:new_app/core/theme/app_spacing.dart';
import 'package:new_app/core/utils/snackbar_util.dart';
import 'package:new_app/core/validators/form_validators.dart';
import 'package:new_app/feature/auth/presentation/cubit/cubit/auth_cubit.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_divider.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_footer_link.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_header.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_password_field.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_primary_button.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_social_button.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _onGoogleSignIn() {
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingHorizontalLg,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is RegisterError) {
                  SnackBarUtil.showError(context, state.message);
                } else if (state is GoogleSignInError) {
                  SnackBarUtil.showError(context, state.message);
                } else if (state is RegisterSuccess) {
                  SnackBarUtil.showSuccess(context, 'Account created successfully!');
                  Navigator.of(context).pop();
                } else if (state is GoogleSignInSuccess) {
                  SnackBarUtil.showSuccess(context, 'Signed in with Google successfully!');
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                final isEmailLoading = state is RegisterLoading;
                final isGoogleLoading = state is GoogleSignInLoading;
                final isBusy = isEmailLoading || isGoogleLoading;

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSpacing.verticalGapXl,
                      const AuthHeader(
                        title: 'Create Account',
                        subtitle: 'Sign up to get started',
                        icon: Icons.person_add_alt_1_rounded,
                      ),
                      AppSpacing.verticalGapXl,
                      AuthTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                        validator: FormValidators.validateName,
                        enabled: !isBusy,
                      ),
                      AppSpacing.verticalGapMd,
                      AuthTextField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: FormValidators.validateEmail,
                        enabled: !isBusy,
                      ),
                      AppSpacing.verticalGapMd,
                      AuthPasswordField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Create a password',
                        validator: FormValidators.validatePassword,
                        textInputAction: TextInputAction.next,
                        enabled: !isBusy,
                      ),
                      AppSpacing.verticalGapMd,
                      AuthPasswordField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hintText: 'Confirm your password',
                        validator: (value) => FormValidators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        ),
                        enabled: !isBusy,
                      ),
                      AppSpacing.verticalGapLg,
                      AuthPrimaryButton(
                        text: 'Create Account',
                        onPressed: _onRegister,
                        isLoading: isEmailLoading,
                      ),
                      AppSpacing.verticalGapLg,
                      const AuthDivider(),
                      AppSpacing.verticalGapLg,
                      AuthSocialButton(
                        text: 'Continue with Google',
                        icon: Icons.g_mobiledata_rounded,
                        isLoading: isGoogleLoading,
                        onPressed: isBusy ? null : _onGoogleSignIn,
                      ),
                      AppSpacing.verticalGapXl,
                      AuthFooterLink(
                        leadingText: 'Already have an account? ',
                        actionText: 'Sign In',
                        onTap: _navigateToLogin,
                      ),
                      AppSpacing.verticalGapXl,
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
