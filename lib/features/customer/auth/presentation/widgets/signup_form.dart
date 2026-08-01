import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';

// Signup Form
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark
        ? CustomerAppColors.darkTextSecondary
        : CustomerAppColors.textSecondary;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
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
                  color: iconColor,
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
                  color: iconColor,
                  size: 20.h,
                ),
              ),
              24.verticalSpace,

              CustomTextField(
                label: "Password",
                hintText: "Create a password",
                controller: _passwordController,
                isPassword: state.obscurePassword,
                validator: Validators.validatePassword,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: iconColor,
                  size: 20.h,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: iconColor,
                    size: 20.h,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      ToggleSignupPasswordVisibility(),
                    );
                  },
                ),
              ),
              24.verticalSpace,

              CustomTextField(
                label: "Confirm Password",
                hintText: "Repeat your password",
                controller: _confirmPasswordController,
                isPassword: state.obscureConfirmPassword,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: iconColor,
                  size: 20.h,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: iconColor,
                    size: 20.h,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      ToggleConfirmPasswordVisibility(),
                    );
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
                      value: state.agreedToTerms,
                      activeColor: CustomerAppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      side: const BorderSide(color: CustomerAppColors.border),
                      onChanged: (val) {
                        context.read<AuthBloc>().add(
                          ToggleTermsAgreement(val ?? false),
                        );
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
                    if (!state.agreedToTerms) {
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
      },
    );
  }
}
