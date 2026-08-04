import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Size Qty Grid
class SizeQtyGrid extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  const SizeQtyGrid({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sizes = controllers.keys.toList();
    // Grid View
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: sizes.length,
      itemBuilder: (_, i) {
        final size = sizes[i];
        return Container(
          decoration: BoxDecoration(
            color: isDark ? ShopAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark ? ShopAppColors.darkBorder : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: ShopAppColors.primary.withValues(
                    alpha: isDark ? 0.2 : 0.08,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r),
                  ),
                ),
                alignment: Alignment.center,
                // Size name
                child: Text(
                  size,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: ShopAppColors.primary,
                  ),
                ),
              ),
              Expanded(
                // Size Quantity Field
                child: TextField(
                  controller: controllers[size],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
