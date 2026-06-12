import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/onboarding/data/datasource/shop_onboarding_local_datasource.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

class ShopOnboardingPage extends StatefulWidget {
  const ShopOnboardingPage({super.key});

  @override
  State<ShopOnboardingPage> createState() => _ShopOnboardingPageState();
}

class _ShopOnboardingPageState extends State<ShopOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Grow Your Local Business',
      description:
          'Bring your shop online and reach customers around you with our seamless digital platform.',
      image: 'assets/images/shop_onboarding_1.png',
    ),
    OnboardingContent(
      title: 'Manage Orders Easily',
      description:
          'Accept orders, update products, and manage sales effortlessly. Everything you need to grow your business in one place.',
      image: 'assets/images/shop_onboarding_2.png',
    ),
    OnboardingContent(
      title: 'Sell Locally with Confidence',
      description:
          'Connect with nearby buyers based on your delivery area and grow your community business.',
      image: 'assets/images/shop_onboarding_3.png',
    ),
  ];

  void _onFinish() async {
    await GetIt.I<IShopOnboardingLocalDataSource>().setFirstTimeFalse();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ShopLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShopAppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 30.w, top: 5.h),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _onFinish,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: ShopAppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _contents.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            _contents[index].image,
                            height: 300.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 48.h),
                        Text(
                          _contents[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: ShopAppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          _contents[index].description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ShopAppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(40.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _contents.length,
                      (index) => Container(
                        margin: EdgeInsets.only(right: 8.w),
                        height: 8.h,
                        width: _currentPage == index ? 24.w : 8.w,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? ShopAppColors.primary
                              : ShopAppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  PrimaryButton(
                    text: _currentPage == _contents.length - 1
                        ? 'Get Started'
                        : 'Next',
                    backgroundColor: ShopAppColors.primary,
                    textStyle: TextStyle(
                      color: ShopAppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                    onPressed: () {
                      if (_currentPage == _contents.length - 1) {
                        _onFinish();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String image;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}
