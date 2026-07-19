import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/constants/shop_constants.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/help_support_contact_card.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/help_topic_card.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/help_expandable_category_row.dart';
import 'package:street_cart/features/shop/support/presentation/pages/faq_page.dart';
import 'package:street_cart/features/shop/support/presentation/utils/shop_support_helper.dart';

// Help Support Page
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: ShopAppColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
        // Page Header
        title: Text(
          'Help & Support',
          style: ShopAppTextStyles.heading4.copyWith(
            color: ShopAppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              'Common Topics',
              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                fontSize: 16.sp,
                color: ShopAppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  // Help Topic Card
                  child: HelpTopicCard(
                    icon: Icons.local_mall_outlined,
                    title: 'Orders',
                    onTap: () {
                      // Navigate to FAQ Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FAQPage()),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  // Help Topic Card
                  child: HelpTopicCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'Products',
                    onTap: () {
                      // Navigate to FAQ Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FAQPage()),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  // Help Topic Card
                  child: HelpTopicCard(
                    icon: Icons.payments_outlined,
                    title: 'Payments',
                    onTap: () {
                      // Navigate to FAQ Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FAQPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),
            Text(
              'Help Categories',
              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                fontSize: 16.sp,
                color: ShopAppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            ...ShopConstants.helpSupportCategories.map((category) {
              final String title = category['title'];
              final String subtitle = category['subtitle'];
              final List items = category['items'];
              final IconData icon = ShopSupportHelper.getCategoryIcon(title);
              // Help Expandable Category
              return HelpExpandableCategoryRow(
                icon: icon,
                title: title,
                subtitle: subtitle,
                items: List<Map<String, String>>.from(
                  items.map((item) => Map<String, String>.from(item)),
                ),
              );
            }),
            SizedBox(height: 20.h),
            // Help Support Contact Card
            const HelpSupportContactCard(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
