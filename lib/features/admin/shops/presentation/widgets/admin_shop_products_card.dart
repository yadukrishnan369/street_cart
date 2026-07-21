import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_bloc.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_event.dart';
import 'package:street_cart/features/admin/shops/presentation/utils/shop_products_card_helper.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';

// Admin Shop Products Card
class AdminShopProductsCard extends StatelessWidget {
  final List<ProductModel> products;
  final String shopId;
  final String selectedFilter;
  final int currentPage;

  const AdminShopProductsCard({
    super.key,
    required this.products,
    required this.shopId,
    required this.selectedFilter,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final filterOptions = ShopProductsCardHelper.buildFilterOptions(products);
    final activeFilter = ShopProductsCardHelper.resolveActiveFilter(
      selectedFilter,
      filterOptions,
    );
    final filteredProducts = ShopProductsCardHelper.applyFilter(
      products,
      activeFilter,
    );
    final totalPages = ShopProductsCardHelper.computeTotalPages(
      filteredProducts,
    );
    final safePage = ShopProductsCardHelper.resolveSafePage(
      currentPage,
      totalPages,
    );
    final paginatedProducts = ShopProductsCardHelper.paginate(
      filteredProducts,
      safePage,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E2F).withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title and filter dropdown
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.format_list_bulleted,
                      color: AdminAppColors.primaryColor,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Products (${filteredProducts.length})',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AdminAppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                // Filter dropdown
                Container(
                  width: 150.w,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFC),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFFE8E7ED),
                      width: 1.2,
                    ),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    menuMaxHeight: 300.h,
                    value: activeFilter,
                    underline: const SizedBox.shrink(),
                    icon: Icon(
                      Icons.filter_list,
                      size: 16.sp,
                      color: const Color(0xFF8A8A9E),
                    ),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF1E1E2F),
                      fontWeight: FontWeight.w600,
                    ),
                    selectedItemBuilder: (context) {
                      return filterOptions.map((option) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            option,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList();
                    },
                    items: filterOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: SizedBox(
                          width: 180.w,
                          child: Text(
                            option,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (selectedOption) {
                      if (selectedOption != null) {
                        context.read<AdminShopDetailBloc>().add(
                          ShopProductFilterChanged(selectedOption),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8E7ED)),

          // Empty state
          if (filteredProducts.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 48.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 48.sp,
                      color: const Color(0xFFD1D5DB),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      activeFilter == 'All Products'
                          ? 'No products listed yet'
                          : 'No matching products found',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF8A8A9E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Product table
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2.5),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.2),
                5: FlexColumnWidth(1.0),
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
                  // Table header titles
                  children: [
                    _headerCell('PRODUCT'),
                    _headerCell('CATEGORY'),
                    _headerCell('PRICE'),
                    _headerCell('STOCK'),
                    _headerCell('STATUS'),
                    _headerCell('ACTIONS'),
                  ],
                ),
                ...paginatedProducts.map((p) => _buildProductRow(context, p)),
              ],
            ),

            // Pagination
            if (totalPages >= 1) ...[
              SizedBox(height: 24.h),
              AdminPagination(
                currentPage: safePage,
                totalPages: totalPages,
                onPageChanged: (page) {
                  context.read<AdminShopDetailBloc>().add(
                    ShopProductPageChanged(page),
                  );
                },
              ),
            ],
            SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }

  TableRow _buildProductRow(BuildContext context, ProductModel p) {
    final status = ShopProductsCardHelper.resolveStatus(p);
    final priceText = ShopProductsCardHelper.formatPrice(p);
    final stockText = ShopProductsCardHelper.formatStock(p);
    final thumbnailUrl = ShopProductsCardHelper.getThumbnailUrl(p);
    final isOutOfStock = p.stockQuantity == 0;

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.2),
        ),
      ),
      children: [
        // Product name and image
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                clipBehavior: Clip.antiAlias,
                child: thumbnailUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Icon(
                          Icons.image_not_supported_outlined,
                          size: 16.sp,
                          color: const Color(0xFF8A8A9E),
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        size: 18.sp,
                        color: AdminAppColors.primaryColor,
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  p.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E1E2F),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Category
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            p.category,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6C6C80)),
          ),
        ),
        // Price
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            priceText,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E1E2F),
            ),
          ),
        ),
        // Stock badge
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isOutOfStock
                    ? const Color(0xFFFDE8E8)
                    : const Color(0xFFDEF7EC),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                stockText,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: isOutOfStock
                      ? AdminAppColors.errorColor
                      : AdminAppColors.successColor,
                ),
              ),
            ),
          ),
        ),
        // Status dot and label
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: status.dotColor,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                status.label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: status.textColor,
                ),
              ),
            ],
          ),
        ),
        // View action button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: TextButton(
            onPressed: () {
              context.push('/products/${p.id}');
            },
            child: Text(
              'View',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AdminAppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
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
}
