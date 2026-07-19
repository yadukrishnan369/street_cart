import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/domain/usecases/get_shop_products.dart';
import 'package:street_cart/features/shop/products/domain/usecases/add_product.dart';
import 'package:street_cart/features/shop/products/domain/usecases/update_product.dart';
import 'package:street_cart/features/shop/products/domain/usecases/delete_product.dart';
import 'package:street_cart/features/shop/products/domain/usecases/get_shop_product_config.dart';
import 'package:street_cart/features/shop/products/domain/usecases/save_shop_product_config.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_product_categories.dart';
import 'shop_products_event.dart';
import 'shop_products_state.dart';

class ShopProductsBloc extends Bloc<ShopProductsEvent, ShopProductsState> {
  final GetShopProducts _getShopProducts;
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;
  final GetShopProductConfig _getShopProductConfig;
  final SaveShopProductConfig _saveShopProductConfig;
  final GetProductCategories _getProductCategories;

  StreamSubscription<List<ProductModel>>? _productsSubscription;
  Map<String, dynamic> _customConfig = const {};

  ShopProductsBloc({
    required GetShopProducts getShopProducts,
    required AddProduct addProduct,
    required UpdateProduct updateProduct,
    required DeleteProduct deleteProduct,
    required GetShopProductConfig getShopProductConfig,
    required SaveShopProductConfig saveShopProductConfig,
    required GetProductCategories getProductCategories,
  }) : _getShopProducts = getShopProducts,
       _addProduct = addProduct,
       _updateProduct = updateProduct,
       _deleteProduct = deleteProduct,
       _getShopProductConfig = getShopProductConfig,
       _saveShopProductConfig = saveShopProductConfig,
       _getProductCategories = getProductCategories,
       super(const ShopProductsState()) {
    on<LoadShopProductsEvent>(_onLoadShopProducts);
    on<ShopProductsUpdatedEvent>(_onShopProductsUpdated);
    on<ShopProductsErrorEvent>((event, emit) {
      emit(
        state.copyWith(
          status: ShopProductsStatus.error,
          errorMessage: event.message,
        ),
      );
    });
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterProductsByCategoryEvent>(_onFilterProductsByCategory);
    on<AddCustomSizeEvent>(_onAddCustomSize);
    on<AddCustomColorEvent>(_onAddCustomColor);
    on<LoadProductConfigEvent>(_onLoadProductConfig);
    on<LoadProductCategoriesEvent>(_onLoadProductCategories);

    // Products UI Search
    on<ToggleSearchEvent>((event, emit) {
      emit(state.copyWith(isSearching: event.isSearching));
    });

    // Product Detail UI selectors
    on<InitProductDetailEvent>((event, emit) {
      final p = event.product;
      emit(
        state.copyWith(
          detailProduct: p,
          selectedColor: p.allColors.isNotEmpty ? p.allColors.first : null,
          selectedSize: p.allSizes.isNotEmpty ? p.allSizes.first : null,
          currentImageIndex: 0,
        ),
      );
    });

    on<SelectColorEvent>((event, emit) {
      if (event.color == null) {
        emit(state.copyWith(clearColor: true, currentImageIndex: 0));
      } else {
        emit(state.copyWith(selectedColor: event.color, currentImageIndex: 0));
      }
    });

    on<SelectSizeEvent>((event, emit) {
      if (event.size == null) {
        emit(state.copyWith(clearSize: true));
      } else {
        emit(state.copyWith(selectedSize: event.size));
      }
    });

    on<SelectImageIndexEvent>((event, emit) {
      emit(state.copyWith(currentImageIndex: event.index));
    });

    // Bottom sheet category filter selections
    on<InitFilterSelectionEvent>((event, emit) {
      emit(
        state.copyWith(
          tempSelectedCategories: List<String>.from(state.selectedCategories),
        ),
      );
    });

    on<ToggleCategoryFilterEvent>((event, emit) {
      var list = List<String>.from(state.tempSelectedCategories);
      if (event.category == 'All') {
        list = ['All'];
      } else {
        list.remove('All');
        if (event.isSelected) {
          if (!list.contains(event.category)) {
            list.add(event.category);
          }
        } else {
          list.remove(event.category);
        }
        if (list.isEmpty) {
          list.add('All');
        }
      }
      emit(state.copyWith(tempSelectedCategories: list));
    });
  }
  // Load Shop Products
  Future<void> _onLoadShopProducts(
    LoadShopProductsEvent event,
    Emitter<ShopProductsState> emit,
  ) async {
    emit(state.copyWith(status: ShopProductsStatus.loading));
    await _productsSubscription?.cancel();

    try {
      _customConfig = await _getShopProductConfig(event.shopId);
    } catch (_) {}

    _productsSubscription = _getShopProducts(event.shopId).listen(
      (products) => add(ShopProductsUpdatedEvent(products)),
      onError: (error) => add(ShopProductsErrorEvent(error.toString())),
    );
  }

