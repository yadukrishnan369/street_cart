import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

class ShopAppTextStyles {
  // Headings
  static TextStyle heading1 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: ShopAppColors.textPrimary,
  );

  static TextStyle heading2 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: ShopAppColors.textPrimary,
  );

  static TextStyle heading3 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: ShopAppColors.textPrimary,
  );

  static TextStyle heading4 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: ShopAppColors.textPrimary,
  );

  // Body Text
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: ShopAppColors.textPrimary,
  );

  static TextStyle bodyLargeBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: ShopAppColors.textPrimary,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: ShopAppColors.textSecondary,
  );

  static TextStyle bodyMediumBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: ShopAppColors.textPrimary,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: ShopAppColors.textSecondary,
  );

  static TextStyle bodySmallBold = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
    color: ShopAppColors.textPrimary,
  );

  // Buttons & Labels
  static TextStyle buttonText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: ShopAppColors.textLight,
  );

  static TextStyle caption = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: ShopAppColors.textSecondary,
    letterSpacing: 0.5.sp,
  );

  static TextStyle labelBold = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w800,
    color: ShopAppColors.primary,
    letterSpacing: 1.2.sp,
  );
}
