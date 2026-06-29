import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class ProductDetailHeader extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onToggleDisable;
  final VoidCallback onDelete;

  const ProductDetailHeader({
    super.key,
    required this.product,
    required this.onToggleDisable,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;
    final bool isOutOfStock = p.stockQuantity == 0;

    String statusText = 'Active';
    Color statusBg = const Color(0xFFDEF7EC);
    Color statusTextCol = const Color(0xFF03543F);

    if (p.disabledByAdmin) {
      statusText = 'Disabled';
      statusBg = const Color(0xFFFDE8E8);
      statusTextCol = AdminAppColors.errorColor;
    } else if (isOutOfStock) {
      statusText = 'Out of Stock';
      statusBg = const Color(0xFFFEF08A);
      statusTextCol = AdminAppColors.warningColor;
    } else if (!p.isActive) {
      statusText = 'Disabled';
      statusBg = const Color(0xFFE5E7EB);
      statusTextCol = const Color(0xFF374151);
    }

    final thumbnailUrl = p.images.isNotEmpty ? p.images.first : '';

    final headerInfo = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product thumbnail
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F2F7),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE8E7ED), width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: thumbnailUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (_, __, ___) => Icon(
                    Icons.inventory_2_outlined,
                    size: 32.sp,
                    color: const Color(0xFF8A8A9E),
                  ),
                )
              : Icon(
                  Icons.inventory_2_outlined,
                  size: 32.sp,
                  color: const Color(0xFF8A8A9E),
                ),
        ),
        SizedBox(width: 24.w),

        // Product info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      p.name,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: AdminAppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: statusTextCol,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 14.sp,
                    color: const Color(0xFF6C6C80),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    p.category,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF6C6C80),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                'Product ID: #${p.id.substring(0, p.id.length > 8 ? 8 : p.id.length).toUpperCase()}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8A8A9E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final actionButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Disable / Enable button
        OutlinedButton.icon(
          onPressed: onToggleDisable,
          icon: Icon(
            p.disabledByAdmin ? Icons.check_circle_outline : Icons.block,
            color: p.disabledByAdmin
                ? AdminAppColors.successColor
                : AdminAppColors.errorColor,
            size: 16.sp,
          ),
          label: Text(
            p.disabledByAdmin ? 'Enable Product' : 'Disable Product',
            style: TextStyle(
              color: p.disabledByAdmin
                  ? AdminAppColors.successColor
                  : AdminAppColors.errorColor,
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            side: BorderSide(
              color: p.disabledByAdmin
                  ? AdminAppColors.successColor
                  : AdminAppColors.errorColor,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        SizedBox(width: 16.w),

        // Delete button
        ElevatedButton.icon(
          onPressed: onDelete,
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminAppColors.errorColor,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          icon: Icon(Icons.delete_outline, size: 16.sp, color: Colors.white),
          label: const Text(
            'Delete Product',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E2F).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return isWide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: headerInfo),
                    SizedBox(width: 32.w),
                    actionButtons,
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerInfo,
                    SizedBox(height: 24.h),
                    actionButtons,
                  ],
                );
        },
      ),
    );
  }
}
