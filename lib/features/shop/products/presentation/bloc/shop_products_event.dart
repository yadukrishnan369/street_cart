import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/data/models/variant_image_draft.dart';

abstract class ShopProductsEvent extends Equatable {
  const ShopProductsEvent();

  @override
  List<Object?> get props => [];
}

// Load Shop Products Event
class LoadShopProductsEvent extends ShopProductsEvent {
  final String shopId;
  const LoadShopProductsEvent(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

// Shop Products Updated Event
class ShopProductsUpdatedEvent extends ShopProductsEvent {
  final List<ProductModel> products;
  const ShopProductsUpdatedEvent(this.products);

  @override
  List<Object?> get props => [products];
}

// Add Product Event
class AddProductEvent extends ShopProductsEvent {
  final ProductModel product;
  final List<VariantImageDraft> variantDrafts;

  const AddProductEvent(this.product, this.variantDrafts);

  @override
  List<Object?> get props => [product, variantDrafts];
}

// Update Product Event
class UpdateProductEvent extends ShopProductsEvent {
  final ProductModel product;
  final List<VariantImageDraft> variantDrafts;

  const UpdateProductEvent(this.product, this.variantDrafts);

  @override
  List<Object?> get props => [product, variantDrafts];
}

// Delete Product Event
class DeleteProductEvent extends ShopProductsEvent {
  final String shopId;
  final String productId;
  const DeleteProductEvent(this.shopId, this.productId);

  @override
  List<Object?> get props => [shopId, productId];
}

// Search Products Event
class SearchProductsEvent extends ShopProductsEvent {
  final String query;
  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

// Filter Products By Category Event
class FilterProductsByCategoryEvent extends ShopProductsEvent {
  final List<String> categories;
  const FilterProductsByCategoryEvent(this.categories);

  @override
  List<Object?> get props => [categories];
}

// Add Custom Size Event
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

// Add Custom Color Event
class AddCustomColorEvent extends ShopProductsEvent {
  final String shopId;
  final String newColorHex;
  const AddCustomColorEvent({required this.shopId, required this.newColorHex});

  @override
  List<Object?> get props => [shopId, newColorHex];
}

// Product Config Event
class LoadProductConfigEvent extends ShopProductsEvent {
  final String shopId;
  const LoadProductConfigEvent(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

class LoadProductCategoriesEvent extends ShopProductsEvent {}

// Products UI Search
class ToggleSearchEvent extends ShopProductsEvent {
  final bool isSearching;
  const ToggleSearchEvent(this.isSearching);

  @override
  List<Object?> get props => [isSearching];
}

// Product Detail UI selectors
class InitProductDetailEvent extends ShopProductsEvent {
  final ProductModel product;
  const InitProductDetailEvent(this.product);

  @override
  List<Object?> get props => [product];
}

// Select Color Event
class SelectColorEvent extends ShopProductsEvent {
  final String? color;
  const SelectColorEvent(this.color);

  @override
  List<Object?> get props => [color];
}

// Select Size Event
class SelectSizeEvent extends ShopProductsEvent {
  final String? size;
  const SelectSizeEvent(this.size);

  @override
  List<Object?> get props => [size];
}

// Select Image Index Event
class SelectImageIndexEvent extends ShopProductsEvent {
  final int index;
  const SelectImageIndexEvent(this.index);

  @override
  List<Object?> get props => [index];
}

// Bottom sheet category filter selections
class InitFilterSelectionEvent extends ShopProductsEvent {}

class ToggleCategoryFilterEvent extends ShopProductsEvent {
  final String category;
  final bool isSelected;
  const ToggleCategoryFilterEvent(this.category, this.isSelected);

  @override
  List<Object?> get props => [category, isSelected];
}
