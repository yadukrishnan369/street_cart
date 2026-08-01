import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_event.dart';
import 'package:street_cart/features/customer/profile/presentation/pages/saved_addresses_page.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_event.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';

// Order Details Shipping Section
class OrderDetailsShippingSection extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsShippingSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final status = order.status.toLowerCase();
    // Address not changable if shipped, delivered, or cancelled
    final isLocked =
        status == 'shipped' || status == 'delivered' || status == 'cancelled';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title
            Text(
              'SHIPPING DETAILS',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                color: isDark
                    ? CustomerAppColors.darkTextSecondary
                    : Colors.grey[600],
                letterSpacing: 0.8,
              ),
            ),
            GestureDetector(
              onTap: isLocked
                  ? null
                  : () {
                      OrdersHelper.showChangeAddressConfirmation(
                        context: context,
                        onConfirm: () async {
                          final ordersBloc = context.read<OrdersBloc>();
                          final dynamic selectedAddress = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(value: ordersBloc),
                                  BlocProvider<AddressBloc>(
                                    create: (context) =>
                                        sl<AddressBloc>()
                                          ..add(FetchAddresses()),
                                  ),
                                ],
                                child: const SavedAddressesPage(),
                              ),
                            ),
                          );

                          if (selectedAddress != null) {
                            ordersBloc.add(
                              UpdateOrderAddressEvent(
                                order.id,
                                selectedAddress,
                              ),
                            );
                          }
                        },
                      );
                    },
              child: Text(
                'Change',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isLocked
                      ? (isDark
                            ? CustomerAppColors.darkTextSecondary
                            : Colors.grey[400])
                      : const Color(0xFF5E5CE6),
                ),
              ),
            ),
          ],
        ),
        if (!isLocked) ...[
          SizedBox(height: 4.h),
          Text(
            'Address can be change only before order is shipped.',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : Colors.grey[500],
            ),
          ),
        ],
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: isDark
                ? Border.all(color: CustomerAppColors.darkBorder)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: const Color(0xFF5E5CE6),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Name
                    Text(
                      order.deliveryAddress.fullName,
                      style: TextStyle(
                        color: isDark
                            ? CustomerAppColors.darkTextPrimary
                            : CustomerAppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Customer Address
                    Text(
                      '${order.deliveryAddress.addressLine1}, ${order.deliveryAddress.addressLine2.isNotEmpty ? "${order.deliveryAddress.addressLine2}, " : ""}\n'
                      '${order.deliveryAddress.district.isNotEmpty ? order.deliveryAddress.district : order.deliveryAddress.city}'
                      '${order.deliveryAddress.state.isNotEmpty ? ", ${order.deliveryAddress.state}" : ""}'
                      ' - ${order.deliveryAddress.pincode}',
                      style: TextStyle(
                        color: isDark
                            ? CustomerAppColors.darkTextSecondary
                            : Colors.grey[600],
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Customer Phone Number
                    Text(
                      'Phone: ${order.deliveryAddress.phone}',
                      style: TextStyle(
                        color: isDark
                            ? CustomerAppColors.darkTextSecondary
                            : Colors.grey[600],
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
