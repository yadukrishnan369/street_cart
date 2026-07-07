import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/payment/presentation/widgets/order_placed_success_section.dart';
import 'package:street_cart/features/customer/payment/presentation/widgets/order_success_buttons_section.dart';
import 'package:street_cart/features/customer/payment/presentation/widgets/order_success_estimation_banner.dart';
import 'package:street_cart/features/customer/payment/presentation/utils/payment_helper.dart';

class OrderSuccessPage extends StatefulWidget {
  final String paymentMethod;
  final String paymentStatus;
  final double totalAmount;
  final String orderId;

  const OrderSuccessPage({
    super.key,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.totalAmount,
    required this.orderId,
  });

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  late String orderIdSuffix;

  @override
  void initState() {
    super.initState();
    orderIdSuffix = PaymentHelper.getOrderIdSuffix(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      appBar: AppBar(
        backgroundColor: CustomerAppColors.surface,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'Order Status',
          style: TextStyle(
            color: CustomerAppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              OrderPlacedSuccessSection(orderIdSuffix: orderIdSuffix),
              SizedBox(height: 34.h),
              const OrderSuccessButtonsSection(),
              SizedBox(height: 34.h),
              OrderSuccessEstimationBanner(
                totalAmount: widget.totalAmount,
                paymentStatus: widget.paymentStatus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
