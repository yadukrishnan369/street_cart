import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/shop/notification/data/models/shop_notification_model.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_bloc.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_event.dart';

// Shop Notification  Tile
class ShopNotificationTile extends StatelessWidget {
  final ShopNotificationModel notification;
  final String shopId;
  final bool isDark;
  final Color titleColor;
  final Color subtitleColor;

  const ShopNotificationTile({
    super.key,
    required this.notification,
    required this.shopId,
    required this.isDark,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    // Nofitication Dismissible
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: ShopAppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.delete_outline,
          color: ShopAppColors.error,
          size: 24.r,
        ),
      ),
      onDismissed: (direction) {
        context.read<ShopNotificationsBloc>().add(
          DeleteShopNotificationEvent(
            shopId: shopId,
            notificationId: notification.id,
          ),
        );
      },
      // Notification List Tiles
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDark ? ShopAppColors.darkSurface : ShopAppColors.surface)
                : ShopAppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          // Icon
          child: Icon(
            notification.type == 'order'
                ? Icons.shopping_bag_outlined
                : notification.type == 'product_review'
                ? Icons.star_outline_rounded
                : Icons.notifications_none_outlined,
            color: notification.isRead ? subtitleColor : ShopAppColors.primary,
            size: 22.r,
          ),
        ),
        // Title
        title: Text(
          notification.title,
          style: ShopAppTextStyles.bodyLarge.copyWith(
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
              style: ShopAppTextStyles.bodyMedium.copyWith(
                color: subtitleColor,
              ),
            ),
            SizedBox(height: 6.h),
            // Date and time
            Text(
              DateFormatter.formatRelativeTime(notification.createdAt),
              style: ShopAppTextStyles.bodySmall.copyWith(
                color: subtitleColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        // Read/unreead badge
        trailing: !notification.isRead
            ? Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  color: ShopAppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          if (notification.type == 'commission_update') {
            context.read<ShopNotificationsBloc>().add(
              MarkShopAsReadEvent(
                shopId: shopId,
                notificationId: notification.id,
              ),
            );
            return;
          }

          if ((notification.type == 'order' ||
                  notification.type == 'order_status' ||
                  notification.type == 'new_order') &&
              notification.relatedId != null) {
            final isReturn =
                notification.title.toLowerCase().contains('return') ||
                notification.body.toLowerCase().contains('return');
            context.read<ShopNotificationsBloc>().add(
              GetShopOrderDetailsEvent(
                notification.relatedId!,
                isReturnOrder: isReturn,
                notificationId: notification.id,
              ),
            );
          } else if (notification.type == 'product_review' &&
              notification.relatedId != null) {
            context.read<ShopNotificationsBloc>().add(
              GetShopProductDetailsEvent(
                notification.relatedId!,
                notificationId: notification.id,
              ),
            );
          }
        },
      ),
    );
  }
}
