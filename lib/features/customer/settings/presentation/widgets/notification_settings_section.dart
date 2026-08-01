import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_event.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/settings_switch_tile.dart';

Widget _buildSectionHeader(BuildContext context, String text) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: EdgeInsets.only(left: 16.w, top: 24.h, bottom: 8.h),
    child: Text(
      text,
      style: CustomerAppTextStyles.body.copyWith(
        color: isDark
            ? CustomerAppColors.darkTextSecondary
            : CustomerAppColors.textSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  );
}

// Notification Settings Section
class NotificationSettingsSection extends StatelessWidget {
  final Map<String, dynamic> settings;

  const NotificationSettingsSection({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildSectionHeader(context, 'NOTIFICATION SETTINGS'),

        // Settings Switch Tile
        SettingsSwitchTile(
          icon: Icons.notifications_none_outlined,
          iconColor: CustomerAppColors.primary,
          backgroundColor: CustomerAppColors.primary.withValues(alpha: 0.1),
          title: 'Push Notifications',
          value: settings['pushNotifications'] ?? true,
          onChanged: (val) {
            context.read<SettingsBloc>().add(
              ToggleSetting(key: 'pushNotifications', value: val),
            );
          },
        ),

        // Settings Switch Tile
        SettingsSwitchTile(
          icon: Icons.shopping_bag_outlined,
          iconColor: CustomerAppColors.primary,
          backgroundColor: CustomerAppColors.primary.withValues(alpha: 0.1),
          title: 'Order Alerts',
          value: settings['orderAlerts'] ?? true,
          onChanged: (val) {
            context.read<SettingsBloc>().add(
              ToggleSetting(key: 'orderAlerts', value: val),
            );
          },
        ),
      ],
    );
  }
}
