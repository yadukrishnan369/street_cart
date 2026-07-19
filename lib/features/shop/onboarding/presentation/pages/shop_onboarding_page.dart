import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/onboarding/presentation/bloc/shop_onboarding_bloc.dart';
import 'package:street_cart/features/shop/onboarding/data/models/onboarding_content.dart';
import 'package:street_cart/features/shop/onboarding/presentation/widgets/shop_onboarding_page_view.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Shop Onboarding Pages
class ShopOnboardingPage extends StatefulWidget {
  const ShopOnboardingPage({super.key});

  @override
  State<ShopOnboardingPage> createState() => _ShopOnboardingPageState();
}

class _ShopOnboardingPageState extends State<ShopOnboardingPage> {
  final PageController _pageController = PageController();
  final List<OnboardingContent> _contents = OnboardingContent.defaultContents;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopOnboardingBloc>(
      create: (_) => sl<ShopOnboardingBloc>(),
      child: BlocConsumer<ShopOnboardingBloc, ShopOnboardingState>(
        listener: (context, state) {
          if (state.status == ShopOnboardingStatus.completed) {
            // Navigate to Login Page After Onboarding Completes
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ShopLoginPage()),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ShopAppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  // Skip Button Section
                  Padding(
                    padding: EdgeInsets.only(right: 30.w, top: 5.h),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.read<ShopOnboardingBloc>().add(
                            CompleteShopOnboardingEvent(),
                          );
                        },
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
                  // Onboarding PageView Section
                  ShopOnboardingPageView(
                    controller: _pageController,
                    contents: _contents,
                    onPageChanged: (index) {
                      context.read<ShopOnboardingBloc>().add(
                        ShopOnboardingPageChangedEvent(index),
                      );
                    },
                  ),
                  // Onboarding indicators and action buttons
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
                              width: state.currentPage == index ? 24.w : 8.w,
                              decoration: BoxDecoration(
                                color: state.currentPage == index
                                    ? ShopAppColors.primary
                                    : ShopAppColors.primary.withAlpha(51),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        // Primary Button
                        PrimaryButton(
                          text: state.currentPage == _contents.length - 1
                              ? 'Get Started'
                              : 'Next',
                          isLoading:
                              state.status == ShopOnboardingStatus.loading,
                          backgroundColor: ShopAppColors.primary,
                          textStyle: TextStyle(
                            color: ShopAppColors.textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                          onPressed: () {
                            if (state.currentPage == _contents.length - 1) {
                              context.read<ShopOnboardingBloc>().add(
                                CompleteShopOnboardingEvent(),
                              );
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
        },
      ),
    );
  }
}
