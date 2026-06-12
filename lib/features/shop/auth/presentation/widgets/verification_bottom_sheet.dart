import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ShopVerificationBottomSheet extends StatefulWidget {
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
  State<ShopVerificationBottomSheet> createState() =>
      _ShopVerificationBottomSheetState();
}

class _ShopVerificationBottomSheetState extends State<ShopVerificationBottomSheet> {
  Timer? _pollingTimer;
  Timer? _countdownTimer;
  int _secondsRemaining = 80;

  @override
  void initState() {
    super.initState();
    _startPolling();
    _startCountdown();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        context.read<ShopAuthBloc>().add(
          ShopCheckEmailVerificationStatusEvent(
            ownerName: widget.ownerName,
            shopName: widget.shopName,
            email: widget.email,
          ),
        );
      }
    });
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timerExpired();
        }
      }
    });
  }

  void _timerExpired() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    context.read<ShopAuthBloc>().add(ShopVerificationCancelledEvent());
    if (mounted) {
      Navigator.pop(context);
      CustomSnackBar.show(
        context,
        message: 'Verification time expired. Please try again.',
      );
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
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
                  color: Colors.grey.shade300,
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
              Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: ShopAppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'We have sent a verification link to\n${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ShopAppColors.textSecondary,
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
                      value: _secondsRemaining / 80,
                      strokeWidth: 4,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _secondsRemaining > 20
                            ? ShopAppColors.primary
                            : Colors.redAccent,
                      ),
                    ),
                  ),
                  Text(
                    '$_secondsRemaining',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: _secondsRemaining > 20
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
              BlocConsumer<ShopAuthBloc, ShopAuthState>(
                listener: (context, state) {
                  if (state is ShopAuthVerificationSuccess) {
                    _pollingTimer?.cancel();
                    _countdownTimer?.cancel();
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            _pollingTimer?.cancel();
                            _countdownTimer?.cancel();
                            context.read<ShopAuthBloc>().add(
                              ShopVerificationCancelledEvent(),
                            );
                            Navigator.pop(context);
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
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
