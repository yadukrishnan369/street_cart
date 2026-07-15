import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class SignupForm extends StatefulWidget {
  final bool isLoading;
  final void Function(String email, String password, String fullName) onSignUp;

  const SignupForm({
    super.key,
    required this.isLoading,
    required this.onSignUp,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: "Full Name",
            hintText: "Enter your full name",
            controller: _nameController,
            validator: Validators.validateName,
            prefixIcon: Icon(
              Icons.person_outline,
              color: CustomerAppColors.textSecondary,
              size: 20.h,
            ),
          ),
          24.verticalSpace,

          CustomTextField(
            label: "Email Address",
            hintText: "name@example.com",
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: Validators.validateEmail,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: CustomerAppColors.textSecondary,
              size: 20.h,
            ),
          ),
          24.verticalSpace,

          CustomTextField(
            label: "Password",
            hintText: "Create a password",
            controller: _passwordController,
            isPassword: _obscurePassword,
            validator: Validators.validatePassword,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: CustomerAppColors.textSecondary,
              size: 20.h,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: CustomerAppColors.textSecondary,
                size: 20.h,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          24.verticalSpace,

          CustomTextField(
            label: "Confirm Password",
            hintText: "Repeat your password",
            controller: _confirmPasswordController,
            isPassword: _obscureConfirmPassword,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: CustomerAppColors.textSecondary,
              size: 20.h,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: CustomerAppColors.textSecondary,
                size: 20.h,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Confirm your password";
              }
              if (value != _passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          24.verticalSpace,

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: Checkbox(
                  value: _agreedToTerms,
                  activeColor: CustomerAppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  side: const BorderSide(color: CustomerAppColors.border),
                  onChanged: (val) {
                    setState(() {
                      _agreedToTerms = val ?? false;
                    });
                  },
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: CustomerAppTextStyles.body.copyWith(
                      color: CustomerAppColors.textSecondary,
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: "I agree to the "),
                      TextSpan(
                        text: "Terms and Conditions",
                        style: TextStyle(
                          color: CustomerAppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          color: CustomerAppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: "."),
                    ],
                  ),
                ),
              ),
            ],
          ),
          40.verticalSpace,

          PrimaryButton(
            text: "Sign Up",
            isLoading: widget.isLoading,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (!_agreedToTerms) {
                  CustomSnackBar.show(
                    context,
                    message: "You must agree to the Terms and Conditions",
                    isError: true,
                  );
                  return;
                }
                widget.onSignUp(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                  _nameController.text.trim(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
