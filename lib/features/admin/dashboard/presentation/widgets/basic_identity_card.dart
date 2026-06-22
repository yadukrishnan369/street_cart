import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class BasicIdentityCard extends StatelessWidget {
  final ShopProfileModel shop;

  const BasicIdentityCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AdminAppColors.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Basic Identity',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),
          Divider(height: 32.h, color: const Color(0xFFF0EFF5)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BUSINESS NAME',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8A8A9E),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      shop.shopName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1E2F),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CATEGORY',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8A8A9E),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 16.sp,
                          color: AdminAppColors.primaryColor,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            shop.category,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E1E2F),
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            'BUSINESS DESCRIPTION',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF8A8A9E),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            shop.description.isNotEmpty
                ? shop.description
                : 'No description provided.',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF5A5A6A),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
