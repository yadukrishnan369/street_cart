import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/onboarding/data/models/onboarding_content.dart';
import 'package:street_cart/core/animation/text_animation.dart';

// Onboarding Page View widget
class ShopOnboardingPageView extends StatelessWidget {
  final PageController controller;
  final List<OnboardingContent> contents;
  final ValueChanged<int> onPageChanged;

  const ShopOnboardingPageView({
    super.key,
    required this.controller,
    required this.contents,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: PageView.builder(
        controller: controller,
        itemCount: contents.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          final content = contents[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Page Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.asset(
                    content.image,
                    height: 300.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 48.h),
                AppTextAnimation.fade(
                  content.title,
                  key: ValueKey('shop_onboarding_title_$index'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
                  ),
                  duration: const Duration(milliseconds: 1000),
                ),
                SizedBox(height: 16.h),
                // Page Description
                Text(
                  content.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDark
                        ? ShopAppColors.darkTextSecondary
                        : ShopAppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
