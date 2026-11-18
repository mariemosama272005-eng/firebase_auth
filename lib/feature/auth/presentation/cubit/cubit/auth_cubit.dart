import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:new_app/feature/auth/data/repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(AuthInitial());

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      await _authRepo.register(email: email, password: password);
      emit(RegisterSuccess());
    } on AuthException catch (e) {
      emit(RegisterError(message: e.message));
    } catch (e) {
      emit(RegisterError(message: e.toString()));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      await _authRepo.login(email: email, password: password);
      emit(LoginSuccess());
    } on AuthException catch (e) {
      emit(LoginError(message: e.message));
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoading());
    try {
      final credential = await _authRepo.signInWithGoogle();
      if (credential != null) {
        emit(GoogleSignInSuccess());
      } else {
        emit(GoogleSignInCanceled());
      }
    } on AuthException catch (e) {
      emit(GoogleSignInError(message: e.message));
    } catch (e) {
      emit(GoogleSignInError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    await _authRepo.logout();
    emit(AuthInitial());
  }
}
