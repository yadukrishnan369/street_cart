import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/features/shop/support/presentation/utils/shop_support_helper.dart';
import 'package:street_cart/core/services/app_info_service.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/contact_support_row.dart';

// Contact Support Page
class ContactSupportPage extends StatelessWidget {
  final IAppInfoService _appInfoService = sl<IAppInfoService>();

  ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final comms = sl<CommunicationService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? ShopAppColors.darkBackground
          : const Color(0xFFF8F9FA),
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
          'Contact Support',
          style: ShopAppTextStyles.heading4.copyWith(
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            // Illustration Banner
            Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ShopAppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24.r),
                gradient: isDark
                    ? LinearGradient(
                        colors: [
                          ShopAppColors.primary.withValues(alpha: 0.2),
                          ShopAppColors.primary.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: Center(
                child: Icon(
                  Icons.support_agent_rounded,
                  size: 84.sp,
                  color: ShopAppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 6.h),

            // Welcome & Description Header
            Text(
              "We're here to help!",
              style: ShopAppTextStyles.heading2.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? ShopAppColors.darkTextPrimary
                    : ShopAppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Our dedicated Street Cart support team is available Monday to Friday, 9:00 AM - 6:00 PM EST to help you grow your business and resolve any issues.',
              style: ShopAppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextSecondary
                    : ShopAppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 36.h),

            // Call Support Action Card
            ContactSupportRow(
              icon: Icons.phone_in_talk_outlined,
              title: 'Call Support',
              subtitle: 'Speak with an agent now',
              onTap: () => ShopSupportHelper.callSupport(context, comms),
            ),
            SizedBox(height: 14.h),

            // Email Support Action Card
            ContactSupportRow(
              icon: Icons.mail_outline_rounded,
              title: 'Email Support',
              subtitle: 'Response within 24 hours',
              onTap: () => ShopSupportHelper.emailSupport(context, comms),
            ),
            SizedBox(height: 60.h),

            // Footer App Version
            Text(
              '${_appInfoService.appName} Seller App v${_appInfoService.version}',
              style: ShopAppTextStyles.bodySmall.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextSecondary
                    : ShopAppColors.textTertiary,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
