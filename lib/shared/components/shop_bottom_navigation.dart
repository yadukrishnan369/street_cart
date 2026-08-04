import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/features/shop/profile/presentation/pages/shop_profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/pages/products_page.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_orders_page.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_bloc.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_state.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_order_status.dart';

class ShopBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const ShopBottomNavigation({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? ShopAppColors.darkSurface : Colors.white,
      selectedItemColor: ShopAppColors.primary,
      unselectedItemColor: isDark
          ? ShopAppColors.darkTextSecondary
          : ShopAppColors.textTertiary,
      selectedLabelStyle: TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5.sp,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5.sp,
      ),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          activeIcon: Icon(Icons.grid_view),
          label: 'DASHBOARD',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          activeIcon: Icon(Icons.inventory_2),
          label: 'PRODUCTS',
        ),
        BottomNavigationBarItem(
          icon: BlocBuilder<ShopHomeBloc, ShopHomeState>(
            bloc: sl<ShopHomeBloc>(),
            builder: (context, state) {
              int newOrdersCount = 0;
              if (state is ShopHomeDataLoaded) {
                final authState = context.read<ShopAuthBloc>().state;
                if (authState.status == ShopAuthStatus.authenticated) {
                  final shopId = authState.shop?.uid ?? '';
                  newOrdersCount = state.orders.where((o) {
                    final hasShopItem = o.items.any((i) => i.shopId == shopId);
                    final isNew =
                        ShopOrderStatus.fromString(o.status) ==
                        ShopOrderStatus.placed;
                    return hasShopItem && isNew;
                  }).length;
                }
              }
              if (newOrdersCount > 0) {
                return Badge(
                  label: Text(
                    newOrdersCount.toString(),
                    style: TextStyle(fontSize: 10.sp, color: Colors.white),
                  ),
                  backgroundColor: ShopAppColors.error,
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              }
              return const Icon(Icons.shopping_cart_outlined);
            },
          ),
          activeIcon: BlocBuilder<ShopHomeBloc, ShopHomeState>(
            bloc: sl<ShopHomeBloc>(),
            builder: (context, state) {
              int newOrdersCount = 0;
              if (state is ShopHomeDataLoaded) {
                final authState = context.read<ShopAuthBloc>().state;
                if (authState.status == ShopAuthStatus.authenticated) {
                  final shopId = authState.shop?.uid ?? '';
                  newOrdersCount = state.orders.where((o) {
                    final hasShopItem = o.items.any((i) => i.shopId == shopId);
                    final isNew =
                        ShopOrderStatus.fromString(o.status) ==
                        ShopOrderStatus.placed;
                    return hasShopItem && isNew;
                  }).length;
                }
              }
              if (newOrdersCount > 0) {
                return Badge(
                  label: Text(
                    newOrdersCount.toString(),
                    style: TextStyle(fontSize: 10.sp, color: Colors.white),
                  ),
                  backgroundColor: ShopAppColors.error,
                  child: const Icon(Icons.shopping_cart),
                );
              }
              return const Icon(Icons.shopping_cart);
            },
          ),
          label: 'ORDERS',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'PROFILE',
        ),
      ],
      onTap: (index) {
        if (index == currentIndex) return;

        Widget page;
        switch (index) {
          case 0:
            page = const ShopHomePage();
            break;
          case 1:
            page = const ProductsPage();
            break;
          case 2:
            page = const ShopOrdersPage();
            break;
          case 3:
            page = ShopProfilePage(authBloc: context.read<ShopAuthBloc>());
            break;
          default:
            page = const ShopHomePage();
        }

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => page,
            transitionDuration: Duration.zero,
          ),
        );
      },
    );
  }
}
