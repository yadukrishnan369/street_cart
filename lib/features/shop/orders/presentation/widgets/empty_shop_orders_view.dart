import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

class EmptyShopOrdersView extends StatelessWidget {
  final VoidCallback onRefresh;
  final int tabIndex;

  const EmptyShopOrdersView({
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
      case 0: // NEW
        icon = Icons.new_releases_outlined;
        title = 'No New Orders';
        description =
            'You have no new order requests. Drag down to check for new incoming orders!';
        break;
      case 1: // PROCESS
        icon = Icons.hourglass_empty_rounded;
        title = 'No Orders in Process';
        description =
            'There are no confirmed orders to prepare. Go to the "New" tab to confirm pending orders.';
        break;
      case 2: // SHIPPED
        icon = Icons.local_shipping_outlined;
        title = 'No Shipped Orders';
        description =
            'No orders are currently out for delivery. Finish processing confirmed orders to ship them.';
        break;
      case 3: // DONE (Delivered)
        icon = Icons.task_alt_outlined;
        title = 'No Completed Orders';
        description =
            'You haven\'t completed any orders yet. Keep serving customers to build your history!';
        break;
      case 4: // RETURNED
        icon = Icons.cancel_presentation_outlined;
        title = 'No Returned Orders';
        description =
            'Clean sheet! You have no cancelled or returned orders at this time.';
        break;
      default:
        icon = Icons.assignment_outlined;
        title = 'No Orders Found';
        description =
            'There are no orders here at the moment. Drag down to refresh!';
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
                // Shop Icon Wrapper
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: ShopAppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 64.sp, color: ShopAppColors.primary),
                ),
                SizedBox(height: 24.h),
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
