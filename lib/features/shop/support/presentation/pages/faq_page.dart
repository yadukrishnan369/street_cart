import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/constants/shop_constants.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/faq_category_list_view.dart';

// FAQ Page
class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: ShopConstants.faqCategories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? ShopAppColors.darkBackground : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? ShopAppColors.darkBackground : Colors.white,
        elevation: isDark ? null : 1.5,
        shape: Border(
          bottom: BorderSide(
            color: isDark
                ? ShopAppColors.darkBorder
                : ShopAppColors.border.withValues(alpha: 1.5),
            width: 0.5,
          ),
        ),
        // Page Header
        title: Text(
          'FAQs',
          style: ShopAppTextStyles.heading4.copyWith(
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // Tab bar
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: ShopAppColors.primary,
          indicatorWeight: 3.h,
          labelColor: ShopAppColors.primary,
          unselectedLabelColor: isDark
              ? ShopAppColors.darkTextSecondary
              : Colors.grey[500],
          labelStyle: ShopAppTextStyles.bodyMediumBold.copyWith(
            fontSize: 13.sp,
          ),
          unselectedLabelStyle: ShopAppTextStyles.bodyMedium.copyWith(
            fontSize: 13.sp,
          ),
          tabs: ShopConstants.faqCategories.map((cat) {
            return Tab(text: cat['title']);
          }).toList(),
        ),
      ),
      // Tab bar View
      body: TabBarView(
        controller: _tabController,
        children: ShopConstants.faqCategories.map((cat) {
          final String title = cat['title'];
          final List faqs = cat['faqs'];

          String categoryDesc =
              'Manage your digital storefront and preferences';
          if (title.toLowerCase().contains('order')) {
            categoryDesc = 'Tracking and managing your customer deliveries';
          } else if (title.toLowerCase().contains('payment')) {
            categoryDesc = 'Understanding payouts and digital collections';
          }
          // FAQ Category List View
          return FAQCategoryListView(
            title: title,
            categoryDesc: categoryDesc,
            faqs: faqs,
          );
        }).toList(),
      ),
    );
  }
}
