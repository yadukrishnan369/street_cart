import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/clear_data_ui_cubit.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class ClearDataPage extends StatelessWidget {
  const ClearDataPage({super.key});

  void _showDoubleConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext1) => ConfirmationModal(
        title: 'Clear App Data',
        content:
            'Are you sure you want to clear all locally stored images and temporary files?',
        confirmText: 'Next',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext1);
          _showSecondConfirmation(context);
        },
        onCancel: () => Navigator.pop(dialogContext1),
      ),
    );
  }

  void _showSecondConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext2) => ConfirmationModal(
        title: 'Confirm Action',
        content:
            'Warning: This action will reset cached files and preferences. Are you absolutely sure you want to proceed?',
        confirmText: 'Clear Now',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext2);
          context.read<ClearDataUiCubit>().performClearData();
        },
        onCancel: () => Navigator.pop(dialogContext2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClearDataUiCubit>(
      create: (context) => ClearDataUiCubit(),
      child: BlocConsumer<ClearDataUiCubit, ClearDataUiState>(
        listener: (context, state) {
          if (state.isSuccess) {
            CustomSnackBar.show(
              context,
              message: 'Local cache cleared successfully.',
            );
            Navigator.pop(context);
          } else if (state.errorMessage != null) {
            CustomSnackBar.show(
              context,
              message: 'Failed to clear data: ${state.errorMessage}',
              isError: true,
            );
          }
        },
        builder: (context, state) {
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
                'Clear Data',
                style: ShopAppTextStyles.heading4.copyWith(
                  color: ShopAppColors.textPrimary,
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
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_sweep_outlined,
                      size: 56.sp,
                      color: ShopAppColors.primary,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Clear App Data?',
                    style: ShopAppTextStyles.heading2.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
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
                          color: ShopAppColors.textSecondary,
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'This will remove all locally stored images and temporary files. Your ',
                          ),
                          TextSpan(
                            text: 'Street Cart',
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
                  PrimaryButton(
                    text: 'Clear Data Now',
                    backgroundColor: ShopAppColors.primary,
                    textStyle: ShopAppTextStyles.buttonText,
                    isLoading: state.isClearing,
                    onPressed: () => _showDoubleConfirmation(context),
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: ShopAppTextStyles.bodyMediumBold.copyWith(
                        color: ShopAppColors.textSecondary,
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
                        color: const Color(0xFF90A4AE),
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'SERVER SYNC PROTECTED',
                        style: ShopAppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF90A4AE),
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
      ),
    );
  }
}
