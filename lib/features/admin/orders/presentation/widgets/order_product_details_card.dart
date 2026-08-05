import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';

// Order Product Details Card
class OrderProductDetailsCard extends StatelessWidget {
  final OrderModel order;

  const OrderProductDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            // Title
            child: Text(
              'Product Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AdminAppColors.darkTextPrimary
                    : AdminAppColors.textPrimary,
              ),
            ),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3.0), // PRODUCT
              1: FlexColumnWidth(1.0), // QUANTITY
              2: FlexColumnWidth(1.2), // PRICE
              3: FlexColumnWidth(1.2), // TOTAL
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: isDark
                      ? AdminAppColors.darkInputBackground
                      : const Color(0xFFF9FAFC),
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AdminAppColors.darkBorder
                          : const Color(0xFFE8E7ED),
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: isDark
                          ? AdminAppColors.darkBorder
                          : const Color(0xFFE8E7ED),
                      width: 1,
                    ),
                  ),
                ),
                // Table Titles
                children: [
                  _buildHeaderCell(context, 'PRODUCT'),
                  _buildHeaderCell(context, 'QUANTITY'),
                  _buildHeaderCell(context, 'PRICE'),
                  _buildHeaderCell(context, 'TOTAL'),
                ],
              ),
              ...order.items.map((item) => _buildProductRow(context, item)),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: isDark
              ? AdminAppColors.darkTextSecondary
              : const Color(0xFF8A8A9E),
        ),
      ),
    );
  }

  TableRow _buildProductRow(BuildContext context, OrderItemModel item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priceStr = '₹${PriceUtils.formatPrice(item.price)}';
    final totalStr = '₹${PriceUtils.formatPrice(item.price * item.quantity)}';

    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AdminAppColors.darkBorder : const Color(0xFFF0EFF5),
            width: 1,
          ),
        ),
      ),
      children: [
        // Product name with image
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: InkWell(
            onTap: () {
              context.push('/products/${item.productId}');
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: item.productImage,
                    width: 44.w,
                    height: 44.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const ProductImagePlaceholder(),
                    errorWidget: (context, url, error) =>
                        const ProductImagePlaceholder(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        item.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AdminAppColors.darkTextPrimary
                              : AdminAppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        item.selectedSize ?? 'Standard',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isDark
                              ? AdminAppColors.darkTextSecondary
                              : const Color(0xFF8A8A9E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Quantity
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            item.quantity.toString().padLeft(2, '0'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF6C6C80),
            ),
          ),
        ),

        // Price
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            priceStr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF6C6C80),
            ),
          ),
        ),

        // Total
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            totalStr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AdminAppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
