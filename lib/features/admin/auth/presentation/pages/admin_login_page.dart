import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_event.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_login_ui_cubit.dart';
import 'package:street_cart/features/admin/auth/presentation/widgets/admin_login_form.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    return BlocProvider(
      create: (_) => AdminLoginUiCubit(),
      child: BlocListener<AdminAuthBloc, AdminAuthState>(
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
                              child: AdminLoginForm(
                                formKey: _formKey,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                onLogin: _login,
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
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
      ),
    );
  }
}
