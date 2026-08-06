import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_event.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_bloc.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_state.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/cart_items_list.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/order_summary.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/cart_empty_state.dart';
import 'package:street_cart/features/customer/cart/presentation/utils/cart_helper.dart';
import 'package:street_cart/features/customer/cart/presentation/pages/checkout_page.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/shimmer/cart_shimmer.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Cart Page
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final ScrollController _scrollController;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartBloc>().add(LoadCart());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // listens to scroll, and show summary card
  void _scrollListener() {
    final state = context.read<CartBloc>().state;
    if (state is CartLoaded) {
      CartHelper.handleScroll(context, _scrollController, state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.foregroundColor,
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
        // Page Header
        title: Text(
          'My Cart',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartItemUpdateError) {
            CustomSnackBar.show(
              context,
              message: state.errorMessage,
              isError: true,
            );
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (_isFirstLoad) {
              _isFirstLoad = false;
              return const CartShimmer();
            }
            if (state is CartLoading) {
              return const CartShimmer();
            } else if (state is CartError) {
              // Error State
              return AppErrorView(
                message: state.message,
                onRetry: () => context.read<CartBloc>().add(LoadCart()),
              );
            } else if (state is CartLoaded) {
              final items = state.items;
              if (items.isEmpty) {
                // Cart Empty State
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
                    // Cart items List Section
                    CartItemsList(
                      items: items,
                      scrollController: _scrollController,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Order Summary Section
                          OrderSummary(
                            totalItems: totalItems,
                            productTypes: items.length,
                            subtotal: subtotal,
                            totalAmount: totalAmount,
                            isVisible: state.isSummaryVisible,
                          ),
                          // Action Button
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
      ),
    );
  }
}
