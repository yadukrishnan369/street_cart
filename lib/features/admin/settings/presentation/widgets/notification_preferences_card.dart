import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_event.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_state.dart';

// Notification Preferences Card
class NotificationPreferencesCard extends StatelessWidget {
  const NotificationPreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminSettingsBloc, AdminSettingsState>(
      buildWhen: (prev, curr) =>
          prev.notifyNewShopAlert != curr.notifyNewShopAlert ||
          prev.notifyNewOrderAlert != curr.notifyNewOrderAlert,
      builder: (context, state) {
        final bloc = context.read<AdminSettingsBloc>();

        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AdminAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? AdminAppColors.darkBorder
                  : const Color(0xFFE8E7ED),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      color: AdminAppColors.primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    // Title
                    Text(
                      'Notification Preferences',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AdminAppColors.darkTextPrimary
                            : AdminAppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDark
                    ? AdminAppColors.darkBorder
                    : const Color(0xFFF0EFF5),
              ),
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    // New Registration Alerts
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Registration Alerts',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AdminAppColors.darkTextPrimary
                                      : AdminAppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Receive a notification when a new customer or vendor registers.',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? AdminAppColors.darkTextSecondary
                                      : const Color(0xFF8A8A9E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: state.notifyNewShopAlert,
                            activeThumbColor: AdminAppColors.primaryColor,
                            onChanged: (val) =>
                                bloc.add(ToggleNewShopAlert(val)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Order Alerts
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Alerts',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AdminAppColors.darkTextPrimary
                                      : AdminAppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Get real-time updates for every new order, cancellation, status change or refund.',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? AdminAppColors.darkTextSecondary
                                      : const Color(0xFF8A8A9E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: state.notifyNewOrderAlert,
                            activeThumbColor: AdminAppColors.primaryColor,
                            onChanged: (val) =>
                                bloc.add(ToggleNewOrderAlert(val)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
