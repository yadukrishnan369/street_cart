import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class AdminShopDetailState {}

class AdminShopDetailInitial extends AdminShopDetailState {}

class AdminShopDetailLoading extends AdminShopDetailState {}

class AdminShopDetailLoaded extends AdminShopDetailState {
  final ShopProfileModel shop;
  final List<ProductModel> products;

  AdminShopDetailLoaded(this.shop, this.products);
}

class AdminShopDetailError extends AdminShopDetailState {
  final String message;

  AdminShopDetailError(this.message);
}

class AdminShopDetailActionSuccess extends AdminShopDetailState {
  final String message;

  AdminShopDetailActionSuccess(this.message);
}

class AdminShopDetailActionInProgress extends AdminShopDetailState {}
