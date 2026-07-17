import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// email verification BottomSheet
class VerificationBottomSheet extends StatefulWidget {
  final String fullName;
  final String email;

  const VerificationBottomSheet({
    super.key,
    required this.fullName,
    required this.email,
  });

  @override
  State<VerificationBottomSheet> createState() =>
      _VerificationBottomSheetState();
}

class _VerificationBottomSheetState extends State<VerificationBottomSheet> {
  @override
  void initState() {
    super.initState();
    // starts countdown timer
    context.read<AuthBloc>().add(
      StartVerificationTimerEvent(
        fullName: widget.fullName,
        email: widget.email,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthVerificationSuccess) {
          Navigator.pop(context);
        } else if (state is AuthError && state.message.contains('expired')) {
          Navigator.pop(context);
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        final secondsRemaining = state.secondsRemaining;
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
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
                color: CustomerAppColors.primary,
              ),
              SizedBox(height: 24.h),
              Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomerAppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'We have sent a verification link to\n${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CustomerAppColors.textSecondary,
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
                      value: secondsRemaining / 90,
                      strokeWidth: 4,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        secondsRemaining > 30
                            ? CustomerAppColors.primary
                            : Colors.redAccent,
                      ),
                    ),
                  ),
                  Text(
                    '$secondsRemaining',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: secondsRemaining > 30
                          ? CustomerAppColors.primary
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
                  color: CustomerAppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(VerificationCancelledEvent());
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
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }
}
