import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class AdminShopDetailState {}

class AdminShopDetailInitial extends AdminShopDetailState {}

class AdminShopDetailLoading extends AdminShopDetailState {}

class AdminShopDetailLoaded extends AdminShopDetailState {
  final ShopProfileModel shop;

  AdminShopDetailLoaded(this.shop);
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
