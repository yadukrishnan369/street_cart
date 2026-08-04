import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/constants/app_constants.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/forgot_password_form.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Shop Forgot Password Page
class ShopForgotPasswordPage extends StatelessWidget {
  const ShopForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding.w,
          ),
          child: BlocConsumer<ShopAuthBloc, ShopAuthState>(
            listener: (context, state) {
              if (state.status == ShopAuthStatus.passwordResetSuccess) {
                // Reset Link Info Snackbar
                CustomSnackBar.show(
                  context,
                  message:
                      "If an account exists, a secure login link was sent to your email!",
                );
                Navigator.pop(context); // Go back to Login
              } else if (state.status == ShopAuthStatus.failure &&
                  state.errorMessage != null) {
                CustomSnackBar.show(
                  context,
                  message: state.errorMessage!,
                  isError: true,
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    40.verticalSpace,
                    // App Logo Section
                    const AppLogo(
                      size: 80,
                      backgroundColor: ShopAppColors.primary,
                      logoColor: Colors.white,
                    ),
                    16.verticalSpace,
                    // App name
                    Text(
                      "Street Cart",
                      style: ShopAppTextStyles.heading2.copyWith(
                        fontSize: 20.sp,
                        color: isDark
                            ? ShopAppColors.darkTextPrimary
                            : ShopAppColors.textPrimary,
                      ),
                    ),
                    40.verticalSpace,
                    // Page Title and Contents
                    Text(
                      "Forgot Password",
                      style: ShopAppTextStyles.heading1.copyWith(
                        color: isDark
                            ? ShopAppColors.darkTextPrimary
                            : ShopAppColors.textPrimary,
                      ),
                    ),
                    16.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "Enter your registered business email address to receive a password reset link",
                        textAlign: TextAlign.center,
                        style: ShopAppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? ShopAppColors.darkTextSecondary
                              : ShopAppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    40.verticalSpace,
                    // Forgot Password Form Section
                    ShopForgotPasswordForm(
                      isLoading: state.status == ShopAuthStatus.loading,
                      onSendResetLink: (email) {
                        context.read<ShopAuthBloc>().add(
                          ShopPasswordResetRequested(email),
                        );
                      },
                    ),

                    32.verticalSpace,
                    // Back to Login Page
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: ShopAppColors.primary,
                        size: 16.h,
                      ),
                      label: Text(
                        "Back to Login",
                        style: ShopAppTextStyles.buttonText.copyWith(
                          color: ShopAppColors.primary,
                        ),
                      ),
                    ),
                    40.verticalSpace, // Bottom padding
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
