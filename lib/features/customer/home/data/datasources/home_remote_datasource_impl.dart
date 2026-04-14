import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/core/services/location_service.dart';
import 'home_remote_datasource.dart';

class HomeRemoteDataSourceImpl implements IHomeRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final LocationService _locationService;

  HomeRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required LocationService locationService,
  })  : _auth = auth,
        _firestore = firestore,
        _locationService = locationService;

  @override
  Future<String?> getCustomerAddress() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('customers').doc(user.uid).get();
      if (!doc.exists) return null;

      final data = doc.data();
      if (data != null && data['location_permission'] == true && data['location'] != null) {
        final loc = data['location'] as Map<String, dynamic>;
        final dynamic lat = loc['latitude'];
        final dynamic lng = loc['longitude'];

        if (lat != null && lng != null) {
          final address = await _locationService.getAddressFromCoordinates(
            (lat as num).toDouble(),
            (lng as num).toDouble(),
          );
          return address;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get customer address: $e');
    }
  }
}
