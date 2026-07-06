import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

class PublishProductButton extends StatelessWidget {
  final bool isPublishing;
  final bool isEdit;
  final VoidCallback onPressed;

  const PublishProductButton({
    super.key,
    required this.isPublishing,
    required this.isEdit,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isPublishing ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ShopAppColors.primary,
          disabledBackgroundColor: ShopAppColors.primary.withValues(alpha: 0.6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
        child: isPublishing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18.sp,
                    height: 18.sp,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    isEdit ? 'Saving...' : 'Publishing...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Text(
                isEdit ? 'Save Changes' : 'Publish Product',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
