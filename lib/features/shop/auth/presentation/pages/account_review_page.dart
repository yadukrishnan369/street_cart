import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

class AccountReviewPage extends StatefulWidget {
  const AccountReviewPage({super.key});

  @override
  State<AccountReviewPage> createState() => _AccountReviewPageState();
}

class _AccountReviewPageState extends State<AccountReviewPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShopAuthBloc>().add(ShopStatusSubscriptionRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShopAppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Account Status',
          style: ShopAppTextStyles.heading4,
        ),
      ),
      body: BlocBuilder<ShopAuthBloc, ShopAuthState>(
        builder: (context, state) {
          final bool isApproved =
              state is ShopStatusLoaded && (state.shop?.isApproved ?? false);

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 380.h,
                  margin: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/shop_review_waiting.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 80.r,
                            width: 80.r,
                            decoration: const BoxDecoration(
                              color: ShopAppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.hourglass_bottom_rounded,
                              size: 36.sp,
                              color: ShopAppColors.primary,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          right: 20.w,
                          child: Text(
                            'Your shop account is ready!\n(Waiting for Approval)',
                            textAlign: TextAlign.center,
                            style: ShopAppTextStyles.heading4.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      Text(
                        isApproved ? "You're All Set!" : 'Account Under Review',
                        style: ShopAppTextStyles.heading1,
                      ),
                      SizedBox(height: 32.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: ShopAppColors.surface,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: ShopAppColors.border,
                            width: 1.5.w,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: ShopAppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Icon(
                                isApproved
                                    ? Icons.check_circle_outline
                                    : Icons.verified_user_outlined,
                                color: ShopAppColors.primary,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isApproved
                                        ? 'Account Approved'
                                        : 'Reviewing Credentials',
                                    style: ShopAppTextStyles.bodyMediumBold,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    isApproved
                                        ? 'Your shop is now live! Click below to enter.'
                                        : 'We are currently verifying your business documentation and identity. Expected time: 24-48 hours.',
                                    style: ShopAppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                      PrimaryButton(
                        text: 'Go to Dashboard',
                        backgroundColor: isApproved
                            ? ShopAppColors.primary
                            : ShopAppColors.primary.withOpacity(0.5),
                        textStyle: ShopAppTextStyles.buttonText.copyWith(
                          color: Colors.white.withOpacity(isApproved ? 1 : 0.6),
                        ),
                        prefixIcon: isApproved
                            ? null
                            : Icon(
                                Icons.lock_outline,
                                color: Colors.white.withOpacity(0.6),
                                size: 18.sp,
                              ),
                        onPressed: isApproved
                            ? () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ShopHomePage(),
                                  ),
                                  (route) => false,
                                );
                              }
                            : null,
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