  // Shop Products Updated
  void _onShopProductsUpdated(
    ShopProductsUpdatedEvent event,
    Emitter<ShopProductsState> emit,
  ) {
    final filtered = _filterAndSearchList(
      event.products,
      state.searchQuery,
      state.selectedCategories,
    );

    ProductModel? updatedDetailProduct;
    if (state.detailProduct != null) {
      final matchIdx = event.products.indexWhere(
        (p) => p.id == state.detailProduct!.id,
      );
      if (matchIdx != -1) {
        updatedDetailProduct = event.products[matchIdx];
      }
    }

    emit(
      state.copyWith(
        status: ShopProductsStatus.loaded,
        allProducts: event.products,
        filteredProducts: filtered,
        customConfig: _customConfig,
        detailProduct: updatedDetailProduct,
      ),
    );
  }

  // Add Product
  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ShopProductsState> emit,
  ) async {
    try {
      await _addProduct(event.product, event.variantDrafts);
      emit(
        state.copyWith(
          status: ShopProductsStatus.operationSuccess,
          successMessage: 'Product published successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopProductsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Update Product
  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ShopProductsState> emit,
  ) async {
    try {
      await _updateProduct(event.product, event.variantDrafts);
      emit(
        state.copyWith(
          status: ShopProductsStatus.operationSuccess,
          successMessage: 'Product updated successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopProductsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Delete Product
  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ShopProductsState> emit,
  ) async {
    try {
      await _deleteProduct(event.shopId, event.productId);
      emit(
        state.copyWith(
          status: ShopProductsStatus.operationSuccess,
          successMessage: 'Product deleted successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopProductsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Search Products
  void _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ShopProductsState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        filteredProducts: _filterAndSearchList(
          state.allProducts,
          event.query,
          state.selectedCategories,
        ),
      ),
    );
  }

  // Filter Products By Category
  void _onFilterProductsByCategory(
    FilterProductsByCategoryEvent event,
    Emitter<ShopProductsState> emit,
  ) {
    emit(
      state.copyWith(
        selectedCategories: event.categories,
        filteredProducts: _filterAndSearchList(
          state.allProducts,
          state.searchQuery,
          event.categories,
        ),
      ),
    );
  }

  // Add Custom Size
  Future<void> _onAddCustomSize(
    AddCustomSizeEvent event,
    Emitter<ShopProductsState> emit,
  ) async {
    final Map<String, dynamic> config = Map.from(_customConfig);
    final Map<String, dynamic> sizes = Map.from(config['sizes'] ?? {});
    final List<String> currentSizes = List<String>.from(
      sizes[event.sizeStandard] ?? [],
    );

    if (!currentSizes.contains(event.newSize)) {
      currentSizes.add(event.newSize);
    }
    sizes[event.sizeStandard] = currentSizes;
    config['sizes'] = sizes;

    try {
      await _saveShopProductConfig(event.shopId, config);
      _customConfig = config;
      emit(state.copyWith(customConfig: config));
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopProductsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Add Custom Color
  Future<void> _onAddCustomColor(
    AddCustomColorEvent event,
    Emitter<ShopProductsState> emit,
  ) async {
    final Map<String, dynamic> config = Map.from(_customConfig);
    final List<String> currentColors = List<String>.from(
      config['colors'] ?? [],
    );

    if (!currentColors.contains(event.newColorHex)) {
      currentColors.add(event.newColorHex);
    }
    config['colors'] = currentColors;

    try {
      await _saveShopProductConfig(event.shopId, config);
      _customConfig = config;
      emit(state.copyWith(customConfig: config));
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopProductsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Load Product Config
  Future<void> _onLoadProductConfig(
    LoadProductConfigEvent event,
    Emitter<ShopProductsState> emit,
  ) async {
    emit(state.copyWith(status: ShopProductsStatus.loading));
    try {
      _customConfig = await _getShopProductConfig(event.shopId);
      emit(
        state.copyWith(
          status: ShopProductsStatus.loaded,
          customConfig: _customConfig,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopProductsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Load Product Config
  Future<void> _onLoadProductCategories(
    LoadProductCategoriesEvent event,
    Emitter<ShopProductsState> emit,
  ) async {
    emit(state.copyWith(status: ShopProductsStatus.categoriesLoading));
    try {
      final loadedCategories = await _getProductCategories();
      emit(
        state.copyWith(
          status: ShopProductsStatus.categoriesLoaded,
          categories: loadedCategories,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopProductsStatus.categoriesError,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  // Filter And Search List
  List<ProductModel> _filterAndSearchList(
    List<ProductModel> list,
    String query,
    List<String> categories,
  ) {
    return list.where((product) {
      final matchesQuery = product.name.toLowerCase().contains(
        query.toLowerCase(),
      );
      final matchesCategory =
          categories.isEmpty ||
          categories.contains('All') ||
          categories.contains(product.category);
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}
