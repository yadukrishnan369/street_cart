import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/rejection_details_page.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

class RejectionReviewBody extends StatelessWidget {
  final ShopProfileModel shop;

  const RejectionReviewBody({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 380.h,
            margin: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
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
                      decoration: const BoxDecoration(
                        color: ShopAppColors.surface,
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
                    color: ShopAppColors.error,
                  ),
                ),
                SizedBox(height: 32.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ShopAppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.red.shade200,
                      width: 1.5.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Icon(
                          Icons.assignment_late_outlined,
                          color: ShopAppColors.error,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verification Feedback',
                              style: ShopAppTextStyles.bodyMediumBold,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Your registration application requires changes before approval. Please view details to make the necessary corrections.',
                              style: ShopAppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                PrimaryButton(
                  text: 'View Rejection Details',
                  backgroundColor: Colors.red.shade700,
                  textStyle: ShopAppTextStyles.buttonText.copyWith(
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RejectionDetailsPage(shop: shop),
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
