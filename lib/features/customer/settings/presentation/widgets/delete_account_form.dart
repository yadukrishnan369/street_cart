import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';

// Delete Account Form
class DeleteAccountForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final bool isEmailUser;
  final bool obscurePassword;
  final VoidCallback onObscurePressed;

  const DeleteAccountForm({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.isEmailUser,
    required this.obscurePassword,
    required this.onObscurePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Verify Identity',
            style: CustomerAppTextStyles.heading2.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          // Info
          Text(
            isEmailUser
                ? 'For security, you must enter your current password to confirm account deletion. This process cannot be undone.'
                : 'Your account is linked with Google. You do not need to enter a password to delete your account, but this action is permanent.',
            style: CustomerAppTextStyles.body.copyWith(
              color: CustomerAppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 32.h),
          // Show password TextField if email user
          if (isEmailUser) ...[
            CustomTextField(
              key: const ValueKey('password_field'),
              label: 'Password',
              controller: passwordController,
              hintText: 'Enter your password',
              isPassword: obscurePassword,
              labelStyle: CustomerAppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textStyle: CustomerAppTextStyles.body,
              fillColor: Colors.white,
              borderColor: CustomerAppColors.border,
              focusedBorderColor: Colors.red,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: CustomerAppColors.textSecondary,
                  size: 20.sp,
                ),
                onPressed: onObscurePressed,
              ),
              validator: Validators.validatePasswordVerification,
            ),
            SizedBox(height: 40.h),
          ],
          // Danger Warning
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFFFCDD2), width: 0.8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Confirming deletion will immediately remove your profile details, past order records, and saved addresses from the platform.',
                    style: CustomerAppTextStyles.body.copyWith(
                      color: const Color(0xFFC62828),
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
