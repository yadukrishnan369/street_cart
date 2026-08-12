import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_bloc.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_event.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_state.dart';
import 'package:street_cart/features/admin/notification/presentation/widgets/admin_notification_list.dart';

// Admin Notifications Page
class AdminNotificationsPage extends StatelessWidget {
  const AdminNotificationsPage({super.key});

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page title
                    Text(
                      'View Notifications',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Subtitle
                    Text(
                      'Review recent registrations, requests, and order updates.',
                      style: TextStyle(fontSize: 13.sp, color: subtitleColor),
                    ),
                  ],
                ),
                // Mark all notification read
                BlocBuilder<AdminNotificationsBloc, AdminNotificationsState>(
                  builder: (context, state) {
                    if (state.unreadCount > 0) {
                      return TextButton.icon(
                        onPressed: () => context
                            .read<AdminNotificationsBloc>()
                            .add(MarkAllAdminAsReadEvent(state.adminId)),
                        icon: const Icon(
                          Icons.done_all,
                          size: 16,
                          color: AdminAppColors.primaryColor,
                        ),
                        label: Text(
                          'Mark all read',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AdminAppColors.primaryColor,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            // Admin Notification List
            SizedBox(height: 24.h),
            const Expanded(child: AdminNotificationList()),
          ],
        ),
      ),
    );
  }
}
