import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/get_profile_data.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/update_profile_data.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/upload_profile_image.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/remove_profile_image.dart';
import 'profile_event.dart';
import 'profile_state.dart';

// Profile Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileData getProfileData;
  final UpdateProfileData updateProfileData;
  final UploadProfileImage uploadProfileImage;
  final RemoveProfileImage removeProfileImage;

  ProfileBloc({
    required this.getProfileData,
    required this.updateProfileData,
    required this.uploadProfileImage,
    required this.removeProfileImage,
  }) : super(ProfileInitial()) {
    // Fetch profile data
    on<FetchProfileData>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getProfileData();
        if (profile != null) {
          emit(
            ProfileLoaded(
              profile,
              editImageUrl: profile.profileImageUrl,
              editActiveName: profile.fullName,
            ),
          );
        } else {
          emit(const ProfileError('Failed to load profile data'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    // Update profile data
    on<UpdateProfileDataEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        await updateProfileData(event.updatedProfile);
        final profile = await getProfileData();
        if (profile != null) {
          emit(ProfileUpdateSuccess(profile));
          emit(
            ProfileLoaded(
              profile,
              editImageUrl: profile.profileImageUrl,
              editActiveName: profile.fullName,
            ),
          );
        } else {
          emit(const ProfileError('Updated but failed to reload details.'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    // Upload profile picture
    on<UploadProfileImageEvent>((event, emit) async {
      if (state is ProfileLoaded) {
        final current = state as ProfileLoaded;
        emit(current.copyWith(isUploadingImage: true));
        try {
          final url = await uploadProfileImage(event.imageFile);
          if (url != null) {
            emit(current.copyWith(isUploadingImage: false, editImageUrl: url));
            emit(ProfileImageUploaded(url));
          } else {
            emit(const ProfileError('Failed to upload image.'));
          }
        } catch (e) {
          emit(ProfileError(e.toString()));
        }
      }
    });

    // Remove profile picture
    on<RemoveProfileImageEvent>((event, emit) async {
      if (state is ProfileLoaded) {
        final current = state as ProfileLoaded;
        emit(current.copyWith(isUploadingImage: true));
        try {
          await removeProfileImage();
          emit(current.copyWith(isUploadingImage: false, clearImageUrl: true));
        } catch (e) {
          emit(ProfileError(e.toString()));
        }
      }
    });

    // Update, user typed name changes in the Edit Profile Page
    on<UpdateActiveNameEvent>((event, emit) {
      if (state is ProfileLoaded) {
        final current = state as ProfileLoaded;
        emit(current.copyWith(editActiveName: event.name));
      }
    });

    // Clears the selected profile image
    on<ClearProfileImageUrlEvent>((event, emit) {
      if (state is ProfileLoaded) {
        final current = state as ProfileLoaded;
        emit(current.copyWith(clearImageUrl: true));
      }
    });

    // Order Updates Toggle changes
    on<ToggleOrderUpdatesEvent>((event, emit) {
      if (state is ProfileLoaded) {
        final current = state as ProfileLoaded;
        emit(current.copyWith(orderUpdates: event.value));
      }
    });

    // Offers & Promotions Toggle changes
    on<ToggleOffersPromotionsEvent>((event, emit) {
      if (state is ProfileLoaded) {
        final current = state as ProfileLoaded;
        emit(current.copyWith(offersPromotions: event.value));
      }
    });
  }
}
