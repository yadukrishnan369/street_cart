import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

class DeliveryValidator {
  final FirebaseFirestore _firestore;
  final INetworkInfo _networkInfo;

  DeliveryValidator({
    required FirebaseFirestore firestore,
    required INetworkInfo networkInfo,
  }) : _firestore = firestore,
       _networkInfo = networkInfo;
  // Validate the Delivery Address before Proceed the Order
  Future<AddressModel> validateAddress({
    required AddressModel address,
    required List<String> shopIds,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    final query =
        "${address.addressLine1}, ${address.addressLine2}, ${address.district}, ${address.state}, ${address.pincode}";
    double lat;
    double lng;

    try {
      // Convert the Delivery Address to Latitude and Longitude
      final locations = await locationFromAddress(query);
      if (locations.isEmpty) {
        throw AddressVerificationException();
      }
      lat = locations.first.latitude;
      lng = locations.first.longitude;
    } catch (e) {
      if (e is OutOfDeliveryRadiusException) rethrow;
      throw AddressVerificationException();
    }

    // Validate distance for each shop
    for (final shopId in shopIds) {
      final shopDoc = await _firestore.collection('shops').doc(shopId).get();
      if (!shopDoc.exists) {
        throw Exception('Shop not found: $shopId');
      }

      final shopData = shopDoc.data();
      if (shopData == null) {
        throw Exception('Shop data is empty: $shopId');
      }

      final shopLoc = shopData['location'] as Map<String, dynamic>?;
      final double? shopLat = (shopLoc?['latitude'] as num?)?.toDouble();
      final double? shopLng = (shopLoc?['longitude'] as num?)?.toDouble();
      final double deliveryRadius =
          (shopData['delivery_radius'] as num?)?.toDouble() ?? 5.0;

      if (shopLat == null || shopLng == null) {
        throw Exception('Shop location is not configured.');
      }

      final distance = Geolocator.distanceBetween(shopLat, shopLng, lat, lng);
      // deliveryRadius is in km, distanceBetween is in meters
      if (distance > deliveryRadius * 1000) {
        throw OutOfDeliveryRadiusException();
      }
    }

    return address.copyWith(latitude: lat, longitude: lng);
  }
}
