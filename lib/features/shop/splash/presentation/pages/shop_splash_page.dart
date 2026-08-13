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
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/core/animation/text_animation.dart';

// Shop Splash Page
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider.value(
      value: _splashBloc,
      child: BlocListener<ShopSplashBloc, ShopSplashState>(
        listener: (context, state) {
          if (state is ShopSplashLoaded) {
            switch (state.status) {
              case ShopAppStatus.firstTime:
                // Navigate to Shop Onboarding Page
                Navigator.pushReplacement(
                  context,
                  AppPageTransitions.splashSlideExit(
                    const ShopOnboardingPage(),
                  ),
                );
                break;
              case ShopAppStatus.notLoggedIn:
                // Navigate to Shop Login Page
                Navigator.pushReplacement(
                  context,
                  AppPageTransitions.splashSlideExit(const ShopLoginPage()),
                );
                break;
              case ShopAppStatus.profilePending:
                // Navigate to Shop Profile Setup Page
                Navigator.pushReplacement(
                  context,
                  AppPageTransitions.splashSlideExit(
                    const ShopProfileSetupPage(),
                  ),
                );
                break;
              case ShopAppStatus.reviewPending:
                // Navigate to Account Review Page
                Navigator.pushReplacement(
                  context,
                  AppPageTransitions.splashSlideExit(const AccountReviewPage()),
                );
                break;
              case ShopAppStatus.approved:
                // Navigate to Shop Home Page
                Navigator.pushReplacement(
                  context,
                  AppPageTransitions.splashExit(const ShopHomePage()),
                );
                break;
            }
          }
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
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
                        color: ShopAppColors.primary.withValues(
                          alpha: isDark ? 0.15 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(48.r),
                      ),
                      child: Center(
                        // App Logo
                        child: AppLogo(
                          size: 100,
                          backgroundColor: ShopAppColors.primary,
                          logoColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 48.h),
                    // App name and Titles
                    AppTextAnimation.scale(
                      'Street Cart',
                      style: ShopAppTextStyles.heading1.copyWith(
                        fontSize: 32.sp,
                        letterSpacing: -0.5,
                        color: isDark
                            ? ShopAppColors.darkTextPrimary
                            : ShopAppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    AppTextAnimation.scale(
                      'Manage your shop.',
                      style: ShopAppTextStyles.heading3.copyWith(
                        color: ShopAppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AppTextAnimation.scale(
                      'Reach nearby customers effortlessly.',
                      style: ShopAppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : ShopAppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: 250.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        // Linear Progress Line to 100
                        child: LinearProgressIndicator(
                          minHeight: 6.h,
                          backgroundColor: ShopAppColors.primary.withValues(
                            alpha: isDark ? 0.2 : 0.1,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            ShopAppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Footer Content
                    Text(
                      'Connecting to local marketplace...',
                      style: ShopAppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : ShopAppColors.textTertiary,
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
