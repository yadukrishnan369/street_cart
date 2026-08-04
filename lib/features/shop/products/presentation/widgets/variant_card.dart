import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_state.dart';

// Card for Single Color Variant
class VariantCard extends StatelessWidget {
  final VariantDraft variant;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VariantCard({
    super.key,
    required this.variant,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final color = ShopAppColors.getColorFromName(variant.colorName);
    final isWhite = color.toARGB32() == 0xFFFFFFFF;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? ShopAppColors.darkBorder
              : ShopAppColors.border.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: ShopAppColors.primary.withValues(
                alpha: isDark ? 0.15 : 0.05,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                // Color dot
                Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isWhite
                          ? Colors.grey[400]!
                          : ShopAppColors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  // Color Name
                  child: Text(
                    variant.colorName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? ShopAppColors.darkTextPrimary
                          : ShopAppColors.textPrimary,
                    ),
                  ),
                ),
                // Stock badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: variant.totalStock > 0
                        ? ShopAppColors.successBg
                        : (isDark
                              ? ShopAppColors.darkInputBackground
                              : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  // Varient Total Stock
                  child: Text(
                    '${variant.totalStock} pcs',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: variant.totalStock > 0
                          ? ShopAppColors.success
                          : (isDark
                                ? ShopAppColors.darkTextSecondary
                                : ShopAppColors.textSecondary),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Edit
                _ActionButton(
                  icon: Icons.edit_outlined,
                  color: ShopAppColors.primary,
                  onTap: onEdit,
                ),
                SizedBox(width: 4.w),
                // Delete
                _ActionButton(
                  icon: Icons.delete_outline_rounded,
                  color: ShopAppColors.error,
                  onTap: onDelete,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Images
                if (variant.images.isNotEmpty) ...[
                  _ImageThumbnailRow(images: variant.images),
                  SizedBox(height: 12.h),
                ],

                // Sizes & qty chips
                if (variant.sizes.isNotEmpty) ...[
                  Text(
                    'Sizes & Quantity',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? ShopAppColors.darkTextSecondary
                          : ShopAppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: variant.sizes.entries.map((entry) {
                      final hasStock = entry.value > 0;
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: hasStock
                              ? ShopAppColors.primary.withValues(
                                  alpha: isDark ? 0.2 : 0.08,
                                )
                              : (isDark
                                    ? ShopAppColors.darkInputBackground
                                    : Colors.grey[100]),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: hasStock
                                ? ShopAppColors.primary.withValues(alpha: 0.3)
                                : (isDark
                                      ? ShopAppColors.darkBorder
                                      : Colors.grey[300]!),
                          ),
                        ),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: hasStock
                                ? ShopAppColors.primary
                                : (isDark
                                      ? ShopAppColors.darkTextSecondary
                                      : ShopAppColors.textSecondary),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Image Thumbnail
class _ImageThumbnailRow extends StatelessWidget {
  final List<dynamic> images;

  const _ImageThumbnailRow({required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final img = images[i];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: img is File
                ? Image.file(img, width: 60.w, height: 60.h, fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: img as String,
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                  ),
          );
        },
      ),
    );
  }
}

// Action Button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(7.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: color, size: 16.sp),
      ),
    );
  }
}
