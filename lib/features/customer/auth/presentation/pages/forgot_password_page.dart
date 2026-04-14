import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/constants/app_constants.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/features/customer/auth/presentation/widgets/forgot_password_form.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CustomerAppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding.w,
          ),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthPasswordResetSuccess) {
                CustomSnackBar.show(
                  context,
                  message:
                      "If an account exists, a secure login link was sent to your email!",
                );
                Navigator.pop(context); // Go back to Login
              } else if (state is AuthError) {
                CustomSnackBar.show(context, message: state.message, isError: true);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  40.verticalSpace,
                  const AppLogo(size: 80),
                  16.verticalSpace,
                  Text(
                    "Street Cart",
                    style: CustomerAppTextStyles.heading2.copyWith(
                      fontSize: 20.sp,
                    ),
                  ),
                  40.verticalSpace,
                  Text(
                    "Forgot Password",
                    style: CustomerAppTextStyles.heading1,
                  ),
                  16.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "Enter your registered email address to receive a password reset link",
                      textAlign: TextAlign.center,
                      style: CustomerAppTextStyles.body.copyWith(
                        color: CustomerAppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  40.verticalSpace,

                  ForgotPasswordForm(
                    isLoading: state is AuthLoading,
                    onSendResetLink: (email) {
                      context.read<AuthBloc>().add(
                        PasswordResetRequested(email),
                      );
                    },
                  ),

                  32.verticalSpace,
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: CustomerAppColors.primary,
                      size: 16.h,
                    ),
                    label: Text(
                      "Back to Login",
                      style: CustomerAppTextStyles.buttonText.copyWith(
                        color: CustomerAppColors.primary,
                      ),
                    ),
                  ),
                  40.verticalSpace, // Bottom padding
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
