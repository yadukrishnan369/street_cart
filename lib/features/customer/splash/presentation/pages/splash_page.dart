import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/customer/Customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/features/customer/onboarding/presentation/pages/onboarding_page.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/features/customer/splash/domain/repositories/i_splash_repository.dart';
import 'package:street_cart/features/customer/splash/presentation/bloc/splash_bloc.dart';
import 'package:street_cart/features/customer/splash/presentation/bloc/splash_event.dart';
import 'package:street_cart/features/customer/splash/presentation/bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();

    _splashBloc = sl<SplashBloc>();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
              _splashBloc.add(CheckAppStatusEvent());
            }
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _splashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _splashBloc,
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            switch (state.status) {
              case AppStatus.firstTime:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingPage()),
                );
                break;
              case AppStatus.notLoggedIn:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
                break;
              case AppStatus.loggedIn:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
                break;
            }
          }
        },
        child: Scaffold(
          backgroundColor: CustomerAppColors.background,
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLogo(isDark: true, size: 85.w),
                    32.verticalSpace,
                    Text("Street Cart", style: CustomerAppTextStyles.heading1),
                    8.verticalSpace,
                    Text(
                      "Discover shops around you",
                      style: CustomerAppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 120.h,
                left: 24.w,
                right: 24.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Initializing...",
                          style: CustomerAppTextStyles.body.copyWith(
                            color: CustomerAppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${(_controller.value * 100).toInt()}%",
                          style: CustomerAppTextStyles.body.copyWith(
                            color: CustomerAppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    LinearProgressIndicator(
                      value: _controller.value,
                      backgroundColor: CustomerAppColors.primary.withOpacity(0.15),
                      color: CustomerAppColors.primary,
                      minHeight: 6.h,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
