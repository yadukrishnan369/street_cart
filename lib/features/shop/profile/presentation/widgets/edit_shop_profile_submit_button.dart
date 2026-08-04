import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_state.dart';
import 'package:street_cart/features/shop/profile/presentation/utils/edit_shop_profile_helper.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Edit Shop Profile Submit Button
class EditShopProfileSubmitButton extends StatelessWidget {
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
    final isSaving = uiState.status == ShopProfileStatus.loading;
    final isUploadingAny =
        uiState.isUploadingImage ||
        uiState.isUploadingLicense ||
        uiState.isUploadingOwnerId;
    final isBusy = isUploadingAny || isSaving;

    // Button for Uploading / Save Changes / Next Step
    return PrimaryButton(
      text: isUploadingAny
          ? 'Uploading...'
          : (isSaving
                ? 'Saving...'
                : (uiState.currentStep == 3 ? 'Save Changes' : 'Next')),
      backgroundColor: isBusy ? Colors.grey : ShopAppColors.primary,
      textStyle: ShopAppTextStyles.buttonText,
      suffixIcon: isBusy
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
      prefixIcon: isBusy
          ? null
          : (uiState.currentStep == 3
                ? const Icon(Icons.check_circle_outline, color: Colors.white)
                : null),
      onPressed: isBusy
          ? null
          : () {
              if (uiState.currentStep == 1) {
                // Move to Step 2
                EditShopProfileHelper.goToStep2(context, formKeyStep1);
              } else if (uiState.currentStep == 2) {
                // Move to Step 3
                EditShopProfileHelper.goToStep3(context, formKeyStep2, uiState);
              } else {
                // Save Changes
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
