import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_state.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'change_password_page.dart';
import 'clear_data_page.dart';
import 'delete_account_page.dart';
import 'delivery_radius_settings_page.dart';

class ShopSettingsPage extends StatefulWidget {
  final ShopAuthBloc authBloc;

  const ShopSettingsPage({
    super.key,
    required this.authBloc,
  });

  @override
  State<ShopSettingsPage> createState() => _ShopSettingsPageState();
}

class _ShopSettingsPageState extends State<ShopSettingsPage> {
  bool _appTheme = false;
  bool _pushNotifications = true;
  bool _orderAlerts = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopProfileBloc, ShopProfileState>(
      listener: (context, state) {
        if (state is ShopProfileUpdateSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Settings updated successfully!',
          );
        } else if (state is ShopProfileError) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        ShopProfileModel? profile;
        if (state is ShopProfileLoaded) {
          profile = state.profile;
        } else if (state is ShopProfileUpdateSuccess) {
          profile = state.profile;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ShopAppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Settings',
              style: ShopAppTextStyles.heading4.copyWith(
                color: ShopAppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('BUSINESS CONFIGURATION'),
                _buildSectionCard(
                  children: [
                    _buildSettingRow(
                      icon: Icons.my_location_outlined,
                      title: 'Delivery Radius Setup',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            profile != null
                                ? '${profile.deliveryRadius.toStringAsFixed(1)} km'
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
                SizedBox(height: 24.h),

                _buildSectionHeader('PREFERENCES'),
                _buildSectionCard(
                  children: [
                    _buildSettingRow(
                      icon: Icons.nightlight_outlined,
                      title: 'App Theme',
                      trailing: _buildCustomSwitch(
                        value: _appTheme,
                        onChanged: (val) => setState(() => _appTheme = val),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                _buildSectionHeader('NOTIFICATIONS'),
                _buildSectionCard(
                  children: [
                    _buildSettingRow(
                      icon: Icons.notifications_none_outlined,
                      title: 'Push Notifications',
                      trailing: _buildCustomSwitch(
                        value: _pushNotifications,
                        onChanged: (val) =>
                            setState(() => _pushNotifications = val),
                      ),
                    ),
                    _buildRowDivider(),
                    _buildSettingRow(
                      icon: Icons.campaign_outlined,
                      title: 'Order Alerts',
                      trailing: _buildCustomSwitch(
                        value: _orderAlerts,
                        onChanged: (val) => setState(() => _orderAlerts = val),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                _buildSectionHeader('SECURITY'),
                _buildSectionCard(
                  children: [
                    _buildSettingRow(
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
                SizedBox(height: 24.h),

                _buildSectionHeader('ACCOUNT MANAGEMENT'),
                _buildSectionCard(
                  children: [
                    _buildSettingRow(
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
                    _buildRowDivider(),
                    _buildSettingRow(
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
                          MaterialPageRoute(
                            builder: (_) => const ClearDataPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                Center(
                  child: Text(
                    'Street Cart Seller App v2.4.0',
                    style: ShopAppTextStyles.bodySmall.copyWith(
                      color: ShopAppColors.textTertiary,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, left: 4.w),
      child: Text(
        title,
        style: ShopAppTextStyles.bodySmall.copyWith(
          color: ShopAppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 11.sp,
          letterSpacing: 0.5.sp,
        ),
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    Color? iconBgColor,
    Color? iconColor,
    Color? titleColor,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconBgColor ?? const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: iconColor ?? ShopAppColors.primary,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: titleColor ?? ShopAppColors.textPrimary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildRowDivider() {
    return Divider(
      color: const Color(0xFFECEFF1),
      height: 1,
      thickness: 0.8,
      indent: 56.w,
    );
  }

  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 24.h,
      child: Transform.scale(
        scale: 0.75,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: ShopAppColors.primary,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFCFD8DC),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
