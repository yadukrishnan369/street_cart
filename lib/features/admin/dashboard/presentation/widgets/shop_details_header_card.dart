import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/admin/dashboard/presentation/utils/admin_dashboard_helper.dart';

// Shop Details Header Card
class ShopDetailsHeaderCard extends StatelessWidget {
  final ShopProfileModel shop;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const ShopDetailsHeaderCard({
    super.key,
    required this.shop,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final regId = AdminDashboardHelper.getRegistrationId(shop);
    final submittedTime = AdminDashboardHelper.getSubmittedTime(shop);

    final bool isApproved = shop.isApproved;
    final bool isSuspended = shop.isSuspended;

    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final headerContent = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shop Icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.storefront_outlined,
                      color: AdminAppColors.primaryColor,
                      size: 40.sp,
                    ),
                  ),
                  Positioned(
                    bottom: -8.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSuspended
                              ? const Color(0xFFFDE8E8)
                              : !isApproved
                              ? const Color(0xFFFFF3CD)
                              : const Color(0xFFDEF7EC),
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: isSuspended
                                ? const Color(0xFFFBD5D5)
                                : !isApproved
                                ? const Color(0xFFFFEBAA)
                                : const Color(0xFFBCF0DA),
                            width: 1,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            isSuspended
                                ? 'SUSPENDED'
                                : !isApproved
                                ? (shop.isReRegistered
                                      ? 'RE-REGISTERED'
                                      : 'PENDING')
                                : 'ACTIVE',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              color: isSuspended
                                  ? const Color(0xFF9B1C1C)
                                  : !isApproved
                                  ? const Color(0xFF856404)
                                  : const Color(0xFF03543F),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              // Shop Title and Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          // Shop Name
                          child: Text(
                            shop.shopName,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1E1E2F),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          // Registration ID
                          child: Text(
                            'REGISTRATION ID: $regId',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: AdminAppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14.sp,
                          color: const Color(0xFF8A8A9E),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          isApproved
                              ? 'Registered merchant'
                              : 'Submitted on $submittedTime',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF8A8A9E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

          final buttons = !isApproved
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Button for Reject Shop
                    OutlinedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(
                        Icons.close,
                        color: AdminAppColors.errorColor,
                      ),
                      label: const Text(
                        'Reject',
                        style: TextStyle(color: AdminAppColors.errorColor),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        side: const BorderSide(
                          color: AdminAppColors.errorColor,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Button for Approve Shop
                    ElevatedButton.icon(
                      onPressed: onApprove,
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Approve Shop',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminAppColors.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink();

          if (isWide) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: headerContent),
                SizedBox(width: 24.w),
                buttons,
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerContent,
                SizedBox(height: 24.h),
                buttons,
              ],
            );
          }
        },
      ),
    );
  }
}
