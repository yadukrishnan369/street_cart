import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Normal Review Body
class NormalReviewBody extends StatelessWidget {
  final bool isApproved;

  const NormalReviewBody({super.key, required this.isApproved});

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
                          Colors.black.withAlpha(179),
                          Colors.transparent,
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
                        Icons.hourglass_bottom_rounded,
                        size: 36.sp,
                        color: ShopAppColors.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                    // Shop Approval State Content
                    child: Text(
                      'Your shop account is ready!\n(Lets Explore Streetcart)',
                      textAlign: TextAlign.center,
                      style: ShopAppTextStyles.heading4.copyWith(
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
                // Approved/ Waiting Label
                Text(
                  isApproved ? "You're All Set!" : 'Account Under Review',
                  style: ShopAppTextStyles.heading1.copyWith(
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
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
                      color: isDark
                          ? ShopAppColors.darkBorder
                          : ShopAppColors.border,
                      width: 1.5.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: ShopAppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        // Icons
                        child: Icon(
                          isApproved
                              ? Icons.check_circle_outline
                              : Icons.verified_user_outlined,
                          color: ShopAppColors.primary,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Waiting/Approved State contents
                            Text(
                              isApproved
                                  ? 'Account Approved'
                                  : 'Reviewing Credentials',
                              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                                color: isDark
                                    ? ShopAppColors.darkTextPrimary
                                    : ShopAppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              isApproved
                                  ? 'Your shop is now live! Click below to enter.'
                                  : 'We are currently verifying your business documentation and identity. Expected time: 24-48 hours.',
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
                // Button for Go to DashBoard
                PrimaryButton(
                  text: 'Go to Dashboard',
                  backgroundColor: isApproved
                      ? ShopAppColors.primary
                      : ShopAppColors.primary.withAlpha(128),
                  textStyle: ShopAppTextStyles.buttonText.copyWith(
                    color: Colors.white.withAlpha(isApproved ? 255 : 153),
                  ),
                  prefixIcon: isApproved
                      ? null
                      : Icon(
                          Icons.lock_outline,
                          color: Colors.white.withAlpha(153),
                          size: 18.sp,
                        ),
                  onPressed: isApproved
                      ? () {
                          // Navigation for Shop home page
                          Navigator.pushAndRemoveUntil(
                            context,
                            AppPageTransitions.none(const ShopHomePage()),
                            (route) => false,
                          );
                        }
                      : null,
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
