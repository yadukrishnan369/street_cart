import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/logger.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/features/customer/location/presentation/pages/location_permission_page.dart';
import 'package:street_cart/features/customer/auth/presentation/widgets/auth_header.dart';
import 'package:street_cart/features/customer/auth/presentation/widgets/social_login_section.dart';
import 'package:street_cart/features/customer/auth/presentation/widgets/auth_footer.dart';
import 'package:street_cart/features/customer/auth/presentation/widgets/login_form.dart';
import 'signup_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              if (state.isNewUser) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocationPermissionPage(
                      isProfileCompleted: state.isProfileCompleted,
                    ),
                  ),
                );
              } else if (!state.isProfileCompleted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(showProfileModal: true),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(showProfileModal: false),
                  ),
                );
              }
            } else if (state is AuthError) {
              AppLogger.error("AuthError: ${state.message}");
              CustomSnackBar.show(context, message: state.message, isError: true);
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Container(
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: CustomerAppColors.surface,
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AuthHeader(
                        title: "Welcome Back",
                        subtitle: "Please enter your details to sign in",
                        centerText: true,
                      ),
                      32.verticalSpace,

                      SocialLoginSection(
                        onGoogleLogin: () {
                          context.read<AuthBloc>().add(GoogleSignInRequested());
                        },
                      ),
                      24.verticalSpace,

                      LoginForm(
                        isLoading: state is AuthLoading,
                        onLogin: (email, password) {
                          context.read<AuthBloc>().add(
                            LoginRequested(email: email, password: password),
                          );
                        },
                      ),

                      32.verticalSpace,

                      AuthFooter(
                        text1: "Don't have an account? ",
                        text2: "Sign Up",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupPage(),
                            ),
                          );
                        },
                      ),
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
}
