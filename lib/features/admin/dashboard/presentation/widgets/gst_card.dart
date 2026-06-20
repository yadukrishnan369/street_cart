import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class GstCard extends StatelessWidget {
  final ShopProfileModel shop;

  const GstCard({super.key, required this.shop});

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
          Text(
            'GST Number',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E1E2F),
            ),
          ),
          Divider(height: 32.h, color: const Color(0xFFF0EFF5)),
          Text(
            shop.gstNumber.isNotEmpty ? shop.gstNumber : 'Not Provided',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: shop.gstNumber.isNotEmpty
                  ? const Color(0xFF1E1E2F)
                  : const Color(0xFF8A8A9E),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
