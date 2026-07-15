import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_bloc.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_event.dart';
import 'package:street_cart/features/customer/cart/presentation/utils/cart_helper.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/cart_item_card.dart';
import 'package:street_cart/features/customer/cart/presentation/pages/checkout_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class CartItemsList extends StatelessWidget {
  final List<CartItem> items;
  final ScrollController scrollController;

  const CartItemsList({
    super.key,
    required this.items,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => CartHelper.navigateToProductDetail(context, item),
            child: CartItemCard(
              item: item,
              onIncrement: () {
                context.read<CartBloc>().add(
                  UpdateItemQuantity(
                    itemId: item.id,
                    quantity: item.quantity + 1,
                  ),
                );
              },
              onDecrement: () {
                if (item.quantity <= 1) {
                  CustomSnackBar.show(
                    context,
                    message: 'Minimum quantity must be 1',
                    isError: true,
                  );
                } else {
                  context.read<CartBloc>().add(
                    UpdateItemQuantity(
                      itemId: item.id,
                      quantity: item.quantity - 1,
                    ),
                  );
                }
              },
              onDelete: () {
                CartHelper.showDeleteDialog(context, () {
                  context.read<CartBloc>().add(RemoveItem(itemId: item.id));
                });
              },
              onBuyNow: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutPage(cartItems: [item]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
