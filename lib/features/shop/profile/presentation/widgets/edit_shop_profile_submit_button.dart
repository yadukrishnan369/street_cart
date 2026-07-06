import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/edit_shop_profile_ui_cubit.dart';
import 'package:street_cart/features/shop/profile/presentation/utils/edit_shop_profile_helper.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

class EditShopProfileSubmitButton extends StatelessWidget {
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

  const EditShopProfileSubmitButton({
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
    final isUploadingAny =
        uiState.isUploadingImage ||
        uiState.isUploadingLicense ||
        uiState.isUploadingOwnerId;

    return PrimaryButton(
      text: isUploadingAny
          ? 'Uploading...'
          : (uiState.currentStep == 3 ? 'Save Changes' : 'Next'),
      backgroundColor: isUploadingAny ? Colors.grey : ShopAppColors.primary,
      textStyle: ShopAppTextStyles.buttonText,
      suffixIcon: isUploadingAny
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : (uiState.currentStep == 3
                ? null
                : const Icon(Icons.arrow_forward, color: Colors.white)),
      prefixIcon: isUploadingAny
          ? null
          : (uiState.currentStep == 3
                ? const Icon(Icons.check_circle_outline, color: Colors.white)
                : null),
      onPressed: isUploadingAny
          ? null
          : () {
              if (uiState.currentStep == 1) {
                EditShopProfileHelper.goToStep2(context, formKeyStep1);
              } else if (uiState.currentStep == 2) {
                EditShopProfileHelper.goToStep3(context, formKeyStep2, uiState);
              } else {
                EditShopProfileHelper.saveChanges(
                  context: context,
                  formKey: formKeyStep3,
                  uiState: uiState,
                  profile: profile,
                  ownerName: ownerNameController.text,
                  shopName: shopNameController.text,
                  description: descriptionController.text,
                  fullAddress: fullAddressController.text,
                  landmark: landmarkController.text,
                  city: cityController.text,
                  pincode: pincodeController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  gst: gstController.text,
                );
              }
            },
    );
  }
}
