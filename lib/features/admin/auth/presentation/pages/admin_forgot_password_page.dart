import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_event.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_forgot_password_ui_cubit.dart';
import 'package:street_cart/features/admin/auth/presentation/widgets/admin_forgot_password_form.dart';

class AdminForgotPasswordPage extends StatefulWidget {
  const AdminForgotPasswordPage({super.key});

  @override
  State<AdminForgotPasswordPage> createState() => _AdminForgotPasswordPageState();
}

class _AdminForgotPasswordPageState extends State<AdminForgotPasswordPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink(BuildContext context) {
    if (_formKey1.currentState!.validate()) {
      context.read<AdminAuthBloc>().add(
            AdminPasswordResetRequested(_emailController.text.trim()),
          );
    }
  }

  void _onExpired(BuildContext context) {
    if (mounted) {
      CustomSnackBar.show(
        context,
        message: 'Reset link has expired! Please request a new link.',
        isError: true,
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminForgotPasswordUiCubit(),
      child: Builder(
        builder: (context) {
          return BlocListener<AdminAuthBloc, AdminAuthState>(
            listener: (context, state) {
              if (state is AdminAuthPasswordResetSent) {
                CustomSnackBar.show(
                  context,
                  message: 'Reset link sent successfully! Please check your email.',
                );
                context.read<AdminForgotPasswordUiCubit>().startCountdown(() => _onExpired(context));
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
                                  child: AdminForgotPasswordForm(
                                    formKey: _formKey1,
                                    emailController: _emailController,
                                    onSendResetLink: () => _sendResetLink(context),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.h),
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
        },
      ),
    );
  }
}
