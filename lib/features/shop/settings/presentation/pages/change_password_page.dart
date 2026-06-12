import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_event.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_state.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ShopSettingsBloc>().add(
          ChangePasswordRequested(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopSettingsBloc, ShopSettingsState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          CustomSnackBar.show(context, message: 'Password updated successfully!');
          Navigator.pop(context);
        } else if (state is ShopSettingsFailure) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is ShopSettingsLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ShopAppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Change Password',
              style: ShopAppTextStyles.heading4.copyWith(
                color: ShopAppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Secure Your Account',
                    style: ShopAppTextStyles.heading2.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Enter your current password and choose a new strong password to update your shop owner credentials.',
                    style: ShopAppTextStyles.bodyMedium.copyWith(
                      color: ShopAppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Current Password Field
                  CustomTextField(
                    label: 'Current Password',
                    controller: _currentPasswordController,
                    hintText: 'Enter current password',
                    isPassword: _obscureCurrent,
                    labelStyle: ShopAppTextStyles.bodyMediumBold,
                    textStyle: ShopAppTextStyles.bodyMedium,
                    fillColor: const Color(0xFFF8F9FA),
                    borderColor: ShopAppColors.border,
                    focusedBorderColor: ShopAppColors.primary,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: ShopAppColors.textTertiary,
                        size: 20.sp,
                      ),
                      onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Current password is required';
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  // New Password Field
                  CustomTextField(
                    label: 'New Password',
                    controller: _newPasswordController,
                    hintText: 'Enter new password',
                    isPassword: _obscureNew,
                    labelStyle: ShopAppTextStyles.bodyMediumBold,
                    textStyle: ShopAppTextStyles.bodyMedium,
                    fillColor: const Color(0xFFF8F9FA),
                    borderColor: ShopAppColors.border,
                    focusedBorderColor: ShopAppColors.primary,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: ShopAppColors.textTertiary,
                        size: 20.sp,
                      ),
                      onPressed: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'New password is required';
                      if (val.length < 8) return 'Password must be at least 8 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  // Confirm New Password Field
                  CustomTextField(
                    label: 'Confirm New Password',
                    controller: _confirmPasswordController,
                    hintText: 'Re-enter new password',
                    isPassword: _obscureConfirm,
                    labelStyle: ShopAppTextStyles.bodyMediumBold,
                    textStyle: ShopAppTextStyles.bodyMedium,
                    fillColor: const Color(0xFFF8F9FA),
                    borderColor: ShopAppColors.border,
                    focusedBorderColor: ShopAppColors.primary,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: ShopAppColors.textTertiary,
                        size: 20.sp,
                      ),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Confirm password is required';
                      if (val != _newPasswordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),

                  // Info Row
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: ShopAppColors.textSecondary,
                        size: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Password must be at least 8 characters long',
                        style: ShopAppTextStyles.bodySmall.copyWith(
                          color: ShopAppColors.textSecondary,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // Action Button
                  PrimaryButton(
                    text: 'Update Password',
                    backgroundColor: ShopAppColors.primary,
                    textStyle: ShopAppTextStyles.buttonText,
                    isLoading: isLoading,
                    suffixIcon: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    onPressed: _updatePassword,
                  ),
                  SizedBox(height: 24.h),

                  // Security Tip Card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: ShopAppColors.primary,
                          size: 22.sp,
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Security Tip',
                                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                                  color: ShopAppColors.primary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Mix uppercase letters, numbers, and symbols to create a strong password. Avoid using common words or birthdates.',
                                style: ShopAppTextStyles.bodySmall.copyWith(
                                  color: ShopAppColors.textSecondary,
                                  height: 1.4,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
