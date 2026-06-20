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
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AdminAuthBloc>().add(
        AdminLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminAuthBloc, AdminAuthState>(
      listener: (context, state) {
        if (state is AdminAuthSuccess) {
          CustomSnackBar.show(context, message: 'Logged in successfully!');
          context.go('/dashboard');
        } else if (state is AdminAuthFailure) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: AdminAppColors.backgroundLight,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 800;

                  return Container(
                    width: isDesktop ? 450.w : double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Card Container
                        Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 32.h,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Shopping Bag Icon inside Circular Badge
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: AdminAppColors.primaryLight
                                          .withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      color: AdminAppColors.primaryColor,
                                      size: 32.sp,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),

                                  // Admin Portal title
                                  Text(
                                    'Admin Portal',
                                    style: AdminAppTextStyles.heading2.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Enter your credentials to manage your Street Cart marketplace',
                                    textAlign: TextAlign.center,
                                    style: AdminAppTextStyles.bodyMedium
                                        .copyWith(
                                          fontSize: 13.sp,
                                          color: AdminAppColors.textSecondary,
                                        ),
                                  ),
                                  SizedBox(height: 32.h),

                                  // Email input field
                                  CustomTextField(
                                    label: 'Email Address',
                                    controller: _emailController,
                                    hintText: 'admin@hyperlocal.com',
                                    labelStyle: AdminAppTextStyles.bodyMedium
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AdminAppColors.textPrimary,
                                        ),
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: AdminAppColors.textSecondary,
                                      size: 20.sp,
                                    ),
                                    validator: Validators.validateEmail,
                                  ),
                                  SizedBox(height: 20.h),

                                  CustomTextField(
                                    label: 'Password',
                                    controller: _passwordController,
                                    hintText: '••••••••',
                                    isPassword: _obscurePassword,
                                    labelStyle: AdminAppTextStyles.bodyMedium
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AdminAppColors.textPrimary,
                                        ),
                                    labelTrailing: InkWell(
                                      onTap: () {
                                        context.push(RoutePaths.forgotPassword);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        child: Text(
                                          'Forgot password?',
                                          style: AdminAppTextStyles.bodySmall
                                              .copyWith(
                                                color:
                                                    AdminAppColors.primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: AdminAppColors.textSecondary,
                                      size: 20.sp,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AdminAppColors.textSecondary,
                                        size: 20.sp,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                    ),
                                    validator: Validators.validateAdminPassword,
                                  ),
                                  SizedBox(height: 32.h),

                                  // Login Button
                                  BlocBuilder<AdminAuthBloc, AdminAuthState>(
                                    builder: (context, state) {
                                      final isLoading =
                                          state is AdminAuthLoading;
                                      return PrimaryButton(
                                        text: 'Login to Dashboard',
                                        isLoading: isLoading,
                                        backgroundColor:
                                            AdminAppColors.primaryColor,
                                        textStyle:
                                            AdminAppTextStyles.buttonText,
                                        onPressed: _login,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 24.h),

                                  // Secure info footer inside card
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.security_outlined,
                                        size: 14.sp,
                                        color: AdminAppColors.textSecondary,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        'SECURE ADMIN ACCESS ONLY',
                                        style: AdminAppTextStyles.caption
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  AdminAppColors.textSecondary,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Operations Status footer under card
                        Text(
                          '© 2026 Hyperlocal Marketplace. All systems operational.',
                          textAlign: TextAlign.center,
                          style: AdminAppTextStyles.caption.copyWith(
                            color: AdminAppColors.textSecondary,
                          ),
                        ),
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
}
