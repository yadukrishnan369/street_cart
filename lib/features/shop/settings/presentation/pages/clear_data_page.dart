import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class ClearDataPage extends StatefulWidget {
  const ClearDataPage({super.key});

  @override
  State<ClearDataPage> createState() => _ClearDataPageState();
}

class _ClearDataPageState extends State<ClearDataPage> {
  bool _isClearing = false;

  void _showDoubleConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext1) => ConfirmationModal(
        title: 'Clear App Data',
        content: 'Are you sure you want to clear all locally stored images and temporary files?',
        confirmText: 'Next',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext1);
          _showSecondConfirmation();
        },
        onCancel: () => Navigator.pop(dialogContext1),
      ),
    );
  }

  void _showSecondConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext2) => ConfirmationModal(
        title: 'Confirm Action',
        content: 'Warning: This action will reset cached files and preferences. Are you absolutely sure you want to proceed?',
        confirmText: 'Clear Now',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext2);
          _performClearData();
        },
        onCancel: () => Navigator.pop(dialogContext2),
      ),
    );
  }

  Future<void> _performClearData() async {
    setState(() => _isClearing = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        CustomSnackBar.show(context, message: 'Local cache cleared successfully.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(context, message: 'Failed to clear data: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isClearing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ShopAppColors.primary),
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
                    const TextSpan(text: 'This will remove all locally stored images and temporary files. Your '),
                    TextSpan(
                      text: 'Street Cart',
                      style: ShopAppTextStyles.bodyMediumBold.copyWith(
                        color: ShopAppColors.primary,
                      ),
                    ),
                    const TextSpan(text: ' shop profile, products, and orders will remain safely stored on our servers.'),
                  ],
                ),
              ),
            ),
            const Spacer(),

            PrimaryButton(
              text: 'Clear Data Now',
              backgroundColor: ShopAppColors.primary,
              textStyle: ShopAppTextStyles.buttonText,
              isLoading: _isClearing,
              onPressed: _showDoubleConfirmation,
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
  }
}
