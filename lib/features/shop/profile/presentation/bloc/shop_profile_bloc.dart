import 'package:flutter_bloc/flutter_bloc.dart';
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
  }) : super(ShopProfileInitial()) {
    on<FetchShopProfileData>((event, emit) async {
      emit(ShopProfileLoading());
      try {
        final profile = await getProfileData();
        if (profile != null) {
          emit(ShopProfileLoaded(profile));
        } else {
          emit(const ShopProfileError('Failed to load profile data'));
        }
      } catch (e) {
        emit(ShopProfileError(e.toString()));
      }
    });

    on<UpdateShopProfileDataEvent>((event, emit) async {
      emit(ShopProfileLoading());
      try {
        await updateProfileData(event.updatedProfile);
        final profile = await getProfileData();
        if (profile != null) {
          emit(ShopProfileUpdateSuccess(profile));
        } else {
          emit(const ShopProfileError('Updated but failed to reload details.'));
        }
      } catch (e) {
        emit(ShopProfileError(e.toString()));
      }
    });

    on<UploadShopProfileImageEvent>((event, emit) async {
      emit(ShopProfileImageUploading());
      try {
        final url = await uploadProfileImage(event.imageFile);
        emit(ShopProfileImageUploaded(url));
      } catch (e) {
        emit(ShopProfileError(e.toString()));
      }
    });

    on<RemoveShopProfileImageEvent>((event, emit) async {
      emit(ShopProfileLoading());
      try {
        await removeProfileImage();
        final profile = await getProfileData();
        if (profile != null) {
          emit(ShopProfileImageRemoved());
        }
      } catch (e) {
        emit(ShopProfileError(e.toString()));
      }
    });

    on<FetchShopPaymentSettings>((event, emit) async {
      emit(ShopPaymentSettingsLoading());
      try {
        final settings = await getShopPaymentSettings();
        emit(ShopPaymentSettingsLoaded(settings));
      } catch (e) {
        emit(
          ShopPaymentSettingsError(e.toString().replaceAll('Exception: ', '')),
        );
      }
    });
  }
}
