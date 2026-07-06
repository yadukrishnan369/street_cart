import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/delete_account_ui_cubit.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_event.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class DeleteAccountForm extends StatefulWidget {
  final bool isLoading;

  const DeleteAccountForm({super.key, required this.isLoading});

  @override
  State<DeleteAccountForm> createState() => _DeleteAccountFormState();
}

class _DeleteAccountFormState extends State<DeleteAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

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
        title: 'Delete Account?',
        content:
            'Are you sure you want to permanently delete your merchant account? This action cannot be undone.',
        confirmText: 'Yes, Delete',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          _confirmDeleteDouble();
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  void _confirmDeleteDouble() {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Permanently Erase Data?',
        content:
            'Warning: This action will permanently erase your store profile, active products, and past order records. Proceed?',
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
    return Form(
      key: _formKey,
      child: BlocBuilder<DeleteAccountUiCubit, DeleteAccountUiState>(
        builder: (context, uiState) {
          final cubit = context.read<DeleteAccountUiCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Password input field
              CustomTextField(
                label: 'Password',
                controller: _passwordController,
                hintText: 'Enter your password',
                isPassword: uiState.obscurePassword,
                labelStyle: ShopAppTextStyles.bodyMediumBold,
                textStyle: ShopAppTextStyles.bodyMedium,
                fillColor: const Color(0xFFF8F9FA),
                borderColor: ShopAppColors.border,
                focusedBorderColor: const Color(0xFFD32F2F),
                suffixIcon: IconButton(
                  icon: Icon(
                    uiState.obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: ShopAppColors.textTertiary,
                    size: 20.sp,
                  ),
                  onPressed: cubit.toggleObscurePassword,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Password verification is required';
                  }
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
                  border: Border.all(
                    color: const Color(0xFFFFCDD2),
                    width: 0.8,
                  ),
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
                isLoading: widget.isLoading,
                suffixIcon: Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: _confirmDelete,
              ),
            ],
          );
        },
      ),
    );
  }
}
