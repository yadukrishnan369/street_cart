import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/Customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? labelTrailing;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.suffixIcon,
    this.prefixIcon,
    this.labelTrailing,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: CustomerAppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (labelTrailing != null) labelTrailing!,
          ],
        ),
        8.verticalSpace,
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          style: CustomerAppTextStyles.body,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: CustomerAppTextStyles.body.copyWith(
              color: CustomerAppColors.textSecondary,
            ),
            filled: true,
            fillColor: CustomerAppColors.inputBackground,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: CustomerAppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: CustomerAppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: CustomerAppColors.primary),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorStyle: const TextStyle(height: 0.8),
          ),
        ),
      ],
    );
  }
}
