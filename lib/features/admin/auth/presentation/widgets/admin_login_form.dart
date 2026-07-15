import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_state.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_login_ui_cubit.dart';

class AdminLoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  const AdminLoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminLoginUiCubit, AdminLoginUiState>(
      builder: (context, uiState) {
        return Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AdminAppColors.primaryLight.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AdminAppColors.primaryColor,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Admin Portal',
                style: AdminAppTextStyles.heading2.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Enter your credentials to manage your Street Cart marketplace',
                textAlign: TextAlign.center,
                style: AdminAppTextStyles.bodyMedium.copyWith(
                  fontSize: 13.sp,
                  color: AdminAppColors.textSecondary,
                ),
              ),
              SizedBox(height: 32.h),
              CustomTextField(
                label: 'Email Address',
                controller: emailController,
                hintText: 'admin@hyperlocal.com',
                keyboardType: TextInputType.emailAddress,
                labelStyle: AdminAppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AdminAppColors.textPrimary,
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AdminAppColors.textSecondary,
                  size: 20.sp,
                ),
                validator: Validators.validateEmail,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                label: 'Password',
                controller: passwordController,
                hintText: '••••••••',
                isPassword: uiState.obscurePassword,
                labelStyle: AdminAppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AdminAppColors.textPrimary,
                ),
                labelTrailing: InkWell(
                  onTap: () {
                    context.push(RoutePaths.forgotPassword);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: AdminAppTextStyles.bodySmall.copyWith(
                        color: AdminAppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AdminAppColors.textSecondary,
                  size: 20.sp,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    uiState.obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AdminAppColors.textSecondary,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    context.read<AdminLoginUiCubit>().toggleObscurePassword();
                  },
                ),
                validator: Validators.validateAdminPassword,
              ),
              SizedBox(height: 32.h),
              BlocBuilder<AdminAuthBloc, AdminAuthState>(
                builder: (context, state) {
                  final isLoading = state is AdminAuthLoading;
                  return PrimaryButton(
                    text: 'Login to Dashboard',
                    isLoading: isLoading,
                    backgroundColor: AdminAppColors.primaryColor,
                    textStyle: AdminAppTextStyles.buttonText,
                    onPressed: onLogin,
                  );
                },
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.security_outlined,
                    size: 14.sp,
                    color: AdminAppColors.textSecondary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'SECURE ADMIN ACCESS ONLY',
                    style: AdminAppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AdminAppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
