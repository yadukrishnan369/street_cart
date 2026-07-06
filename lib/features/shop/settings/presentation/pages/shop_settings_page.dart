import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_state.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_ui_cubit.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/shop_settings_sections.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ShopSettingsPage extends StatelessWidget {
  final ShopAuthBloc authBloc;

  const ShopSettingsPage({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShopSettingsUiCubit(),
      child: BlocConsumer<ShopProfileBloc, ShopProfileState>(
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
        builder: (context, profileState) {
          ShopProfileModel? profile;
          if (profileState is ShopProfileLoaded) {
            profile = profileState.profile;
          } else if (profileState is ShopProfileUpdateSuccess) {
            profile = profileState.profile;
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: ShopAppColors.primary,
                ),
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
            body: BlocBuilder<ShopSettingsUiCubit, ShopSettingsUiState>(
              builder: (context, uiState) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BusinessConfigurationSection(profile: profile),
                      SizedBox(height: 24.h),
                      PreferencesSection(uiState: uiState),
                      SizedBox(height: 24.h),
                      NotificationsSection(uiState: uiState),
                      SizedBox(height: 24.h),
                      const SecuritySection(),
                      SizedBox(height: 24.h),
                      const AccountManagementSection(),
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
