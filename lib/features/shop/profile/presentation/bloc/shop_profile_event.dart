import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

// Base class
abstract class ShopProfileEvent extends Equatable {
  const ShopProfileEvent();

  @override
  List<Object?> get props => [];
}

// Fetch current shop profile details
class FetchShopProfileData extends ShopProfileEvent {}

// Update Shop profile
class UpdateShopProfileDataEvent extends ShopProfileEvent {
  final ShopProfileModel updatedProfile;

  const UpdateShopProfileDataEvent(this.updatedProfile);

  @override
  List<Object?> get props => [updatedProfile];
}

// Upload Shop profile Image
class UploadShopProfileImageEvent extends ShopProfileEvent {
  final File imageFile;

  const UploadShopProfileImageEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

// Remove Shop profile image
class RemoveShopProfileImageEvent extends ShopProfileEvent {}

// Fetch active payment methods
class FetchShopPaymentSettings extends ShopProfileEvent {}

// Initialized current profile details for Editing
class EditProfileInitEvent extends ShopProfileEvent {
  final ShopProfileModel profile;
  const EditProfileInitEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

// Change Active form page
class UpdateStepEvent extends ShopProfileEvent {
  final int step;
  const UpdateStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

// Change Business Category
class UpdateCategoryEvent extends ShopProfileEvent {
  final String category;
  const UpdateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

// Profile Image uploaded url updates
class UpdateProfileImageUrlEvent extends ShopProfileEvent {
  final String url;
  const UpdateProfileImageUrlEvent(this.url);

  @override
  List<Object?> get props => [url];
}

// Business license document url updates
class UpdateBusinessLicenseUrlEvent extends ShopProfileEvent {
  final String url;
  const UpdateBusinessLicenseUrlEvent(this.url);

  @override
  List<Object?> get props => [url];
}

// Owner ID url updates
class UpdateOwnerIdUrlEvent extends ShopProfileEvent {
  final String url;
  const UpdateOwnerIdUrlEvent(this.url);

  @override
  List<Object?> get props => [url];
}

// Change selected district value
class UpdateDistrictEvent extends ShopProfileEvent {
  final String? district;
  const UpdateDistrictEvent(this.district);

  @override
  List<Object?> get props => [district];
}

// Change selected state value
class UpdateStateEvent extends ShopProfileEvent {
  final String? selectedState;
  const UpdateStateEvent(this.selectedState);

  @override
  List<Object?> get props => [selectedState];
}

// Indicating progress uploading photos
class UpdateUploadingImageEvent extends ShopProfileEvent {
  final bool val;
  const UpdateUploadingImageEvent(this.val);

  @override
  List<Object?> get props => [val];
}

// Indicating progress uploading license
class UpdateUploadingLicenseEvent extends ShopProfileEvent {
  final bool val;
  const UpdateUploadingLicenseEvent(this.val);

  @override
  List<Object?> get props => [val];
}

// Indicating progress uploading verification IDs
class UpdateUploadingOwnerIdEvent extends ShopProfileEvent {
  final bool val;
  const UpdateUploadingOwnerIdEvent(this.val);

  @override
  List<Object?> get props => [val];
}

// Select/Deselect options from supported payment
class TogglePaymentMethodEvent extends ShopProfileEvent {
  final String method;
  final bool isSelected;
  const TogglePaymentMethodEvent(this.method, this.isSelected);

  @override
  List<Object?> get props => [method, isSelected];
}
