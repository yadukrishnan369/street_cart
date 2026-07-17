import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:street_cart/features/customer/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:street_cart/features/customer/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:street_cart/features/customer/onboarding/presentation/utils/onboarding_helper.dart';

// Onboarding Page
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingBloc>(),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            final currentPage = state.currentPage;

            return Scaffold(
              backgroundColor: CustomerAppColors.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  TextButton(
                    onPressed: () {
                      context.read<OnboardingBloc>().add(
                        CompleteOnboardingEvent(),
                      );
                    },
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
                        itemCount: OnboardingHelper.onboardingData.length,
                        onPageChanged: (index) {
                          context.read<OnboardingBloc>().add(
                            ChangeOnboardingPage(index),
                          );
                        },
                        itemBuilder: (context, index) {
                          final item = OnboardingHelper.onboardingData[index];
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
                                      color: CustomerAppColors.surface,
                                      width: 4,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.r),
                                    child: Image.asset(
                                      item['image']!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                40.verticalSpace,
                                Text(
                                  item['title']!,
                                  style: CustomerAppTextStyles.heading2,
                                  textAlign: TextAlign.center,
                                ),
                                16.verticalSpace,
                                Text(
                                  item['text']!,
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
                        OnboardingHelper.onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: currentPage == index ? 24.w : 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? CustomerAppColors.primary
                                : CustomerAppColors.primaryLight,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                    32.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        children: [
                          // Action Button
                          PrimaryButton(
                            text:
                                currentPage ==
                                    OnboardingHelper.onboardingData.length - 1
                                ? "Get Started →"
                                : "Next →",
                            isLoading: state is OnboardingLoading,
                            onPressed: () {
                              if (currentPage ==
                                  OnboardingHelper.onboardingData.length - 1) {
                                context.read<OnboardingBloc>().add(
                                  CompleteOnboardingEvent(),
                                );
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
                            "Step ${currentPage + 1} of 3",
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
          },
        ),
      ),
    );
  }
}
