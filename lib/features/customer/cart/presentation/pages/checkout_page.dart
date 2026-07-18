import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/checkout_bloc.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/checkout_event.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/checkout_state.dart';
import 'package:street_cart/features/customer/cart/presentation/utils/checkout_helper.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/checkout_button_section.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/checkout_content_section.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/shimmer/checkout_shimmer.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_event.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_state.dart';
import 'package:street_cart/features/customer/payment/presentation/bloc/payment_bloc.dart';
import 'package:street_cart/features/customer/payment/presentation/bloc/payment_state.dart';
import 'package:street_cart/features/customer/payment/presentation/widgets/payment_processing_overlay.dart';
import 'package:street_cart/features/customer/payment/presentation/widgets/order_error_dialog.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';

// Checkout Page
class CheckoutPage extends StatelessWidget {
  final List<CartItem> cartItems;

  const CheckoutPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CheckoutBloc>()..add(LoadCheckout(cartItems)),
        ),
        BlocProvider(
          create: (context) => sl<AddressBloc>()..add(FetchAddresses()),
        ),
        BlocProvider(create: (context) => sl<PaymentBloc>()),
      ],
      child: Scaffold(
        backgroundColor: CustomerAppColors.background,
        appBar: AppBar(
          backgroundColor: CustomerAppColors.surface,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: CustomerAppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          // Page Header
          title: Text(
            'Checkout',
            style: TextStyle(
              color: CustomerAppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, paymentState) {
            if (paymentState is PaymentOrderCreating) {
              final totalAmount = CheckoutHelper.getTotalAmount(cartItems);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<PaymentBloc>(),
                    child: PaymentProcessingOverlay(
                      paymentMethod: paymentState.paymentMethod,
                      totalAmount: totalAmount,
                      cartItems: cartItems,
                    ),
                  ),
                ),
              );
            } else if (paymentState is PaymentFailure) {
              if (paymentState.message.contains(
                "does not deliver to the selected address",
              )) {
                // Delivery Validation Error
                OrdersHelper.showOutOfRadiusDialog(context);
              } else {
                final isNetwork =
                    paymentState.message.toLowerCase().contains('connection') ||
                    paymentState.message.toLowerCase().contains('internet') ||
                    paymentState.message.toLowerCase().contains('network') ||
                    paymentState.message.toLowerCase().contains('offline');

                if (isNetwork) {
                  // Network Error
                  CustomSnackBar.show(
                    context,
                    message: paymentState.message,
                    isError: true,
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        OrderErrorDialog(message: paymentState.message),
                  );
                }
              }
            }
          },
          builder: (context, paymentState) {
            return BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, checkoutState) {
                return BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, addressState) {
                    if (checkoutState is CheckoutLoading ||
                        addressState is AddressLoading ||
                        addressState is AddressInitial) {
                      return const CheckoutShimmer();
                    }

                    if (checkoutState is CheckoutError ||
                        addressState is AddressError) {
                      final String errorMessage = checkoutState is CheckoutError
                          ? (checkoutState).message
                          : (addressState as AddressError).message;
                      // Error State
                      return AppErrorView(
                        message: errorMessage,
                        onRetry: () {
                          context.read<CheckoutBloc>().add(
                            LoadCheckout(cartItems),
                          );
                          context.read<AddressBloc>().add(FetchAddresses());
                        },
                      );
                    }

                    if (checkoutState is CheckoutLoaded) {
                      return Column(
                        children: [
                          Expanded(
                            // Main Content Area
                            child: CheckoutContentSection(
                              cartItems: cartItems,
                              checkoutState: checkoutState,
                            ),
                          ),
                          // Checkout  Buttons
                          CheckoutButtonSection(
                            cartItems: cartItems,
                            checkoutState: checkoutState,
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
