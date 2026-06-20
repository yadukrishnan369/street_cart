import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/splash/domain/repositories/i_shop_splash_repository.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/features/shop/onboarding/presentation/pages/shop_onboarding_page.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/profile_setup_page.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/account_review_page.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/features/shop/splash/presentation/bloc/shop_splash_bloc.dart';
import 'package:street_cart/features/shop/splash/presentation/bloc/shop_splash_event.dart';
import 'package:street_cart/features/shop/splash/presentation/bloc/shop_splash_state.dart';

class ShopSplashPage extends StatefulWidget {
  const ShopSplashPage({super.key});

  @override
  State<ShopSplashPage> createState() => _ShopSplashPageState();
}

class _ShopSplashPageState extends State<ShopSplashPage> {
  late ShopSplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc = sl<ShopSplashBloc>();
    _initAndCheckStatus();
  }

  Future<void> _initAndCheckStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      _splashBloc.add(CheckShopAppStatusEvent());
    }
  }

  @override
  void dispose() {
    _splashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _splashBloc,
      child: BlocListener<ShopSplashBloc, ShopSplashState>(
        listener: (context, state) {
          if (state is ShopSplashLoaded) {
            switch (state.status) {
              case ShopAppStatus.firstTime:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopOnboardingPage()),
                );
                break;
              case ShopAppStatus.notLoggedIn:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopLoginPage()),
                );
                break;
              case ShopAppStatus.profilePending:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopProfileSetupPage()),
                );
                break;
              case ShopAppStatus.reviewPending:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountReviewPage()),
                );
                break;
              case ShopAppStatus.approved:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopHomePage()),
                );
                break;
            }
          }
        },
        child: Scaffold(
          backgroundColor: ShopAppColors.background,
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 180.r,
                      height: 180.r,
                      decoration: BoxDecoration(
                        color: ShopAppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(48.r),
                      ),
                      child: Center(
                        child: AppLogo(
                          size: 100,
                          backgroundColor: ShopAppColors.primary,
                          logoColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 48.h),
                    Text(
                      'Street Cart',
                      style: ShopAppTextStyles.heading1.copyWith(
                        fontSize: 32.sp,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Manage your shop.',
                      style: ShopAppTextStyles.heading3.copyWith(
                        color: ShopAppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Reach nearby customers effortlessly.',
                      style: ShopAppTextStyles.bodyMedium,
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: 250.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: LinearProgressIndicator(
                          minHeight: 6.h,
                          backgroundColor: ShopAppColors.primary.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            ShopAppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Connecting to local marketplace...',
                      style: ShopAppTextStyles.bodySmall.copyWith(
                        color: ShopAppColors.textTertiary,
                      ),
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
