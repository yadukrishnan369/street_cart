import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_order_returned_details_page.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_order_card.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';

// Returned Orders View
class ReturnedOrdersView extends StatelessWidget {
  final List<OrderModel> filteredList;
  final String shopId;

  const ReturnedOrdersView({
    super.key,
    required this.filteredList,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    // Get Returned Order Items
    final listItems = ShopOrdersHelper.getReturnedOrdersListItems(filteredList);

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<ShopOrdersBloc>().add(FetchShopOrdersEvent(shopId)),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: listItems.length,
        itemBuilder: (context, idx) {
          final item = listItems[idx];
          // Section Titles
          if (item is String) {
            return Padding(
              padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 8.h),
              child: Text(
                item.toUpperCase(),
                style: TextStyle(
                  color: ShopAppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 13.sp,
                  letterSpacing: 0.8,
                ),
              ),
            );
          }
          final order = item as OrderModel;
          return GestureDetector(
            onTap: () {
              // Navigate to Order Returned Details Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ShopOrdersBloc>(),
                    child: ShopOrderReturnedDetailsPage(
                      order: order,
                      shopId: shopId,
                    ),
                  ),
                ),
              );
            },
            // Shop Order Card
            child: ShopOrderCard(
              order: order,
              shopId: shopId,
              onUpdateStatus: (_) {},
            ),
          );
        },
      ),
    );
  }
}
