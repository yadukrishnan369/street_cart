import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_event.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_state.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class AdminForgotPasswordPage extends StatefulWidget {
  const AdminForgotPasswordPage({super.key});

  @override
  State<AdminForgotPasswordPage> createState() =>
      _AdminForgotPasswordPageState();
}

class _AdminForgotPasswordPageState extends State<AdminForgotPasswordPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  Timer? _timer;
  int _countdown = 80;
  bool _isResetLinkSent = false;

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isResetLinkSent = true;
      _countdown = 80;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        if (mounted) {
          CustomSnackBar.show(
            context,
            message: 'Reset link has expired! Please request a new link.',
            isError: true,
          );
          context.pop();
        }
      }
    });
  }

  void _sendResetLink() {
    if (_formKey1.currentState!.validate()) {
      context.read<AdminAuthBloc>().add(
        AdminPasswordResetRequested(_emailController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminAuthBloc, AdminAuthState>(
      listener: (context, state) {
        if (state is AdminAuthPasswordResetSent) {
          CustomSnackBar.show(
            context,
            message: 'Reset link sent successfully! Please check your email.',
          );
          _startCountdown();
        } else if (state is AdminAuthFailure) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 800;
                  final contentWidth = isDesktop ? 480.w : double.infinity;

                  return SizedBox(
                    width: contentWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Form Card Container
                        Card(
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.06),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                            side: const BorderSide(
                              color: Color(0xFFF0EFF5),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 40.h,
                            ),
                            child: _buildForm(),
                          ),
                        ),
                        SizedBox(height: 40.h),

                        // Footer
                        Text(
                          'STREETCART MARKETPLACE',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: const Color(0xFF8A8A9E),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '© 2026 Streetcart Marketplace. All systems operational.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF8A8A9E),
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Shield Icon Badge
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: const BoxDecoration(
              color: Color(0xFFF3E8FF),
              shape: BoxShape.circle,
            ),
            child: AppLogo(
              size: 50,
              backgroundColor: AdminAppColors.primaryColor,
              logoColor: AdminAppColors.surfaceWhite,
            ),
          ),
          SizedBox(height: 24.h),

          Text(
            'Forgot Password?',
            style: AdminAppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: const Color(0xFF1E1E2F),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Enter your email address and we'll send you a link to reset your password.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: const Color(0xFF6C6C80),
            ),
          ),
          SizedBox(height: 32.h),

          // Email Input Field
          CustomTextField(
            label: 'Email Address',
            controller: _emailController,
            hintText: 'admin@hyperlocal.com',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: const Color(0xFF4A4A68),
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: const Color(0xFF8A8A9E),
              size: 20.sp,
            ),
            validator: Validators.validateEmail,
          ),
          SizedBox(height: 24.h),

          BlocBuilder<AdminAuthBloc, AdminAuthState>(
            builder: (context, state) {
              final isLoading = state is AdminAuthLoading;
              return PrimaryButton(
                text: _isResetLinkSent ? 'Reset Link Sent' : 'Send Reset Link',
                isLoading: isLoading,
                backgroundColor: _isResetLinkSent ? Colors.grey : AdminAppColors.primaryColor,
                textStyle: AdminAppTextStyles.buttonText,
                onPressed: _isResetLinkSent ? null : _sendResetLink,
              );
            },
          ),
          if (_isResetLinkSent) ...[
            SizedBox(height: 12.h),
            Text(
              'Link expires in: $_countdown seconds',
              style: TextStyle(
                fontSize: 12.sp,
                color: AdminAppColors.errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          SizedBox(height: 24.h),

          // Back to Login Link
          GestureDetector(
            onTap: () => context.pop(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: AdminAppColors.primaryColor,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Back to Login',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AdminAppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
