import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/forgot_password_page.dart';

class LoginForm extends StatefulWidget {
  final bool isLoading;
  final void Function(String email, String password) onLogin;

  const LoginForm({super.key, required this.isLoading, required this.onLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            label: "Email Address",
            hintText: "name@example.com",
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: Validators.validateEmail,
          ),
          24.verticalSpace,

          CustomTextField(
            label: "Password",
            hintText: "••••••••",
            controller: _passwordController,
            isPassword: !_isPasswordVisible,
            validator: Validators.validatePassword,
            labelTrailing: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                );
              },
              child: Text(
                "Forgot password?",
                style: CustomerAppTextStyles.body.copyWith(
                  color: CustomerAppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: CustomerAppColors.iconColor,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          32.verticalSpace,

          PrimaryButton(
            text: "Login with Email",
            isLoading: widget.isLoading,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onLogin(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
