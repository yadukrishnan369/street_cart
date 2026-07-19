import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/support/presentation/pages/contact_support_page.dart';

// Help Support Contact Card
class HelpSupportContactCard extends StatelessWidget {
  const HelpSupportContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: ShopAppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Still need help?',
            style: ShopAppTextStyles.heading4.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 6.h),
          // Subtitle
          Text(
            'Our support team is available 24/7 for street cart owners.',
            style: ShopAppTextStyles.bodySmall.copyWith(
              color: Colors.white.withAlpha(217),
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),
          // Button for Contact
          ElevatedButton(
            onPressed: () {
              // Navigate to Contact Support Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactSupportPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: ShopAppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              elevation: 0,
            ),
            child: Text(
              'Contact Us',
              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                color: ShopAppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
