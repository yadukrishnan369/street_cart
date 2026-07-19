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
import 'package:street_cart/features/shop/settings/presentation/widgets/shop_settings_sections.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Shop Settings Page
class ShopSettingsPage extends StatelessWidget {
  final ShopAuthBloc authBloc;

  const ShopSettingsPage({super.key, required this.authBloc});

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
          CustomSnackBar.show(context, message: state.message ?? 'An error occurred', isError: true);
        }
      },
      builder: (context, profileState) {
        ShopProfileModel? profile;
        if (profileState.status == ShopProfileStatus.loaded) {
          profile = profileState.profile;
        } else if (profileState.status == ShopProfileStatus.updateSuccess) {
          profile = profileState.profile;
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
            // Page Header
            title: Text(
              'Settings',
              style: ShopAppTextStyles.heading4.copyWith(
                color: ShopAppColors.textPrimary,
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
              );
            },
          ),
        );
      },
    );
  }
}
