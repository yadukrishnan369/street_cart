import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/services/app_info_service.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/utils/shop_settings_helper.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Clear Data Page
class ClearDataPage extends StatelessWidget {
  final IAppInfoService _appInfoService = sl<IAppInfoService>();
  ClearDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopSettingsBloc, ShopSettingsState>(
      listener: (context, state) {
        if (state.isClearDataSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Local cache cleared successfully.',
          );
          Navigator.pop(context);
        } else if (state.clearDataError != null) {
          CustomSnackBar.show(
            context,
            message: 'Failed to clear data: ${state.clearDataError}',
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

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
              'Clear Data',
              style: ShopAppTextStyles.heading4.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextPrimary
                    : ShopAppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(28.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ShopAppColors.primary.withValues(alpha: 0.15)
                        : const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_sweep_outlined,
                    size: 56.sp,
                    color: ShopAppColors.primary,
                  ),
                ),
                SizedBox(height: 32.h),
                // Title and Clear Data Info
                Text(
                  'Clear App Data?',
                  style: ShopAppTextStyles.heading2.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: ShopAppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : ShopAppColors.textSecondary,
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'This will remove all locally stored images and temporary files. Your ',
                        ),
                        TextSpan(
                          text: 'STREET CART',
                          style: ShopAppTextStyles.bodyMediumBold.copyWith(
                            color: ShopAppColors.primary,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' shop profile, products, and orders will remain safely stored on our servers.',
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Button for Clear Data
                PrimaryButton(
                  text: 'Clear Data Now',
                  backgroundColor: ShopAppColors.primary,
                  textStyle: ShopAppTextStyles.buttonText,
                  isLoading: state.isClearingData,
                  onPressed: () {
                    ShopSettingsHelper.showDoubleConfirmation(
                      context: context,
                      onConfirm: () {
                        context.read<ShopSettingsBloc>().add(
                          PerformClearDataEvent(),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: ShopAppTextStyles.bodyMediumBold.copyWith(
                      color: isDark
                          ? ShopAppColors.darkTextSecondary
                          : ShopAppColors.textSecondary,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: isDark
                          ? ShopAppColors.darkTextSecondary
                          : const Color(0xFF90A4AE),
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    // Footer App name
                    Text(
                      '${_appInfoService.appName.toUpperCase()}',
                      style: ShopAppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : const Color(0xFF90A4AE),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8.sp,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
