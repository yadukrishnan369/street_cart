import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/Customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/onboarding/data/datasource/onboarding_local_datasource_impl.dart';
import 'package:street_cart/features/customer/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:street_cart/features/customer/onboarding/domain/usecases/complete_onboarding.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late CompleteOnboarding completeOnboarding;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Discover nearby local products",
      "text":
          "Support your community and find unique items from local vendors just around the corner.",
      "image": "assets/images/onboarding_1.png",
    },
    {
      "title": "Support local shops easily",
      "text":
          "Discover unique products from vendors in your neighborhood and contribute to your community with every purchase.",
      "image": "assets/images/onboarding_2.png",
    },
    {
      "title": "Order and track with confidence",
      "text":
          "Monitor your package in real-time from the shops to your doorstep. Reliable updates at every step.",
      "image": "assets/images/onboarding_3.png",
    },
  ];

  @override
  void initState() {
    super.initState();

    final repository = OnboardingRepositoryImpl(
      local: OnboardingLocalDataSourceImpl(),
    );

    completeOnboarding = CompleteOnboarding(repository);
  }

  Future<void> _completeOnboarding() async {
    await completeOnboarding();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _completeOnboarding,
            child: Text(
              "Skip",
              style: CustomerAppTextStyles.body.copyWith(
                color: CustomerAppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          16.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                                color: CustomerAppColors.surface, width: 4),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.asset(
                              _onboardingData[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        40.verticalSpace,
                        Text(
                          _onboardingData[index]['title']!,
                          style: CustomerAppTextStyles.heading2,
                          textAlign: TextAlign.center,
                        ),
                        16.verticalSpace,
                        Text(
                          _onboardingData[index]['text']!,
                          style: CustomerAppTextStyles.subtitle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: _currentPage == index ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? CustomerAppColors.primary
                        : CustomerAppColors.primaryLight,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
            32.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                children: [
                  PrimaryButton(
                    text: _currentPage == _onboardingData.length - 1
                        ? "Get Started →"
                        : "Next →",
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                  24.verticalSpace,
                  Text(
                    "Step ${_currentPage + 1} of 3",
                    style: CustomerAppTextStyles.body.copyWith(
                      color: CustomerAppColors.textSecondary,
                    ),
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
