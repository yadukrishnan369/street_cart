import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/customer/notification/data/models/customer_notification_model.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_bloc.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_event.dart';

// Customer Notification Tile
class CustomerNotificationTile extends StatelessWidget {
  final CustomerNotificationModel notification;
  final String userId;
  final bool isDark;
  final Color titleColor;
  final Color subtitleColor;

  const CustomerNotificationTile({
    super.key,
    required this.notification,
    required this.userId,
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
          color: CustomerAppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.delete_outline,
          color: CustomerAppColors.error,
          size: 24.r,
        ),
      ),
      onDismissed: (direction) {
        context.read<CustomerNotificationsBloc>().add(
          MarkAsReadEvent(userId: userId, notificationId: notification.id),
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
                      ? CustomerAppColors.darkInputBackground
                      : CustomerAppColors.background)
                : CustomerAppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification.type == 'order' || notification.type == 'order_status'
                ? Icons.local_shipping_outlined
                : notification.type == 'cart_price_drop'
                ? Icons.shopping_cart_outlined
                : Icons.notifications_none_outlined,
            color: notification.isRead
                ? (isDark
                      ? CustomerAppColors.darkTextSecondary
                      : CustomerAppColors.textSecondary)
                : CustomerAppColors.primary,
            size: 22.r,
          ),
        ),
        // Title
        title: Text(
          notification.title,
          style: CustomerAppTextStyles.body.copyWith(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
            color: titleColor,
          ),
        ),
        // Subtitle
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              notification.body,
              style: CustomerAppTextStyles.subtitle.copyWith(
                fontSize: 12.sp,
                color: subtitleColor,
              ),
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
        trailing: !notification.isRead
            ? Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  color: CustomerAppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          if ((notification.type == 'order' ||
                  notification.type == 'order_status' ||
                  notification.type == 'new_order') &&
              notification.relatedId != null) {
            context.read<CustomerNotificationsBloc>().add(
              GetOrderDetailsEvent(
                orderId: notification.relatedId!,
                notificationId: notification.id,
              ),
            );
          } else if ((notification.type == 'wishlist_restock' ||
                  notification.type == 'wishlist_price_drop' ||
                  notification.type == 'cart_price_drop' ||
                  notification.type == 'wishlist_alert') &&
              notification.relatedId != null) {
            context.read<CustomerNotificationsBloc>().add(
              GetProductDetailsEvent(
                productId: notification.relatedId!,
                notificationId: notification.id,
              ),
            );
          }
        },
      ),
    );
  }
}
