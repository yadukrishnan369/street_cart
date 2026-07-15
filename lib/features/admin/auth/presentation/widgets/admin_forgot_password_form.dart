import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_state.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_forgot_password_ui_cubit.dart';

class AdminForgotPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final VoidCallback onSendResetLink;

  const AdminForgotPasswordForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.onSendResetLink,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminForgotPasswordUiCubit, AdminForgotPasswordUiState>(
      builder: (context, uiState) {
        return Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E8FF),
                  shape: BoxShape.circle,
                ),
                child: AppLogo(
                  size: 50,
                  backgroundColor: AdminAppColors.primaryColor,
                  logoColor: AdminAppColors.surfaceWhite,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Forgot Password?',
                style: AdminAppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Enter your email address and we'll send you a link to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.5,
                  color: const Color(0xFF6C6C80),
                ),
              ),
              SizedBox(height: 32.h),
              CustomTextField(
                label: 'Email Address',
                controller: emailController,
                hintText: 'admin@hyperlocal.com',
                keyboardType: TextInputType.emailAddress,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: const Color(0xFF4A4A68),
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: const Color(0xFF8A8A9E),
                  size: 20.sp,
                ),
                validator: Validators.validateEmail,
              ),
              SizedBox(height: 24.h),
              BlocBuilder<AdminAuthBloc, AdminAuthState>(
                builder: (context, state) {
                  final isLoading = state is AdminAuthLoading;
                  return PrimaryButton(
                    text: uiState.isResetLinkSent
                        ? 'Reset Link Sent'
                        : 'Send Reset Link',
                    isLoading: isLoading,
                    backgroundColor: uiState.isResetLinkSent
                        ? Colors.grey
                        : AdminAppColors.primaryColor,
                    textStyle: AdminAppTextStyles.buttonText,
                    onPressed: uiState.isResetLinkSent ? null : onSendResetLink,
                  );
                },
              ),
              if (uiState.isResetLinkSent) ...[
                SizedBox(height: 12.h),
                Text(
                  'Link expires in: ${uiState.countdown} seconds',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AdminAppColors.errorColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () => context.pop(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: AdminAppColors.primaryColor,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Back to Login',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AdminAppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
