import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_event.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_state.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

// Security Access Card
class SecurityAccessCard extends StatefulWidget {
  final bool isInProgress;

  const SecurityAccessCard({super.key, required this.isInProgress});

  @override
  State<SecurityAccessCard> createState() => _SecurityAccessCardState();
}

class _SecurityAccessCardState extends State<SecurityAccessCard> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFormKey = GlobalKey<FormState>();
  Timer? _errorTimer;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _errorTimer?.cancel();
    super.dispose();
  }

  void _clearPasswordError() {
    context.read<AdminSettingsBloc>().add(const SetCurrentPasswordError(null));
  }

  void _resetForm() {
    _passwordFormKey.currentState?.reset();
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    _clearPasswordError();
    _errorTimer?.cancel();
  }

  InputDecoration _buildInputDecoration(String hintText, bool isDark) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 13.sp,
        color: isDark
            ? AdminAppColors.darkTextSecondary
            : const Color(0xFF8A8A9E),
      ),
      fillColor: isDark
          ? AdminAppColors.darkInputBackground
          : const Color(0xFFF9FAFC),
      filled: true,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isDark
              ? AdminAppColors.borderLight
              : AdminAppColors.darkBorder,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AdminAppColors.primaryColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AdminAppColors.errorColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AdminAppColors.errorColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<AdminSettingsBloc, AdminSettingsState>(
      buildWhen: (prev, curr) =>
          prev.currentPasswordError != curr.currentPasswordError ||
          curr is AdminSettingsActionSuccess ||
          curr is AdminSettingsActionFailure,
      listenWhen: (prev, curr) =>
          curr is AdminSettingsActionSuccess ||
          curr is AdminSettingsActionFailure,
      listener: (context, state) {
        final bloc = context.read<AdminSettingsBloc>();

        if (state is AdminSettingsActionSuccess) {
          if (state.message.contains('Password')) {
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
            bloc.add(const SetCurrentPasswordError(null));
          }
        } else if (state is AdminSettingsActionFailure) {
          if (state.message.contains('Incorrect current password')) {
            bloc.add(
              const SetCurrentPasswordError('Incorrect current password.'),
            );
            _passwordFormKey.currentState?.validate();

            _errorTimer?.cancel();
            _errorTimer = Timer(const Duration(seconds: 3), () {
              if (!mounted) return;
              bloc.add(const SetCurrentPasswordError(null));
              _passwordFormKey.currentState?.reset();
              _currentPasswordController.clear();
              _newPasswordController.clear();
              _confirmPasswordController.clear();
              FocusScope.of(context).unfocus();
            });
          }
        }
      },
      builder: (context, state) {
        final bloc = context.read<AdminSettingsBloc>();

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AdminAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? AdminAppColors.darkBorder
                  : const Color(0xFFE8E7ED),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.security_outlined,
                      color: AdminAppColors.primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Security & Access Settings',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AdminAppColors.darkTextPrimary
                            : AdminAppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? AdminAppColors.darkBorder
                    : const Color(0xFFF0EFF5),
              ),

              // Form body
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: _passwordFormKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AdminAppColors.darkTextPrimary
                                    : AdminAppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Ensure your account remains secure with a strong password.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark
                                    ? AdminAppColors.darkTextSecondary
                                    : const Color(0xFF8A8A9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Current Password
                            TextFormField(
                              controller: _currentPasswordController,
                              obscureText: true,
                              style: TextStyle(
                                color: isDark
                                    ? AdminAppColors.darkTextPrimary
                                    : AdminAppColors.textPrimary,
                                fontSize: 14.sp,
                              ),
                              decoration: _buildInputDecoration(
                                'Current Password',
                                isDark,
                              ),
                              onChanged: (_) {
                                if (state.currentPasswordError != null) {
                                  bloc.add(const SetCurrentPasswordError(null));
                                }
                              },
                              validator: Validators.validateAdminPassword,
                            ),
                            if (state.currentPasswordError != null)
                              Padding(
                                padding: EdgeInsets.only(top: 8.h, right: 320),
                                child: Text(
                                  state.currentPasswordError!,
                                  style: TextStyle(
                                    color: AdminAppColors.errorColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            SizedBox(height: 16.h),

                            // New Password
                            TextFormField(
                              controller: _newPasswordController,
                              obscureText: true,
                              style: TextStyle(
                                color: isDark
                                    ? AdminAppColors.darkTextPrimary
                                    : AdminAppColors.textPrimary,
                                fontSize: 14.sp,
                              ),
                              decoration: _buildInputDecoration(
                                'New Password',
                                isDark,
                              ),
                              validator: Validators.validateAdminPassword,
                            ),
                            SizedBox(height: 16.h),

                            // Confirm New Password
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              style: TextStyle(
                                color: isDark
                                    ? AdminAppColors.darkTextPrimary
                                    : AdminAppColors.textPrimary,
                                fontSize: 14.sp,
                              ),
                              decoration: _buildInputDecoration(
                                'Confirm New Password',
                                isDark,
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please confirm new password';
                                }
                                if (val != _newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Reset button
                                OutlinedButton(
                                  onPressed: _resetForm,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: isDark
                                          ? AdminAppColors.darkBorder
                                          : const Color(0xFFE8E7ED),
                                    ),
                                    foregroundColor: isDark
                                        ? AdminAppColors.darkTextSecondary
                                        : const Color(0xFF8A8A9E),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 12.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // Update Password button
                                ElevatedButton(
                                  onPressed: widget.isInProgress
                                      ? null
                                      : () {
                                          if (_passwordFormKey.currentState
                                                  ?.validate() ==
                                              true) {
                                            showDialog(
                                              context: context,
                                              builder: (dialogCtx) => CustomAlertDialog(
                                                title: 'Change Password',
                                                content:
                                                    'Are you sure you want to update your administrator password?',
                                                secondaryActionLabel: 'Cancel',
                                                primaryActionLabel: 'Confirm',
                                                icon: Icons.lock_outline,
                                                iconColor:
                                                    AdminAppColors.primaryColor,
                                                primaryActionColor:
                                                    AdminAppColors.primaryColor,
                                                onPrimaryAction: () {
                                                  Navigator.pop(dialogCtx);
                                                  bloc.add(
                                                    UpdateAdminPassword(
                                                      currentPassword:
                                                          _currentPasswordController
                                                              .text,
                                                      newPassword:
                                                          _newPasswordController
                                                              .text,
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            // clear form validation errors
                                            _errorTimer?.cancel();
                                            _errorTimer = Timer(
                                              const Duration(seconds: 3),
                                              () {
                                                if (!mounted) return;
                                                final currentText =
                                                    _currentPasswordController
                                                        .text;
                                                final newText =
                                                    _newPasswordController.text;
                                                final confirmText =
                                                    _confirmPasswordController
                                                        .text;
                                                _passwordFormKey.currentState
                                                    ?.reset();
                                                _currentPasswordController
                                                        .text =
                                                    currentText;
                                                _newPasswordController.text =
                                                    newText;
                                                _confirmPasswordController
                                                        .text =
                                                    confirmText;
                                              },
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AdminAppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 12.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text('Update Password'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
