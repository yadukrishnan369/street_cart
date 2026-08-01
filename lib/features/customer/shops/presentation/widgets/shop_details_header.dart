import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/shop_image_placeholder.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';

// Shop Details Header
class ShopDetailsHeader extends StatelessWidget {
  final ShopProfileModel shop;

  const ShopDetailsHeader({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? CustomerAppColors.darkBorder
                : CustomerAppColors.border,
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Shop Profile Image
            Container(
              width: 110.w,
              height: 110.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? CustomerAppColors.darkBorder
                      : CustomerAppColors.border,
                  width: 2.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              // Profile Image Preview
              child: GestureDetector(
                onTap: shop.profileImageUrl.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImagePreviewPage(
                              images: [shop.profileImageUrl],
                              initialIndex: 0,
                            ),
                          ),
                        );
                      }
                    : null,
                // Shop Profile Image
                child: ClipOval(
                  child: shop.profileImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: shop.profileImageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const ShopImagePlaceholder(iconSize: 48),
                          errorWidget: (context, url, error) =>
                              const ShopImagePlaceholder(iconSize: 48),
                        )
                      : const ShopImagePlaceholder(iconSize: 48),
                ),
              ),
            ),

            SizedBox(height: 16.h),
            // Shop Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                shop.shopName,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : CustomerAppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 8.h),
            // Location address
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: isDark
                        ? CustomerAppColors.darkTextSecondary
                        : CustomerAppColors.textSecondary,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  // Shop Landmark
                  Flexible(
                    child: Text(
                      shop.landmark.isNotEmpty
                          ? '${shop.landmark}, ${shop.city}'
                          : shop.city.isNotEmpty
                          ? shop.city
                          : 'Local Shop',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark
                            ? CustomerAppColors.darkTextSecondary
                            : CustomerAppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(
                color: isDark
                    ? CustomerAppColors.darkBorder
                    : CustomerAppColors.border,
                height: 1,
              ),
            ),

            // Info Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoStat(
                  context,
                  Icons.category_outlined,
                  'Category',
                  shop.category.isNotEmpty ? shop.category : '',
                ),
                _buildInfoStat(
                  context,
                  Icons.delivery_dining_outlined,
                  'Delivery',
                  '${shop.deliveryRadius.toStringAsFixed(0)} km',
                ),
                _buildInfoStat(
                  context,
                  Icons.payments_outlined,
                  'Payments',
                  shop.paymentMethods.isNotEmpty
                      ? shop.paymentMethods
                            .map((m) {
                              final clean = m.trim().toLowerCase();
                              if (clean.contains('gpay') ||
                                  clean.contains('google pay'))
                                return 'GPAY';
                              if (clean.contains('cash on delivery') ||
                                  clean.contains('cash'))
                                return 'COD';
                              return m.toUpperCase();
                            })
                            .toSet()
                            .join('/')
                      : 'COD',
                ),
              ],
            ),

            // Call Phone Button
            if (shop.phone.isNotEmpty) ...[
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  // Confirmation for Phone Call
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => CustomAlertDialog(
                        title: 'Call Store',
                        content:
                            'Are you sure you want to call +91 ${shop.phone}?',
                        primaryActionLabel: 'Call',
                        secondaryActionLabel: 'Cancel',
                        icon: Icons.phone_forwarded_rounded,
                        iconColor: CustomerAppColors.primary,
                        primaryActionColor: CustomerAppColors.primary,
                        onPrimaryAction: () async {
                          Navigator.pop(dialogCtx);
                          final Uri launchUri = Uri(
                            scheme: 'tel',
                            path: shop.phone,
                          );
                          if (await canLaunchUrl(launchUri)) {
                            await launchUrl(launchUri);
                          }
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.call, size: 16, color: Colors.white),
                  label: Text('Call Store (+91 ${shop.phone})'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomerAppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoStat(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: CustomerAppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: CustomerAppColors.primary, size: 20.sp),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: isDark
                ? CustomerAppColors.darkTextSecondary
                : CustomerAppColors.textSecondary,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
