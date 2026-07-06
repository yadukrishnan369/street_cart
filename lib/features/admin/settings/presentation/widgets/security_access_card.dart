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
  String? _currentPasswordError;
  Timer? _errorTimer;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _errorTimer?.cancel();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF8A8A9E)),
      fillColor: const Color(0xFFF9FAFC),
      filled: true,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE8E7ED)),
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
    return BlocListener<AdminSettingsBloc, AdminSettingsState>(
      listener: (context, state) {
        if (state is AdminSettingsActionSuccess) {
          if (state.message.contains('Password')) {
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
            setState(() {
              _currentPasswordError = null;
            });
          }
        } else if (state is AdminSettingsActionFailure) {
          if (state.message.contains('Incorrect current password')) {
            setState(() {
              _currentPasswordError = 'Incorrect current password.';
            });

            _passwordFormKey.currentState?.validate();

            Future.delayed(const Duration(seconds: 3), () {
              if (!mounted) return;

              setState(() {
                _currentPasswordError = null;
              });

              _passwordFormKey.currentState?.reset();

              _currentPasswordController.clear();
              _newPasswordController.clear();
              _confirmPasswordController.clear();

              FocusScope.of(context).unfocus();
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
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
                      color: const Color(0xFF1E1E2F),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0EFF5)),

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
                              color: const Color(0xFF1E1E2F),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Ensure your account remains secure with a strong password.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF8A8A9E),
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
                            decoration: _buildInputDecoration(
                              'Current Password',
                            ),
                            onChanged: (val) {
                              if (_currentPasswordError != null) {
                                setState(() {
                                  _currentPasswordError = null;
                                });
                              }
                            },
                            validator: Validators.validateAdminPassword,
                          ),
                          if (_currentPasswordError != null)
                            Padding(
                              padding: EdgeInsets.only(top: 8.h, right: 320),
                              child: Text(
                                _currentPasswordError!,
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
                            decoration: _buildInputDecoration('New Password'),
                            validator: Validators.validateAdminPassword,
                          ),
                          SizedBox(height: 16.h),

                          // Confirm New Password
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: _buildInputDecoration(
                              'Confirm New Password',
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
                              OutlinedButton(
                                onPressed: () {
                                  _passwordFormKey.currentState?.reset();
                                  _currentPasswordController.clear();
                                  _newPasswordController.clear();
                                  _confirmPasswordController.clear();
                                  setState(() {
                                    _currentPasswordError = null;
                                  });
                                  _errorTimer?.cancel();
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFE8E7ED),
                                  ),
                                  foregroundColor: const Color(0xFF8A8A9E),
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
                                                context.read<AdminSettingsBloc>().add(
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

                                              _currentPasswordController.text =
                                                  currentText;
                                              _newPasswordController.text =
                                                  newText;
                                              _confirmPasswordController.text =
                                                  confirmText;
                                            },
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AdminAppColors.primaryColor,
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
      ),
    );
  }
}
