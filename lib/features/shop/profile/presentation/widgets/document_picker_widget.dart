import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class DocumentPickerWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isPicked;
  final String? existingUrl;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const DocumentPickerWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isPicked,
    this.existingUrl,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasDocument =
        isPicked || (existingUrl != null && existingUrl!.isNotEmpty);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FBFB),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: hasDocument ? ShopAppColors.primary : ShopAppColors.border,
            width: hasDocument ? 2 : 1.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: hasDocument
                    ? ShopAppColors.primary.withOpacity(0.08)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                hasDocument ? Icons.check_circle : icon,
                color: hasDocument
                    ? ShopAppColors.primary
                    : Colors.grey.shade600,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: ShopAppTextStyles.bodyMediumBold),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: ShopAppTextStyles.bodySmall.copyWith(
                      color: ShopAppColors.textSecondary,
                    ),
                  ),
                  if (hasDocument && onClear != null) ...[
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: onClear,
                      child: Text(
                        'Clear File',
                        style: ShopAppTextStyles.bodySmall.copyWith(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              hasDocument ? Icons.check_circle : Icons.add_circle_outline,
              size: 20.sp,
              color: hasDocument
                  ? ShopAppColors.primary
                  : ShopAppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
