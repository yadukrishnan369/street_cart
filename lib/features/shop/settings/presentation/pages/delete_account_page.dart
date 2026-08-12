import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/delete_account_form.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Delete Account Page
class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopSettingsBloc, ShopSettingsState>(
      listener: (BuildContext context, ShopSettingsState state) {
        if (state.status == ShopSettingsStatus.deleteAccountSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Account deleted successfully.',
          );
          Navigator.pushAndRemoveUntil(
            context,
            AppPageTransitions.slide(const ShopLoginPage()),
            (Route<dynamic> route) => false,
          );
        } else if (state.status == ShopSettingsStatus.failure) {
          CustomSnackBar.show(
            context,
            message: state.errorMessage ?? 'Failed to delete account',
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
              'Delete Account',
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
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Title and Info
                Text(
                  'Verify Identity',
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
                  'For security, you must enter your current password to confirm account deletion. This process cannot be undone.',
                  style: ShopAppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? ShopAppColors.darkTextSecondary
                        : ShopAppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 32.h),

                // Delete Account form
                DeleteAccountForm(isLoading: isLoading),
                SizedBox(height: 24.h),

                // Info Tip
                const _DeleteWarningTipCard(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Delete Warning Tip Card
class _DeleteWarningTipCard extends StatelessWidget {
  const _DeleteWarningTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F9),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFE0E0), width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.info_outline_rounded, color: Color(0xFFD32F2F)),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Please make sure you have backed up all store inventory details. This operation permanently deletes all data linked to your shop owner profile.',
              style: ShopAppTextStyles.bodySmall.copyWith(
                color: const Color(0xFFC62828),
                height: 1.4,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
