import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
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

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
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
                        color: const Color(0xFF1E1E2F),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF0EFF5)),
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    // New Shop Registration Alert
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Shop Registration Alert',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E1E2F),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Receive a notification when a new vendor applies to join.',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF8A8A9E),
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

                    // New Order Alert
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Order Alert',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E1E2F),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Get real-time updates for every new order placed on the platform.',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF8A8A9E),
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
                    SizedBox(height: 24.h),

                    // Save button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogCtx) => CustomAlertDialog(
                              title: 'Save Preferences',
                              content:
                                  'Are you sure you want to save these notification preferences?',
                              secondaryActionLabel: 'Cancel',
                              primaryActionLabel: 'Confirm',
                              icon: Icons.notifications_none,
                              iconColor: AdminAppColors.primaryColor,
                              primaryActionColor: AdminAppColors.primaryColor,
                              onPrimaryAction: () {
                                Navigator.pop(dialogCtx);
                                CustomSnackBar.show(
                                  context,
                                  message: 'Notification preferences saved',
                                );
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminAppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Save Preferences'),
                      ),
                    ),
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
