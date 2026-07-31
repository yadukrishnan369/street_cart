import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/constants/app_constants.dart';
import 'package:street_cart/core/utils/logger.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/auth/presentation/widgets/auth_header.dart';
import 'package:street_cart/features/customer/auth/presentation/widgets/auth_footer.dart';
import 'package:street_cart/features/customer/auth/presentation/widgets/signup_form.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/features/customer/location/presentation/pages/location_permission_page.dart';
import 'package:street_cart/features/customer/auth/presentation/widgets/verification_bottom_sheet.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Signup Page
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CustomerAppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding.w,
          ),
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
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HomePage(showProfileModal: !state.isProfileCompleted),
                    ),
                  );
                }
                // Showing Verification Bottom Sheet
              } else if (state is AuthVerificationWaiting &&
                  !state.isVerificationSheetShowing) {
                context.read<AuthBloc>().add(SetVerificationSheetShowing(true));
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  isDismissible: false,
                  enableDrag: false,
                  builder: (_) => VerificationBottomSheet(
                    fullName: state.fullName,
                    email: state.email,
                  ),
                ).then((_) {
                  if (context.mounted) {
                    context.read<AuthBloc>().add(
                      SetVerificationSheetShowing(false),
                    );
                  }
                });
              } else if (state is AuthError) {
                AppLogger.error("AuthError state reached: ${state.message}");
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.verticalSpace,
                  // Auth Header Section
                  AuthHeader(
                    title: "Create Account",
                    subtitle:
                        "Create your account to discover nearby shops and start shopping locally.",
                    showLogo: false,
                  ),
                  40.verticalSpace,
                  // Signup Form
                  SignupForm(
                    isLoading: state is AuthLoading,
                    onSignUp: (email, password, fullName) {
                      context.read<AuthBloc>().add(
                        SignUpRequested(
                          email: email,
                          password: password,
                          fullName: fullName,
                        ),
                      );
                    },
                  ),
                  32.verticalSpace,
                  // Auth Footer
                  AuthFooter(
                    text1: "Already have an account? ",
                    text2: "Log In",
                    onTap: () {
                      // Navigate to Login Page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                  ),
                  40.verticalSpace,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
