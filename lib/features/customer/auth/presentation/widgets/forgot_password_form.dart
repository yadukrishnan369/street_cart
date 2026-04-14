import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

class ForgotPasswordForm extends StatefulWidget {
  final bool isLoading;
  final void Function(String email) onSendResetLink;

  const ForgotPasswordForm({
    super.key,
    required this.isLoading,
    required this.onSendResetLink,
  });

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            hintText: "example@email.com",
            controller: _emailController,
            validator: Validators.validateEmail,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: CustomerAppColors.primary,
              size: 20.h,
            ),
          ),
          32.verticalSpace,
          PrimaryButton(
            text: "Send Reset Link",
            isLoading: widget.isLoading,
            suffixIcon: Icon(
              Icons.send_outlined,
              color: Colors.white,
              size: 20.h,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSendResetLink(_emailController.text.trim());
              }
            },
          ),
        ],
      ),
    );
  }
}
