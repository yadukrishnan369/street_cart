import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class ShopInfoCard extends StatelessWidget {
  final ShopProfileModel? shop;
  final String shopName;

  const ShopInfoCard({super.key, required this.shopName, this.shop});

  @override
  Widget build(BuildContext context) {
    final initials = shopName.length >= 2
        ? shopName.substring(0, 2).toUpperCase()
        : 'SH';
    final address = shop != null
        ? '${shop!.fullAddress}, ${shop!.city}'
        : 'Address unavailable';
    final phone = shop?.phone ?? 'N/A';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: InkWell(
        onTap: () {
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
                    color: const Color(0xFF7B2CBF),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Shop Information',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E1E2F),
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
                      color: const Color(0xFFF4EBFF),
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
                        Text(
                          shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E1E2F),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          shop?.isSuspended == true
                              ? 'Suspended'
                              : 'Verified Shop',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: shop?.isSuspended == true
                                ? const Color.fromARGB(255, 236, 67, 45)
                                : const Color(0xFF137333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              const Divider(color: Color(0xFFE8E7ED), thickness: 1.2),
              SizedBox(height: 20.h),
              _buildInfoRow(Icons.location_on_outlined, address),
              SizedBox(height: 12.h),
              _buildInfoRow(Icons.phone_outlined, phone),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF8A8A9E), size: 16.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6C6C80)),
          ),
        ),
      ],
    );
  }
}
