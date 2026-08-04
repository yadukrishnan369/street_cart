import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/services/app_info_service.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_state.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/shop_settings_sections.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';

// Shop Settings Page
class ShopSettingsPage extends StatelessWidget {
  final IAppInfoService _appInfoService = sl<IAppInfoService>();
  final ShopAuthBloc authBloc;

  ShopSettingsPage({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopProfileBloc, ShopProfileState>(
      listener: (context, state) {
        if (state.status == ShopProfileStatus.updateSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Settings updated successfully!',
          );
        } else if (state.status == ShopProfileStatus.error) {
          CustomSnackBar.show(
            context,
            message: state.message ?? 'An error occurred',
            isError: true,
          );
        }
      },
      builder: (context, profileState) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        if (profileState.status == ShopProfileStatus.error &&
            profileState.profile == null) {
          return Scaffold(
            backgroundColor: isDark
                ? ShopAppColors.darkBackground
                : const Color(0xFFF8F9FA),
            appBar: AppBar(
              backgroundColor: isDark
                  ? ShopAppColors.darkBackground
                  : Colors.white,
              elevation: isDark ? null : 1.5,
              title: Text(
                'Settings',
                style: TextStyle(
                  color: isDark ? ShopAppColors.darkTextPrimary : Colors.black,
                ),
              ),
            ),
            // Showing Error View
            body: AppErrorView(
              message: profileState.message ?? 'Failed to load configuration.',
              onRetry: () {
                context.read<ShopProfileBloc>().add(FetchShopProfileData());
              },
            ),
          );
        }

        ShopProfileModel? profile;
        if (profileState.status == ShopProfileStatus.loaded) {
          profile = profileState.profile;
        } else if (profileState.status == ShopProfileStatus.updateSuccess) {
          profile = profileState.profile;
        }

        return Scaffold(
          backgroundColor: isDark
              ? ShopAppColors.darkBackground
              : const Color(0xFFF8F9FA),
          appBar: AppBar(
            backgroundColor: isDark
                ? ShopAppColors.darkBackground
                : Colors.white,
            elevation: isDark ? null : 1.5,
            shape: Border(
              bottom: BorderSide(
                color: isDark
                    ? ShopAppColors.darkBorder
                    : ShopAppColors.border.withValues(alpha: 1.5),
                width: 0.5,
              ),
            ),
            // Page Header
            title: Text(
              'Settings',
              style: ShopAppTextStyles.heading4.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextPrimary
                    : ShopAppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: BlocBuilder<ShopSettingsBloc, ShopSettingsState>(
            builder: (context, uiState) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Business Configuration Section
                    BusinessConfigurationSection(profile: profile),
                    SizedBox(height: 24.h),
                    // Preferences Section
                    PreferencesSection(uiState: uiState),
                    SizedBox(height: 24.h),
                    // Notifications Section
                    NotificationsSection(uiState: uiState),
                    SizedBox(height: 24.h),
                    // Security Section
                    const SecuritySection(),
                    SizedBox(height: 24.h),
                    // Account Management Section
                    const AccountManagementSection(),
                    SizedBox(height: 32.h),
                    Center(
                      // Footer App Info
                      child: Text(
                        '${_appInfoService.appName} Seller App v${_appInfoService.version}',
                        style: ShopAppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? ShopAppColors.darkTextSecondary
                              : ShopAppColors.textTertiary,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
