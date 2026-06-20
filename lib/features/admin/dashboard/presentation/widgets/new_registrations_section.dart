import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/dashboard/data/models/new_registration_model.dart';

class NewRegistrationsSection extends StatelessWidget {
  final List<NewRegistrationModel> registrations;
  final VoidCallback? onSeeAll;
  final Function(String id)? onApprove;

  const NewRegistrationsSection({
    super.key,
    required this.registrations,
    this.onSeeAll,
    this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF0EFF5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Registrations',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
              Text(
                'Pending Approval',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9D4EDD),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (registrations.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32.h),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    color: AdminAppColors.primaryColor,
                    size: 44.sp,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'No new registers',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AdminAppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: registrations.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final reg = registrations[index];
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFFF0EFF5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.storefront_outlined,
                          color: const Color(0xFF9D4EDD),
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reg.shopName,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E1E2F),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              () {
                                final category = reg.address
                                    .split('•')
                                    .first
                                    .trim();
                                if (reg.createdAt != null) {
                                  final datePart =
                                      DateFormatter.formatToReadableDate(
                                        reg.createdAt!,
                                      ).split(',').first;
                                  final timePart = DateFormatter.formatToTime(
                                    reg.createdAt!,
                                  );
                                  return '$category • $datePart, $timePart';
                                }
                                return '$category • Recently';
                              }(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF8A8A9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: const Color(0xFF9D4EDD),
                          size: 20.sp,
                        ),
                        onPressed: () => onApprove?.call(reg.id),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),
            Center(
              child: TextButton(
                onPressed: onSeeAll,
                child: Text(
                  'See all registrations',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF9D4EDD),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
