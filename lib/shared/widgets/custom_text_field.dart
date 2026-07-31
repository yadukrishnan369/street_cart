import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? labelTrailing;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final TextInputType? keyboardType;

  // Theming parameters
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;

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
    this.onChanged,
    this.maxLines = 1,
    this.keyboardType,
    this.labelStyle,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    // Default fallback values if not provided
    final effectiveLabelStyle =
        labelStyle ??
        TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        );
    final effectiveTextStyle =
        textStyle ?? TextStyle(fontSize: 14.sp, color: Colors.black);
    final effectiveHintStyle =
        hintStyle ?? TextStyle(fontSize: 14.sp, color: Colors.grey);
    final effectiveFillColor = fillColor ?? const Color(0xFFF5F5F5);
    final effectiveBorderColor = borderColor ?? const Color(0xFFE0E0E0);
    final effectiveFocusedBorderColor = focusedBorderColor ?? Colors.blue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: effectiveLabelStyle),
            if (labelTrailing != null) labelTrailing!,
          ],
        ),
        8.verticalSpace,
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          style: effectiveTextStyle,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: effectiveHintStyle,
            filled: true,
            fillColor: effectiveFillColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: effectiveBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: effectiveBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: effectiveFocusedBorderColor),
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
