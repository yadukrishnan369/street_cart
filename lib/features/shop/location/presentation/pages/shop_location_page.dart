import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/account_review_page.dart';
import 'package:street_cart/features/shop/location/presentation/widgets/map_illustration.dart';
import 'package:street_cart/features/shop/location/presentation/widgets/why_we_need_this_card.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/shop/location/presentation/bloc/shop_location_bloc.dart';
import 'package:street_cart/features/shop/location/presentation/bloc/shop_location_event.dart';
import 'package:street_cart/features/shop/location/presentation/bloc/shop_location_state.dart';

class ShopLocationPermissionPage extends StatefulWidget {
  final bool isFromProfile;
  const ShopLocationPermissionPage({super.key, this.isFromProfile = false});

  @override
  State<ShopLocationPermissionPage> createState() =>
      _ShopLocationPermissionPageState();
}

class _ShopLocationPermissionPageState
    extends State<ShopLocationPermissionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ShopLocationBloc>(),
      child: BlocListener<ShopLocationBloc, ShopLocationState>(
        listener: (context, state) {
          if (state is ShopLocationSuccess) {
            if (state.success) {
              if (widget.isFromProfile) {
                Navigator.pop(context, true);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountReviewPage(),
                  ),
                );
              }
            }
          } else if (state is ShopLocationSkipped) {
            if (widget.isFromProfile) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountReviewPage(),
                ),
              );
            }
          } else if (state is ShopLocationFailure) {
            CustomSnackBar.show(
              context,
              message: state.message.replaceAll("Exception: ", ""),
              isError: true,
            );
          }
        },
        child: Scaffold(
          backgroundColor: ShopAppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: widget.isFromProfile,
            title: Text(
              'Location Setup',
              style: TextStyle(
                color: ShopAppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: BlocBuilder<ShopLocationBloc, ShopLocationState>(
                builder: (context, state) {
                  final isLoading = state is ShopLocationLoading;

                  return Column(
                    children: [
                      SizedBox(height: 20.h),
                      const MapIllustration(),
                      SizedBox(height: 30.h),
                      Text(
                        'Reach Nearby\nCustomers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: ShopAppColors.textPrimary,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Enable location to show your shop to nearby customers. This helps buyers find you more easily and increases local sales.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: ShopAppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      const WhyWeNeedThisCard(),
                      SizedBox(height: 30.h),
                      PrimaryButton(
                        text: 'Allow Location Access',
                        isLoading: isLoading,
                        backgroundColor: ShopAppColors.primary,
                        textStyle: TextStyle(
                          color: ShopAppColors.textLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        onPressed: () {
                          context.read<ShopLocationBloc>().add(
                            RequestShopLocationEvent(),
                          );
                        },
                      ),
                      if (!widget.isFromProfile) ...[
                        SizedBox(height: 8.h),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.read<ShopLocationBloc>().add(
                                    SkipShopLocationEvent(),
                                  );
                                },
                          child: Text(
                            'Skip for Now',
                            style: TextStyle(
                              color: ShopAppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 32.h),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
