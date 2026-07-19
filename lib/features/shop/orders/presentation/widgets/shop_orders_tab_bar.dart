import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';

// Shop Orders Tabbar
class ShopOrdersTabBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<int> activeTabNotifier;

  const ShopOrdersTabBar({super.key, required this.activeTabNotifier});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopOrdersBloc, ShopOrdersState>(
      builder: (context, state) {
        final orders = state.status == ShopOrdersStatus.loaded
            ? state.orders
            : const <dynamic>[];

        return TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: ShopAppColors.primary,
          indicatorWeight: 3.h,
          labelColor: ShopAppColors.primary,
          unselectedLabelColor: Colors.grey[500],
          onTap: (index) => activeTabNotifier.value = index,
          tabs: List.generate(5, (index) {
            final tabTitles = ['NEW', 'PROCESS', 'SHIPPED', 'DONE', 'RETURNED'];
            final count = ShopOrdersHelper.getCount(orders.cast(), index);

            return ValueListenableBuilder<int>(
              valueListenable: activeTabNotifier,
              builder: (context, activeIndex, _) {
                final isSelected = activeIndex == index;
                return Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Tab Title
                        Text(
                          tabTitles[index],
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: isSelected
                                ? FontWeight.w900
                                : FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ShopAppColors.primary
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          // Tab Orders Count
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(74.h);
}
