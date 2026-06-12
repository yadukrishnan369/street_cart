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
    final hasDocument = isPicked || (existingUrl != null && existingUrl!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(
            title,
            style: ShopAppTextStyles.bodyMediumBold,
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBFB),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: hasDocument ? ShopAppColors.primary : ShopAppColors.border,
                width: hasDocument ? 2 : 1.w,
                style: hasDocument ? BorderStyle.solid : BorderStyle.solid, // In Flutter, dashed borders need custom painters, so we'll use a clean solid/border style or styled container
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: hasDocument
                        ? ShopAppColors.primary.withOpacity(0.08)
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasDocument ? Icons.check_circle : icon,
                    color: hasDocument ? ShopAppColors.primary : Colors.grey.shade600,
                    size: 32.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  hasDocument ? 'Document Selected' : 'Tap to upload $title',
                  style: ShopAppTextStyles.bodyMediumBold.copyWith(
                    color: hasDocument ? ShopAppColors.primary : ShopAppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: ShopAppTextStyles.bodySmall.copyWith(
                    color: ShopAppColors.textSecondary,
                  ),
                ),
                if (hasDocument && onClear != null) ...[
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: onClear,
                    child: Text(
                      'Clear File',
                      style: ShopAppTextStyles.bodySmall.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }
}
