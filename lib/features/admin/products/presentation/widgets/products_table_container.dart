import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/debouncer.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_bloc.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_event.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_state.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/products_table.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';
import 'package:street_cart/shared/widgets/custom_admin_search_bar.dart';

// Products Table Container
class ProductsTableContainer extends StatelessWidget {
  final AdminProductLoaded state;
  final bool isWide;
  final bool isLoading;
  final TextEditingController searchController;
  final Debouncer debouncer;
  final int currentPage;
  final int perPage;
  final ValueChanged<int> onPageChanged;
  final String statusFilter;
  final String? categoryFilter;

  const ProductsTableContainer({
    super.key,
    required this.state,
    required this.isWide,
    required this.isLoading,
    required this.searchController,
    required this.debouncer,
    required this.currentPage,
    required this.perPage,
    required this.onPageChanged,
    required this.statusFilter,
    required this.categoryFilter,
  });

  @override
  Widget build(BuildContext context) {
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
          // Header with Search and Filters
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomAdminSearchBar(
                  hintText: 'Search products by name or shop',
                  controller: searchController,
                  width: isWide ? 320.w : 200.w,
                  onChanged: (val) {
                    debouncer.run(() {
                      context.read<AdminProductBloc>().add(
                        SearchQueryChanged(val),
                      );
                    });
                  },
                ),

                // Filters dropdown
                Row(
                  children: [
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
                        value: statusFilter == 'Category'
                            ? (categoryFilter ??
                                  (state.availableCategories.isNotEmpty
                                      ? state.availableCategories.first
                                      : null))
                            : statusFilter,
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
                          return [
                            'Total Products',
                            'Active',
                            'Out of Stock',
                            ...state.availableCategories,
                          ].map((option) {
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
                        items:
                            [
                              'Total Products',
                              'Active',
                              'Out of Stock',
                              ...state.availableCategories,
                            ].map((option) {
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
                            String newStatusFilter;
                            String? newCategoryFilter;

                            if (selectedOption == 'Total Products' ||
                                selectedOption == 'Active' ||
                                selectedOption == 'Out of Stock') {
                              newStatusFilter = selectedOption;
                              newCategoryFilter = null;
                            } else {
                              newStatusFilter = 'Category';
                              newCategoryFilter = selectedOption;
                            }

                            context.read<AdminProductBloc>().add(
                              FilterChanged(
                                statusFilter: newStatusFilter,
                                categoryFilter: newCategoryFilter,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (isLoading)
            const LinearProgressIndicator(
              color: AdminAppColors.primaryColor,
              backgroundColor: Colors.transparent,
              minHeight: 2,
            )
          else
            const SizedBox(height: 2),

          // Data Table
          if (state.products.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      color: AdminAppColors.primaryColor,
                      size: 64.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No matching products found',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AdminAppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Products Table
            ProductsTable(
              products: state.products,
              currentPage: currentPage,
              perPage: perPage,
            ),
            SizedBox(height: 24.h),
            // Pagination
            AdminPagination(
              currentPage: currentPage,
              totalPages: (state.totalMatchingCount / perPage).ceil(),
              onPageChanged: onPageChanged,
            ),
            SizedBox(height: 24.h),
          ],
        ],
      ),
    );
  }
}
