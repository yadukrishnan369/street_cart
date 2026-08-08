import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/services/app_info_service.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_event.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_state.dart';
import 'package:street_cart/features/customer/settings/presentation/utils/settings_helper.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Customer Clear Data Page
class ClearDataPage extends StatelessWidget {
  final IAppInfoService _appInfoService = sl<IAppInfoService>();
  ClearDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsClearDataSuccess) {
          // Reload settings state
          context.read<SettingsBloc>().add(FetchSettingsData());

          CustomSnackBar.show(
            context,
            message: 'Local app data cleared successfully!',
            backgroundColor: CustomerAppColors.success,
          );
          Navigator.pop(context);
        } else if (state is SettingsError) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final isClearing = state is SettingsClearingData;

        return Scaffold(
          backgroundColor: isDark
              ? CustomerAppColors.darkBackground
              : const Color(0xFFF8F9FA),
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            // Page Header
            title: Text(
              'Clear Data',
              style: CustomerAppTextStyles.heading2.copyWith(
                fontSize: 20.sp,
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.textPrimary,
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
                        ? CustomerAppColors.primary.withValues(alpha: 0.15)
                        : const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_sweep_outlined,
                    size: 56.sp,
                    color: CustomerAppColors.primary,
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  'Clear App Data?',
                  style: CustomerAppTextStyles.heading2.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? CustomerAppColors.darkTextPrimary
                        : CustomerAppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: CustomerAppTextStyles.body.copyWith(
                        color: isDark
                            ? CustomerAppColors.darkTextSecondary
                            : CustomerAppColors.textSecondary,
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'This will remove all locally stored images, search history, and temporary preferences. Your ',
                        ),
                        TextSpan(
                          text: '${_appInfoService.appName.toUpperCase()}',
                          style: CustomerAppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CustomerAppColors.primary,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' profile details, cart, and orders will remain safely stored on our servers.',
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'Clear Data Now',
                  backgroundColor: CustomerAppColors.primary,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  isLoading: isClearing,
                  onPressed: () => SettingsHelper.showClearConfirm(context),
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: CustomerAppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? CustomerAppColors.darkTextSecondary
                          : CustomerAppColors.textSecondary,
                    ),
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
