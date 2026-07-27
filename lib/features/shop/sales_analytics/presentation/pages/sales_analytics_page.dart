import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/bloc/sales_analytics_bloc.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/bloc/sales_analytics_event.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/bloc/sales_analytics_state.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/analytics_header.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/earnings_card.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/order_summary_grid.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/recent_transactions_section.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/timeframe_earnings_cards.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/shimmer/sales_analytics_shimmer.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/sales_items_count_cards.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/utils/sales_analytics_helper.dart';

// Shop Sales Analytics Page
class ShopSalesAnalyticsPage extends StatelessWidget {
  const ShopSalesAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shopId = context.read<ShopAuthBloc>().state.shop?.uid ?? '';
    final scrollController = ScrollController();

    return BlocProvider(
      create: (context) =>
          sl<SalesAnalyticsBloc>()..add(FetchSalesAnalyticsData(shopId)),
      child: BlocListener<SalesAnalyticsBloc, SalesAnalyticsState>(
        listener: (context, state) {
          if (state is SalesAnalyticsLoaded) {
            if (scrollController.hasClients) {
              scrollController.jumpTo(0.0);
            }
          }
        },
        child: Scaffold(
          backgroundColor: ShopAppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            // Page Header
            title: Text(
              'Sales Analytics',
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: const BackButton(color: Colors.black),
          ),
          body: SafeArea(
            child: BlocBuilder<SalesAnalyticsBloc, SalesAnalyticsState>(
              builder: (context, state) {
                // Showing Loading Shimmer
                if (state is SalesAnalyticsLoading ||
                    state is SalesAnalyticsInitial) {
                  return const SalesAnalyticsShimmer();
                }
                // Error View
                if (state is SalesAnalyticsError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is SalesAnalyticsLoaded) {
                  final countData =
                      SalesAnalyticsHelper.calculateSalesAndItemsCount(
                        orders: state.filteredOrders,
                        shopId: shopId,
                        productCategories: state.productCategories,
                        selectedCategory: state.selectedCategory,
                      );
                  final salesCount = countData['salesCount'] ?? 0;
                  final itemsCount = countData['itemsCount'] ?? 0;
                  // Refresh Indicator
                  return RefreshIndicator(
                    color: ShopAppColors.primary,
                    onRefresh: () async {
                      context.read<SalesAnalyticsBloc>().add(
                        FetchSalesAnalyticsData(shopId),
                      );
                      await Future.delayed(const Duration(milliseconds: 800));
                    },
                    // Nested Scroll View
                    child: NestedScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 20.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Analytics Header
                                  AnalyticsHeader(
                                    selectedTimeframe: state.selectedTimeframe,
                                    selectedCategory: state.selectedCategory,
                                    availableCategories:
                                        state.availableCategories,
                                    customStartDate: state.customStartDate,
                                    customEndDate: state.customEndDate,
                                  ),
                                  SizedBox(height: 20.h),
                                  // Earnings Card
                                  EarningsCard(
                                    totalEarnings: state.totalEarnings,
                                  ),
                                  SizedBox(height: 20.h),
                                  // Time frame Earnings Cards
                                  TimeframeEarningsCards(
                                    todayEarnings: state.todayEarnings,
                                    weekEarnings: state.weekEarnings,
                                    monthEarnings: state.monthEarnings,
                                  ),
                                  SizedBox(height: 20.h),
                                  // Sales and Items Count Cards
                                  SalesItemsCountCards(
                                    salesCount: salesCount,
                                    itemsCount: itemsCount,
                                  ),
                                  SizedBox(height: 28.h),
                                  // Order Summary Grid
                                  OrderSummaryGrid(
                                    orderSummary: state.orderSummary,
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      // Recent Transactions Section
                      body: RecentTransactionsSection(
                        transactions: state.recentTransactions,
                        shopId: shopId,
                        scrollController: scrollController,
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
