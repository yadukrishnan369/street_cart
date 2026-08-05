import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/dashboard/data/models/new_registration_model.dart';
import 'package:street_cart/features/admin/dashboard/presentation/utils/admin_dashboard_helper.dart';

// New Registrations Section
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFF0EFF5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Text(
                'New Registrations',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AdminAppColors.darkTextPrimary
                      : AdminAppColors.textPrimary,
                ),
              ),
              Text(
                'Pending Approval',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AdminAppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Empty State View
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
            // List of New Registration
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
                    color: isDark
                        ? AdminAppColors.darkInputBackground
                        : const Color(0xFFF9FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? AdminAppColors.darkBorder
                          : const Color(0xFFF0EFF5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AdminAppColors.primaryColor.withValues(
                                  alpha: 0.15,
                                )
                              : const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.storefront_outlined,
                          color: AdminAppColors.primaryColor,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  // Shop Name
                                  child: Text(
                                    reg.shopName,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AdminAppColors.darkTextPrimary
                                          : AdminAppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (reg.isReRegistered) ...[
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF423715)
                                          : const Color(0xFFFFF3CD),
                                      borderRadius: BorderRadius.circular(4.r),
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFF63521D)
                                            : const Color(0xFFFFEBAA),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'Re-registered',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? const Color(0xFFFFD54F)
                                            : const Color(0xFF856404),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              AdminDashboardHelper.getRegistrationSubtitle(reg),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark
                                    ? AdminAppColors.darkTextSecondary
                                    : const Color(0xFF8A8A9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: AdminAppColors.primaryColor,
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
              // Button for See All Registration
              child: TextButton(
                onPressed: onSeeAll,
                child: Text(
                  'See all registrations',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AdminAppColors.primaryColor,
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
