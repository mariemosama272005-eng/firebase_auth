part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

// --- Login States ---

final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {}

final class LoginError extends AuthState {
  final String message;

  LoginError({required this.message});
}


final class RegisterLoading extends AuthState {}

final class RegisterSuccess extends AuthState {}

final class RegisterError extends AuthState {
  final String message;

  RegisterError({required this.message});
}



final class GoogleSignInLoading extends AuthState {}

final class GoogleSignInSuccess extends AuthState {}

final class GoogleSignInCanceled extends AuthState {}

final class GoogleSignInError extends AuthState {
  final String message;

  GoogleSignInError({required this.message});
}
