import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

// Base class
abstract class AdminShopDetailState {}

// Shop Detail Initial State
class AdminShopDetailInitial extends AdminShopDetailState {}

// Shop Detail Loading State
class AdminShopDetailLoading extends AdminShopDetailState {}

// Shop Detail Loaded State
class AdminShopDetailLoaded extends AdminShopDetailState {
  final ShopProfileModel shop;
  final List<ProductModel> products;
  final String productFilter;
  final int productPage;
  static const int itemsPerPage = 6;

  AdminShopDetailLoaded(
    this.shop,
    this.products, {
    this.productFilter = 'All Products',
    this.productPage = 1,
  });

  AdminShopDetailLoaded copyWith({
    ShopProfileModel? shop,
    List<ProductModel>? products,
    String? productFilter,
    int? productPage,
  }) {
    return AdminShopDetailLoaded(
      shop ?? this.shop,
      products ?? this.products,
      productFilter: productFilter ?? this.productFilter,
      productPage: productPage ?? this.productPage,
    );
  }
}

// Shop Detail Action InProgress State
class AdminShopDetailActionInProgress extends AdminShopDetailState {}

// Shop Detail Action Success State
class AdminShopDetailActionSuccess extends AdminShopDetailState {
  final String message;

  AdminShopDetailActionSuccess(this.message);
}

// Shop Detail Error State
class AdminShopDetailError extends AdminShopDetailState {
  final String message;

  AdminShopDetailError(this.message);
}
