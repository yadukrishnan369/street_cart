import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/change_password_form.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Change Password Page
class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopSettingsBloc, ShopSettingsState>(
      listener: (BuildContext context, ShopSettingsState state) {
        if (state.status == ShopSettingsStatus.changePasswordSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Password updated successfully!',
          );
          Navigator.pop(context);
        } else if (state.status == ShopSettingsStatus.failure) {
          CustomSnackBar.show(
            context,
            message: state.errorMessage ?? 'Failed to change password',
            isError: true,
          );
        }
      },
      builder: (BuildContext context, ShopSettingsState state) {
        final bool isLoading = state.status == ShopSettingsStatus.loading;

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark ? ShopAppColors.darkBackground : Colors.white,
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
              'Change Password',
              style: ShopAppTextStyles.heading4.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextPrimary
                    : ShopAppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header Title and Subtitle
                Text(
                  'Secure Your Account',
                  style: ShopAppTextStyles.heading2.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Enter your current password and choose a new strong password to update your shop owner credentials.',
                  style: ShopAppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? ShopAppColors.darkTextSecondary
                        : ShopAppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 32.h),

                // Change Password Form
                ChangePasswordForm(isLoading: isLoading),
                SizedBox(height: 24.h),

                // Security Tip Card
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ShopAppColors.darkSurface
                        : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark
                          ? ShopAppColors.darkBorder
                          : const Color(0xFFECEFF1),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.shield_outlined,
                        color: ShopAppColors.primary,
                        size: 22.sp,
                      ),
                      SizedBox(width: 14.w),
                      // New Password Tips
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Security Tip',
                              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                                color: ShopAppColors.primary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Mix uppercase letters, numbers, and symbols to create a strong password. Avoid using common words or birthdates.',
                              style: ShopAppTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? ShopAppColors.darkTextSecondary
                                    : ShopAppColors.textSecondary,
                                height: 1.4,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
