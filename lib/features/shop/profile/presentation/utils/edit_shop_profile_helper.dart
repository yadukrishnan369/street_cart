import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/edit_shop_profile_ui_cubit.dart';
import 'package:street_cart/core/utils/image_picker_helper.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class EditShopProfileHelper {
  static Future<void> pickProfileImage(BuildContext context) async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null) {
      if (context.mounted) {
        context.read<ShopProfileBloc>().add(UploadShopProfileImageEvent(file));
        context.read<EditShopProfileUiCubit>().updateUploadingImage(true);
      }
    }
  }

  static Future<void> pickLicense(BuildContext context) async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null) {
      if (context.mounted) {
        context.read<EditShopProfileUiCubit>().updateUploadingLicense(true);
        try {
          final url = await context.read<ShopProfileBloc>().uploadProfileImage(
            file,
          );
          if (context.mounted) {
            context.read<EditShopProfileUiCubit>().updateBusinessLicenseUrl(
              url,
            );
            context.read<EditShopProfileUiCubit>().updateUploadingLicense(
              false,
            );
            CustomSnackBar.show(
              context,
              message: 'License uploaded successfully!',
            );
          }
        } catch (e) {
          if (context.mounted) {
            context.read<EditShopProfileUiCubit>().updateUploadingLicense(
              false,
            );
            CustomSnackBar.show(
              context,
              message: 'Failed to upload license: $e',
              isError: true,
            );
          }
        }
      }
    }
  }

  static Future<void> pickOwnerId(BuildContext context) async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null) {
      if (context.mounted) {
        context.read<EditShopProfileUiCubit>().updateUploadingOwnerId(true);
        try {
          final url = await context.read<ShopProfileBloc>().uploadProfileImage(
            file,
          );
          if (context.mounted) {
            context.read<EditShopProfileUiCubit>().updateOwnerIdUrl(url);
            context.read<EditShopProfileUiCubit>().updateUploadingOwnerId(
              false,
            );
            CustomSnackBar.show(
              context,
              message: 'Owner ID uploaded successfully!',
            );
          }
        } catch (e) {
          if (context.mounted) {
            context.read<EditShopProfileUiCubit>().updateUploadingOwnerId(
              false,
            );
            CustomSnackBar.show(
              context,
              message: 'Failed to upload ID: $e',
              isError: true,
            );
          }
        }
      }
    }
  }

  static void onRemoveProfileImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Remove Profile Photo',
        content: 'Are you sure you want to remove your profile photo?',
        confirmText: 'Remove',
        cancelText: 'Cancel',
        confirmColor: Colors.redAccent,
        onCancel: () => Navigator.pop(dialogContext),
        onConfirm: () {
          Navigator.pop(dialogContext);
          context.read<ShopProfileBloc>().add(RemoveShopProfileImageEvent());
        },
      ),
    );
  }

  static void goToStep2(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      context.read<EditShopProfileUiCubit>().updateStep(2);
    }
  }

  static void goToStep3(
    BuildContext context,
    GlobalKey<FormState> formKey,
    EditShopProfileUiState uiState,
  ) {
    if (formKey.currentState!.validate()) {
      if (uiState.selectedDistrict == null) {
        CustomSnackBar.show(
          context,
          message: 'Please select a District',
          isError: true,
        );
        return;
      }
      if (uiState.selectedState == null) {
        CustomSnackBar.show(
          context,
          message: 'Please select a State',
          isError: true,
        );
        return;
      }
      if (uiState.selectedPaymentMethods.isEmpty) {
        CustomSnackBar.show(
          context,
          message: 'Please select at least one Payment Method',
          isError: true,
        );
        return;
      }
      context.read<EditShopProfileUiCubit>().updateStep(3);
    }
  }

  static void saveChanges({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required EditShopProfileUiState uiState,
    required ShopProfileModel profile,
    required String ownerName,
    required String shopName,
    required String description,
    required String fullAddress,
    required String landmark,
    required String city,
    required String pincode,
    required String email,
    required String phone,
    required String gst,
  }) {
    if (!formKey.currentState!.validate()) return;

    if (uiState.businessLicenseUrl == null ||
        uiState.businessLicenseUrl!.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please upload business license document',
        isError: true,
      );
      return;
    }

    if (uiState.ownerIdUrl == null || uiState.ownerIdUrl!.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please upload owner ID document',
        isError: true,
      );
      return;
    }

    final updated = profile.copyWith(
      ownerName: ownerName.trim(),
      shopName: shopName.trim(),
      description: description.trim(),
      fullAddress: fullAddress.trim(),
      landmark: landmark.trim(),
      city: city.trim(),
      pincode: pincode.trim(),
      district: uiState.selectedDistrict ?? '',
      state: uiState.selectedState ?? '',
      paymentMethods: uiState.selectedPaymentMethods,
      email: email.trim(),
      phone: phone.trim(),
      gstNumber: gst.trim(),
      category: uiState.selectedCategory,
      profileImageUrl: uiState.profileImageUrl ?? '',
      businessLicenseUrl: uiState.businessLicenseUrl ?? '',
      ownerIdUrl: uiState.ownerIdUrl ?? '',
      isProfileCompleted: true,
      isApproved: profile.isApproved,
      isRejected: profile.isApproved ? false : profile.isRejected,
      rejectionReason: profile.isApproved ? profile.rejectionReason : '',
      isReRegistered: profile.isApproved
          ? false
          : (profile.isRejected ? true : profile.isReRegistered),
    );

    context.read<ShopProfileBloc>().add(UpdateShopProfileDataEvent(updated));
  }
}
