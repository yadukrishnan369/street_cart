import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';

class ChangePasswordForm extends StatefulWidget {
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
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Current Password',
            hintText: 'Enter current password',
            controller: widget.currentPasswordController,
            isPassword: _obscureCurrent,
            validator: (value) => Validators.validatePassword(value),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
            ),
          ),
          20.verticalSpace,
          CustomTextField(
            label: 'New Password',
            hintText: 'Enter new password',
            controller: widget.newPasswordController,
            isPassword: _obscureNew,
            validator: (value) {
              final result = Validators.validatePassword(value);
              if (result != null) return result;
              if (value == widget.currentPasswordController.text) {
                return 'New password must be different';
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                _obscureNew ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _obscureNew = !_obscureNew),
            ),
          ),
          20.verticalSpace,
          CustomTextField(
            label: 'Confirm New Password',
            hintText: 'Re-enter new password',
            controller: widget.confirmPasswordController,
            isPassword: _obscureConfirm,
            validator: (value) {
              if (value != widget.newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
        ],
      ),
    );
  }
}
