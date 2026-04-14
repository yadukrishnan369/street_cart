import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfileData extends ProfileEvent {}

class UpdateProfileDataEvent extends ProfileEvent {
  final ProfileModel updatedProfile;

  const UpdateProfileDataEvent(this.updatedProfile);

  @override
  List<Object?> get props => [updatedProfile];
}

class UploadProfileImageEvent extends ProfileEvent {
  final File imageFile;

  const UploadProfileImageEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class RemoveProfileImageEvent extends ProfileEvent {}
