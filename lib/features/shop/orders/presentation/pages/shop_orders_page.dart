import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_order_details_page.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_order_card.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/empty_shop_orders_view.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_orders_tab_bar.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shimmer/shop_orders_shimmer.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/returned_orders_view.dart';
import 'package:street_cart/shared/components/shop_bottom_navigation.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/core/animation/staggered_animation.dart';

// Shop Orders Page
class ShopOrdersPage extends StatelessWidget {
  const ShopOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = context.read<ShopAuthBloc>().state;
    final shopId = authState.status == ShopAuthStatus.authenticated
        ? (authState.shop?.uid ?? '')
        : '';
    final activeTabNotifier = ValueNotifier<int>(0);

    return BlocProvider<ShopOrdersBloc>(
      create: (context) =>
          sl<ShopOrdersBloc>()..add(FetchShopOrdersEvent(shopId)),
      child: DefaultTabController(
        length: 6,
        child: BlocListener<ShopOrdersBloc, ShopOrdersState>(
          listener: (context, state) {
            if (state.status == ShopOrdersStatus.failure &&
                state.orders.isNotEmpty) {
              CustomSnackBar.show(
                context,
                message: state.errorMessage ?? 'Failed to update order status.',
                isError: true,
              );
            }
          },
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: isDark
                  ? ShopAppColors.darkBackground
                  : Colors.white,
              centerTitle: true,
              elevation: isDark ? null : 1.0,
              // Page Title
              title: Text(
                'Orders',
                style: TextStyle(
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ShopHomePage(),
                        transitionDuration: Duration.zero,
                      ),
                    );
                  }
                },
              ),
              // Orders Tab Bar
              bottom: ShopOrdersTabBar(activeTabNotifier: activeTabNotifier),
            ),
            body: BlocBuilder<ShopOrdersBloc, ShopOrdersState>(
              builder: (context, state) {
                if (state.status == ShopOrdersStatus.loading ||
                    state.status == ShopOrdersStatus.initial) {
                  // Shop Orders Shimmer
                  return const ShopOrdersShimmer();
                }

                if (state.status == ShopOrdersStatus.loaded) {
                  final allOrders = state.orders;
                  // Tab Bar Views
                  return TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(6, (tabIndex) {
                      final filteredList = ShopOrdersHelper.filterOrders(
                        allOrders,
                        tabIndex,
                        shopId,
                      );

                      if (filteredList.isEmpty) {
                        // Empty Shop Order View
                        return EmptyShopOrdersView(
                          onRefresh: () => context.read<ShopOrdersBloc>().add(
                            FetchShopOrdersEvent(shopId),
                          ),
                          tabIndex: tabIndex,
                        );
                      }
                      // Return Orders View
                      if (tabIndex == 5) {
                        return ReturnedOrdersView(
                          filteredList: filteredList,
                          shopId: shopId,
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async => context
                            .read<ShopOrdersBloc>()
                            .add(FetchShopOrdersEvent(shopId)),
                        child: AppStaggeredAnimation.limiter(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final order = filteredList[index];
                              return AppStaggeredAnimation.staggeredList(
                                index: index,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      AppPageTransitions.slide(
                                        BlocProvider.value(
                                          value: context.read<ShopOrdersBloc>(),
                                          child: ShopOrderDetailsPage(
                                            order: order,
                                            shopId: shopId,
                                            isCancelledView: tabIndex == 4,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  // Shop Order Card
                                  child: ShopOrderCard(
                                    order: order,
                                    shopId: shopId,
                                    isCancelledView: tabIndex == 4,
                                    onUpdateStatus: (nextStatus) {
                                      context.read<ShopOrdersBloc>().add(
                                        UpdateOrderStatusEvent(
                                          shopId: shopId,
                                          orderId: order.id,
                                          newStatus: nextStatus,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  );
                }

                if (state.status == ShopOrdersStatus.failure) {
                  // App Error View
                  return AppErrorView(
                    message: state.errorMessage ?? 'An error occurred',
                    onRetry: () {
                      context.read<ShopOrdersBloc>().add(
                        FetchShopOrdersEvent(shopId),
                      );
                    },
                  );
                }

                return const Center(child: Text('Something went wrong.'));
              },
            ),
            // Bottom Navigation Bar
            bottomNavigationBar: const ShopBottomNavigation(currentIndex: 2),
          ),
        ),
      ),
    );
  }
}
