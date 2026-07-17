import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/checkout_bloc.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/checkout_event.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/checkout_state.dart';
import 'package:street_cart/features/customer/cart/presentation/utils/checkout_helper.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/checkout_address_section.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/checkout_payment_section.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/checkout_summary_section.dart';

// Checkout Content Section
class CheckoutContentSection extends StatelessWidget {
  final List<CartItem> cartItems;
  final CheckoutLoaded checkoutState;

  const CheckoutContentSection({
    super.key,
    required this.cartItems,
    required this.checkoutState,
  });

  @override
  Widget build(BuildContext context) {
    final productTypes = CheckoutHelper.getProductTypesCount(cartItems);
    final totalQuantity = CheckoutHelper.getTotalProductsCount(cartItems);
    final totalAmount = CheckoutHelper.getTotalAmount(cartItems);

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w, top: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CheckoutAddressSection(),
          SizedBox(height: 24.h),
          // Payment Section
          CheckoutPaymentSection(
            allowedMethods: checkoutState.allowedPaymentMethods,
            selectedMethod: checkoutState.selectedPaymentMethod,
            onMethodSelected: (method) {
              context.read<CheckoutBloc>().add(SelectPaymentMethod(method));
            },
          ),
          SizedBox(height: 24.h),
          // Checkout Summary
          CheckoutSummarySection(
            cartItems: cartItems,
            productTypesCount: productTypes,
            totalProductsCount: totalQuantity,
            totalAmount: totalAmount,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
