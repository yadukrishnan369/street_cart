import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/debouncer.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_bloc.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_event.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_state.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/shops_table.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/shops_pagination.dart';
import 'package:street_cart/shared/widgets/custom_admin_search_bar.dart';

class ShopsTableContainer extends StatelessWidget {
  final AdminShopLoaded state;
  final bool isWide;
  final bool isLoading;
  final TextEditingController searchController;
  final Debouncer debouncer;
  final int currentPage;
  final int perPage;
  final ValueChanged<int> onPageChanged;

  const ShopsTableContainer({
    super.key,
    required this.state,
    required this.isWide,
    required this.isLoading,
    required this.searchController,
    required this.debouncer,
    required this.currentPage,
    required this.perPage,
    required this.onPageChanged,
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
          // Controls Header Search bar + Filter Dropdown
          Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 12.h,
              bottom: 12.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomAdminSearchBar(
                  hintText: 'Search shops by name',
                  controller: searchController,
                  width: isWide ? 320.w : 200.w,
                  onChanged: (val) {
                    debouncer.run(() {
                      context.read<AdminShopBloc>().add(
                        SearchQueryChanged(val),
                      );
                    });
                  },
                ),

                // Filters dropdown
                Row(
                  children: [
                    Container(
                      width: 130.w,
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
                        value: state.statusFilter == 'Category'
                            ? (state.categoryFilter ??
                                  state.availableCategories.first)
                            : state.statusFilter,
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
                            'Total Shops',
                            'Active',
                            'Suspended',
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
                              'Total Shops',
                              'Active',
                              'Suspended',
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
                            if (selectedOption == 'Total Shops' ||
                                selectedOption == 'Active' ||
                                selectedOption == 'Suspended') {
                              context.read<AdminShopBloc>().add(
                                FilterChanged(
                                  statusFilter: selectedOption,
                                  categoryFilter: null,
                                ),
                              );
                            } else {
                              context.read<AdminShopBloc>().add(
                                FilterChanged(
                                  statusFilter: 'Category',
                                  categoryFilter: selectedOption,
                                ),
                              );
                            }
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

          //  Data Table
          if (state.shops.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      color: const Color(0xFF8A8A9E),
                      size: 64.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No matching shops found',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8A8A9E),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            ShopsTable(
              shops: state.shops,
              currentPage: currentPage,
              perPage: perPage,
            ),
            SizedBox(height: 24.h),

            // Pagination
            ShopsPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              perPage: perPage,
              onPageChanged: onPageChanged,
            ),
            SizedBox(height: 24.h),
          ],
        ],
      ),
    );
  }
}
