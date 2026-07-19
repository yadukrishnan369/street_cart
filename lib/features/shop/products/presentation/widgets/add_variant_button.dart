import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Add Variant Button
class AddVariantButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool hasVariants;

  const AddVariantButton({
    super.key,
    required this.onTap,
    required this.hasVariants,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: hasVariants
              ? ShopAppColors.primaryLight
              : ShopAppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: ShopAppColors.primary.withValues(alpha: 0.5),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: ShopAppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 14.sp),
            ),
            SizedBox(width: 10.w),
            // Button Text
            Text(
              hasVariants ? 'Add Another Color Variant' : 'Add Color Variant',
              style: TextStyle(
                color: ShopAppColors.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
