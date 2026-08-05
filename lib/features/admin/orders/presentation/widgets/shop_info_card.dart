import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

// Shop Info Card
class ShopInfoCard extends StatelessWidget {
  final ShopProfileModel? shop;
  final String shopName;

  const ShopInfoCard({super.key, required this.shopName, this.shop});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Shop info card data
    final initials = AdminOrdersHelper.getShopInitials(shopName);
    final address = AdminOrdersHelper.getShopAddress(shop);
    final phone = AdminOrdersHelper.getShopPhone(shop);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to Shop Details Page
          if (shop?.uid != null) {
            context.push('/shops/${shop!.uid}');
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    color: AdminAppColors.primaryColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  // Title
                  Text(
                    'Shop Information',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AdminAppColors.darkTextPrimary
                          : AdminAppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AdminAppColors.primaryColor.withValues(alpha: 0.15)
                          : const Color(0xFFF4EBFF),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AdminAppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shop Name
                        Text(
                          shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AdminAppColors.darkTextPrimary
                                : AdminAppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        // Status Label
                        Text(
                          shop?.isSuspended == true
                              ? 'Suspended'
                              : 'Verified Shop',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: shop?.isSuspended == true
                                ? AdminAppColors.errorColor
                                : AdminAppColors.successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Divider(
                color: isDark
                    ? AdminAppColors.darkBorder
                    : const Color(0xFFE8E7ED),
                thickness: 1.2,
              ),
              SizedBox(height: 20.h),
              _buildInfoRow(context, Icons.location_on_outlined, address),
              SizedBox(height: 12.h),
              _buildInfoRow(context, Icons.phone_outlined, phone),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: isDark
              ? AdminAppColors.darkTextSecondary
              : const Color(0xFF8A8A9E),
          size: 16.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF6C6C80),
            ),
          ),
        ),
      ],
    );
  }
}
