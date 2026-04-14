import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'customer_app_colors.dart';

class CustomerAppTextStyles {
  static TextStyle get heading1 {
    return TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: CustomerAppColors.textPrimary,
    );
  }

  static TextStyle get heading2 {
    return TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      color: CustomerAppColors.textPrimary,
    );
  }

  static TextStyle get subtitle {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: CustomerAppColors.textSecondary,
    );
  }

  static TextStyle get body {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: CustomerAppColors.textPrimary,
    );
  }

  static TextStyle get buttonText {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }
}
