import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Interfaces
abstract class ISettingsRemoteDataSource {
  Future<Map<String, bool>> getNotificationPreferences();
  Future<void> saveNotificationPreference(String key, bool value);
}

class SettingsRemoteDataSourceImpl implements ISettingsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  SettingsRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;
  // Get Notification Preferences
  @override
  Future<Map<String, bool>> getNotificationPreferences() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('customers').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return {
          'generalNotificationsEnabled':
              data['generalNotificationsEnabled'] ?? true,
          'orderAlertsEnabled': data['orderAlertsEnabled'] ?? true,
        };
      }
    }
    return {'generalNotificationsEnabled': true, 'orderAlertsEnabled': true};
  }

  // Save Notification Preference
  @override
  Future<void> saveNotificationPreference(String key, bool value) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('customers').doc(user.uid).set({
        key: value,
      }, SetOptions(merge: true));
    }
  }
}
