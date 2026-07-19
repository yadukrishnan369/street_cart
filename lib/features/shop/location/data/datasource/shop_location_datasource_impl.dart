import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
  // Save Location
  @override
  Future<bool> requestAndSave() async {
    // Check if location services are enabled
    final isEnabled = await locationService.isServiceEnabled();
    if (!isEnabled) {
      throw LocationException(
        "Location services are disabled. Please enable GPS in your device settings.",
      );
    }

    // permission request
    LocationPermission permission = await locationService.checkPermission();

    // If permission is permanently denied, can't show the modal anymore
    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        "Location permissions are permanently denied. Please enable them in App Settings to proceed.",
      );
    }

    // If permission is denied or not determined, request it
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      permission = await locationService.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw LocationException(
          "Location permission was denied. We need this to verify your shop's location.",
        );
      }
    }

    // Get current location once permission is definitely granted
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
      throw LocationException(
        "We couldn't get a precise location. Please check your signal and try again.",
      );
    }

    // Save to under shops collection
    final user = firebaseAuth.currentUser;

    if (user != null) {
      try {
        String? city;
        String? state;
        String? district;
        String? pincode;
        String? fullAddress;

        if (success) {
          try {
            final placemarks = await placemarkFromCoordinates(
              latitude,
              longitude,
            );
            if (placemarks.isNotEmpty) {
              final place = placemarks.first;
              city = place.locality ?? place.subLocality;
              state = place.administrativeArea;
              district = place.subAdministrativeArea;
              pincode = place.postalCode;

              final addressParts = [
                if (place.name != null && place.name!.isNotEmpty) place.name,
                if (place.street != null &&
                    place.street!.isNotEmpty &&
                    place.street != place.name)
                  place.street,
                if (place.subLocality != null && place.subLocality!.isNotEmpty)
                  place.subLocality,
                if (place.locality != null &&
                    place.locality!.isNotEmpty &&
                    place.locality != place.subLocality)
                  place.locality,
                if (place.subAdministrativeArea != null &&
                    place.subAdministrativeArea!.isNotEmpty)
                  place.subAdministrativeArea,
                if (place.administrativeArea != null &&
                    place.administrativeArea!.isNotEmpty)
                  place.administrativeArea,
                if (place.postalCode != null && place.postalCode!.isNotEmpty)
                  place.postalCode,
              ];
              fullAddress = addressParts.join(', ');
            }
          } catch (e) {
            AppLogger.error("Failed to reverse geocode shop coordinates: $e");
          }
        }

        final updateData = <String, dynamic>{
          'location_permission': true,
          'location': {'latitude': latitude, 'longitude': longitude},
          'location_updated_at': FieldValue.serverTimestamp(),
        };

        if (city != null && city.isNotEmpty) {
          updateData['city'] = city;
        }
        if (state != null && state.isNotEmpty) {
          updateData['state'] = state;
        }
        if (district != null && district.isNotEmpty) {
          updateData['district'] = district;
        }
        if (pincode != null && pincode.isNotEmpty) {
          updateData['pincode'] = pincode;
        }
        if (fullAddress != null && fullAddress.isNotEmpty) {
          updateData['full_address'] = fullAddress;
        }

        await firebaseFirestore
            .collection('shops')
            .doc(user.uid)
            .update(updateData);

        // Save Locally
        await sharedPreferences.setBool('shopLocationServices', true);
      } catch (e) {
        throw Exception(
          'An error occurred while saving your location to your shop profile.',
        );
      }
    }

    return success;
  }

  // Skip Location Access
  @override
  Future<void> skip() async {
    final user = firebaseAuth.currentUser;

    if (user != null) {
      try {
        await firebaseFirestore.collection('shops').doc(user.uid).update({
          'location_permission': false,
          'location_updated_at': FieldValue.serverTimestamp(),
        });

        // Save Locally
        await sharedPreferences.setBool('shopLocationServices', false);
      } catch (e) {
        throw Exception('An error occurred while updating shop location: $e');
      }
    }
  }
}
