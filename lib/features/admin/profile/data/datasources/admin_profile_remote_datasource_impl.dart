import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/features/admin/profile/data/models/admin_profile_model.dart';
import 'admin_profile_remote_datasource.dart';

class AdminProfileRemoteDataSourceImpl
    implements IAdminProfileRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AdminProfileRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;
  // Get Admin Profile Data
  @override
  Future<AdminProfileModel> getProfileData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated admin user session found.');
    }

    final uid = user.uid;
    String fullName = '';
    String email = user.email ?? '';
    String role = 'Super Admin';
    DateTime? lastLogin;
    DateTime? lastLogout;

    // Fetch admin details from users collection
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists && userDoc.data() != null) {
      final data = userDoc.data()!;
      fullName = data['full_name'] ?? data['fullName'] ?? data['name'] ?? '';
      role = data['role'] ?? 'Super Admin';

      final prevLoginTimestamp = data['last_login_previous'] as Timestamp?;
      if (prevLoginTimestamp != null) {
        lastLogin = prevLoginTimestamp.toDate();
      } else {
        final currentLoginTimestamp = data['last_login'] as Timestamp?;
        if (currentLoginTimestamp != null) {
          lastLogin = currentLoginTimestamp.toDate();
        }
      }

      final logoutTimestamp = data['last_logout'] as Timestamp?;
      if (logoutTimestamp != null) {
        lastLogout = logoutTimestamp.toDate();
      }
    }

    // Fallback to admins collection
    if (fullName.isEmpty) {
      final adminDoc = await _firestore.collection('admins').doc(uid).get();
      if (adminDoc.exists && adminDoc.data() != null) {
        final data = adminDoc.data()!;
        fullName = data['full_name'] ?? data['fullName'] ?? data['name'] ?? '';
        role = data['role'] ?? 'Super Admin';

        final prevLoginTimestamp = data['last_login_previous'] as Timestamp?;
        if (prevLoginTimestamp != null) {
          lastLogin = prevLoginTimestamp.toDate();
        } else {
          final currentLoginTimestamp = data['last_login'] as Timestamp?;
          if (currentLoginTimestamp != null) {
            lastLogin = currentLoginTimestamp.toDate();
          }
        }

        final logoutTimestamp = data['last_logout'] as Timestamp?;
        if (logoutTimestamp != null) {
          lastLogout = logoutTimestamp.toDate();
        }
      }
    }

    // Last fallback to email or displayName
    if (fullName.isEmpty) {
      fullName = user.displayName ?? email.split('@').first;
    }

    // Format role correctly
    if (role == 'super_admin') {
      role = 'Super Admin';
    } else if (role == 'admin') {
      role = 'Admin';
    } else {
      role = role.substring(0, 1).toUpperCase() + role.substring(1);
    }

    // Fallback to lastLogin if still null
    lastLogin ??= user.metadata.lastSignInTime;

    // Count approved shops
    final approvedShopsSnap = await _firestore
        .collection('shops')
        .where('is_approved', isEqualTo: true)
        .get();
    final approvedCount = approvedShopsSnap.docs.length;

    // Count tracked orders
    final ordersSnap = await _firestore.collection('orders').get();
    final ordersCount = ordersSnap.docs.length;

    return AdminProfileModel(
      uid: uid,
      fullName: fullName,
      email: email,
      role: role,
      lastLogin: lastLogin,
      lastLogout: lastLogout,
      approvedShopsCount: approvedCount,
      ordersTrackedCount: ordersCount,
    );
  }

  // Update Admin Profile Name
  @override
  Future<void> updateProfileName(String fullName) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated admin user session found.');
    }

    final uid = user.uid;

    // Try updating in users collection first
    final userDocRef = _firestore.collection('users').doc(uid);
    final userDoc = await userDocRef.get();
    if (userDoc.exists) {
      await userDocRef.update({'full_name': fullName});
      return;
    }

    // Fallback to admins collection
    final adminDocRef = _firestore.collection('admins').doc(uid);
    final adminDoc = await adminDocRef.get();
    if (adminDoc.exists) {
      await adminDocRef.update({'full_name': fullName});
      return;
    }

    throw Exception('Admin document not found in database.');
  }
}
