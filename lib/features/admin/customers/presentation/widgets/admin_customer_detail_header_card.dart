import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_event.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';

class AdminCustomerDetailHeaderCard extends StatelessWidget {
  final CustomerModel customer;

  const AdminCustomerDetailHeaderCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final initials = customer.fullName.isNotEmpty
        ? customer.fullName
              .trim()
              .split(' ')
              .map((e) => e[0])
              .take(2)
              .join()
              .toUpperCase()
        : 'AJ';

    final joinedDate = customer.createdAt != null
        ? DateFormatter.formatToReadableDate(customer.createdAt!)
        : 'Oct 12, 2023';

    final isBlocked = customer.isBlocked;

    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E2F).withOpacity(0.01),
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
              // Avatar
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
                child: CircleAvatar(
                  radius: 40.r,
                  backgroundColor: const Color(0xFFF3E8FF),
                  backgroundImage: customer.profileImageUrl.isNotEmpty
                      ? NetworkImage(customer.profileImageUrl)
                      : null,
                  child: customer.profileImageUrl.isEmpty
                      ? Text(
                          initials,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: AdminAppColors.primaryColor,
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(width: 24.w),

              // Textual info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            customer.fullName.isNotEmpty
                                ? customer.fullName
                                : 'Alex Johnson',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: AdminAppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 12.w),

                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: isBlocked
                                ? const Color(0xFFFDE8E8)
                                : const Color(0xFFDEF7EC),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Text(
                            isBlocked ? 'Blocked' : 'Active',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: isBlocked
                                  ? const Color(0xFF9B1C1C)
                                  : const Color(0xFF03543F),
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
                        SizedBox(width: 6.w),
                        Text(
                          'Joined: $joinedDate',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF6C6C80),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Block/Unblock Button
              OutlinedButton(
                onPressed: () => _confirmBlockToggle(context),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  side: BorderSide(
                    color: isBlocked
                        ? AdminAppColors.successColor
                        : AdminAppColors.errorColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  isBlocked ? 'Unblock Customer' : 'Block Customer',
                  style: TextStyle(
                    color: isBlocked
                        ? AdminAppColors.successColor
                        : AdminAppColors.errorColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Delete Button
              ElevatedButton(
                onPressed: () => _confirmDelete(context),
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

  void _confirmBlockToggle(BuildContext context) {
    final isBlocked = customer.isBlocked;
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: isBlocked ? 'Unblock Customer' : 'Block Customer',
        content:
            'Are you sure you want to ${isBlocked ? "unblock" : "block"} "${customer.fullName}"?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: isBlocked ? 'Unblock' : 'Block',
        icon: isBlocked ? Icons.check_circle_outline : Icons.block_outlined,
        iconColor: isBlocked
            ? AdminAppColors.successColor
            : AdminAppColors.errorColor,
        primaryActionColor: isBlocked
            ? AdminAppColors.successColor
            : AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          context.read<AdminCustomerDetailBloc>().add(
            ToggleBlockStatusRequested(
              uid: customer.uid,
              isBlocked: !isBlocked,
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Delete Customer',
        content: 'Are you sure you want to delete "${customer.fullName}"?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Delete',
        icon: Icons.delete_outline,
        iconColor: AdminAppColors.errorColor,
        primaryActionColor: AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          _confirmDeleteSecondStep(context);
        },
      ),
    );
  }

  void _confirmDeleteSecondStep(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Permanently Delete Customer',
        content:
            'This action is irreversible. All profile data for "${customer.fullName}" will be permanently deleted. Do you want to proceed?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Permanently Delete',
        icon: Icons.warning_amber_outlined,
        iconColor: AdminAppColors.errorColor,
        primaryActionColor: AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          context.read<AdminCustomerDetailBloc>().add(
            DeleteCustomerRequested(customer.uid),
          );
        },
      ),
    );
  }
}
