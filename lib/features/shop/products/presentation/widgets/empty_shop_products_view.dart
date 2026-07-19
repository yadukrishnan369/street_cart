import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Empty Shop Products View
class EmptyShopProductsView extends StatelessWidget {
  final VoidCallback onRefresh;
  final int tabIndex;

  const EmptyShopProductsView({
    super.key,
    required this.onRefresh,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;
    String description;

    switch (tabIndex) {
      case 0: // All Products
        icon = Icons.inventory_2_outlined;
        title = 'No Products Yet';
        description =
            'Start building your digital catalog! Add your first product to make it available for customers.';
        break;
      case 1: // Active
        icon = Icons.grid_view_outlined;
        title = 'No Active Products';
        description =
            'None of your products are active right now. Activate products to make them visible to customers.';
        break;
      case 2: // Out of Stock
        icon = Icons.remove_shopping_cart_outlined;
        title = 'All Products In Stock';
        description =
            'Great job! All your catalog products are currently in stock and available for purchase.';
        break;
      default:
        icon = Icons.inventory_outlined;
        title = 'No Products';
        description = 'No products found. Drag down to refresh!';
    }

    return RefreshIndicator(
      color: ShopAppColors.primary,
      onRefresh: () async => onRefresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Circle
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: ShopAppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 64.sp, color: ShopAppColors.primary),
                ),
                SizedBox(height: 24.h),
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: ShopAppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8.h),
                // Description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
