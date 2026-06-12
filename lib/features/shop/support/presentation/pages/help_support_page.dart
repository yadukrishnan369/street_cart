import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/constants/shop_constants.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/faq_expansion_tile.dart';
import 'contact_support_page.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  IconData _getCategoryIcon(String title) {
    switch (title) {
      case 'Account & Security':
        return Icons.account_circle_outlined;
      case 'Shop Customization':
        return Icons.storefront_outlined;
      case 'Shipping & Delivery':
        return Icons.local_shipping_outlined;
      case 'Marketing & Sales':
        return Icons.campaign_outlined;
      default:
        return Icons.help_outline;
    }
  }

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
            // Common Topics
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
                Expanded(child: _buildTopicCard(context, Icons.local_mall_outlined, 'Orders')),
                SizedBox(width: 12.w),
                Expanded(child: _buildTopicCard(context, Icons.inventory_2_outlined, 'Products')),
                SizedBox(width: 12.w),
                Expanded(child: _buildTopicCard(context, Icons.payments_outlined, 'Payments')),
              ],
            ),
            SizedBox(height: 28.h),

            // Help Categories
            Text(
              'Help Categories',
              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                fontSize: 16.sp,
                color: ShopAppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            
            // Expandable Help Categories
            ...ShopConstants.helpSupportCategories.map((category) {
              final String title = category['title'];
              final String subtitle = category['subtitle'];
              final List items = category['items'];
              final IconData icon = _getCategoryIcon(title);
              
              return _buildExpandableCategoryRow(
                icon: icon,
                title: title,
                subtitle: subtitle,
                items: List<Map<String, String>>.from(
                  items.map((item) => Map<String, String>.from(item)),
                ),
              );
            }),
            SizedBox(height: 20.h),

            // Contact Banner Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: ShopAppColors.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Still need help?',
                    style: ShopAppTextStyles.heading4.copyWith(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Our support team is available 24/7 for street cart owners.',
                    style: ShopAppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
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
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, IconData icon, String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ShopAppColors.primary, size: 24.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: ShopAppColors.textPrimary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCategoryRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Map<String, String>> items,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          colorScheme: const ColorScheme.light(primary: ShopAppColors.primary),
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ShopAppColors.primary, size: 22.sp),
          ),
          title: Text(
            title,
            style: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: ShopAppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              subtitle,
              style: ShopAppTextStyles.bodySmall.copyWith(
                color: ShopAppColors.textSecondary,
                fontSize: 12.sp,
              ),
            ),
          ),
          iconColor: ShopAppColors.primary,
          collapsedIconColor: ShopAppColors.textSecondary,
          childrenPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          children: items.map((item) {
            return FAQExpansionTile(
              question: item['question']!,
              answer: item['answer']!,
            );
          }).toList(),
        ),
      ),
    );
  }
}

