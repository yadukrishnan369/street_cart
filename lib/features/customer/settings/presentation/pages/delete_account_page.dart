import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/delete_account_ui_cubit.dart';

class DeleteAccountPage extends StatefulWidget {
  final bool isEmailUser;
  const DeleteAccountPage({super.key, required this.isEmailUser});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _confirmDelete() {
    if (widget.isEmailUser && !_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Delete Account?',
        content:
            'Are you sure you want to permanently delete your account? This action cannot be undone.',
        confirmText: 'Yes, Delete',
        confirmColor: Colors.red,
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
        title: 'Permanently Erase All Data?',
        content:
            'Warning: This will immediately delete all your profile details, orders history, and addresses. Proceed?',
        confirmText: 'Delete Permanently',
        confirmColor: Colors.red,
        onConfirm: () {
          Navigator.pop(dialogContext);
          _performDelete();
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  void _performDelete() {
    context.read<AuthBloc>().add(
      DeleteAccountRequested(
        widget.isEmailUser ? _passwordController.text.trim() : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeleteAccountUiCubit(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAccountDeleted) {
            CustomSnackBar.show(
              context,
              message: 'Account deleted successfully.',
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          } else if (state is AuthError) {
            CustomSnackBar.show(context, message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return BlocBuilder<DeleteAccountUiCubit, DeleteAccountUiState>(
            builder: (context, uiState) {
              return Scaffold(
                backgroundColor: CustomerAppColors.background,
                appBar: AppBar(
                  backgroundColor: CustomerAppColors.background,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'Delete Account',
                    style: CustomerAppTextStyles.heading2.copyWith(
                      color: Colors.black87,
                      fontSize: 20.sp,
                    ),
                  ),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 30.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verify Identity',
                          style: CustomerAppTextStyles.heading2.copyWith(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.isEmailUser
                              ? 'For security, you must enter your current password to confirm account deletion. This process cannot be undone.'
                              : 'Your account is linked with Google. You do not need to enter a password to delete your account, but this action is permanent.',
                          style: CustomerAppTextStyles.body.copyWith(
                            color: CustomerAppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        if (widget.isEmailUser) ...[
                          CustomTextField(
                            key: const ValueKey('password_field'),
                            label: 'Password',
                            controller: _passwordController,
                            hintText: 'Enter your password',
                            isPassword: uiState.obscurePassword,
                            labelStyle: CustomerAppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textStyle: CustomerAppTextStyles.body,
                            fillColor: Colors.white,
                            borderColor: CustomerAppColors.border,
                            focusedBorderColor: Colors.red,
                            suffixIcon: IconButton(
                              icon: Icon(
                                uiState.obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: CustomerAppColors.textSecondary,
                                size: 20.sp,
                              ),
                              onPressed: () {
                                context
                                    .read<DeleteAccountUiCubit>()
                                    .toggleObscurePassword();
                              },
                            ),
                            validator: Validators.validatePasswordVerification,
                          ),
                          SizedBox(height: 40.h),
                        ],
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
                                color: Colors.red,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  'Confirming deletion will immediately remove your profile details, past order records, and saved addresses from the platform.',
                                  style: CustomerAppTextStyles.body.copyWith(
                                    color: const Color(0xFFC62828),
                                    height: 1.4,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 48.h),
                        PrimaryButton(
                          text: 'Delete Account',
                          backgroundColor: Colors.red,
                          textStyle: CustomerAppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
        },
      ),
    );
  }
}
