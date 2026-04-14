import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/get_profile_data.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/update_profile_data.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/upload_profile_image.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/remove_profile_image.dart';
import 'profile_event.dart';
import 'profile_state.dart';

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
    on<FetchProfileData>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await getProfileData();
        if (profile != null) {
          emit(ProfileLoaded(profile));
        } else {
          emit(const ProfileError('Failed to load profile data'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfileDataEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        await updateProfileData(event.updatedProfile);
        final profile = await getProfileData();
        if (profile != null) {
          emit(ProfileUpdateSuccess(profile));
        } else {
          emit(const ProfileError('Updated but failed to reload details.'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UploadProfileImageEvent>((event, emit) async {
      emit(ProfileImageUploading());
      try {
        final url = await uploadProfileImage(event.imageFile);
        if (url != null) {
          emit(ProfileImageUploaded(url));
        } else {
          emit(const ProfileError('Failed to upload image.'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<RemoveProfileImageEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        await removeProfileImage();
        final profile = await getProfileData();
        if (profile != null) {
          emit(ProfileUpdateSuccess(profile));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
