import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/onboarding/presentation/bloc/shop_onboarding_bloc.dart';
import 'package:street_cart/features/shop/onboarding/presentation/bloc/shop_onboarding_event.dart';
import 'package:street_cart/features/shop/onboarding/presentation/bloc/shop_onboarding_state.dart';
import 'package:street_cart/features/shop/onboarding/presentation/bloc/shop_onboarding_ui_cubit.dart';
import 'package:street_cart/features/shop/onboarding/data/models/onboarding_content.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShopOnboardingBloc>(
          create: (_) => sl<ShopOnboardingBloc>(),
        ),
        BlocProvider<ShopOnboardingUiCubit>(
          create: (_) => ShopOnboardingUiCubit(),
        ),
      ],
      child: BlocListener<ShopOnboardingBloc, ShopOnboardingState>(
        listener: (context, state) {
          if (state is ShopOnboardingCompleted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ShopLoginPage()),
            );
          }
        },
        child: BlocBuilder<ShopOnboardingUiCubit, ShopOnboardingUiState>(
          builder: (context, uiState) {
            return Scaffold(
              backgroundColor: ShopAppColors.background,
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 30.w, top: 5.h),
                      child: Align(
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
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _contents.length,
                        onPageChanged: (index) {
                          context.read<ShopOnboardingUiCubit>().setPage(index);
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
                                width: uiState.currentPage == index
                                    ? 24.w
                                    : 8.w,
                                decoration: BoxDecoration(
                                  color: uiState.currentPage == index
                                      ? ShopAppColors.primary
                                      : ShopAppColors.primary.withAlpha(51),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          BlocBuilder<ShopOnboardingBloc, ShopOnboardingState>(
                            builder: (context, state) {
                              return PrimaryButton(
                                text:
                                    uiState.currentPage == _contents.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                                isLoading: state is ShopOnboardingLoading,
                                backgroundColor: ShopAppColors.primary,
                                textStyle: TextStyle(
                                  color: ShopAppColors.textLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                                onPressed: () {
                                  if (uiState.currentPage ==
                                      _contents.length - 1) {
                                    context.read<ShopOnboardingBloc>().add(
                                      CompleteShopOnboardingEvent(),
                                    );
                                  } else {
                                    _pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                              );
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
      ),
    );
  }
}
