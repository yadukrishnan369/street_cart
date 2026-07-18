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
import 'package:street_cart/features/customer/shops/presentation/widgets/shimmer/shop_card_shimmer.dart';
import 'package:street_cart/features/customer/shops/presentation/utils/shops_helper.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';

// Customer Shops Page
class CustomerShopsPage extends StatefulWidget {
  const CustomerShopsPage({super.key});

  @override
  State<CustomerShopsPage> createState() => _CustomerShopsPageState();
}

class _CustomerShopsPageState extends State<CustomerShopsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CustomerShopsBloc>()..add(FetchCustomerShops()),
      child: Scaffold(
        backgroundColor: CustomerAppColors.background,
        appBar: AppBar(
          backgroundColor: CustomerAppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: CustomerAppColors.textPrimary,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HomePage(),
                    transitionDuration: Duration.zero,
                  ),
                );
              }
            },
          ),
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
              // Page Header
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
            Divider(height: 1, color: CustomerAppColors.border),
            // Search Field
            Builder(
              builder: (context) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: CustomSearchBar(
                    controller: _searchController,
                    hintText: 'Search for shops...',
                    onChanged: (q) {
                      context.read<CustomerShopsBloc>().add(
                        UpdateShopSearchQuery(q),
                      );
                    },
                    showFilter: false,
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<CustomerShopsBloc, CustomerShopsState>(
                builder: (context, state) {
                  // Shimmer loading card
                  if (state is CustomerShopsLoading ||
                      state is CustomerShopsInitial) {
                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                      itemCount: 3,
                      itemBuilder: (context, index) => const ShopCardShimmer(),
                    );
                  }
                  // Enable location permission dialog
                  if (state is CustomerShopsLocationDisabled) {
                    return ShopsLocationDisabled(
                      onRefreshLocation: () {
                        context.read<CustomerShopsBloc>().add(
                          FetchCustomerShops(),
                        );
                      },
                    );
                  }
                  // Error UI state with retry Button
                  if (state is CustomerShopsError) {
                    return AppErrorView(
                      message: state.message,
                      onRetry: () => context.read<CustomerShopsBloc>().add(
                        FetchCustomerShops(),
                      ),
                    );
                  }
                  // List of filtered nearby shop profiles Card
                  if (state is CustomerShopsLoaded) {
                    final shops = ShopsHelper.filterShops(
                      state.shops,
                      state.searchQuery,
                    );
                    if (shops.isEmpty) {
                      return ShopsEmptyState(
                        isSearching: state.searchQuery.isNotEmpty,
                      );
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
      ),
    );
  }
}
