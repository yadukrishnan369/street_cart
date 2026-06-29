import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/shops/presentation/bloc/customer_shops_bloc.dart';
import 'package:street_cart/features/customer/shops/presentation/bloc/customer_shops_event.dart';
import 'package:street_cart/features/customer/shops/presentation/bloc/customer_shops_state.dart';
import 'package:street_cart/shared/components/customer_bottom_navigation.dart';
import 'package:street_cart/shared/components/customer_search_bar.dart';
import 'package:street_cart/features/customer/shops/presentation/widgets/shop_card.dart';
import 'package:street_cart/features/customer/shops/presentation/widgets/shops_location_disabled.dart';
import 'package:street_cart/features/customer/shops/presentation/widgets/shops_empty_state.dart';

class CustomerShopsPage extends StatefulWidget {
  const CustomerShopsPage({super.key});

  @override
  State<CustomerShopsPage> createState() => _CustomerShopsPageState();
}

class _CustomerShopsPageState extends State<CustomerShopsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CustomerShopsBloc>()..add(FetchCustomerShops()),
      child: _CustomerShopsView(
        searchController: _searchController,
        searchQuery: _searchQuery,
        onSearchChanged: (q) => setState(() => _searchQuery = q),
      ),
    );
  }
}

class _CustomerShopsView extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const _CustomerShopsView({
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      appBar: AppBar(
        backgroundColor: CustomerAppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.storefront_rounded,
              color: CustomerAppColors.primary,
              size: 22.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Local Shops',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: CustomerAppColors.textPrimary,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider
          Divider(height: 1, color: CustomerAppColors.border),

          // Search container
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: CustomSearchBar(
              controller: searchController,
              hintText: 'Search for shops...',
              onChanged: onSearchChanged,
              showFilter: false,
            ),
          ),

          // Shop list
          Expanded(
            child: BlocBuilder<CustomerShopsBloc, CustomerShopsState>(
              builder: (context, state) {
                if (state is CustomerShopsLoading ||
                    state is CustomerShopsInitial) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: CustomerAppColors.primary,
                    ),
                  );
                }

                if (state is CustomerShopsLocationDisabled) {
                  return ShopsLocationDisabled(
                    onRefreshLocation: () {
                      context
                          .read<CustomerShopsBloc>()
                          .add(FetchCustomerShops());
                    },
                  );
                }

                if (state is CustomerShopsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 64.sp,
                          color: CustomerAppColors.textSecondary.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Failed to load shops',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: CustomerAppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton.icon(
                          onPressed: () => context
                              .read<CustomerShopsBloc>()
                              .add(FetchCustomerShops()),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomerAppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is CustomerShopsLoaded) {
                  final shops = state.shops.where((s) {
                    if (searchQuery.isEmpty) return true;
                    final q = searchQuery.toLowerCase();
                    return s.shopName.toLowerCase().contains(q) ||
                        s.category.toLowerCase().contains(q) ||
                        s.city.toLowerCase().contains(q);
                  }).toList();

                  if (shops.isEmpty) {
                    return ShopsEmptyState(isSearching: searchQuery.isNotEmpty);
                  }

                  return RefreshIndicator(
                    color: CustomerAppColors.primary,
                    onRefresh: () async {
                      context.read<CustomerShopsBloc>().add(
                            FetchCustomerShops(),
                          );
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                      itemCount: shops.length,
                      itemBuilder: (context, index) =>
                          ShopCard(shop: shops[index]),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomerBottomNavigation(currentIndex: 1),
    );
  }
}
