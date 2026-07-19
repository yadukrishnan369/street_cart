import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/utils/change_password_validators.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Change Password Form
class ChangePasswordForm extends StatefulWidget {
  final bool isLoading;

  const ChangePasswordForm({super.key, required this.isLoading});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
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
    return Form(
      key: _formKey,
      child: BlocBuilder<ShopSettingsBloc, ShopSettingsState>(
        builder: (context, uiState) {
          final bloc = context.read<ShopSettingsBloc>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Password Field
              CustomTextField(
                label: 'Current Password',
                controller: _currentPasswordController,
                hintText: 'Enter current password',
                isPassword: uiState.obscureCurrent,
                labelStyle: ShopAppTextStyles.bodyMediumBold,
                textStyle: ShopAppTextStyles.bodyMedium,
                fillColor: const Color(0xFFF8F9FA),
                borderColor: ShopAppColors.border,
                focusedBorderColor: ShopAppColors.primary,
                suffixIcon: IconButton(
                  icon: Icon(
                    uiState.obscureCurrent
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: ShopAppColors.textTertiary,
                    size: 20.sp,
                  ),
                  onPressed: () => bloc.add(ToggleObscureCurrentEvent()),
                ),
                validator: ChangePasswordValidators.validateCurrentPassword,
              ),
              SizedBox(height: 20.h),

              // New Password Field
              CustomTextField(
                label: 'New Password',
                controller: _newPasswordController,
                hintText: 'Enter new password',
                isPassword: uiState.obscureNew,
                labelStyle: ShopAppTextStyles.bodyMediumBold,
                textStyle: ShopAppTextStyles.bodyMedium,
                fillColor: const Color(0xFFF8F9FA),
                borderColor: ShopAppColors.border,
                focusedBorderColor: ShopAppColors.primary,
                suffixIcon: IconButton(
                  icon: Icon(
                    uiState.obscureNew
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: ShopAppColors.textTertiary,
                    size: 20.sp,
                  ),
                  onPressed: () => bloc.add(ToggleObscureNewEvent()),
                ),
                validator: ChangePasswordValidators.validateNewPassword,
              ),
              SizedBox(height: 20.h),

              // Confirm New Password Field
              CustomTextField(
                label: 'Confirm New Password',
                controller: _confirmPasswordController,
                hintText: 'Re-enter new password',
                isPassword: uiState.obscureConfirm,
                labelStyle: ShopAppTextStyles.bodyMediumBold,
                textStyle: ShopAppTextStyles.bodyMedium,
                fillColor: const Color(0xFFF8F9FA),
                borderColor: ShopAppColors.border,
                focusedBorderColor: ShopAppColors.primary,
                suffixIcon: IconButton(
                  icon: Icon(
                    uiState.obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: ShopAppColors.textTertiary,
                    size: 20.sp,
                  ),
                  onPressed: () => bloc.add(ToggleObscureConfirmEvent()),
                ),
                validator: (val) =>
                    ChangePasswordValidators.validateConfirmPassword(
                      val,
                      _newPasswordController.text,
                    ),
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

              // Update Password Action Button
              PrimaryButton(
                text: 'Update Password',
                backgroundColor: ShopAppColors.primary,
                textStyle: ShopAppTextStyles.buttonText,
                isLoading: widget.isLoading,
                suffixIcon: Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: _submit,
              ),
            ],
          );
        },
      ),
    );
  }
}
