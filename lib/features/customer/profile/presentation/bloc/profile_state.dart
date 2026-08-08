import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ProfileInitial extends ProfileState {}

// Profile Loading State
class ProfileLoading extends ProfileState {}

// Profile Loaded State
class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  final String? editImageUrl;

  final String editActiveName;

  final bool isUploadingImage;

  final bool orderUpdates;

  final bool offersPromotions;

  const ProfileLoaded(
    this.profile, {
    this.editImageUrl,
    this.editActiveName = '',
    this.isUploadingImage = false,
    this.orderUpdates = true,
    this.offersPromotions = false,
  });

  @override
  List<Object?> get props => [
    profile,
    editImageUrl,
    editActiveName,
    isUploadingImage,
    orderUpdates,
    offersPromotions,
  ];

  ProfileLoaded copyWith({
    ProfileModel? profile,
    String? editImageUrl,
    String? editActiveName,
    bool? isUploadingImage,
    bool? orderUpdates,
    bool? offersPromotions,
    bool clearImageUrl = false,
  }) {
    return ProfileLoaded(
      profile ?? this.profile,
      editImageUrl: clearImageUrl ? '' : (editImageUrl ?? this.editImageUrl),
      editActiveName: editActiveName ?? this.editActiveName,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      orderUpdates: orderUpdates ?? this.orderUpdates,
      offersPromotions: offersPromotions ?? this.offersPromotions,
    );
  }
}

//Profile is Updated Successfull State
class ProfileUpdateSuccess extends ProfileState {
  final ProfileModel profile;

  const ProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

// Error Occurs during Profile Fetch/Update State
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// Profile Image is Uploading State
class ProfileImageUploading extends ProfileState {}

// Profile Image is Successfully Uploaded State
class ProfileImageUploaded extends ProfileState {
  final String imageUrl;

  const ProfileImageUploaded(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}
