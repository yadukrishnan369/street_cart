import 'package:flutter/material.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/shop_product_list_view.dart';
import 'package:street_cart/features/shop/products/presentation/utils/products_page_helper.dart';

class ProductsTabBarView extends StatelessWidget {
  final TabController tabController;
  final List<ProductModel> allProducts;
  final String shopId;
  final ShopProductsBloc productsBloc;

  const ProductsTabBarView({
    super.key,
    required this.tabController,
    required this.allProducts,
    required this.shopId,
    required this.productsBloc,
  });

  @override
  Widget build(BuildContext context) {
    final active = ProductsPageHelper.getActiveProducts(allProducts);
    final outOfStock = ProductsPageHelper.getOutOfStockProducts(allProducts);

    return TabBarView(
      controller: tabController,
      children: [
        ShopProductListView(
          products: allProducts,
          shopId: shopId,
          productsBloc: productsBloc,
        ),
        ShopProductListView(
          products: active,
          shopId: shopId,
          productsBloc: productsBloc,
        ),
        ShopProductListView(
          products: outOfStock,
          shopId: shopId,
          productsBloc: productsBloc,
        ),
      ],
    );
  }
}
