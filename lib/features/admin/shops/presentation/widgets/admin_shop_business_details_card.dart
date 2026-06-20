import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class AdminShopBusinessDetailsCard extends StatelessWidget {
  final ShopProfileModel shop;

  const AdminShopBusinessDetailsCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Business Details',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AdminAppColors.textPrimary,
                ),
              ),
            ],
          ),
          Divider(height: 32.h, color: const Color(0xFFF0EFF5), thickness: 1.2),
          Text(
            'DESCRIPTION',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: const Color(0xFF8A8A9E),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            shop.description.isNotEmpty
                ? shop.description
                : 'No description provided.',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF6C6C80),
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTACT INFORMATION',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: const Color(0xFF8A8A9E),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Tooltip(
                      message: "Send a mail",
                      child: Row(
                        children: [
                          Icon(
                            Icons.mail_outline,
                            size: 14.sp,
                            color: const Color(0xFF8A8A9E),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: InkWell(
                              onTap: () => sl<CommunicationService>().sendEmail(
                                shop.email,
                              ),
                              child: Text(
                                shop.email,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AdminAppColors.primaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14.sp,
                          color: const Color(0xFF8A8A9E),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          shop.phone.isNotEmpty ? shop.phone : 'N/A',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF6C6C80),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14.sp,
                          color: const Color(0xFF8A8A9E),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          shop.ownerName,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF6C6C80),
                          ),
                        ),
                      ],
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
                      'SHOP GST ID',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: const Color(0xFF8A8A9E),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      shop.gstNumber.isNotEmpty
                          ? shop.gstNumber
                          : 'Not Provided',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E1E2F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            'FULL BUSINESS ADDRESS',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: const Color(0xFF8A8A9E),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            () {
              if (shop.fullAddress.trim().isNotEmpty) {
                return shop.fullAddress;
              }
              final parts = [
                if (shop.landmark.trim().isNotEmpty) shop.landmark.trim(),
                if (shop.city.trim().isNotEmpty) shop.city.trim(),
                if (shop.district.trim().isNotEmpty) shop.district.trim(),
                if (shop.state.trim().isNotEmpty) shop.state.trim(),
              ];
              if (parts.isEmpty && shop.pincode.trim().isEmpty) {
                return 'Not provided';
              }
              return parts.join(', ') + (shop.pincode.trim().isNotEmpty ? ' - ${shop.pincode.trim()}' : '');
            }(),
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF6C6C80),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
