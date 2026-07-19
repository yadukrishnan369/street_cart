import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/forgot_password_page.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/signup_page.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Shop Login Form
class ShopLoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const ShopLoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Form(
        key: formKey,
        child: BlocBuilder<ShopAuthBloc, ShopAuthState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Welcome Contents
              children: [
                Text('Welcome back', style: ShopAppTextStyles.heading1),
                SizedBox(height: 8.h),
                Text(
                  'Log in to manage your shop and reach millions of customers across our network.',
                  style: ShopAppTextStyles.bodyMedium,
                ),
                SizedBox(height: 24.h),
                // Email Field
                CustomTextField(
                  label: "Business Email",
                  controller: emailController,
                  hintText: 'e.g. name@business.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  labelStyle: ShopAppTextStyles.bodyMediumBold,
                  textStyle: ShopAppTextStyles.bodyMedium,
                  hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
                    color: ShopAppColors.textTertiary,
                  ),
                  fillColor: ShopAppColors.surface,
                  borderColor: ShopAppColors.border,
                  focusedBorderColor: ShopAppColors.primary,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: ShopAppColors.textSecondary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                // Password Field
                CustomTextField(
                  label: "Password",
                  controller: passwordController,
                  hintText: 'Enter your password',
                  isPassword: !state.isPasswordVisible,
                  validator: Validators.validateShopPassword,
                  labelStyle: ShopAppTextStyles.bodyMediumBold,
                  textStyle: ShopAppTextStyles.bodyMedium,
                  hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
                    color: ShopAppColors.textTertiary,
                  ),
                  fillColor: ShopAppColors.surface,
                  borderColor: ShopAppColors.border,
                  focusedBorderColor: ShopAppColors.primary,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: ShopAppColors.textSecondary,
                    size: 20.sp,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: ShopAppColors.textSecondary,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      context.read<ShopAuthBloc>().add(
                        ShopTogglePasswordVisibility(),
                      );
                    },
                  ),
                  labelTrailing: InkWell(
                    onTap: () {
                      // Navigate to forgot Password Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopForgotPasswordPage(),
                        ),
                      );
                    },
                    // Forgot password option
                    child: Text(
                      "Forgot password?",
                      style: ShopAppTextStyles.bodySmallBold.copyWith(
                        color: ShopAppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 48.h),
                // Button for Login
                PrimaryButton(
                  text: 'Login',
                  isLoading: state.status == ShopAuthStatus.loading,
                  backgroundColor: ShopAppColors.primary,
                  textStyle: ShopAppTextStyles.buttonText,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<ShopAuthBloc>().add(
                        ShopLoginStarted(
                          email: emailController.text.trim(),
                          password: passwordController.text,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New seller? ', style: ShopAppTextStyles.bodyMedium),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Signup Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShopSignupPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Create Shop Account',
                        style: ShopAppTextStyles.bodyMediumBold.copyWith(
                          color: ShopAppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_person_outlined,
                        size: 14.sp,
                        color: ShopAppColors.textTertiary,
                      ),
                      SizedBox(width: 8.w),
                      // Bottom Content
                      Text(
                        'SECURE MERCHANT AUTHENTICATION',
                        style: ShopAppTextStyles.caption.copyWith(
                          color: ShopAppColors.textTertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            );
          },
        ),
      ),
    );
  }
}
