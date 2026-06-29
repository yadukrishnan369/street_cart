import 'dart:io';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/domain/repositories/i_shop_products_repository.dart';

class AddProduct {
  final IShopProductsRepository _repository;

  AddProduct(this._repository);

  Future<void> call(ProductModel product, List<File> imageFiles) async {
    return await _repository.addProduct(product, imageFiles);
  }
}
