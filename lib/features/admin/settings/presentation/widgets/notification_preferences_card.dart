import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class NotificationPreferencesCard extends StatefulWidget {
  const NotificationPreferencesCard({super.key});

  @override
  State<NotificationPreferencesCard> createState() => _NotificationPreferencesCardState();
}

class _NotificationPreferencesCardState extends State<NotificationPreferencesCard> {
  bool _newShopAlert = true;
  bool _newOrderAlert = false;

  @override
  Widget build(BuildContext context) {
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
                        value: _newShopAlert,
                        activeThumbColor: AdminAppColors.primaryColor,
                        onChanged: (val) {
                          setState(() {
                            _newShopAlert = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
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
                        value: _newOrderAlert,
                        activeThumbColor: AdminAppColors.primaryColor,
                        onChanged: (val) {
                          setState(() {
                            _newOrderAlert = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
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
  }
}
