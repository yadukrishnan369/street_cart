import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/features/shop/profile/presentation/pages/shop_profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';

class ShopBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const ShopBottomNavigation({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: ShopAppColors.primary,
      unselectedItemColor: ShopAppColors.textTertiary,
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          activeIcon: Icon(Icons.grid_view),
          label: 'DASHBOARD',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          activeIcon: Icon(Icons.inventory_2),
          label: 'PRODUCTS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'ORDERS',
        ),
        BottomNavigationBarItem(
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
            page = Scaffold(
              appBar: AppBar(title: const Text('Products')),
              body: const Center(child: Text('Products Page (Coming Soon)')),
              bottomNavigationBar: const ShopBottomNavigation(currentIndex: 1),
            );
            break;
          case 2:
            page = Scaffold(
              appBar: AppBar(title: const Text('Orders')),
              body: const Center(child: Text('Orders Page (Coming Soon)')),
              bottomNavigationBar: const ShopBottomNavigation(currentIndex: 2),
            );
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
