import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class ShopProfileState extends Equatable {
  const ShopProfileState();

  @override
  List<Object?> get props => [];
}

class ShopProfileInitial extends ShopProfileState {}

class ShopProfileLoading extends ShopProfileState {}

class ShopProfileLoaded extends ShopProfileState {
  final ShopProfileModel profile;

  const ShopProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ShopProfileUpdateSuccess extends ShopProfileState {
  final ShopProfileModel profile;

  const ShopProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ShopProfileError extends ShopProfileState {
  final String message;

  const ShopProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ShopProfileImageUploading extends ShopProfileState {}

class ShopProfileImageUploaded extends ShopProfileState {
  final String imageUrl;

  const ShopProfileImageUploaded(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class ShopProfileImageRemoved extends ShopProfileState {
  const ShopProfileImageRemoved();

  @override
  List<Object?> get props => [];
}

class ShopPaymentSettingsLoading extends ShopProfileState {}

class ShopPaymentSettingsLoaded extends ShopProfileState {
  final Map<String, bool> settings;

  const ShopPaymentSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class ShopPaymentSettingsError extends ShopProfileState {
  final String message;

  const ShopPaymentSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
