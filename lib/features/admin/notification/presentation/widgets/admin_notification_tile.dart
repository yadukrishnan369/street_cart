import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/notification/data/models/admin_notification_model.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_bloc.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_event.dart';

// Admin Notification Tile
class AdminNotificationTile extends StatelessWidget {
  final AdminNotificationModel notification;
  final String adminId;
  final bool isDark;
  final Color titleColor;
  final Color subtitleColor;

  const AdminNotificationTile({
    super.key,
    required this.notification,
    required this.adminId,
    required this.isDark,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    // Notification Dismissible
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: AdminAppColors.errorColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.delete_outline,
          color: AdminAppColors.errorColor,
          size: 24.r,
        ),
      ),
      onDismissed: (direction) {
        context.read<AdminNotificationsBloc>().add(
          MarkAdminAsReadEvent(
            adminId: adminId,
            notificationId: notification.id,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification deleted'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      // Notification List Tile
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDark
                      ? AdminAppColors.darkInputBackground
                      : AdminAppColors.backgroundLight)
                : AdminAppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification.type == 'shop_registration'
                ? Icons.storefront_outlined
                : (notification.type == 'order'
                      ? Icons.receipt_long_outlined
                      : Icons.info_outline),
            color: notification.isRead
                ? (isDark
                      ? AdminAppColors.darkTextSecondary
                      : AdminAppColors.textSecondary)
                : AdminAppColors.primaryColor,
            size: 22.r,
          ),
        ),
        // Title
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
            color: titleColor,
            fontSize: 14.sp,
          ),
        ),
        // Subtitle
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              notification.body,
              style: TextStyle(fontSize: 12.sp, color: subtitleColor),
            ),
            SizedBox(height: 6.h),
            // Date and time
            Text(
              DateFormatter.formatRelativeTime(notification.createdAt),
              style: TextStyle(
                fontSize: 10.sp,
                color: subtitleColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        // Read/unread badge
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!notification.isRead)
              Container(
                width: 8.r,
                height: 8.r,
                margin: EdgeInsets.only(right: 12.w),
                decoration: const BoxDecoration(
                  color: AdminAppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: AdminAppColors.errorColor.withValues(alpha: 0.7),
                size: 20.r,
              ),
              onPressed: () {
                context.read<AdminNotificationsBloc>().add(
                  MarkAdminAsReadEvent(
                    adminId: adminId,
                    notificationId: notification.id,
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            context.read<AdminNotificationsBloc>().add(
              MarkAdminAsReadEvent(
                adminId: adminId,
                notificationId: notification.id,
              ),
            );
          }

          if (notification.type == 'shop_registration' &&
              notification.relatedId != null) {
            context.push(
              RoutePaths.registrationDetails.replaceAll(
                ':id',
                notification.relatedId!,
              ),
            );
          } else if (notification.type == 'order' &&
              notification.relatedId != null) {
            context.push(
              RoutePaths.orderDetails.replaceAll(
                ':id',
                notification.relatedId!,
              ),
            );
          }
        },
      ),
    );
  }
}
