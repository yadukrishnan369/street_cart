import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class DeleteAccountModal extends StatefulWidget {
  final bool isEmailUser;
  const DeleteAccountModal({super.key, required this.isEmailUser});

  @override
  State<DeleteAccountModal> createState() => _DeleteAccountModalState();
}

class _DeleteAccountModalState extends State<DeleteAccountModal> {
  int _currentStep = 1;
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onDeletePressed() {
    if (widget.isEmailUser) {
      setState(() {
        _currentStep = 2;
      });
    } else {
      // google user does not need password for deletion
      context.read<AuthBloc>().add(DeleteAccountRequested(null));
    }
  }

  void _onPasswordSubmit() {
    if (_passwordController.text.trim().isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please enter your password',
        isError: true,
      );
      return;
    }
    context.read<AuthBloc>().add(
      DeleteAccountRequested(_passwordController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAccountDeleted) {
            setState(() {
              _currentStep = 3;
            });
          } else if (state is AuthError) {
            CustomSnackBar.show(context, message: state.message, isError: true);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            bool isLoading = state is AuthLoading;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_currentStep == 1) _buildConfirmStep(isLoading),
                      if (_currentStep == 2) _buildPasswordStep(isLoading),
                      if (_currentStep == 3) _buildSuccessStep(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildConfirmStep(bool isLoading) {
    return Column(
      children: [
        Icon(Icons.warning_amber_rounded, color: Colors.red, size: 64.sp),
        SizedBox(height: 16.h),
        Text(
          'Delete Account?',
          style: CustomerAppTextStyles.heading2.copyWith(color: Colors.red),
        ),
        SizedBox(height: 12.h),
        Text(
          'This action is permanent and will remove all your data from our servers. Are you sure you want to proceed?',
          textAlign: TextAlign.center,
          style: CustomerAppTextStyles.body.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 24.h),
        if (isLoading)
          const CircularProgressIndicator(color: CustomerAppColors.primary)
        else
          Column(
            children: [
              PrimaryButton(
                text: 'Delete My Account',
                onPressed: _onDeletePressed,
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPasswordStep(bool isLoading) {
    return Column(
      children: [
        Icon(Icons.lock_outline, color: CustomerAppColors.primary, size: 64.sp),
        SizedBox(height: 16.h),
        Text('Verify Password', style: CustomerAppTextStyles.heading2),
        SizedBox(height: 12.h),
        Text(
          'For your security, please enter your password to confirm account deletion.',
          textAlign: TextAlign.center,
          style: CustomerAppTextStyles.body.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 20.h),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.password),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        if (isLoading)
          const CircularProgressIndicator(color: CustomerAppColors.primary)
        else
          Column(
            children: [
              PrimaryButton(
                text: 'Confirm Deletion',
                onPressed: _onPasswordSubmit,
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => setState(() => _currentStep = 1),
                child: Text(
                  'Go Back',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSuccessStep() {
    return Column(
      children: [
        Icon(Icons.check_circle_outline, color: Colors.green, size: 64.sp),
        SizedBox(height: 16.h),
        Text(
          'Account Deleted',
          style: CustomerAppTextStyles.heading2.copyWith(color: Colors.green),
        ),
        SizedBox(height: 12.h),
        Text(
          'Your account has been successfully removed. We\'re sorry to see you go!',
          textAlign: TextAlign.center,
          style: CustomerAppTextStyles.body.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 24.h),
        PrimaryButton(
          text: 'Got it',
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
