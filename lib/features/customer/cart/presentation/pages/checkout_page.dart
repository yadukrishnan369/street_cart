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
import 'package:street_cart/features/customer/cart/presentation/widgets/checkout_address_section.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/checkout_payment_section.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/checkout_summary_section.dart';
import 'package:street_cart/features/customer/cart/presentation/widgets/shimmer/checkout_shimmer.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_event.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_state.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

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
          title: Text(
            'Checkout',
            style: TextStyle(
              color: CustomerAppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, checkoutState) {
            return BlocBuilder<AddressBloc, AddressState>(
              builder: (context, addressState) {
                if (checkoutState is CheckoutLoading ||
                    addressState is AddressLoading ||
                    addressState is AddressInitial) {
                  return const CheckoutShimmer();
                }

                if (checkoutState is CheckoutError) {
                  return Center(child: Text('Error: ${checkoutState.message}'));
                }

                if (checkoutState is CheckoutLoaded) {
                  final productTypes = CheckoutHelper.getProductTypesCount(
                    cartItems,
                  );
                  final totalQuantity = CheckoutHelper.getTotalProductsCount(
                    cartItems,
                  );
                  final totalAmount = CheckoutHelper.getTotalAmount(cartItems);

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            bottom: 16.w,
                            top: 4.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CheckoutAddressSection(),
                              SizedBox(height: 24.h),
                              CheckoutPaymentSection(
                                allowedMethods:
                                    checkoutState.allowedPaymentMethods,
                                selectedMethod:
                                    checkoutState.selectedPaymentMethod,
                                onMethodSelected: (method) {
                                  context.read<CheckoutBloc>().add(
                                    SelectPaymentMethod(method),
                                  );
                                },
                              ),
                              SizedBox(height: 24.h),
                              CheckoutSummarySection(
                                cartItems: cartItems,
                                productTypesCount: productTypes,
                                totalProductsCount: totalQuantity,
                                totalAmount: totalAmount,
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: CustomerAppColors.surface,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: SafeArea(
                          child: Builder(
                            builder: (buttonContext) {
                              return PrimaryButton(
                                text: 'Confirm Order',
                                onPressed: () {
                                  final addressState = buttonContext
                                      .read<AddressBloc>()
                                      .state;
                                  if (addressState is AddressesLoaded &&
                                      addressState.addresses.isEmpty) {
                                    ScaffoldMessenger.of(
                                      buttonContext,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select or add a delivery address first.',
                                        ),
                                        backgroundColor:
                                            CustomerAppColors.error,
                                      ),
                                    );
                                    return;
                                  }

                                  ScaffoldMessenger.of(
                                    buttonContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Order confirmed successfully using ${checkoutState.selectedPaymentMethod}!',
                                      ),
                                      backgroundColor:
                                          CustomerAppColors.success,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
