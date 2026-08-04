import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_order_product_header.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_order_product_details_info.dart';

// Shop Order Product Details Page
class ShopOrderProductDetailsPage extends StatelessWidget {
  final OrderItemModel item;

  const ShopOrderProductDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? ShopAppColors.darkBackground : Colors.white,
        elevation: isDark ? null : 1.0,
        centerTitle: true,
        // Page Header
        title: Text(
          'Product Info',
          style: TextStyle(
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: isDark
                ? ShopAppColors.darkBorder
                : ShopAppColors.border.withValues(alpha: 1.0),
            width: 0.5,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Shop Order Product Header Section
            ShopOrderProductHeader(item: item),
            // Shop Order Product Details Info
            ShopOrderProductDetailsInfo(item: item),
          ],
        ),
      ),
    );
  }
}
