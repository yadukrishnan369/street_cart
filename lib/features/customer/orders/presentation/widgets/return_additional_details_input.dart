import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Return Additional Details Input
class ReturnAdditionalDetailsInput extends StatelessWidget {
  final TextEditingController controller;

  const ReturnAdditionalDetailsInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Text Field for Return Additional Detail
      child: TextField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Type additional details here...',
          hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey[400]),
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF1E293B)),
      ),
    );
  }
}
