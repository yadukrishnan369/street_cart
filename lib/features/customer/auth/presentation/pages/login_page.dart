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
import 'package:street_cart/core/navigation/page_transitions.dart';

// Login Page
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              // If new User Navigate to Location Permission Page
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
                  AppPageTransitions.loginExit(
                    HomePage(showProfileModal: true),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  AppPageTransitions.loginExit(
                    HomePage(showProfileModal: false),
                  ),
                );
              }
            } else if (state is AuthError) {
              AppLogger.error("AuthError: ${state.message}");
              CustomSnackBar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Container(
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(32.r),
                    border: isDark
                        ? Border.all(color: CustomerAppColors.darkBorder)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.2 : 0.05,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Authentication Header
                      AuthHeader(
                        title: "Welcome Back",
                        subtitle: "Please enter your details to sign in",
                        centerText: true,
                      ),
                      32.verticalSpace,
                      // Google Signing Option Button
                      SocialLoginSection(
                        onGoogleLogin: () {
                          context.read<AuthBloc>().add(GoogleSignInRequested());
                        },
                      ),
                      24.verticalSpace,
                      // Login Form
                      LoginForm(
                        isLoading: state is AuthLoading,
                        onLogin: (email, password) {
                          context.read<AuthBloc>().add(
                            LoginRequested(email: email, password: password),
                          );
                        },
                      ),

                      32.verticalSpace,
                      // Auth Footer
                      AuthFooter(
                        text1: "Don't have an account? ",
                        text2: "Sign Up",
                        onTap: () {
                          // Navigate to Signup Page
                          Navigator.push(
                            context,
                            AppPageTransitions.slide(const SignupPage()),
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
