import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Fetch User Profile Event
class FetchProfileData extends ProfileEvent {}

// Update the Profile Event
class UpdateProfileDataEvent extends ProfileEvent {
  final ProfileModel updatedProfile;

  const UpdateProfileDataEvent(this.updatedProfile);

  @override
  List<Object?> get props => [updatedProfile];
}

// Image Uploading Event
class UploadProfileImageEvent extends ProfileEvent {
  final File imageFile;

  const UploadProfileImageEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

// Remove Profile Image Event
class RemoveProfileImageEvent extends ProfileEvent {}

class UpdateActiveNameEvent extends ProfileEvent {
  final String name;

  const UpdateActiveNameEvent(this.name);

  @override
  List<Object?> get props => [name];
}

// Clear Profile Image Url Event
class ClearProfileImageUrlEvent extends ProfileEvent {}

class ToggleOrderUpdatesEvent extends ProfileEvent {
  final bool value;

  const ToggleOrderUpdatesEvent(this.value);

  @override
  List<Object?> get props => [value];
}

// Notification Events
class ToggleOffersPromotionsEvent extends ProfileEvent {
  final bool value;

  const ToggleOffersPromotionsEvent(this.value);

  @override
  List<Object?> get props => [value];
}
