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
  // Sign Up With Email
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
      throw _handleGenericException(e);
    }
  }

  // SignIn With Email
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
      throw _handleGenericException(e);
    }
  }

  // SignIn With Google
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
      throw _handleGenericException(e);
    }
  }

  // SignOut
  Future<void> signOut() async {
    try {
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // Ignore Google sign-in sign-out errors
      }
      await _auth.signOut();
    } catch (e) {
      throw _handleGenericException(e);
    }
  }

  // Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw _handleGenericException(e);
    }
  }

  // Confirm Password Reset
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw _handleGenericException(e);
    }
  }

  // Change Password
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
      throw _handleGenericException(e);
    }
  }

  // Reauthenticate
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
      throw _handleGenericException(e);
    }
  }

  // Delete Auth Account
  Future<void> deleteAuthAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw ServerException('No user logged in');
    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw _handleGenericException(e);
    }
  }

  // Get Current User ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> getCurrentUserIdAsync() async {
    final user = await _auth.authStateChanges().first;
    return user?.uid;
  }

  // Get Current User Email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // Check, Email Password User
  bool isEmailPasswordUser() {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'password');
  }

  // Send Email Verification
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) throw ServerException('No user logged in');
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw _handleGenericException(e);
    }
  }

  // Check, is Email Verified
  bool isEmailVerified() {
    final user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  // Reload User
  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw _handleGenericException(e);
    }
  }

  // Handle AuthException
  ServerException _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
      case 'network-error':
      case 'unavailable':
        return ServerException(
          'No internet connection. Please check your network and try again.',
        );
      case 'email-already-in-use':
        return ServerException(
          'The email address is already in use by another account.',
        );
      case 'invalid-email':
        return ServerException('Please enter a valid email address.');
      case 'weak-password':
        return ServerException('The password provided is too weak.');
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return ServerException('Incorrect email address or password.');
      case 'user-disabled':
        return ServerException(
          'This account has been disabled. Please contact support.',
        );
      case 'too-many-requests':
        return ServerException(
          'Too many failed attempts. Please try again later.',
        );
      case 'requires-recent-login':
        return ServerException(
          'For security reasons, you need to log in again before performing this action.',
        );
      default:
        final msg = e.message ?? '';
        final lower = msg.toLowerCase();
        if (lower.contains('network') ||
            lower.contains('connection') ||
            lower.contains('offline') ||
            lower.contains('fetch')) {
          return ServerException(
            'No internet connection. Please check your network and try again.',
          );
        }
        return ServerException(
          msg.isNotEmpty ? msg : 'An unexpected authentication error occurred.',
        );
    }
  }

  // Handle Generic Exception
  ServerException _handleGenericException(Object e) {
    final str = e.toString().toLowerCase();
    if (str.contains('network') ||
        str.contains('connection') ||
        str.contains('offline') ||
        str.contains('socketexception') ||
        str.contains('xmlhttprequest') ||
        str.contains('failed to fetch') ||
        str.contains('host lookup')) {
      return ServerException(
        'No internet connection. Please check your network and try again.',
      );
    }
    return ServerException(
      e.toString().replaceAll(RegExp(r'^Exception:\s*'), ''),
    );
  }
}
