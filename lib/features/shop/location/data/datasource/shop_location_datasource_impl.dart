import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/core/services/location_service.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/core/utils/logger.dart';
import 'shop_location_datasource.dart';

class ShopLocationDataSourceImpl implements ShopLocationDataSource {
  final LocationService locationService;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences sharedPreferences;

  ShopLocationDataSourceImpl({
    required this.locationService,
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.sharedPreferences,
  });

  @override
  Future<bool> requestAndSave() async {
    // 1. Check if location services are enabled
    final isEnabled = await locationService.isServiceEnabled();
    if (!isEnabled) {
      throw LocationException("Location services are disabled. Please enable GPS in your device settings.");
    }

    // 2. Standardize permission request flow for maximum reliability
    LocationPermission permission = await locationService.checkPermission();
    
    // If permission is permanently denied, we can't show the modal anymore
    if (permission == LocationPermission.deniedForever) {
      throw LocationException("Location permissions are permanently denied. Please enable them in App Settings to proceed.");
    }

    // If permission is denied or not determined, request it
    if (permission == LocationPermission.denied || permission == LocationPermission.unableToDetermine) {
      permission = await locationService.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw LocationException("Location permission was denied. We need this to verify your shop's location.");
      }
    }

    // 3. Get current location once permission is definitely granted
    double? latitude;
    double? longitude;
    bool success = false;

    try {
      final position = await locationService.getCurrentLocation();
      latitude = position.latitude;
      longitude = position.longitude;
      success = true;
    } on LocationException catch (e, stack) {
      AppLogger.error(e.message, e, stack);
      throw LocationException("We couldn't get a precise location. Please check your signal and try again.");
    }

    // 4. Save to Firestore under shops collection
    final user = firebaseAuth.currentUser;

    if (user != null) {
      try {
        await firebaseFirestore.collection('shops').doc(user.uid).update({
          'location_permission': true,
          'location': {
            'latitude': latitude,
            'longitude': longitude,
          },
          'location_updated_at': FieldValue.serverTimestamp(),
        });
        
        // SYNC PREFERENCE
        await sharedPreferences.setBool('shopLocationServices', true);
        
      } catch (e) {
        throw Exception('An error occurred while saving your location to your shop profile.');
      }
    }
    
    return success;
  }

  @override
  Future<void> skip() async {
    final user = firebaseAuth.currentUser;

    if (user != null) {
      try {
        await firebaseFirestore.collection('shops').doc(user.uid).update({
          'location_permission': false,
          'location_updated_at': FieldValue.serverTimestamp(),
        });
        
        // SYNC PREFERENCE
        await sharedPreferences.setBool('shopLocationServices', false);
        
      } catch (e) {
        throw Exception('An error occurred while updating shop location: $e');
      }
    }
  }
}
