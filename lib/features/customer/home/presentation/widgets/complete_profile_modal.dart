import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// Complete Profile Modal
class CompleteProfileModal extends StatelessWidget {
  final VoidCallback onCompleteProfile;
  final VoidCallback onMaybeLater;

  const CompleteProfileModal({
    super.key,
    required this.onCompleteProfile,
    required this.onMaybeLater,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      elevation: 0,
      backgroundColor: CustomerAppColors.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            SizedBox(height: 24.h),
            Text(
              'Welcome to Street Cart!',
              textAlign: TextAlign.center,
              style: CustomerAppTextStyles.heading2.copyWith(
                fontSize: 22.sp,
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Complete your profile to get a personalized shopping experience and faster checkouts.',
              textAlign: TextAlign.center,
              style: CustomerAppTextStyles.body.copyWith(
                fontSize: 14.sp,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCompleteProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomerAppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  elevation: 8,
                  shadowColor: CustomerAppColors.primary.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'Complete Profile',
                  style: CustomerAppTextStyles.buttonText.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: onMaybeLater,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'Maybe later',
                style: CustomerAppTextStyles.body.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // dialogue header profile icon
  Widget _buildIcon() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2FF),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: const Color(0xFFEBEEFF),
            shape: BoxShape.circle,
            border: Border.all(
              color: CustomerAppColors.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.account_circle_rounded,
            size: 32.sp,
            color: CustomerAppColors.primary,
          ),
        ),
      ),
    );
  }
}
