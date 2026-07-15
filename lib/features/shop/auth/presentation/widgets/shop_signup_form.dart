import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_signup_ui_cubit.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

class ShopSignupForm extends StatelessWidget {
  final TextEditingController ownerNameController;
  final TextEditingController shopNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  const ShopSignupForm({
    super.key,
    required this.ownerNameController,
    required this.shopNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopSignupUiCubit, ShopSignupUiState>(
      builder: (context, uiState) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                'Create your seller account',
                style: ShopAppTextStyles.heading1,
              ),
              SizedBox(height: 8.h),
              Text(
                'You can complete shop details later.',
                style: ShopAppTextStyles.bodyMedium,
              ),
              SizedBox(height: 32.h),
              CustomTextField(
                label: "Owner Full Name",
                controller: ownerNameController,
                hintText: 'e.g. John Doe',
                labelStyle: ShopAppTextStyles.bodyMediumBold,
                textStyle: ShopAppTextStyles.bodyMedium,
                hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
                  color: ShopAppColors.textTertiary,
                ),
                fillColor: ShopAppColors.surface,
                borderColor: ShopAppColors.border,
                focusedBorderColor: ShopAppColors.primary,
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: ShopAppColors.textSecondary,
                  size: 20.sp,
                ),
                validator: Validators.validateName,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                label: "Shop Name",
                controller: shopNameController,
                hintText: 'Your brand name',
                labelStyle: ShopAppTextStyles.bodyMediumBold,
                textStyle: ShopAppTextStyles.bodyMedium,
                hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
                  color: ShopAppColors.textTertiary,
                ),
                fillColor: ShopAppColors.surface,
                borderColor: ShopAppColors.border,
                focusedBorderColor: ShopAppColors.primary,
                prefixIcon: Icon(
                  Icons.storefront_outlined,
                  color: ShopAppColors.textSecondary,
                  size: 20.sp,
                ),
                validator: Validators.validateShopName,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                label: "Business Email",
                controller: emailController,
                hintText: 'hello@shop.com',
                keyboardType: TextInputType.emailAddress,
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
                validator: Validators.validateEmail,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                label: "Password",
                controller: passwordController,
                hintText: 'Min. 8 characters',
                isPassword: !uiState.isPasswordVisible,
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
                    uiState.isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: ShopAppColors.textSecondary,
                    size: 20.sp,
                  ),
                  onPressed: () => context
                      .read<ShopSignupUiCubit>()
                      .togglePasswordVisibility(),
                ),
                validator: Validators.validateShopPassword,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                label: "Confirm Password",
                controller: confirmPasswordController,
                hintText: 'Repeat your password',
                isPassword: !uiState.isConfirmPasswordVisible,
                labelStyle: ShopAppTextStyles.bodyMediumBold,
                textStyle: ShopAppTextStyles.bodyMedium,
                hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
                  color: ShopAppColors.textTertiary,
                ),
                fillColor: ShopAppColors.surface,
                borderColor: ShopAppColors.border,
                focusedBorderColor: ShopAppColors.primary,
                prefixIcon: Icon(
                  Icons.lock_reset,
                  color: ShopAppColors.textSecondary,
                  size: 20.sp,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    uiState.isConfirmPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: ShopAppColors.textSecondary,
                    size: 20.sp,
                  ),
                  onPressed: () => context
                      .read<ShopSignupUiCubit>()
                      .toggleConfirmPasswordVisibility(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please confirm your password';
                  if (value != passwordController.text)
                    return 'Passwords do not match';
                  return null;
                },
              ),
              SizedBox(height: 48.h),
              BlocBuilder<ShopAuthBloc, ShopAuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    text: 'Create Account',
                    isLoading: state is ShopAuthLoading,
                    backgroundColor: ShopAppColors.primary,
                    textStyle: ShopAppTextStyles.buttonText,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<ShopAuthBloc>().add(
                          ShopSignupStarted(
                            email: emailController.text.trim(),
                            password: passwordController.text,
                            ownerName: ownerNameController.text.trim(),
                            shopName: shopNameController.text.trim(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 32.h),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have account? ',
                      style: ShopAppTextStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShopLoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Login',
                        style: ShopAppTextStyles.bodyMediumBold.copyWith(
                          color: ShopAppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 48.h),
            ],
          ),
        );
      },
    );
  }
}
