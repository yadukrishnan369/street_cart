import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_list_item.dart';
import 'package:street_cart/features/shop/products/presentation/utils/products_page_helper.dart';

class ShopProductListView extends StatelessWidget {
  final List<ProductModel> products;
  final String shopId;
  final ShopProductsBloc productsBloc;

  const ShopProductListView({
    super.key,
    required this.products,
    required this.shopId,
    required this.productsBloc,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          productsBloc.add(LoadShopProductsEvent(shopId));
        },
        color: ShopAppColors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 400.h,
              child: Center(
                child: Text(
                  'No products available in this tab.',
                  style: ShopAppTextStyles.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        productsBloc.add(LoadShopProductsEvent(shopId));
      },
      color: ShopAppColors.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductListItem(
            product: product,
            shopId: shopId,
            productsBloc: productsBloc,
            onDeleteTap: () => ProductsPageHelper.confirmDelete(
              context: context,
              shopId: shopId,
              product: product,
              productsBloc: productsBloc,
            ),
          );
        },
      ),
    );
  }
}
