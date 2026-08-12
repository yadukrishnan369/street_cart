import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/rejection_details_page.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Rejection Review Body
class RejectionReviewBody extends StatelessWidget {
  final ShopProfileModel shop;

  const RejectionReviewBody({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 380.h,
            margin: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              // Page Decoration Shop Image
              image: const DecorationImage(
                image: AssetImage('assets/images/shop_review_waiting.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade900.withAlpha(115),
                          Colors.red.shade700.withAlpha(51),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 80.r,
                      width: 80.r,
                      decoration: BoxDecoration(
                        color: isDark
                            ? ShopAppColors.darkSurface
                            : ShopAppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 44.sp,
                        color: ShopAppColors.error,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                    // Rejected Text
                    child: Text(
                      'Application Rejected',
                      textAlign: TextAlign.center,
                      style: ShopAppTextStyles.heading3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 12.h),
                Text(
                  'Action Required',
                  style: ShopAppTextStyles.heading1.copyWith(
                    color: isDark ? Colors.red.shade300 : ShopAppColors.error,
                  ),
                ),
                SizedBox(height: 32.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ShopAppColors.darkSurface
                        : ShopAppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark ? Colors.red.shade700 : Colors.red.shade200,
                      width: 1.5.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.red.shade900.withValues(alpha: 0.3)
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Icon(
                          Icons.assignment_late_outlined,
                          color: isDark
                              ? Colors.red.shade300
                              : ShopAppColors.error,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Feedback State Contents
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verification Feedback',
                              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                                color: isDark
                                    ? ShopAppColors.darkTextPrimary
                                    : ShopAppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Your registration application requires changes before approval. Please view details to make the necessary corrections.',
                              style: ShopAppTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? ShopAppColors.darkTextSecondary
                                    : ShopAppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                // Button for View Rejection Details
                PrimaryButton(
                  text: 'View Rejection Details',
                  backgroundColor: Colors.red.shade700,
                  textStyle: ShopAppTextStyles.buttonText.copyWith(
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Navigate to Rejection Detail Page
                    Navigator.push(
                      context,
                      AppPageTransitions.slide(
                        RejectionDetailsPage(shop: shop),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
