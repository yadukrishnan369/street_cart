import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/constants/profile_constants.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/get_shop_profile_data.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/update_shop_profile_data.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/upload_shop_profile_image.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/remove_shop_profile_image.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_shop_payment_settings.dart';
import 'shop_profile_event.dart';
import 'shop_profile_state.dart';

class ShopProfileBloc extends Bloc<ShopProfileEvent, ShopProfileState> {
  final GetShopProfileData getProfileData;
  final UpdateShopProfileData updateProfileData;
  final UploadShopProfileImage uploadProfileImage;
  final RemoveShopProfileImage removeProfileImage;
  final GetShopPaymentSettings getShopPaymentSettings;

  ShopProfileBloc({
    required this.getProfileData,
    required this.updateProfileData,
    required this.uploadProfileImage,
    required this.removeProfileImage,
    required this.getShopPaymentSettings,
  }) : super(const ShopProfileState()) {
    // Fetch Shop profile details
    on<FetchShopProfileData>((event, emit) async {
      emit(state.copyWith(status: ShopProfileStatus.loading));
      try {
        final profile = await getProfileData();
        if (profile != null) {
          emit(
            state.copyWith(status: ShopProfileStatus.loaded, profile: profile),
          );
        } else {
          emit(
            state.copyWith(
              status: ShopProfileStatus.error,
              message: 'Failed to load profile data',
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: ShopProfileStatus.error,
            message: e.toString(),
          ),
        );
      }
    });

    // Update Shop profile
    on<UpdateShopProfileDataEvent>((event, emit) async {
      emit(state.copyWith(status: ShopProfileStatus.loading));
      try {
        await updateProfileData(event.updatedProfile);
        final profile = await getProfileData();
        if (profile != null) {
          emit(
            state.copyWith(
              status: ShopProfileStatus.updateSuccess,
              profile: profile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: ShopProfileStatus.error,
              message: 'Updated but failed to reload details.',
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: ShopProfileStatus.error,
            message: e.toString(),
          ),
        );
      }
    });

    // Upload Shop Profile Image
    on<UploadShopProfileImageEvent>((event, emit) async {
      emit(state.copyWith(status: ShopProfileStatus.imageUploading));
      try {
        final url = await uploadProfileImage(event.imageFile);
        emit(
          state.copyWith(
            status: ShopProfileStatus.imageUploaded,
            imageUrl: url,
            profileImageUrl: url,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: ShopProfileStatus.error,
            message: e.toString(),
          ),
        );
      }
    });

    // Remove Shop profile Image
    on<RemoveShopProfileImageEvent>((event, emit) async {
      emit(state.copyWith(status: ShopProfileStatus.loading));
      try {
        await removeProfileImage();
        final profile = await getProfileData();
        if (profile != null) {
          emit(
            state.copyWith(
              status: ShopProfileStatus.imageRemoved,
              profileImageUrl: '',
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: ShopProfileStatus.error,
            message: e.toString(),
          ),
        );
      }
    });

    // Fetch active payment Options
    on<FetchShopPaymentSettings>((event, emit) async {
      emit(state.copyWith(status: ShopProfileStatus.paymentSettingsLoading));
      try {
        final settings = await getShopPaymentSettings();
        emit(
          state.copyWith(
            status: ShopProfileStatus.paymentSettingsLoaded,
            paymentSettings: settings,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: ShopProfileStatus.paymentSettingsError,
            message: e.toString().replaceAll('Exception: ', ''),
          ),
        );
      }
    });

    // Onboarding/Edit Form step actions
    on<EditProfileInitEvent>((event, emit) {
      final profile = event.profile;
      emit(
        state.copyWith(
          selectedCategory: profile.category,
          profileImageUrl: profile.profileImageUrl,
          businessLicenseUrl: profile.businessLicenseUrl,
          ownerIdUrl: profile.ownerIdUrl,
          selectedDistrict: () {
            if (profile.district.isEmpty) return null;
            final normalized = profile.district
                .toLowerCase()
                .replaceAll('district', '')
                .trim();
            for (final d in ProfileConstants.districts) {
              if (d.toLowerCase() == normalized ||
                  d.toLowerCase().contains(normalized) ||
                  normalized.contains(d.toLowerCase())) {
                return d;
              }
            }
            return null;
          }(),
          selectedState: () {
            if (profile.state.isEmpty) return null;
            final normalized = profile.state.toLowerCase().trim();
            for (final s in ProfileConstants.states) {
              if (s.toLowerCase() == normalized ||
                  s.toLowerCase().contains(normalized) ||
                  normalized.contains(s.toLowerCase())) {
                return s;
              }
            }
            return null;
          }(),
          selectedPaymentMethods: List<String>.from(profile.paymentMethods),
          currentStep: 1,
        ),
      );
    });

    on<UpdateStepEvent>((event, emit) {
      emit(state.copyWith(currentStep: event.step));
    });

    on<UpdateCategoryEvent>((event, emit) {
      emit(state.copyWith(selectedCategory: event.category));
    });

    on<UpdateProfileImageUrlEvent>((event, emit) {
      emit(state.copyWith(profileImageUrl: event.url));
    });

    on<UpdateBusinessLicenseUrlEvent>((event, emit) {
      emit(state.copyWith(businessLicenseUrl: event.url));
    });

    on<UpdateOwnerIdUrlEvent>((event, emit) {
      emit(state.copyWith(ownerIdUrl: event.url));
    });

    on<UpdateDistrictEvent>((event, emit) {
      emit(state.copyWith(selectedDistrict: event.district));
    });

    on<UpdateStateEvent>((event, emit) {
      emit(state.copyWith(selectedState: event.selectedState));
    });

    on<UpdateUploadingImageEvent>((event, emit) {
      emit(state.copyWith(isUploadingImage: event.val));
    });

    on<UpdateUploadingLicenseEvent>((event, emit) {
      emit(state.copyWith(isUploadingLicense: event.val));
    });

    on<UpdateUploadingOwnerIdEvent>((event, emit) {
      emit(state.copyWith(isUploadingOwnerId: event.val));
    });

    // Toggle Payment Options
    on<TogglePaymentMethodEvent>((event, emit) {
      final list = List<String>.from(state.selectedPaymentMethods);
      if (event.isSelected) {
        if (!list.contains(event.method)) {
          list.add(event.method);
        }
      } else {
        list.remove(event.method);
      }
      emit(state.copyWith(selectedPaymentMethods: list));
    });
  }
}
