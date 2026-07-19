import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'document_picker_widget.dart';

// Edit Step3 Verification
class EditStep3Verification extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController gstController;

  final String? businessLicenseUrl;
  final String? ownerIdUrl;

  final bool isUploadingLicense;
  final bool isUploadingOwnerId;

  final VoidCallback onPickLicense;
  final VoidCallback onPickOwnerId;
  final VoidCallback onClearLicense;
  final VoidCallback onClearOwnerId;

  const EditStep3Verification({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.phoneController,
    required this.gstController,
    required this.businessLicenseUrl,
    required this.ownerIdUrl,
    required this.isUploadingLicense,
    required this.isUploadingOwnerId,
    required this.onPickLicense,
    required this.onPickOwnerId,
    required this.onClearLicense,
    required this.onClearOwnerId,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4.w, height: 18.h, color: ShopAppColors.primary),
              SizedBox(width: 8.w),
              // Title
              Text(
                'CONTACT INFO',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Business Email Field
          CustomTextField(
            label: "Business Email",
            controller: emailController,
            hintText: 'Enter business email',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: ShopAppColors.primary,
            ),
            labelStyle: ShopAppTextStyles.bodyMediumBold,
            textStyle: ShopAppTextStyles.bodyMedium,
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.textTertiary,
            ),
            fillColor: ShopAppColors.surface,
            borderColor: ShopAppColors.border,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 20.h),
          // Business Phone Number Field
          CustomTextField(
            label: "Business Phone Number",
            controller: phoneController,
            hintText: 'Enter phone number',
            keyboardType: TextInputType.phone,
            validator: Validators.validatePhone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: ShopAppColors.primary,
            ),
            labelStyle: ShopAppTextStyles.bodyMediumBold,
            textStyle: ShopAppTextStyles.bodyMedium,
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.textTertiary,
            ),
            fillColor: ShopAppColors.surface,
            borderColor: ShopAppColors.border,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 32.h),
          Row(
            children: [
              Container(width: 4.w, height: 18.h, color: ShopAppColors.primary),
              SizedBox(width: 8.w),
              // Title
              Text(
                'VERIFICATION DETAILS',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // GST Number Field
          CustomTextField(
            label: "GST Number",
            controller: gstController,
            hintText: 'Enter GST details',
            validator: Validators.validateGST,
            prefixIcon: const Icon(
              Icons.description_outlined,
              color: ShopAppColors.primary,
            ),
            labelStyle: ShopAppTextStyles.bodyMediumBold,
            textStyle: ShopAppTextStyles.bodyMedium,
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.textTertiary,
            ),
            fillColor: ShopAppColors.surface,
            borderColor: ShopAppColors.border,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 24.h),
          // Business Licence Image Picker
          DocumentPickerWidget(
            title: "Business License",
            subtitle: "PDF, JPG or PNG (Max 5MB)",
            icon: Icons.description_outlined,
            isPicked:
                businessLicenseUrl != null && businessLicenseUrl!.isNotEmpty,
            existingUrl: businessLicenseUrl,
            onTap: isUploadingLicense ? () {} : onPickLicense,
            onClear: onClearLicense,
          ),
          SizedBox(height: 24.h),
          // Owner ID Proof Image Picker
          DocumentPickerWidget(
            title: "Owner ID Proof",
            subtitle: "Passport, Driving License, or National ID",
            icon: Icons.badge_outlined,
            isPicked: ownerIdUrl != null && ownerIdUrl!.isNotEmpty,
            existingUrl: ownerIdUrl,
            onTap: isUploadingOwnerId ? () {} : onPickOwnerId,
            onClear: onClearOwnerId,
          ),
        ],
      ),
    );
  }
}
