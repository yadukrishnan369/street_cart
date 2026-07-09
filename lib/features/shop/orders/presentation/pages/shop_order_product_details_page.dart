import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_order_product_header.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_order_product_details_info.dart';

class ShopOrderProductDetailsPage extends StatelessWidget {
  final OrderItemModel item;

  const ShopOrderProductDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'Product Details',
          style: TextStyle(
            color: ShopAppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ShopOrderProductHeader(item: item),
            ShopOrderProductDetailsInfo(item: item),
          ],
        ),
      ),
    );
  }
}
