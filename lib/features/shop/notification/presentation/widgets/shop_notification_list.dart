import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_bloc.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_event.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_state.dart';
import 'package:street_cart/features/shop/notification/presentation/widgets/shop_notification_tile.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';

// Shop Notification List
class ShopNotificationList extends StatelessWidget {
  const ShopNotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark
        ? ShopAppColors.darkTextPrimary
        : ShopAppColors.textPrimary;
    final subtitleColor = isDark
        ? ShopAppColors.darkTextSecondary
        : ShopAppColors.textSecondary;
    final dividerColor = isDark
        ? ShopAppColors.darkBorder
        : ShopAppColors.border;

    return BlocBuilder<ShopNotificationsBloc, ShopNotificationsState>(
      builder: (context, state) {
        if (state.status == ShopNotificationsStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: ShopAppColors.primary),
          );
        }
        // Error view
        if (state.status == ShopNotificationsStatus.failure) {
          return AppErrorView(
            message: state.errorMessage ?? 'Failed to load notifications.',
            onRetry: () {
              context.read<ShopNotificationsBloc>().add(
                LoadShopNotificationsEvent(state.shopId),
              );
            },
          );
        }

        final notifications = state.notifications;
        // Empty state
        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_paused_outlined,
                  size: 64.sp,
                  color: subtitleColor.withValues(alpha: 0.5),
                ),
                SizedBox(height: 16.h),
                // Title
                Text(
                  'No Notifications Yet',
                  style: ShopAppTextStyles.heading2.copyWith(color: titleColor),
                ),
                SizedBox(height: 8.h),
                //Subtitle
                Text(
                  'We will notify you when new orders arrive.',
                  style: ShopAppTextStyles.bodyMedium.copyWith(
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          );
        }

        final isDetailLoading =
            state.status == ShopNotificationsStatus.orderLoading;

        return Stack(
          children: [
            ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: notifications.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1.h, color: dividerColor),
              itemBuilder: (context, index) {
                // Shop Notification Tile
                return ShopNotificationTile(
                  notification: notifications[index],
                  shopId: state.shopId,
                  isDark: isDark,
                  titleColor: titleColor,
                  subtitleColor: subtitleColor,
                );
              },
            ),
            // Loading state
            if (isDetailLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.15),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ShopAppColors.primary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
