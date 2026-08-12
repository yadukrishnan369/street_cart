import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/core/theme/shop/shop_theme_cubit.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/setting_card_widgets.dart';
import 'package:street_cart/features/shop/settings/presentation/pages/delivery_radius_settings_page.dart';
import 'package:street_cart/features/shop/settings/presentation/pages/change_password_page.dart';
import 'package:street_cart/features/shop/settings/presentation/pages/delete_account_page.dart';
import 'package:street_cart/features/shop/settings/presentation/pages/clear_data_page.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Business Configuration Section
class BusinessConfigurationSection extends StatelessWidget {
  final ShopProfileModel? profile;

  const BusinessConfigurationSection({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingSectionHeader(title: 'BUSINESS CONFIGURATION'),
        SettingSectionCard(
          children: [
            SettingRowItem(
              icon: Icons.my_location_outlined,
              // Title
              title: 'Delivery Radius Setup',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Delivery Area Distance
                  Text(
                    profile != null
                        ? '${profile!.deliveryRadius.toStringAsFixed(1)} km'
                        : '5.0 km',
                    style: ShopAppTextStyles.bodyMediumBold.copyWith(
                      color: ShopAppColors.primary,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12.sp,
                    color: ShopAppColors.textSecondary,
                  ),
                ],
              ),
              onTap: () {
                if (profile != null) {
                  // Navigate to Delivery Radius Settings Page
                  Navigator.push(
                    context,
                    AppPageTransitions.slide(
                      DeliveryRadiusSettingsPage(
                        profile: profile!,
                        profileBloc: context.read<ShopProfileBloc>(),
                        settingsBloc: context.read<ShopSettingsBloc>(),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Preference Section
class PreferencesSection extends StatelessWidget {
  final ShopSettingsState uiState;

  const PreferencesSection({super.key, required this.uiState});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const SettingSectionHeader(title: 'PREFERENCES'),
        SettingSectionCard(
          children: [
            SettingRowItem(
              icon: Icons.nightlight_outlined,
              title: 'Dark Mode',
              // Theme Switch
              trailing: SettingCustomSwitch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (val) {
                  context.read<ShopSettingsBloc>().add(
                    ToggleAppThemeEvent(val),
                  );
                  context.read<ShopThemeCubit>().toggleTheme(val);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Notifications Section
class NotificationsSection extends StatelessWidget {
  final ShopSettingsState uiState;

  const NotificationsSection({super.key, required this.uiState});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const SettingSectionHeader(title: 'NOTIFICATIONS'),
        SettingSectionCard(
          children: [
            SettingRowItem(
              icon: Icons.notifications_none_outlined,
              title: 'General Notifications',
              // Push Notification Switch
              trailing: SettingCustomSwitch(
                value: uiState.pushNotifications,
                onChanged: (val) => context.read<ShopSettingsBloc>().add(
                  TogglePushNotificationsEvent(val),
                ),
              ),
            ),
            const SettingRowDivider(),
            SettingRowItem(
              icon: Icons.campaign_outlined,
              // Title
              title: 'Order Alerts',
              // Order Alert Switch
              trailing: SettingCustomSwitch(
                value: uiState.orderAlerts,
                onChanged: (val) => context.read<ShopSettingsBloc>().add(
                  ToggleOrderAlertsEvent(val),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Security Section
class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const SettingSectionHeader(title: 'SECURITY'),
        SettingSectionCard(
          children: [
            SettingRowItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 12.sp,
                color: ShopAppColors.textSecondary,
              ),
              onTap: () {
                final settingsBloc = context.read<ShopSettingsBloc>();
                // Navigate to Change Password Page
                Navigator.push(
                  context,
                  AppPageTransitions.slide(
                    BlocProvider.value(
                      value: settingsBloc,
                      child: const ChangePasswordPage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Account Management Section
class AccountManagementSection extends StatelessWidget {
  const AccountManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const SettingSectionHeader(title: 'ACCOUNT MANAGEMENT'),
        SettingSectionCard(
          children: [
            SettingRowItem(
              icon: Icons.block_outlined,
              iconBgColor: isDark
                  ? ShopAppColors.darkBorder
                  : const Color(0xFFFFEBEE),
              iconColor: const Color(0xFFD32F2F),
              // Title
              title: 'Delete Account',
              titleColor: const Color(0xFFD32F2F),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 12.sp,
                color: const Color(0xFFD32F2F),
              ),
              onTap: () {
                final settingsBloc = context.read<ShopSettingsBloc>();
                // Navigate to Delete Account Page
                Navigator.push(
                  context,
                  AppPageTransitions.slide(
                    BlocProvider.value(
                      value: settingsBloc,
                      child: const DeleteAccountPage(),
                    ),
                  ),
                );
              },
            ),
            const SettingRowDivider(),
            // Title
            SettingRowItem(
              icon: Icons.storage_outlined,
              title: 'Clear Data',
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 12.sp,
                color: ShopAppColors.textSecondary,
              ),
              onTap: () {
                final settingsBloc = context.read<ShopSettingsBloc>();
                // Navigate to Clear Data Page
                Navigator.push(
                  context,
                  AppPageTransitions.slide(
                    BlocProvider.value(
                      value: settingsBloc,
                      child: ClearDataPage(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
