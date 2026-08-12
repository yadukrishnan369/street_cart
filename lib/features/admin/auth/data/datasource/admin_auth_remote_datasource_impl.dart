import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/firebase/firebase_auth_service.dart';
import 'admin_auth_remote_datasource.dart';

class AdminAuthRemoteDataSourceImpl implements IAdminAuthRemoteDataSource {
  final FirebaseAuthService _authService;
  final FirebaseFirestore _firestore;

  AdminAuthRemoteDataSourceImpl({
    required FirebaseAuthService authService,
    required FirebaseFirestore firestore,
  }) : _authService = authService,
       _firestore = firestore;
  // Admin Login
  @override
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await _authService.signInWithEmail(
      email: email,
      password: password,
    );
    final uid = userCredential.user?.uid;
    if (uid != null) {
      await _updateLoginTimestamps(uid);
    }
    return uid;
  }

  // Update Login Time of Admin
  Future<void> _updateLoginTimestamps(String uid) async {
    try {
      // Check in users collection first
      final userDocRef = _firestore.collection('users').doc(uid);
      final userDoc = await userDocRef.get();
      if (userDoc.exists) {
        final data = userDoc.data();
        final currentLastLogin = data?['last_login'];
        await userDocRef.update({
          if (currentLastLogin != null) 'last_login_previous': currentLastLogin,
          'last_login': FieldValue.serverTimestamp(),
        });
      }

      // Check in admins collection
      final adminDocRef = _firestore.collection('admins').doc(uid);
      final adminDoc = await adminDocRef.get();
      if (adminDoc.exists) {
        final data = adminDoc.data();
        final currentLastLogin = data?['last_login'];
        await adminDocRef.update({
          if (currentLastLogin != null) 'last_login_previous': currentLastLogin,
          'last_login': FieldValue.serverTimestamp(),
        });
      } else {
        // Automatically create admin record if it doesn't exist
        final userDoc = await _firestore.collection('users').doc(uid).get();
        final userData = userDoc.exists ? userDoc.data() : null;
        await adminDocRef.set({
          'email': userData?['email'] ?? 'adminstreetcart@gmail.com',
          'full_name': userData?['full_name'] ?? 'Admin',
          'role': userData?['role'] ?? 'admin',
          'last_login': FieldValue.serverTimestamp(),
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating login timestamps: $e');
    }
  }

  // Get Current User ID
  @override
  Future<String?> getCurrentUserId() async {
    return _authService.getCurrentUserIdAsync();
  }

  // Get Current User Email
  @override
  Future<String?> getCurrentUserEmail() async {
    return _authService.getCurrentUserEmail();
  }

  // Check in users collection for role super_admin or admin
  @override
  Future<bool> isSuperAdmin(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      final role = data?['role'];
      if (role == 'super_admin' || role == 'admin') {
        return true;
      }
    }

    // Check in admins collection as fallback/alternative location
    final adminDoc = await _firestore.collection('admins').doc(uid).get();
    if (adminDoc.exists) {
      final data = adminDoc.data();
      final role = data?['role'];
      if (role == 'super_admin' || role == 'admin') {
        return true;
      }
      return true;
    }

    return false;
  }

  // Admin Logout
  @override
  Future<void> logout() async {
    final uid = await getCurrentUserId();
    if (uid != null) {
      await _updateLogoutTimestamp(uid);
    }
    await _authService.signOut();
  }

  // Update Logout Time
  Future<void> _updateLogoutTimestamp(String uid) async {
    try {
      // Check in users collection first
      final userDocRef = _firestore.collection('users').doc(uid);
      final userDoc = await userDocRef.get();
      if (userDoc.exists) {
        await userDocRef.update({'last_logout': FieldValue.serverTimestamp()});
      }

      // Check in admins collection
      final adminDocRef = _firestore.collection('admins').doc(uid);
      final adminDoc = await adminDocRef.get();
      if (adminDoc.exists) {
        await adminDocRef.update({'last_logout': FieldValue.serverTimestamp()});
      }
    } catch (e) {
      print('Error updating logout timestamp: $e');
    }
  }

  // Send Password Reset Email
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Check if the email exists in users collection as admin/super_admin
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      bool isAdminUser = false;
      for (var doc in userQuery.docs) {
        final role = doc.data()['role'];
        if (role == 'admin' || role == 'super_admin') {
          isAdminUser = true;
          break;
        }
      }

      // Check in admins collection
      if (!isAdminUser) {
        final adminQuery = await _firestore
            .collection('admins')
            .where('email', isEqualTo: email)
            .get();
        if (adminQuery.docs.isNotEmpty) {
          isAdminUser = true;
        }
      }

      if (!isAdminUser) {
        throw Exception('This email is not registered as an admin account.');
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('permission-denied') ||
          errorStr.contains('permission denied') ||
          errorStr.contains('insufficient permission')) {
        await _authService.sendPasswordResetEmail(email);
        return;
      }
      rethrow;
    }

    await _authService.sendPasswordResetEmail(email);
  }

  // Confirm Password Reset
  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    await _authService.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    );
  }
}
