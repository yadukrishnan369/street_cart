import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Shop Verification Bottom Sheet
class ShopVerificationBottomSheet extends StatelessWidget {
  final String ownerName;
  final String shopName;
  final String email;

  const ShopVerificationBottomSheet({
    super.key,
    required this.ownerName,
    required this.shopName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAuthBloc, ShopAuthState>(
      listener: (context, state) {
        if (state.status == ShopAuthStatus.initial) {
          Navigator.pop(context);
          CustomSnackBar.show(
            context,
            message: 'Verification cancelled or expired. Please try again.',
          );
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final secondsRemaining = state.secondsRemaining;

        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: isDark ? ShopAppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? ShopAppColors.darkBorder
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: 64.sp,
                    color: ShopAppColors.primary,
                  ),
                  SizedBox(height: 24.h),
                  // title
                  Text(
                    'Verify Your Email',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? ShopAppColors.darkTextPrimary
                          : ShopAppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Subtitle for inform sending the link
                  Text(
                    'We have sent a verification link to\n$email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark
                          ? ShopAppColors.darkTextSecondary
                          : ShopAppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 80.h,
                        width: 80.h,
                        child: CircularProgressIndicator(
                          value: secondsRemaining / 80,
                          strokeWidth: 4,
                          backgroundColor: isDark
                              ? ShopAppColors.darkBorder
                              : Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            secondsRemaining > 20
                                ? ShopAppColors.primary
                                : Colors.redAccent,
                          ),
                        ),
                      ),
                      Text(
                        '$secondsRemaining',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: secondsRemaining > 20
                              ? ShopAppColors.primary
                              : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Please verify your email to continue.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ShopAppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        // Cancel Button
                        child: TextButton(
                          onPressed: () {
                            context.read<ShopAuthBloc>().add(
                              ShopVerificationCancelledEvent(),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                          ),
                          child: Text(
                            'Cancel Signup',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
