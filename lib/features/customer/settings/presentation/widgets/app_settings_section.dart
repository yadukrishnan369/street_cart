import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/settings_action_tile.dart';

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

// App Settings Section
class AppSettingsSection extends StatelessWidget {
  const AppSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'APP SETTINGS'),
        SettingsActionTile(
          icon: Icons.cleaning_services_outlined,
          iconColor: CustomerAppColors.primary,
          backgroundColor: CustomerAppColors.primary.withValues(alpha: 0.1),
          title: 'Clear Data',
          showArrow: true,
          onTap: () {
            // clear data logic
          },
        ),
      ],
    );
  }
}
