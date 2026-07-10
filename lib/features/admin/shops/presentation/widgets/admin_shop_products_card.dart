import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';

class AdminShopProductsCard extends StatefulWidget {
  final List<ProductModel> products;
  final String shopId;

  const AdminShopProductsCard({
    super.key,
    required this.products,
    required this.shopId,
  });

  @override
  State<AdminShopProductsCard> createState() => _AdminShopProductsCardState();
}

class _AdminShopProductsCardState extends State<AdminShopProductsCard> {
  String _selectedFilter = 'All Products';
  int _currentPage = 1;
  static const int _itemsPerPage = 6;

  @override
  Widget build(BuildContext context) {
    // Extract available categories
    final categories = widget.products.map((p) => p.category).toSet().toList();
    categories.sort();

    final filterOptions = [
      'All Products',
      'Active',
      'Disabled',
      'Out of Stock',
      ...categories,
    ];

    // Reset/adjust selected filter if not available in current list
    if (!filterOptions.contains(_selectedFilter)) {
      _selectedFilter = 'All Products';
    }

    // Filter products
    final filteredProducts = widget.products.where((p) {
      if (_selectedFilter == 'All Products') {
        return true;
      } else if (_selectedFilter == 'Active') {
        return !p.disabledByAdmin && p.isActive && p.stockQuantity > 0;
      } else if (_selectedFilter == 'Disabled') {
        return p.disabledByAdmin || (!p.isActive && p.stockQuantity > 0);
      } else if (_selectedFilter == 'Out of Stock') {
        return !p.disabledByAdmin && p.stockQuantity == 0;
      } else {
        return p.category == _selectedFilter;
      }
    }).toList();

    // Paginate products
    final totalPages = (filteredProducts.length / _itemsPerPage).ceil();
    if (totalPages > 0 && _currentPage > totalPages) {
      _currentPage = totalPages;
    } else if (totalPages == 0) {
      _currentPage = 1;
    }

    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final paginatedProducts = filteredProducts.sublist(
      startIndex,
      endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
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
          // Header
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
                    value: _selectedFilter,
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
                        setState(() {
                          _selectedFilter = selectedOption;
                          _currentPage = 1;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8E7ED)),

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
                      _selectedFilter == 'All Products'
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
            if (totalPages >= 1) ...[
              SizedBox(height: 24.h),
              AdminPagination(
                currentPage: _currentPage,
                totalPages: totalPages,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
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
    final isOutOfStock = p.stockQuantity == 0;
    final isDisabledByAdmin = p.disabledByAdmin;

    String statusText;
    Color statusDot;
    Color statusColor;

    if (isDisabledByAdmin) {
      statusText = 'Disabled';
      statusDot = AdminAppColors.errorColor;
      statusColor = AdminAppColors.errorColor;
    } else if (!p.isActive) {
      statusText = 'Disabled';
      statusDot = const Color(0xFF8A8A9E);
      statusColor = const Color(0xFF8A8A9E);
    } else if (isOutOfStock) {
      statusText = 'Out of Stock';
      statusDot = AdminAppColors.warningColor;
      statusColor = AdminAppColors.warningColor;
    } else {
      statusText = 'Active';
      statusDot = AdminAppColors.successColor;
      statusColor = AdminAppColors.successColor;
    }

    final priceText = p.offerPrice != null
        ? '₹${p.offerPrice!.toStringAsFixed(0)}'
        : '₹${p.originalPrice.toStringAsFixed(0)}';

    final stockText = isOutOfStock
        ? 'Out of Stock'
        : '${p.stockQuantity} in stock';
    final thumbnailUrl = p.images.isNotEmpty ? p.images.first : '';

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.2),
        ),
      ),
      children: [
        // Product name + Image
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
        // Status dot + label
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusDot,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ),
        // View action
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
