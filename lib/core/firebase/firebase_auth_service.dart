import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:street_cart/core/error/exceptions.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  }) : _auth = auth,
       _googleSignIn = googleSignIn;

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // Ignore Google sign-in sign-out errors
      }
      await _auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw ServerException('No user logged in or email not found');
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> reauthenticate(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw ServerException('No user logged in');
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    try {
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteAuthAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw ServerException('No user logged in');
    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> getCurrentUserIdAsync() async {
    final user = await _auth.authStateChanges().first;
    return user?.uid;
  }

  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  bool isEmailPasswordUser() {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'password');
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) throw ServerException('No user logged in');
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  bool isEmailVerified() {
    final user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  ServerException _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return ServerException(
          'The email address is already in use by another account.',
        );
      case 'invalid-email':
        return ServerException('The email address is invalid.');
      case 'weak-password':
        return ServerException('The password provided is too weak.');
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return ServerException('Incorrect email or password.');
      case 'requires-recent-login':
        return ServerException(
          'For security reasons, you need to log in again before performing this action.',
        );
      default:
        return ServerException(e.message ?? 'An unknown error occurred.');
    }
  }
}
