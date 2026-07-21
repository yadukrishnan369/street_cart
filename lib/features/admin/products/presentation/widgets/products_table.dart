import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_bloc.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_event.dart';

// Products Table
class ProductsTable extends StatelessWidget {
  final List<AdminProductItem> products;
  final int currentPage;
  final int perPage;

  const ProductsTable({
    super.key,
    required this.products,
    required this.currentPage,
    required this.perPage,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(1.8),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.5),
        5: FlexColumnWidth(1.2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFF4F5F7),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE8E7ED), width: 1.5),
            ),
          ),
          // Table Titles
          children: [
            _buildTableHeaderCell('PRODUCT NAME'),
            _buildTableHeaderCell('SHOP NAME'),
            _buildTableHeaderCell('CATEGORY'),
            _buildTableHeaderCell('PRICE'),
            _buildTableHeaderCell('STATUS'),
            _buildTableHeaderCell('ACTIONS'),
          ],
        ),
        ...products.map((item) => _buildTableRow(context, item)),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: const Color(0xFF8A8A9E),
        ),
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context, AdminProductItem item) {
    final p = item.product;
    final bool isOutOfStock = p.stockQuantity == 0;

    String statusText = 'Active';
    Color statusBg = const Color(0xFFDEF7EC);
    Color statusTextCol = const Color(0xFF03543F);

    if (p.disabledByAdmin) {
      statusText = 'Disabled';
      statusBg = const Color.fromARGB(255, 245, 205, 205);
      statusTextCol = AdminAppColors.errorColor;
    } else if (isOutOfStock) {
      statusText = 'Out of Stock';
      statusBg = const Color.fromARGB(255, 247, 232, 209);
      statusTextCol = AdminAppColors.warningColor;
    } else if (!p.isActive) {
      statusText = 'Disabled';
      statusBg = const Color.fromARGB(255, 250, 215, 215);
      statusTextCol = AdminAppColors.errorColor;
    }

    final String priceStr = p.offerPrice != null
        ? '₹${p.offerPrice!.toStringAsFixed(2)}'
        : '₹${p.originalPrice.toStringAsFixed(2)}';

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.2),
        ),
      ),
      children: [
        // Product name
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  // Product Images
                  child: p.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: p.images.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: AdminAppColors.primaryColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image_not_supported_outlined,
                            size: 16,
                            color: Color(0xFF8A8A9E),
                          ),
                        )
                      : const Icon(
                          Icons.inventory_2_outlined,
                          color: AdminAppColors.primaryColor,
                          size: 16,
                        ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      p.name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E1E2F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    // Product ID
                    Text(
                      'ID: #${p.id.substring(0, p.id.length > 8 ? 8 : p.id.length).toUpperCase()}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF8A8A9E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Shop name
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.shopName,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: item.isShopSuspended
                      ? AdminAppColors.errorColor
                      : const Color(0xFF1E1E2F),
                  decoration: item.isShopSuspended
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: AdminAppColors.errorColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.isShopSuspended) ...[
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8E8),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: const Color(0xFFF8B4B4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Suspended',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: AdminAppColors.errorColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Category
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                p.category,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4B5563),
                ),
              ),
            ),
          ),
        ),
        // Price
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                priceStr,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
              if (p.offerPrice != null)
                Text(
                  '₹${p.originalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF8A8A9E),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ),
        // Status
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: statusTextCol,
                ),
              ),
            ),
          ),
        ),
        // Actions
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () async {
                final refresh = await context.push(
                  RoutePaths.productDetails.replaceAll(':id', p.id),
                );
                if (refresh == true && context.mounted) {
                  context.read<AdminProductBloc>().add(
                    LoadAdminProducts(page: currentPage, limit: perPage),
                  );
                }
              },
              child: Text(
                'View',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminAppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
