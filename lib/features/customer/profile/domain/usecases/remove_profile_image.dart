import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';

class RemoveProfileImage {
  final IProfileRepository repository;

  RemoveProfileImage(this.repository);

  Future<void> call() async {
    await repository.removeProfileImage();
  }
}
