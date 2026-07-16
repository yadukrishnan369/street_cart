class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'A server error occurred']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'A cache error occurred']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => message;
}

class LocationException implements Exception {
  final String message;
  LocationException([this.message = 'Failed to access location services']);

  @override
  String toString() => message;
}

class ImagePickerException implements Exception {
  final String message;
  ImagePickerException([this.message = 'Failed to pick image from gallery']);

  @override
  String toString() => message;
}

class OutOfDeliveryRadiusException implements Exception {
  final String message;
  OutOfDeliveryRadiusException([
    this.message =
        'This shop does not deliver to the selected address. Please choose another delivery address within the delivery area.',
  ]);

  @override
  String toString() => message;
}

class AddressVerificationException implements Exception {
  final String message;
  AddressVerificationException([
    this.message =
        'Unable to verify this address. Please check the address details and try again.',
  ]);

  @override
  String toString() => message;
}
