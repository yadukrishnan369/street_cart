import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/data/models/variant_image_draft.dart';

abstract class ShopProductsEvent extends Equatable {
  const ShopProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadShopProductsEvent extends ShopProductsEvent {
  final String shopId;
  const LoadShopProductsEvent(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

class ShopProductsUpdatedEvent extends ShopProductsEvent {
  final List<ProductModel> products;
  const ShopProductsUpdatedEvent(this.products);

  @override
  List<Object?> get props => [products];
}

class AddProductEvent extends ShopProductsEvent {
  final ProductModel product;

  // One draft per color variant
  final List<VariantImageDraft> variantDrafts;

  const AddProductEvent(this.product, this.variantDrafts);

  @override
  List<Object?> get props => [product, variantDrafts];
}

class UpdateProductEvent extends ShopProductsEvent {
  final ProductModel product;
  final List<VariantImageDraft> variantDrafts;

  const UpdateProductEvent(this.product, this.variantDrafts);

  @override
  List<Object?> get props => [product, variantDrafts];
}

class DeleteProductEvent extends ShopProductsEvent {
  final String shopId;
  final String productId;
  const DeleteProductEvent(this.shopId, this.productId);

  @override
  List<Object?> get props => [shopId, productId];
}

class SearchProductsEvent extends ShopProductsEvent {
  final String query;
  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterProductsByCategoryEvent extends ShopProductsEvent {
  final List<String> categories;
  const FilterProductsByCategoryEvent(this.categories);

  @override
  List<Object?> get props => [categories];
}

class AddCustomSizeEvent extends ShopProductsEvent {
  final String shopId;
  final String sizeStandard;
  final String newSize;
  const AddCustomSizeEvent({
    required this.shopId,
    required this.sizeStandard,
    required this.newSize,
  });

  @override
  List<Object?> get props => [shopId, sizeStandard, newSize];
}

class AddCustomColorEvent extends ShopProductsEvent {
  final String shopId;
  final String newColorHex;
  const AddCustomColorEvent({required this.shopId, required this.newColorHex});

  @override
  List<Object?> get props => [shopId, newColorHex];
}

class LoadProductConfigEvent extends ShopProductsEvent {
  final String shopId;
  const LoadProductConfigEvent(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

class LoadProductCategoriesEvent extends ShopProductsEvent {}
