import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_event.dart';
import 'package:street_cart/core/theme/customer/theme_cubit.dart';
import 'package:street_cart/features/customer/settings/presentation/widgets/settings_switch_tile.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

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

// App Preferences Section
class AppPreferencesSection extends StatelessWidget {
  final Map<String, dynamic> settings;
  final bool hasLocationData;

  const AppPreferencesSection({
    super.key,
    required this.settings,
    required this.hasLocationData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildSectionHeader(context, 'APP PREFERENCES'),
        SettingsSwitchTile(
          icon: Icons.nightlight_round,
          iconColor: CustomerAppColors.primary,
          backgroundColor: CustomerAppColors.primary.withValues(alpha: 0.1),
          title: 'Dark Mode',
          value: settings['darkMode'] ?? false,
          onChanged: (val) {
            context.read<SettingsBloc>().add(
              ToggleSetting(key: 'darkMode', value: val),
            );
            context.read<ThemeCubit>().toggleTheme(val);
          },
        ),
        if (hasLocationData)
          // Settings Switch Tile
          SettingsSwitchTile(
            icon: Icons.location_on_outlined,
            iconColor: CustomerAppColors.primary,
            backgroundColor: CustomerAppColors.primary.withValues(alpha: 0.1),
            title: 'Location Services',
            value: settings['locationServices'] ?? true,
            onChanged: (val) {
              if (val == false) {
                // Confirmation for Disable Location
                showDialog(
                  context: context,
                  builder: (dialogContext) => ConfirmationModal(
                    title: 'Disable Location?',
                    content:
                        'Are you sure you want to disable location services? You might miss out on nearby shop updates.',
                    onConfirm: () {
                      context.read<SettingsBloc>().add(
                        ToggleSetting(key: 'locationServices', value: false),
                      );
                      Navigator.pop(dialogContext);
                    },
                    onCancel: () => Navigator.pop(dialogContext),
                  ),
                );
              } else {
                context.read<SettingsBloc>().add(
                  ToggleSetting(key: 'locationServices', value: true),
                );
              }
            },
          ),
      ],
    );
  }
}
