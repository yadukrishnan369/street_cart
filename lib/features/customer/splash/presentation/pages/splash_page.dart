import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/Customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/splash/data/datasources/splash_local_datasource_impl.dart';
import 'package:street_cart/features/customer/splash/data/datasources/splash_remote_datasource_impl.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/features/customer/onboarding/presentation/pages/onboarding_page.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/features/customer/splash/data/repositories/splash_repository_impl.dart';
import 'package:street_cart/features/customer/splash/domain/usecases/check_app_status.dart';
import 'package:street_cart/features/customer/splash/domain/repositories/i_splash_repository.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late CheckAppStatus checkAppStatus;

  @override
  void initState() {
    super.initState();

    final repo = SplashRepositoryImpl(
      local: SplashLocalDataSourceImpl(),
      remote: SplashRemoteDataSourceImpl(),
    );

    checkAppStatus = CheckAppStatus(repo);

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _navigate();
            }
          });

    _controller.forward();
  }

  Future<void> _navigate() async {
    final status = await checkAppStatus();

    if (!mounted) return;

    switch (status) {
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
