abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'A server error occurred. Please try again.',
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Please check your internet connection and try again.',
  ]);
}

class LocationFailure extends Failure {
  const LocationFailure([super.message = 'Failed to get your location.']);
}

class ImagePickerFailure extends Failure {
  const ImagePickerFailure([
    super.message = 'Could not access your gallery. Please try again.',
  ]);
}
