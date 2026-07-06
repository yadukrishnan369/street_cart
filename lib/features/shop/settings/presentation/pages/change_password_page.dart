import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/change_password_ui_cubit.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_state.dart';
import 'package:street_cart/features/shop/settings/presentation/widgets/change_password_form.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChangePasswordUiCubit>(
          create: (BuildContext context) => ChangePasswordUiCubit(),
        ),
      ],
      child: BlocConsumer<ShopSettingsBloc, ShopSettingsState>(
        listener: (BuildContext context, ShopSettingsState state) {
          if (state is ChangePasswordSuccess) {
            CustomSnackBar.show(
              context,
              message: 'Password updated successfully!',
            );
            Navigator.pop(context);
          } else if (state is ShopSettingsFailure) {
            CustomSnackBar.show(context, message: state.message, isError: true);
          }
        },
        builder: (BuildContext context, ShopSettingsState state) {
          final bool isLoading = state is ShopSettingsLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: ShopAppColors.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Change Password',
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
                children: <Widget>[
                  // Header Title
                  Text(
                    'Secure Your Account',
                    style: ShopAppTextStyles.heading2.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Enter your current password and choose a new strong password to update your shop owner credentials.',
                    style: ShopAppTextStyles.bodyMedium.copyWith(
                      color: ShopAppColors.textSecondary,
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
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFFECEFF1),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Security Tip',
                                style: ShopAppTextStyles.bodyMediumBold
                                    .copyWith(color: ShopAppColors.primary),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Mix uppercase letters, numbers, and symbols to create a strong password. Avoid using common words or birthdates.',
                                style: ShopAppTextStyles.bodySmall.copyWith(
                                  color: ShopAppColors.textSecondary,
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
      ),
    );
  }
}
