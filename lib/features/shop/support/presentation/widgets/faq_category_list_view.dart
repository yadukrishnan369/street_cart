import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/support/presentation/pages/contact_support_page.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/faq_expansion_tile.dart';

// FAQ Category List View
class FAQCategoryListView extends StatelessWidget {
  final String title;
  final String categoryDesc;
  final List faqs;

  const FAQCategoryListView({
    super.key,
    required this.title,
    required this.categoryDesc,
    required this.faqs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      children: [
        // Category Title
        Text(
          title,
          style: ShopAppTextStyles.heading4.copyWith(
            color: ShopAppColors.primary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        // Description
        Text(
          categoryDesc,
          style: ShopAppTextStyles.bodySmall.copyWith(
            color: isDark
                ? ShopAppColors.darkTextSecondary
                : ShopAppColors.textSecondary,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 24.h),

        // FAQ List
        ...faqs.map((faq) {
          return FAQExpansionTile(
            question: faq['question'],
            answer: faq['answer'],
          );
        }),
        SizedBox(height: 32.h),

        // Bottom still need help banner
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark
                ? ShopAppColors.primary.withValues(alpha: 0.15)
                : const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? ShopAppColors.darkBorder
                  : const Color(0xFFC8E6C9),
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: ShopAppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.headset_mic_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Still need help?',
                      style: ShopAppTextStyles.bodyMediumBold.copyWith(
                        color: ShopAppColors.primary,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Our support team is available 24/7',
                      style: ShopAppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : ShopAppColors.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Contact Support Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ContactSupportPage()),
                  );
                },
                // Contact us Button
                style: ElevatedButton.styleFrom(
                  backgroundColor: ShopAppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
