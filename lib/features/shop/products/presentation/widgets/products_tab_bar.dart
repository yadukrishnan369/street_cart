import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Products Tab Bar
class ProductsTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;

  const ProductsTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? ShopAppColors.darkBackground : Colors.white,
      child: TabBar(
        controller: controller,
        indicatorColor: ShopAppColors.primary,
        indicatorWeight: 3.h,
        labelColor: ShopAppColors.primary,
        unselectedLabelColor: isDark
            ? ShopAppColors.darkTextSecondary
            : ShopAppColors.textTertiary,
        labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
        ),
        // Tab Titles
        tabs: const [
          Tab(text: 'All Products'),
          Tab(text: 'Active'),
          Tab(text: 'Out of Stock'),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.h);
}
