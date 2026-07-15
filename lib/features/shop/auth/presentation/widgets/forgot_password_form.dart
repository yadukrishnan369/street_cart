import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

class ShopForgotPasswordForm extends StatefulWidget {
  final bool isLoading;
  final void Function(String email) onSendResetLink;

  const ShopForgotPasswordForm({
    super.key,
    required this.isLoading,
    required this.onSendResetLink,
  });

  @override
  State<ShopForgotPasswordForm> createState() => _ShopForgotPasswordFormState();
}

class _ShopForgotPasswordFormState extends State<ShopForgotPasswordForm> {
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
            label: "Business Email",
            hintText: "example@business.com",
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
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
              color: ShopAppColors.primary,
              size: 20.h,
            ),
          ),
          32.verticalSpace,
          PrimaryButton(
            text: "Send Reset Link",
            isLoading: widget.isLoading,
            backgroundColor: ShopAppColors.primary,
            textStyle: ShopAppTextStyles.buttonText,
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
