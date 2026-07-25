import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Review Comment Field
class ReviewCommentField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  const ReviewCommentField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Your Review',
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        // Comment Field
        TextFormField(
          controller: controller,
          maxLines: 5,
          maxLength: 500,
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF1E293B)),
          decoration: InputDecoration(
            hintText: 'What did you like or dislike? How was the quality?',
            hintStyle: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 13.sp,
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.all(16.w),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: CustomerAppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: CustomerAppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: CustomerAppColors.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
