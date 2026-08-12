import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_bloc.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_event.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_state.dart';
import 'package:street_cart/features/admin/notification/presentation/widgets/admin_notification_tile.dart';
import 'package:street_cart/shared/widgets/admin_error_view.dart';

// Admin Notification List
class AdminNotificationList extends StatelessWidget {
  const AdminNotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark
        ? AdminAppColors.darkTextPrimary
        : AdminAppColors.textPrimary;
    final subtitleColor = isDark
        ? AdminAppColors.darkTextSecondary
        : AdminAppColors.textSecondary;
    final dividerColor = isDark
        ? AdminAppColors.darkBorder
        : AdminAppColors.borderLight;

    return BlocBuilder<AdminNotificationsBloc, AdminNotificationsState>(
      builder: (context, state) {
        if (state.status == AdminNotificationsStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AdminAppColors.primaryColor,
            ),
          );
        }
        // Error View
        if (state.status == AdminNotificationsStatus.failure) {
          return AdminErrorView(
            message: state.errorMessage ?? 'Failed to load notifications.',
            onRetry: () {
              context.read<AdminNotificationsBloc>().add(
                LoadAdminNotificationsEvent(state.adminId),
              );
            },
          );
        }
        // Empty state
        final notifications = state.notifications;
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
                // Title
                Text(
                  'No Admin Notifications',
                  style: AdminAppTextStyles.heading3.copyWith(
                    color: titleColor,
                  ),
                ),
              ],
            ),
          );
        }
        // Notification List View
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: notifications.length,
          separatorBuilder: (context, index) =>
              Divider(height: 1.h, color: dividerColor),
          itemBuilder: (context, index) => AdminNotificationTile(
            notification: notifications[index],
            adminId: state.adminId,
            isDark: isDark,
            titleColor: titleColor,
            subtitleColor: subtitleColor,
          ),
        );
      },
    );
  }
}
