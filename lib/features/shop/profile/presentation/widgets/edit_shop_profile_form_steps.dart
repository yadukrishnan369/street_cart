import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_state.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_step1_info.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_step2_address.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_step3_verification.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/utils/edit_shop_profile_helper.dart';
import 'package:street_cart/core/constants/profile_constants.dart';

// Edit Shop Profile Form Steps
class EditShopProfileFormSteps extends StatelessWidget {
  final ShopProfileModel profile;
  final ShopProfileState uiState;
  final GlobalKey<FormState> formKeyStep1;
  final GlobalKey<FormState> formKeyStep2;
  final GlobalKey<FormState> formKeyStep3;
  final TextEditingController ownerNameController;
  final TextEditingController shopNameController;
  final TextEditingController descriptionController;
  final TextEditingController fullAddressController;
  final TextEditingController landmarkController;
  final TextEditingController cityController;
  final TextEditingController pincodeController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController gstController;

  const EditShopProfileFormSteps({
    super.key,
    required this.profile,
    required this.uiState,
    required this.formKeyStep1,
    required this.formKeyStep2,
    required this.formKeyStep3,
    required this.ownerNameController,
    required this.shopNameController,
    required this.descriptionController,
    required this.fullAddressController,
    required this.landmarkController,
    required this.cityController,
    required this.pincodeController,
    required this.emailController,
    required this.phoneController,
    required this.gstController,
  });

  @override
  Widget build(BuildContext context) {
    if (uiState.currentStep == 1) {
      return BlocBuilder<ShopAuthBloc, ShopAuthState>(
        builder: (context, state) {
          final categories = state.categories;

          if (categories.isNotEmpty &&
              (uiState.selectedCategory == null ||
                  uiState.selectedCategory!.isEmpty ||
                  !categories.contains(uiState.selectedCategory))) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ShopProfileBloc>().add(
                UpdateCategoryEvent(categories.first),
              );
            });
          }
          // Edit Step 1 Section
          return EditStep1Info(
            formKey: formKeyStep1,
            ownerNameController: ownerNameController,
            shopNameController: shopNameController,
            descriptionController: descriptionController,
            profileImageUrl: uiState.profileImageUrl,
            onPickImage: () => EditShopProfileHelper.pickProfileImage(context),
            onRemoveImage: () =>
                EditShopProfileHelper.onRemoveProfileImage(context),
            isUploadingImage: uiState.isUploadingImage,
            selectedCategory: uiState.selectedCategory,
            categories: categories.isNotEmpty
                ? categories
                : (profile.category.isNotEmpty ? [profile.category] : []),
            onCategoryChanged: (val) {
              if (val != null) {
                context.read<ShopProfileBloc>().add(UpdateCategoryEvent(val));
              }
            },
          );
        },
      );
    } else if (uiState.currentStep == 2) {
      return BlocBuilder<ShopProfileBloc, ShopProfileState>(
        builder: (context, state) {
          bool enableCod = true;
          bool enableOnline = true;

          if (state.status == ShopProfileStatus.paymentSettingsLoaded) {
            enableCod = state.paymentSettings?['enable_cod'] ?? true;
            enableOnline = state.paymentSettings?['enable_online'] ?? true;
          }
          // Edit Step 2 Section
          return EditStep2Address(
            formKey: formKeyStep2,
            fullAddressController: fullAddressController,
            landmarkController: landmarkController,
            cityController: cityController,
            pincodeController: pincodeController,
            selectedDistrict: uiState.selectedDistrict,
            districts: ProfileConstants.districts,
            onDistrictChanged: (val) =>
                context.read<ShopProfileBloc>().add(UpdateDistrictEvent(val)),
            selectedState: uiState.selectedState,
            states: ProfileConstants.states,
            onStateChanged: (val) =>
                context.read<ShopProfileBloc>().add(UpdateStateEvent(val)),
            selectedPaymentMethods: uiState.selectedPaymentMethods,
            enableCod: enableCod,
            enableOnline: enableOnline,
            onPaymentMethodChanged: (method, isSelected) => context
                .read<ShopProfileBloc>()
                .add(TogglePaymentMethodEvent(method, isSelected)),
          );
        },
      );
    } else {
      // Edit Step 3 Section
      return EditStep3Verification(
        formKey: formKeyStep3,
        emailController: emailController,
        phoneController: phoneController,
        gstController: gstController,
        businessLicenseUrl: uiState.businessLicenseUrl,
        ownerIdUrl: uiState.ownerIdUrl,
        isUploadingLicense: uiState.isUploadingLicense,
        isUploadingOwnerId: uiState.isUploadingOwnerId,
        onPickLicense: () => EditShopProfileHelper.pickLicense(context),
        onPickOwnerId: () => EditShopProfileHelper.pickOwnerId(context),
        onClearLicense: () => context.read<ShopProfileBloc>().add(
          const UpdateBusinessLicenseUrlEvent(''),
        ),
        onClearOwnerId: () => context.read<ShopProfileBloc>().add(
          const UpdateOwnerIdUrlEvent(''),
        ),
      );
    }
  }
}
