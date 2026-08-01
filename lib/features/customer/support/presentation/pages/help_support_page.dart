import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/constants/customer_constants.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/support_category_section.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/support_footer_box.dart';
import 'contact_support_page.dart';

// Help Support Page
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // Page Title
        title: Text(
          'Help & Support',
          style: CustomerAppTextStyles.heading2.copyWith(
            fontSize: 20.sp,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpHeader(context),
              SizedBox(height: 32.h),
              // Categories
              _buildCategory(0, Icons.inventory_2_outlined),
              _buildCategory(1, Icons.assignment_return_outlined),
              _buildCategory(2, Icons.payment_outlined),
              _buildCategory(3, Icons.person_outline),
              SizedBox(height: 16.h),
              SupportFooterBox(
                title: 'Still need help?',
                subtitle: 'Our support team is available 24/7',
                buttonText: 'Contact Us',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ContactSupportPage(),
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  // Help Section Header
  Widget _buildHelpHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.primary.withValues(alpha: 0.15)
            : const Color(0xFFEEEFFF),
        borderRadius: BorderRadius.circular(24.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How can we help?',
            style: CustomerAppTextStyles.heading2.copyWith(
              fontSize: 18.sp,
              color: isDark
                  ? CustomerAppColors.darkTextPrimary
                  : CustomerAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Search our knowledge base or browse categories below.',
            style: CustomerAppTextStyles.body.copyWith(
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(int index, IconData icon) {
    final cat = CustomerConstants.supportCategories[index];
    return SupportCategorySection(
      title: cat['title'],
      items: List<Map<String, dynamic>>.from(cat['items']),
      icon: icon,
    );
  }
}
