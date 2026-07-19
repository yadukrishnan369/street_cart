import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

enum ShopProductsStatus {
  initial,
  loading,
  loaded,
  operationSuccess,
  error,
  categoriesLoading,
  categoriesLoaded,
  categoriesError,
}

class ShopProductsState extends Equatable {
  final ShopProductsStatus status;
  final String? errorMessage;
  final String? successMessage;
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final String searchQuery;
  final List<String> selectedCategories;
  final Map<String, dynamic> customConfig;
  final List<String> categories;

  // Products UI fields
  final bool isSearching;

  // Product Detail UI fields
  final ProductModel? detailProduct;
  final String? selectedColor;
  final String? selectedSize;
  final int currentImageIndex;

  final List<String> tempSelectedCategories;

  const ShopProductsState({
    this.status = ShopProductsStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.searchQuery = '',
    this.selectedCategories = const ['All'],
    this.customConfig = const {},
    this.categories = const [],
    this.isSearching = false,
    this.detailProduct,
    this.selectedColor,
    this.selectedSize,
    this.currentImageIndex = 0,
    this.tempSelectedCategories = const ['All'],
  });

  ShopProductsState copyWith({
    ShopProductsStatus? status,
    String? errorMessage,
    String? successMessage,
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    String? searchQuery,
    List<String>? selectedCategories,
    Map<String, dynamic>? customConfig,
    List<String>? categories,
    bool? isSearching,
    ProductModel? detailProduct,
    String? selectedColor,
    bool clearColor = false,
    String? selectedSize,
    bool clearSize = false,
    int? currentImageIndex,
    List<String>? tempSelectedCategories,
  }) {
    return ShopProductsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      customConfig: customConfig ?? this.customConfig,
      categories: categories ?? this.categories,
      isSearching: isSearching ?? this.isSearching,
      detailProduct: detailProduct ?? this.detailProduct,
      selectedColor: clearColor ? null : (selectedColor ?? this.selectedColor),
      selectedSize: clearSize ? null : (selectedSize ?? this.selectedSize),
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
      tempSelectedCategories:
          tempSelectedCategories ?? this.tempSelectedCategories,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    successMessage,
    allProducts,
    filteredProducts,
    searchQuery,
    selectedCategories,
    customConfig,
    categories,
    isSearching,
    detailProduct,
    selectedColor,
    selectedSize,
    currentImageIndex,
    tempSelectedCategories,
  ];
}
