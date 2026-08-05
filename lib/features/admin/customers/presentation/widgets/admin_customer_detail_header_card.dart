import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/shared/widgets/customer_image_placeholder.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';
import 'package:street_cart/features/admin/customers/presentation/utils/admin_customers_helper.dart';

// Admin Customer Detail Header Card
class AdminCustomerDetailHeaderCard extends StatelessWidget {
  final CustomerModel customer;

  const AdminCustomerDetailHeaderCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = AdminCustomersHelper.getCustomerInitials(
      customer.fullName,
      defaultInitials: 'AJ',
    );

    final joinedDate = customer.createdAt != null
        ? DateFormatter.formatToReadableDate(customer.createdAt!)
        : 'Oct 12, 2026';

    final isBlocked = customer.isBlocked;

    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E2F).withValues(alpha: 0.01),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;

          final headerInfo = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar
              GestureDetector(
                onTap: customer.profileImageUrl.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImagePreviewPage(
                              images: [customer.profileImageUrl],
                              initialIndex: 0,
                            ),
                          ),
                        );
                      }
                    : null,
                // Customer Profile Image
                child: CircleAvatar(
                  radius: 40.r,
                  backgroundColor: isDark
                      ? AdminAppColors.primaryColor.withValues(alpha: 0.2)
                      : const Color(0xFFF3E8FF),
                  child: customer.profileImageUrl.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: customer.profileImageUrl,
                            width: 77.r,
                            height: 77.r,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CustomerImagePlaceholder(
                                  size: 70.w,
                                  iconColor: AdminAppColors.primaryColor,
                                ),
                            errorWidget: (context, url, error) =>
                                CustomerImagePlaceholder(
                                  size: 70.w,
                                  iconColor: AdminAppColors.primaryColor,
                                ),
                          ),
                        )
                      : Text(
                          initials,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: AdminAppColors.primaryColor,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 24.w),

              // Customer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        // Customer Full Name
                        Text(
                          customer.fullName.isNotEmpty
                              ? customer.fullName
                              : 'Customer Name',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AdminAppColors.darkTextPrimary
                                : AdminAppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 12.w),

                        // Block/Active Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AdminCustomersHelper.getStatusBgColor(
                              isBlocked,
                            ),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Text(
                            AdminCustomersHelper.getStatusLabel(isBlocked),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: AdminCustomersHelper.getStatusTextColor(
                                isBlocked,
                              ),
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
                          color: isDark
                              ? AdminAppColors.darkTextSecondary
                              : const Color(0xFF8A8A9E),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Joined: $joinedDate',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark
                                ? AdminAppColors.darkTextSecondary
                                : const Color(0xFF8A8A9E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

          final actionButtons = Row(
            children: [
              // Block/Unblock Action Button
              ElevatedButton(
                onPressed: () =>
                    AdminCustomersHelper.confirmBlockToggle(context, customer),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBlocked
                      ? AdminAppColors.successColor
                      : AdminAppColors.errorColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  isBlocked ? 'Unblock Customer' : 'Block Customer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Delete Button
              ElevatedButton(
                onPressed: () =>
                    AdminCustomersHelper.confirmDelete(context, customer),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminAppColors.errorColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Delete Customer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          );

          return isWide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: headerInfo),
                    SizedBox(width: 32.w),
                    actionButtons,
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerInfo,
                    SizedBox(height: 24.h),
                    actionButtons,
                  ],
                );
        },
      ),
    );
  }
}
