import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Product Submit Button
class ProductSubmitButton extends StatelessWidget {
  final bool isPublishing;
  final bool isEdit;
  final VoidCallback onPressed;

  const ProductSubmitButton({
    super.key,
    required this.isPublishing,
    required this.isEdit,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ShopAppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        // Showing Loading Progress while Saving
        onPressed: isPublishing ? null : onPressed,
        child: isPublishing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isEdit ? Icons.save : Icons.publish,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isEdit ? 'Save Changes' : 'Publish Product',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
