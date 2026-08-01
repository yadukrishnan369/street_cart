import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/checkout_state.dart';
import 'package:street_cart/features/customer/cart/presentation/utils/checkout_helper.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_state.dart';
import 'package:street_cart/features/customer/payment/presentation/bloc/payment_bloc.dart';
import 'package:street_cart/features/customer/payment/presentation/bloc/payment_event.dart';
import 'package:street_cart/features/customer/payment/presentation/bloc/payment_state.dart';
import 'package:street_cart/features/customer/payment/presentation/utils/payment_helper.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Checkout Button Section
class CheckoutButtonSection extends StatelessWidget {
  final List<CartItem> cartItems;
  final CheckoutLoaded checkoutState;

  const CheckoutButtonSection({
    super.key,
    required this.cartItems,
    required this.checkoutState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: SafeArea(
        child: Builder(
          builder: (buttonContext) {
            return BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, paymentState) {
                return PrimaryButton(
                  text: paymentState is PaymentProcessing
                      ? 'Processing...'
                      : 'Confirm Order',
                  onPressed: paymentState is PaymentProcessing
                      ? null
                      : () {
                          final addressState = buttonContext
                              .read<AddressBloc>()
                              .state;
                          if (addressState is! AddressesLoaded ||
                              addressState.addresses.isEmpty) {
                            CustomSnackBar.show(
                              context,
                              message:
                                  'Please select or add a delivery address first.',
                              isError: true,
                            );
                            return;
                          }

                          final selectedAddress = addressState.addresses
                              .firstWhere(
                                (a) => a.isDefault,
                                orElse: () => addressState.addresses.first,
                              );

                          final totalAmount = CheckoutHelper.getTotalAmount(
                            cartItems,
                          );

                          if (checkoutState.selectedPaymentMethod.isEmpty) {
                            CustomSnackBar.show(
                              context,
                              message: 'Please select a payment method.',
                              isError: true,
                            );
                            return;
                          }

                          PaymentHelper.showConfirmOrderDialog(
                            buttonContext,
                            onConfirm: () {
                              if (checkoutState.selectedPaymentMethod ==
                                  'COD') {
                                buttonContext.read<PaymentBloc>().add(
                                  CompleteOrderWithCOD(
                                    items: cartItems,
                                    address: selectedAddress,
                                    totalAmount: totalAmount,
                                  ),
                                );
                              } else if (checkoutState.selectedPaymentMethod ==
                                  'UPI') {
                                buttonContext.read<PaymentBloc>().add(
                                  InitiateRazorpayPayment(
                                    items: cartItems,
                                    address: selectedAddress,
                                    totalAmount: totalAmount,
                                    contact: selectedAddress.phone,
                                  ),
                                );
                              }
                            },
                          );
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
