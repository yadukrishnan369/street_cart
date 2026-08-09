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

  // Initiate Signup
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

  // Send Email Verification to Customer
  @override
  Future<void> sendEmailVerification() async {
    await _authService.sendEmailVerification();
  }

  // Check Email Verification
  @override
  Future<bool> checkEmailVerification() async {
    await _authService.reloadUser();
    return _authService.isEmailVerified();
  }

  // Finalize  Signup
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

  // Customr Login
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

  // Customer Signup With Google Option
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

        final data = doc.data();
        final wasDeletedOrBlocked =
            doc.exists &&
            (data?['is_deleted'] == true || data?['is_blocked'] == true);

        isNewUser = !doc.exists || wasDeletedOrBlocked;
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
                'is_deleted': false,
                'is_blocked': false,
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

  // Customer Logout
  @override
  Future<void> logout() async {
    await _authService.signOut();
  }

  // Send a Reset Mail Email to Customer
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

  // Get Cusotmer
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

  // Update Customer Profile
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

  // Get current Customer ID
  @override
  Future<String?> getCurrentUserId() async {
    return _authService.getCurrentUserId();
  }

  // Change Password
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

  // Check, if Email Password Customer or Not
  @override
  Future<bool> isEmailPasswordUser() async {
    return _authService.isEmailPasswordUser();
  }

  // Delete Customer Account
  @override
  Future<void> deleteAccount(String? password) async {
    try {
      // Re-authenticate if password is provided
      final isEmailUser = await _authService.isEmailPasswordUser();
      if (isEmailUser) {
        if (password != null) {
          await _authService.reauthenticate(password);
        }
      } else {
        await _authService.reauthenticateWithGoogle();
      }

      final uid = _authService.getCurrentUserId();
      if (uid == null) throw ServerException('No user logged in');

      // Delete Firestore data using batch
      final batch = _firestore.batch();

      // Anonymize Reviews
      final reviewsQuery = await _firestore
          .collection('reviews')
          .where('customer_id', isEqualTo: uid)
          .get();
      for (final doc in reviewsQuery.docs) {
        batch.update(doc.reference, {
          'customer_id': null,
          'customer_name': 'Deleted User',
          'customer_image': '',
        });
      }

      // Flag Orders - NOT delete orders, but completely delete delivery address details
      final ordersQuery = await _firestore
          .collection('orders')
          .where('customer_id', isEqualTo: uid)
          .get();
      for (final doc in ordersQuery.docs) {
        batch.update(doc.reference, {
          'customer_deleted': true,
          'delivery_address': FieldValue.delete(),
        });
      }

      // Delete Addresses Subcollection
      final addressesQuery = await _firestore
          .collection('customers')
          .doc(uid)
          .collection('addresses')
          .get();
      for (final doc in addressesQuery.docs) {
        batch.delete(doc.reference);
      }

      // Delete Cart Subcollection
      final cartQuery = await _firestore
          .collection('customers')
          .doc(uid)
          .collection('cart')
          .get();
      for (final doc in cartQuery.docs) {
        batch.delete(doc.reference);
      }

      // Delete Wishlist Subcollection
      final wishlistQuery = await _firestore
          .collection('customers')
          .doc(uid)
          .collection('wishlist')
          .get();
      for (final doc in wishlistQuery.docs) {
        batch.delete(doc.reference);
      }

      // Delete Customer Document - preserve for order history tracking with placeholders
      batch.update(_firestore.collection('customers').doc(uid), {
        'is_deleted': true,
        'is_blocked': true,
        'email': 'deleted_${uid}@streetcart.com',
        'full_name': 'Deleted User',
        'phone': '',
        'profile_image_url': '',
        'is_profile_completed': false,
      });

      // Commit all Firestore operations
      await batch.commit();

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
