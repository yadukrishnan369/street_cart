import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_bloc.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_event.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_state.dart';
import 'package:street_cart/features/customer/cart/presentation/utils/cart_helper.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/cart_item_card.dart';
import 'package:street_cart/features/customer/cart/presentation/pages/checkout_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/core/animation/staggered_animation.dart';

// Cart Items List
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
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // Carry unavailable Item Ids and unviewable Item Ids
        final Set<String> unavailableIds = state is CartLoaded
            ? state.unavailableItemIds
            : {};
        final Set<String> unviewableIds = state is CartLoaded
            ? state.unviewableItemIds
            : {};

        return Expanded(
          child: AppStaggeredAnimation.limiter(
            child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final bool isUnavailable = unavailableIds.contains(item.id);
                final bool isViewDisabled = unviewableIds.contains(item.id);
                return AppStaggeredAnimation.staggeredList(
                  index: index,
                  child: CartItemCard(
                    item: item,
                    isUnavailable: isUnavailable,
                    isViewDisabled: isViewDisabled,
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
                        context.read<CartBloc>().add(
                          RemoveItem(itemId: item.id),
                        );
                      });
                    },
                    onBuyNow: isUnavailable
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              AppPageTransitions.slideFromBottom(
                                CheckoutPage(cartItems: [item]),
                              ),
                            );
                          },
                    onView: () =>
                        CartHelper.navigateToProductDetail(context, item),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
