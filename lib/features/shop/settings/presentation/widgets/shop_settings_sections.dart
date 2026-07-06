import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_ui_cubit.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/setting_card_widgets.dart';
import 'package:street_cart/features/shop/settings/presentation/pages/delivery_radius_settings_page.dart';
import 'package:street_cart/features/shop/settings/presentation/pages/change_password_page.dart';
import 'package:street_cart/features/shop/settings/presentation/pages/delete_account_page.dart';
import 'package:street_cart/features/shop/settings/presentation/pages/clear_data_page.dart';

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
              title: 'Delivery Radius Setup',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeliveryRadiusSettingsPage(
                        profile: profile!,
                        profileBloc: context.read<ShopProfileBloc>(),
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

class PreferencesSection extends StatelessWidget {
  final ShopSettingsUiState uiState;

  const PreferencesSection({super.key, required this.uiState});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingSectionHeader(title: 'PREFERENCES'),
        SettingSectionCard(
          children: [
            SettingRowItem(
              icon: Icons.nightlight_outlined,
              title: 'App Theme',
              trailing: SettingCustomSwitch(
                value: uiState.appTheme,
                onChanged: (val) =>
                    context.read<ShopSettingsUiCubit>().toggleAppTheme(val),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NotificationsSection extends StatelessWidget {
  final ShopSettingsUiState uiState;

  const NotificationsSection({super.key, required this.uiState});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingSectionHeader(title: 'NOTIFICATIONS'),
        SettingSectionCard(
          children: [
            SettingRowItem(
              icon: Icons.notifications_none_outlined,
              title: 'Push Notifications',
              trailing: SettingCustomSwitch(
                value: uiState.pushNotifications,
                onChanged: (val) => context
                    .read<ShopSettingsUiCubit>()
                    .togglePushNotifications(val),
              ),
            ),
            const SettingRowDivider(),
            SettingRowItem(
              icon: Icons.campaign_outlined,
              title: 'Order Alerts',
              trailing: SettingCustomSwitch(
                value: uiState.orderAlerts,
                onChanged: (val) =>
                    context.read<ShopSettingsUiCubit>().toggleOrderAlerts(val),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
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

class AccountManagementSection extends StatelessWidget {
  const AccountManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingSectionHeader(title: 'ACCOUNT MANAGEMENT'),
        SettingSectionCard(
          children: [
            SettingRowItem(
              icon: Icons.block_outlined,
              iconBgColor: const Color(0xFFFFEBEE),
              iconColor: const Color(0xFFD32F2F),
              title: 'Delete Account',
              titleColor: const Color(0xFFD32F2F),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 12.sp,
                color: const Color(0xFFD32F2F),
              ),
              onTap: () {
                final settingsBloc = context.read<ShopSettingsBloc>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: settingsBloc,
                      child: const DeleteAccountPage(),
                    ),
                  ),
                );
              },
            ),
            const SettingRowDivider(),
            SettingRowItem(
              icon: Icons.storage_outlined,
              title: 'Clear Data',
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 12.sp,
                color: ShopAppColors.textSecondary,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClearDataPage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
