import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_event.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_state.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';

// Change Password Form
class ChangePasswordForm extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  const ChangePasswordForm({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final obscureCurrent = state.obscureCurrentPassword;
        final obscureNew = state.obscureNewPassword;
        final obscureConfirm = state.obscureConfirmPassword;

        return Form(
          key: formKey,
          child: Column(
            children: [
              // Current password field
              CustomTextField(
                label: 'Current Password',
                hintText: 'Enter current password',
                controller: currentPasswordController,
                isPassword: obscureCurrent,
                validator: (value) => Validators.validatePassword(value),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureCurrent ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () => context.read<SettingsBloc>().add(
                    ToggleObscureCurrentPassword(),
                  ),
                ),
              ),
              20.verticalSpace,
              // New password field
              CustomTextField(
                label: 'New Password',
                hintText: 'Enter new password',
                controller: newPasswordController,
                isPassword: obscureNew,
                validator: (value) {
                  final result = Validators.validatePassword(value);
                  if (result != null) return result;
                  if (value == currentPasswordController.text) {
                    return 'New password must be different';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureNew ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () => context.read<SettingsBloc>().add(
                    ToggleObscureNewPassword(),
                  ),
                ),
              ),
              20.verticalSpace,
              // Confirmation password field
              CustomTextField(
                label: 'Confirm New Password',
                hintText: 'Re-enter new password',
                controller: confirmPasswordController,
                isPassword: obscureConfirm,
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () => context.read<SettingsBloc>().add(
                    ToggleObscureConfirmPassword(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
