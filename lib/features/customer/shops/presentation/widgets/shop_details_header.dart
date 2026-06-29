import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

class ShopDetailsHeader extends StatelessWidget {
  final ShopProfileModel shop;

  const ShopDetailsHeader({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 24.h,
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: CustomerAppColors.border,
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Circular Shop Profile Image
            Container(
              width: 110.w,
              height: 110.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: CustomerAppColors.border,
                  width: 2.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: shop.profileImageUrl.isNotEmpty
                    ? Image.network(
                        shop.profileImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _buildFallbackIcon(),
                      )
                    : _buildFallbackIcon(),
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
                  color: CustomerAppColors.textPrimary,
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
                    color: CustomerAppColors.textSecondary,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text(
                      shop.landmark.isNotEmpty
                          ? '${shop.landmark}, ${shop.city}'
                          : shop.city.isNotEmpty
                          ? shop.city
                          : 'Local Shop',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: CustomerAppColors.textSecondary,
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
                color: CustomerAppColors.border,
                height: 1,
              ),
            ),

            // Horizontal info stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoStat(
                  Icons.category_outlined,
                  'Category',
                  shop.category.isNotEmpty ? shop.category : '',
                ),
                _buildInfoStat(
                  Icons.delivery_dining_outlined,
                  'Delivery',
                  '${shop.deliveryRadius.toStringAsFixed(0)} km',
                ),
                _buildInfoStat(
                  Icons.payments_outlined,
                  'Payments',
                  shop.paymentMethods.isNotEmpty
                      ? shop.paymentMethods
                            .map((m) {
                              final clean = m
                                  .trim()
                                  .toLowerCase();
                              if (clean.contains('gpay') ||
                                  clean.contains('google pay'))
                                return 'GPAY';
                              if (clean.contains(
                                    'cash on delivery',
                                  ) ||
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
                        primaryActionColor:
                            CustomerAppColors.primary,
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
                  icon: const Icon(
                    Icons.call,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text('Call Store (+91 ${shop.phone})'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomerAppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                    ),
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

  Widget _buildFallbackIcon() {
    return Container(
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Icon(
        Icons.storefront_outlined,
        color: Colors.grey.shade400,
        size: 40.sp,
      ),
    );
  }

  Widget _buildInfoStat(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: CustomerAppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: CustomerAppColors.primary, size: 20.sp),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: CustomerAppColors.textSecondary,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: CustomerAppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
