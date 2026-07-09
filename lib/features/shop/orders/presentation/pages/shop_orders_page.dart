import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_event.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_state.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_order_details_page.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_order_card.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/empty_shop_orders_view.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_orders_tab_bar.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shimmer/shop_orders_shimmer.dart';
import 'package:street_cart/shared/components/shop_bottom_navigation.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';

class ShopOrdersPage extends StatelessWidget {
  const ShopOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<ShopAuthBloc>().state;
    final shopId = authState is ShopStatusLoaded
        ? (authState.shop?.uid ?? '')
        : '';
    final activeTabNotifier = ValueNotifier<int>(0);

    return BlocProvider<ShopOrdersBloc>(
      create: (context) =>
          sl<ShopOrdersBloc>()..add(FetchShopOrdersEvent(shopId)),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
            title: Text(
              'Orders',
              style: TextStyle(
                color: ShopAppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
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
            bottom: ShopOrdersTabBar(activeTabNotifier: activeTabNotifier),
          ),
          body: BlocBuilder<ShopOrdersBloc, ShopOrdersState>(
            builder: (context, state) {
              if (state is ShopOrdersLoading || state is ShopOrdersInitial) {
                return const ShopOrdersShimmer();
              }

              if (state is ShopOrdersLoaded) {
                final allOrders = state.orders;

                return TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(5, (tabIndex) {
                    final filteredList = ShopOrdersHelper.filterOrders(
                      allOrders,
                      tabIndex,
                    );

                    if (filteredList.isEmpty) {
                      return EmptyShopOrdersView(
                        onRefresh: () => context.read<ShopOrdersBloc>().add(
                          FetchShopOrdersEvent(shopId),
                        ),
                        tabIndex: tabIndex,
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async => context.read<ShopOrdersBloc>().add(
                        FetchShopOrdersEvent(shopId),
                      ),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final order = filteredList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<ShopOrdersBloc>(),
                                    child: ShopOrderDetailsPage(
                                      order: order,
                                      shopId: shopId,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ShopOrderCard(
                              order: order,
                              shopId: shopId,
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
                          );
                        },
                      ),
                    );
                  }),
                );
              }

              return const Center(child: Text('Something went wrong.'));
            },
          ),
          bottomNavigationBar: const ShopBottomNavigation(currentIndex: 2),
        ),
      ),
    );
  }
}
