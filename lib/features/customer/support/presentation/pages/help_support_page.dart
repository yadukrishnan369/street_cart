import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/constants/customer_constants.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/support_category_section.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/support_footer_box.dart';
import 'contact_support_page.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      appBar: AppBar(
        backgroundColor: CustomerAppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpHeader(),
              SizedBox(height: 32.h),
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

  Widget _buildHelpHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEFFF),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How can we help?',
            style: CustomerAppTextStyles.heading2.copyWith(fontSize: 18.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            'Search our knowledge base or browse categories below.',
            style: CustomerAppTextStyles.body.copyWith(
              color: Colors.grey.shade600,
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
