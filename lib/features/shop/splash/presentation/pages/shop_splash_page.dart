import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/splash/domain/repositories/i_shop_splash_repository.dart';
import 'package:street_cart/features/shop/splash/domain/usecases/check_shop_app_status.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/features/shop/onboarding/presentation/pages/shop_onboarding_page.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/profile_setup_page.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/account_review_page.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:get_it/get_it.dart';

class ShopSplashPage extends StatefulWidget {
  const ShopSplashPage({super.key});

  @override
  State<ShopSplashPage> createState() => _ShopSplashPageState();
}

class _ShopSplashPageState extends State<ShopSplashPage> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final checkAppStatus = GetIt.I<CheckShopAppStatus>();
    final status = await checkAppStatus();

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    switch (status) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 64.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'INITIALIZING SHOP',
                    style: ShopAppTextStyles.labelBold.copyWith(
                      color: ShopAppColors.primary,
                      letterSpacing: 2.0.w,
                    ),
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
          ),
        ],
      ),
    );
  }
}
