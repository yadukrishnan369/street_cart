import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:street_cart/core/error/exceptions.dart';

class LocationService {
  Future<bool> isServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<Position> getCurrentLocation() async {
    final permission = await checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw LocationException("Location permission not granted.");
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      throw LocationException("Failed to reach device GPS hardware.");
    }
  }

  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.locality ?? place.subLocality ?? 'Unknown'}, ${place.administrativeArea ?? ''}";
      }
      return null;
    } catch (e) {
      throw LocationException(
        "Failed to resolve city address from coordinates.",
      );
    }
  }
}
