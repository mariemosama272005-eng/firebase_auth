import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthRepo {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepo({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();


  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during register: [${e.code}] ${e.message}');
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      debugPrint('Unexpected error during register: $e');
      throw AuthException(e.toString());
    }
  }


  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during login: [${e.code}] ${e.message}');
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      debugPrint('Unexpected error during login: $e');
      throw AuthException(e.toString());
    }
  }

 
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
    
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        return await _auth.signInWithPopup(googleProvider);
      } else {
   
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
         
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during Google sign-in: [${e.code}] ${e.message}');
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      debugPrint('Unexpected error during Google sign-in: $e');
      throw AuthException(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      if (!kIsWeb && await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (_) {}
    await _auth.signOut();
  }


  User? get currentUser => _auth.currentUser;

 
  Stream<User?> get authStateChanges => _auth.authStateChanges();


  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return 'Email/Password or Google sign-in is not enabled in Firebase Console. Please go to Firebase Console > Authentication > Sign-in method and enable it.';
      case 'email-already-in-use':
        return 'This email is already registered. Please sign in instead.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a few moments and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email using a different sign-in method.';
      case 'popup-closed-by-user':
        return 'Google sign-in popup was closed before completing.';
      default:
        return e.message ?? 'Authentication failed (${e.code}). Please try again.';
    }
  }
}


class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}
