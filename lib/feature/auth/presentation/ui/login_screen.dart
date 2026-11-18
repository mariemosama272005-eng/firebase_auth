import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/core/theme/app_colors.dart';
import 'package:new_app/core/theme/app_spacing.dart';
import 'package:new_app/core/utils/snackbar_util.dart';
import 'package:new_app/core/validators/form_validators.dart';
import 'package:new_app/feature/auth/presentation/cubit/cubit/auth_cubit.dart';
import 'package:new_app/feature/auth/presentation/ui/register_screen.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_divider.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_footer_link.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_header.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_password_field.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_primary_button.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_social_button.dart';
import 'package:new_app/feature/auth/presentation/ui/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _onGoogleSignIn() {
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
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
                if (state is LoginError) {
                  SnackBarUtil.showError(context, state.message);
                } else if (state is GoogleSignInError) {
                  SnackBarUtil.showError(context, state.message);
                } else if (state is LoginSuccess || state is GoogleSignInSuccess) {
                  SnackBarUtil.showSuccess(context, 'Login successful!');
               
                }
              },
              builder: (context, state) {
                final isEmailLoading = state is LoginLoading;
                final isGoogleLoading = state is GoogleSignInLoading;
                final isBusy = isEmailLoading || isGoogleLoading;

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSpacing.verticalGapXl,
                      const AuthHeader(
                        title: 'Welcome Back',
                        subtitle: 'Sign in to continue to your account',
                        icon: Icons.lock_open_rounded,
                      ),
                      AppSpacing.verticalGapXl,
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
                        hintText: 'Enter your password',
                        validator: FormValidators.validatePassword,
                        enabled: !isBusy,
                      ),
                      AppSpacing.verticalGapSm,
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isBusy ? null : () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      AppSpacing.verticalGapMd,
                      AuthPrimaryButton(
                        text: 'Sign In',
                        onPressed: _onLogin,
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
                        leadingText: "Don't have an account? ",
                        actionText: 'Sign Up',
                        onTap: _navigateToRegister,
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
