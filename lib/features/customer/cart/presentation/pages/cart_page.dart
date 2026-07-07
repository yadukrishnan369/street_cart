import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_bloc.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_event.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_state.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/cart_item_card.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/order_summary.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/cart_empty_state.dart';
import 'package:street_cart/features/customer/cart/presentation/utils/cart_helper.dart';
import 'package:street_cart/features/customer/cart/presentation/pages/checkout_page.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/shimmer/cart_shimmer.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      appBar: AppBar(
        backgroundColor: CustomerAppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CustomerAppColors.textPrimary,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomePage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'My Cart',
          style: TextStyle(
            color: CustomerAppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.items.isNotEmpty) {
                return IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: CustomerAppColors.error,
                  ),
                  onPressed: () => CartHelper.showClearCartDialog(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const CartShimmer();
          } else if (state is CartError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: CustomerAppColors.error),
              ),
            );
          } else if (state is CartLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return const CartEmptyState();
            }

            final int totalItems = CartHelper.calculateTotalItems(items);
            final double subtotal = CartHelper.calculateSubtotal(items);
            final double totalAmount = CartHelper.calculateTotalAmount(
              subtotal,
            );

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () =>
                              CartHelper.navigateToProductDetail(context, item),
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
                              context.read<CartBloc>().add(
                                UpdateItemQuantity(
                                  itemId: item.id,
                                  quantity: item.quantity - 1,
                                ),
                              );
                            },
                            onDelete: () {
                              context.read<CartBloc>().add(
                                RemoveItem(itemId: item.id),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OrderSummary(
                          totalItems: totalItems,
                          productTypes: items.length,
                          subtotal: subtotal,
                          totalAmount: totalAmount,
                        ),
                        SizedBox(height: 16.h),
                        PrimaryButton(
                          text: 'Proceed to Checkout',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CheckoutPage(cartItems: state.items),
                              ),
                            );
                          },
                          suffixIcon: const Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
