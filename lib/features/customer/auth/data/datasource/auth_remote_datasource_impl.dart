import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/firebase/firebase_auth_service.dart';
import 'package:street_cart/features/customer/auth/data/datasource/auth_remote_datasource.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/core/error/exceptions.dart';

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final FirebaseAuthService _authService;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required FirebaseAuthService authService,
    required FirebaseFirestore firestore,
  }) : _authService = authService,
       _firestore = firestore;

  @override
  Future<void> initiateSignUp({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.signUpWithEmail(email: email, password: password);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    await _authService.sendEmailVerification();
  }

  @override
  Future<bool> checkEmailVerification() async {
    await _authService.reloadUser();
    return _authService.isEmailVerified();
  }

  @override
  Future<void> finalizeSignUp({
    required String fullName,
    required String email,
    required String userId,
  }) async {
    try {
      await _firestore.collection('customers').doc(userId).set({
        'full_name': fullName,
        'email': email,
        'is_profile_completed': false,
        'created_at': FieldValue.serverTimestamp(),
        'profile_image_url': '',
        'role': 'customer',
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final userCredential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      final uid = userCredential.user?.uid;
      if (uid != null) {
        final doc = await _firestore.collection('customers').doc(uid).get();
        if (!doc.exists) {
          await _authService.signOut();
          throw ServerException(
            'Access denied. You do not have a customer account.',
          );
        }
        final data = doc.data();
        if (data != null && data['is_blocked'] == true) {
          await _authService.signOut();
          throw ServerException(
            'Your account is blocked. Please contact support.',
          );
        }
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential == null) return false;

      bool isNewUser = false;
      // Check if user exists in Firestore, if not create record
      if (userCredential.user != null) {
        final doc = await _firestore
            .collection('customers')
            .doc(userCredential.user!.uid)
            .get();
        isNewUser = !doc.exists;
        if (isNewUser) {
          await _firestore
              .collection('customers')
              .doc(userCredential.user!.uid)
              .set({
                'full_name': userCredential.user!.displayName ?? '',
                'email': userCredential.user!.email ?? '',
                'is_profile_completed': false,
                'created_at': FieldValue.serverTimestamp(),
                'profile_image_url': userCredential.user!.photoURL ?? '',
                'role': 'customer',
              });
        }
      }

      return isNewUser;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _authService.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Check if the email belongs to an admin
      final adminQuery = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .get();

      bool isAdmin = adminQuery.docs.isNotEmpty;

      if (!isAdmin) {
        final userQuery = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        for (var doc in userQuery.docs) {
          final role = doc.data()['role'];
          if (role == 'admin' || role == 'super_admin') {
            isAdmin = true;
            break;
          }
        }
      }

      if (isAdmin) {
        throw ServerException(
          'This email is registered as an another account.',
        );
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('permission-denied') ||
          errorStr.contains('permission denied') ||
          errorStr.contains('insufficient permission')) {
        // If firestore rules block unauthenticated reads, fallback to direct firebase reset
        await _authService.sendPasswordResetEmail(email);
        return;
      }
      rethrow;
    }

    await _authService.sendPasswordResetEmail(email);
  }

  @override
  Future<ProfileModel?> getCustomer(String userId) async {
    try {
      final doc = await _firestore.collection('customers').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return ProfileModel.fromMap(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      throw ServerException(
        'An error occurred while fetching customer profile: $e',
      );
    }
  }

  @override
  Future<void> updateCustomerProfile({
    required String userId,
    required ProfileModel data,
  }) async {
    try {
      await _firestore.collection('customers').doc(userId).update(data.toMap());
    } catch (e) {
      throw ServerException(
        'An error occurred while updating customer profile: $e',
      );
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _authService.getCurrentUserId();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<bool> isEmailPasswordUser() async {
    return _authService.isEmailPasswordUser();
  }

  @override
  Future<void> deleteAccount(String? password) async {
    try {
      // Re-authenticate if password is provided
      if (password != null) {
        await _authService.reauthenticate(password);
      }

      final uid = _authService.getCurrentUserId();
      if (uid == null) throw ServerException('No user logged in');

      // Delete Firestore data
      await _firestore.collection('customers').doc(uid).delete();

      // Delete from Firebase Auth
      await _authService.deleteAuthAccount();

      // Sign out from services
      await _authService.signOut();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('An error occurred during account deletion: $e');
    }
  }
}
