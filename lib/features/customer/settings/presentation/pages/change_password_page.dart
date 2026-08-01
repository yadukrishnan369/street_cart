import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/change_password_form.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Change Password Page
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Update Password
  void _onUpdatePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        ChangePasswordRequested(
          oldPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // Page Header
        title: Text(
          'Change Password',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordChangeSuccess) {
            CustomSnackBar.show(
              context,
              message: 'Password updated successfully!',
            );
            Navigator.pop(context);
          } else if (state is AuthError) {
            CustomSnackBar.show(context, message: state.message, isError: true);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security Settings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : CustomerAppColors.textPrimary,
                ),
              ),
              8.verticalSpace,
              Builder(
                builder: (context) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return Text(
                    'Update your password to keep your account secure',
                    style: CustomerAppTextStyles.body.copyWith(
                      color: isDark
                          ? CustomerAppColors.darkTextSecondary
                          : CustomerAppColors.textSecondary,
                    ),
                  );
                },
              ),
              32.verticalSpace,
              // Change Password Form
              ChangePasswordForm(
                currentPasswordController: _currentPasswordController,
                newPasswordController: _newPasswordController,
                confirmPasswordController: _confirmPasswordController,
                formKey: _formKey,
              ),
              40.verticalSpace,
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  // Button For Update Password
                  return PrimaryButton(
                    text: 'Update Password',
                    onPressed: _onUpdatePressed,
                    isLoading: state is AuthLoading,
                  );
                },
              ),
              24.verticalSpace,
              Builder(
                builder: (context) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? CustomerAppColors.primary.withValues(alpha: 0.1)
                          : CustomerAppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: CustomerAppColors.primary.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: CustomerAppColors.primary,
                          size: 20.w,
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Text(
                            'Your password must be at least 6 characters long.',
                            style: CustomerAppTextStyles.subtitle.copyWith(
                              color: isDark
                                  ? CustomerAppColors.darkTextSecondary
                                  : CustomerAppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
