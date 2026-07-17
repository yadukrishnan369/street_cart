import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Edit Profile Form
class EditProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final VoidCallback onSave;
  final bool isLoading;
  final bool isImageUploading;

  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.onSave,
    required this.isLoading,
    this.isImageUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Field
          CustomTextField(
            label: 'Full Name',
            hintText: 'Enter your full name',
            controller: nameController,
            validator: Validators.validateName,
            fillColor: CustomerAppColors.surface,
            focusedBorderColor: CustomerAppColors.primary,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: CustomerAppColors.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          // Email Field
          CustomTextField(
            label: 'Email Address',
            hintText: 'Enter your email address',
            controller: emailController,
            validator: Validators.validateEmail,
            fillColor: CustomerAppColors.surface,
            focusedBorderColor: CustomerAppColors.primary,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: CustomerAppColors.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          // Phone Field
          CustomTextField(
            label: 'Phone Number',
            hintText: 'Enter your phone number',
            controller: phoneController,
            validator: Validators.validatePhone,
            fillColor: CustomerAppColors.surface,
            focusedBorderColor: CustomerAppColors.primary,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: CustomerAppColors.textSecondary,
            ),
          ),
          SizedBox(height: 40.h),
          // Save Button
          PrimaryButton(
            text: 'Save Changes',
            onPressed: onSave,
            isLoading: isLoading || isImageUploading,
            suffixIcon: Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20.sp,
            ),
            borderRadius: 12,
          ),
        ],
      ),
    );
  }
}
