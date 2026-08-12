import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_bloc.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_event.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_state.dart';
import 'package:street_cart/features/customer/notification/presentation/widgets/customer_notification_tile.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';

// Customer Notification List
class CustomerNotificationList extends StatelessWidget {
  const CustomerNotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark
        ? CustomerAppColors.darkTextPrimary
        : CustomerAppColors.textPrimary;
    final subtitleColor = isDark
        ? CustomerAppColors.darkTextSecondary
        : CustomerAppColors.textSecondary;
    final dividerColor = isDark
        ? CustomerAppColors.darkBorder
        : CustomerAppColors.border;

    return BlocBuilder<CustomerNotificationsBloc, CustomerNotificationsState>(
      builder: (context, state) {
        if (state.status == CustomerNotificationsStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: CustomerAppColors.primary),
          );
        }
        // Error view
        if (state.status == CustomerNotificationsStatus.failure) {
          return AppErrorView(
            message: state.errorMessage ?? 'Failed to load notifications.',
            onRetry: () {
              context.read<CustomerNotificationsBloc>().add(
                LoadNotificationsEvent(state.userId),
              );
            },
          );
        }

        final notifications = state.notifications;
        // Empty State
        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64.sp,
                  color: subtitleColor.withValues(alpha: 0.5),
                ),
                SizedBox(height: 16.h),
                // Title
                Text(
                  'No Notifications yet',
                  style: CustomerAppTextStyles.heading2.copyWith(
                    color: titleColor,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                // Subtitle
                Text(
                  'We will notify you when something updates!',
                  style: CustomerAppTextStyles.subtitle.copyWith(
                    color: subtitleColor,
                    fontSize: 13.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final isDetailLoading =
            state.status == CustomerNotificationsStatus.orderLoading ||
            state.status == CustomerNotificationsStatus.productLoading;
        // Notification List
        return Stack(
          children: [
            ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: notifications.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1.h, color: dividerColor),
              itemBuilder: (context, index) {
                // Customer Notification Tile
                return CustomerNotificationTile(
                  notification: notifications[index],
                  userId: state.userId,
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
                    color: CustomerAppColors.primary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
