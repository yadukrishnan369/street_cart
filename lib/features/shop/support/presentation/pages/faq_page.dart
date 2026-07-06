import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/constants/shop_constants.dart';
import 'contact_support_page.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/faq_expansion_tile.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ShopAppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'FAQ',
          style: ShopAppTextStyles.heading4.copyWith(
            color: ShopAppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: ShopAppColors.primary,
          unselectedLabelColor: ShopAppColors.textSecondary,
          indicatorColor: ShopAppColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
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
              Text(
                categoryDesc,
                style: ShopAppTextStyles.bodySmall.copyWith(
                  color: ShopAppColors.textSecondary,
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
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFC8E6C9),
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
                              color: ShopAppColors.textSecondary,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ContactSupportPage(),
                          ),
                        );
                      },
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
                        style: ShopAppTextStyles.bodySmallBold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          );
        }).toList(),
      ),
    );
  }
}
