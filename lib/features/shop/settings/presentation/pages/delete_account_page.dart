import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_event.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_state.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _confirmDelete() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Delete Account Permanent',
        content: 'Warning: This action will permanently erase your merchant store data and credentials. Are you absolutely sure?',
        confirmText: 'Delete Permanently',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          _performDelete();
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  void _performDelete() {
    context.read<ShopSettingsBloc>().add(
          DeleteAccountRequested(password: _passwordController.text.trim()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopSettingsBloc, ShopSettingsState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          CustomSnackBar.show(context, message: 'Account deleted successfully.');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ShopLoginPage()),
            (route) => false,
          );
        } else if (state is ShopSettingsFailure) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is ShopSettingsLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ShopAppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Delete Account',
              style: ShopAppTextStyles.heading4.copyWith(
                color: ShopAppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verify Identity',
                    style: ShopAppTextStyles.heading2.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'For security, you must enter your current password to confirm account deletion. This process cannot be undone.',
                    style: ShopAppTextStyles.bodyMedium.copyWith(
                      color: ShopAppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Password input field
                  CustomTextField(
                    label: 'Password',
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    isPassword: _obscurePassword,
                    labelStyle: ShopAppTextStyles.bodyMediumBold,
                    textStyle: ShopAppTextStyles.bodyMedium,
                    fillColor: const Color(0xFFF8F9FA),
                    borderColor: ShopAppColors.border,
                    focusedBorderColor: const Color(0xFFD32F2F),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: ShopAppColors.textTertiary,
                        size: 20.sp,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Password verification is required';
                      return null;
                    },
                  ),
                  SizedBox(height: 40.h),

                  // Alert container
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFFFCDD2), width: 0.8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFD32F2F),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Confirming deletion will immediately remove your store profile, active products, and past order records from the platform.',
                            style: ShopAppTextStyles.bodySmall.copyWith(
                              color: const Color(0xFFC62828),
                              height: 1.4,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 48.h),

                  // Action button
                  PrimaryButton(
                    text: 'Delete Account',
                    backgroundColor: const Color(0xFFD32F2F),
                    textStyle: ShopAppTextStyles.buttonText,
                    isLoading: isLoading,
                    suffixIcon: Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    onPressed: _confirmDelete,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
