import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_state.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/edit_shop_profile_ui_cubit.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_step1_info.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_step2_address.dart';
import 'package:street_cart/features/shop/profile/presentation/widgets/edit_step3_verification.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_categories_cubit.dart';
import 'package:street_cart/features/shop/profile/presentation/utils/edit_shop_profile_helper.dart';
import 'package:street_cart/core/constants/profile_constants.dart';

class EditShopProfileFormSteps extends StatelessWidget {
  final ShopProfileModel profile;
  final EditShopProfileUiState uiState;
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
      return BlocBuilder<ShopCategoriesCubit, ShopCategoriesState>(
        builder: (context, state) {
          List<String> categories = [];
          if (state is ShopCategoriesLoaded) {
            categories = state.categories;
          }

          if (categories.isNotEmpty &&
              (uiState.selectedCategory == null ||
                  uiState.selectedCategory!.isEmpty ||
                  !categories.contains(uiState.selectedCategory))) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<EditShopProfileUiCubit>().updateCategory(
                categories.first,
              );
            });
          }

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
                context.read<EditShopProfileUiCubit>().updateCategory(val);
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

          if (state is ShopPaymentSettingsLoaded) {
            enableCod = state.settings['enable_cod'] ?? true;
            enableOnline = state.settings['enable_online'] ?? true;
          }

          return EditStep2Address(
            formKey: formKeyStep2,
            fullAddressController: fullAddressController,
            landmarkController: landmarkController,
            cityController: cityController,
            pincodeController: pincodeController,
            selectedDistrict: uiState.selectedDistrict,
            districts: ProfileConstants.districts,
            onDistrictChanged: (val) =>
                context.read<EditShopProfileUiCubit>().updateDistrict(val),
            selectedState: uiState.selectedState,
            states: ProfileConstants.states,
            onStateChanged: (val) =>
                context.read<EditShopProfileUiCubit>().updateState(val),
            selectedPaymentMethods: uiState.selectedPaymentMethods,
            enableCod: enableCod,
            enableOnline: enableOnline,
            onPaymentMethodChanged: (method, isSelected) => context
                .read<EditShopProfileUiCubit>()
                .togglePaymentMethod(method, isSelected),
          );
        },
      );
    } else {
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
        onClearLicense: () =>
            context.read<EditShopProfileUiCubit>().updateBusinessLicenseUrl(''),
        onClearOwnerId: () =>
            context.read<EditShopProfileUiCubit>().updateOwnerIdUrl(''),
      );
    }
  }
}
