import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_event.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_state.dart';
import 'package:street_cart/features/customer/profile/presentation/pages/saved_addresses_page.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Account Profile Settings Section
class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final orderUpdates = state is ProfileLoaded ? state.orderUpdates : true;
        final offersPromotions = state is ProfileLoaded
            ? state.offersPromotions
            : false;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACCOUNT SETTINGS',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : Colors.grey.shade600,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? CustomerAppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    // Navigate to SavedAddress Page
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          AppPageTransitions.slide(
                            BlocProvider(
                              create: (context) => sl<AddressBloc>(),
                              child: const SavedAddressesPage(),
                            ),
                          ),
                        );
                      },
                      // Saved Address Section
                      child: _buildSettingTile(
                        context: context,
                        icon: Icons.map_outlined,
                        title: 'Saved Addresses',
                        subtitle: 'Manage delivery locations',
                        iconBgColor: CustomerAppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        iconColor: CustomerAppColors.primary,
                        trailing: Icon(
                          Icons.chevron_right,
                          color: isDark
                              ? CustomerAppColors.darkTextSecondary
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 64.w,
                      color: isDark
                          ? CustomerAppColors.darkBorder
                          : Colors.grey.shade100,
                    ),
                    // Notifications Section
                    _buildSettingTile(
                      context: context,
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      iconBgColor: CustomerAppColors.primary.withValues(
                        alpha: 0.1,
                      ),
                      iconColor: CustomerAppColors.primary,
                      trailing: const SizedBox(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 64.w,
                        right: 16.w,
                        bottom: 16.h,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order Updates',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isDark
                                      ? CustomerAppColors.darkTextPrimary
                                      : CustomerAppColors.textPrimary,
                                ),
                              ),
                              SizedBox(
                                height: 24.h,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: orderUpdates,
                                    onChanged: (val) => context
                                        .read<ProfileBloc>()
                                        .add(ToggleOrderUpdatesEvent(val)),
                                    activeThumbColor: CustomerAppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Offers & Promotions',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isDark
                                      ? CustomerAppColors.darkTextPrimary
                                      : CustomerAppColors.textPrimary,
                                ),
                              ),
                              SizedBox(
                                height: 24.h,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: offersPromotions,
                                    onChanged: (val) => context
                                        .read<ProfileBloc>()
                                        .add(ToggleOffersPromotionsEvent(val)),
                                    activeThumbColor: CustomerAppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required Color iconBgColor,
    required Color iconColor,
    required Widget trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? CustomerAppColors.darkTextPrimary
                        : CustomerAppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isDark
                          ? CustomerAppColors.darkTextSecondary
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
