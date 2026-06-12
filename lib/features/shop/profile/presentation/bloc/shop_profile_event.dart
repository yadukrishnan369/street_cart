import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class ShopProfileEvent extends Equatable {
  const ShopProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchShopProfileData extends ShopProfileEvent {}

class UpdateShopProfileDataEvent extends ShopProfileEvent {
  final ShopProfileModel updatedProfile;

  const UpdateShopProfileDataEvent(this.updatedProfile);

  @override
  List<Object?> get props => [updatedProfile];
}

class UploadShopProfileImageEvent extends ShopProfileEvent {
  final File imageFile;

  const UploadShopProfileImageEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

class RemoveShopProfileImageEvent extends ShopProfileEvent {}
