import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/domain/usecases/get_shop_products.dart';
import 'package:street_cart/features/shop/products/domain/usecases/add_product.dart';
import 'package:street_cart/features/shop/products/domain/usecases/update_product.dart';
import 'package:street_cart/features/shop/products/domain/usecases/delete_product.dart';
import 'package:street_cart/features/shop/products/domain/usecases/get_shop_product_config.dart';
import 'package:street_cart/features/shop/products/domain/usecases/save_shop_product_config.dart';
import 'shop_products_event.dart';
import 'shop_products_state.dart';

class ShopProductsBloc extends Bloc<ShopProductsEvent, ShopProductsState> {
  final GetShopProducts _getShopProducts;
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;
  final GetShopProductConfig _getShopProductConfig;
  final SaveShopProductConfig _saveShopProductConfig;

  StreamSubscription<List<ProductModel>>? _productsSubscription;
  Map<String, dynamic> _customConfig = const {};

  ShopProductsBloc({
    required GetShopProducts getShopProducts,
    required AddProduct addProduct,
    required UpdateProduct updateProduct,
    required DeleteProduct deleteProduct,
    required GetShopProductConfig getShopProductConfig,
    required SaveShopProductConfig saveShopProductConfig,
  })  : _getShopProducts = getShopProducts,
        _addProduct = addProduct,
        _updateProduct = updateProduct,
        _deleteProduct = deleteProduct,
        _getShopProductConfig = getShopProductConfig,
        _saveShopProductConfig = saveShopProductConfig,
        super(ShopProductsInitial()) {
    on<LoadShopProductsEvent>(_onLoadShopProducts);
    on<ShopProductsUpdatedEvent>(_onShopProductsUpdated);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterProductsByCategoryEvent>(_onFilterProductsByCategory);
    on<AddCustomSizeEvent>(_onAddCustomSize);
    on<AddCustomColorEvent>(_onAddCustomColor);
    on<LoadProductConfigEvent>(_onLoadProductConfig);
  }

  Future<void> _onLoadShopProducts(
      LoadShopProductsEvent event, Emitter<ShopProductsState> emit) async {
    emit(ShopProductsLoading());
    await _productsSubscription?.cancel();

    try {
      _customConfig = await _getShopProductConfig(event.shopId);
    } catch (_) {}

    _productsSubscription = _getShopProducts(event.shopId).listen(
      (products) {
        add(ShopProductsUpdatedEvent(products));
      },
      onError: (error) {
        print("ERROR FETCHING PRODUCTS: $error");
        add(const ShopProductsUpdatedEvent([]));
      },
    );
  }

  void _onShopProductsUpdated(
      ShopProductsUpdatedEvent event, Emitter<ShopProductsState> emit) {
    final currentSearch = (state is ShopProductsLoaded)
        ? (state as ShopProductsLoaded).searchQuery
        : '';
    final currentCategories = (state is ShopProductsLoaded)
        ? (state as ShopProductsLoaded).selectedCategories
        : const ['All'];

    final filtered = _filterAndSearchList(
      event.products,
      currentSearch,
      currentCategories,
    );

    emit(ShopProductsLoaded(
      allProducts: event.products,
      filteredProducts: filtered,
      searchQuery: currentSearch,
      selectedCategories: currentCategories,
      customConfig: _customConfig,
    ));
  }

  Future<void> _onAddProduct(
      AddProductEvent event, Emitter<ShopProductsState> emit) async {
    try {
      await _addProduct(event.product, event.imageFiles);
      final latestState = state;
      emit(const ShopProductsOperationSuccess('Product published successfully!'));
      if (latestState is ShopProductsLoaded) {
        emit(latestState);
      }
    } catch (e) {
      final latestState = state;
      emit(ShopProductsError(e.toString()));
      if (latestState is ShopProductsLoaded) {
        emit(latestState);
      }
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event, Emitter<ShopProductsState> emit) async {
    try {
      await _updateProduct(event.product, event.imagesOrFiles);
      final latestState = state;
      emit(const ShopProductsOperationSuccess('Product updated successfully!'));
      if (latestState is ShopProductsLoaded) {
        emit(latestState);
      }
    } catch (e) {
      final latestState = state;
      emit(ShopProductsError(e.toString()));
      if (latestState is ShopProductsLoaded) {
        emit(latestState);
      }
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<ShopProductsState> emit) async {
    try {
      await _deleteProduct(event.shopId, event.productId);
      final latestState = state;
      emit(const ShopProductsOperationSuccess('Product deleted successfully!'));
      if (latestState is ShopProductsLoaded) {
        emit(latestState);
      }
    } catch (e) {
      final latestState = state;
      emit(ShopProductsError(e.toString()));
      if (latestState is ShopProductsLoaded) {
        emit(latestState);
      }
    }
  }

  void _onSearchProducts(
      SearchProductsEvent event, Emitter<ShopProductsState> emit) {
    if (state is ShopProductsLoaded) {
      final s = state as ShopProductsLoaded;
      final filtered = _filterAndSearchList(
        s.allProducts,
        event.query,
        s.selectedCategories,
      );
      emit(s.copyWith(
        searchQuery: event.query,
        filteredProducts: filtered,
      ));
    }
  }

  void _onFilterProductsByCategory(
      FilterProductsByCategoryEvent event, Emitter<ShopProductsState> emit) {
    if (state is ShopProductsLoaded) {
      final s = state as ShopProductsLoaded;
      final filtered = _filterAndSearchList(
        s.allProducts,
        s.searchQuery,
        event.categories,
      );
      emit(s.copyWith(
        selectedCategories: event.categories,
        filteredProducts: filtered,
      ));
    }
  }

  Future<void> _onAddCustomSize(
      AddCustomSizeEvent event, Emitter<ShopProductsState> emit) async {
    if (state is ShopProductsLoaded) {
      final s = state as ShopProductsLoaded;
      final Map<String, dynamic> config = Map.from(_customConfig);
      final Map<String, dynamic> sizes = Map.from(config['sizes'] ?? {});
      final List<String> currentSizes = List<String>.from(sizes[event.sizeStandard] ?? []);

      if (!currentSizes.contains(event.newSize)) {
        currentSizes.add(event.newSize);
      }
      sizes[event.sizeStandard] = currentSizes;
      config['sizes'] = sizes;

      try {
        await _saveShopProductConfig(event.shopId, config);
        _customConfig = config;
        emit(s.copyWith(customConfig: config));
      } catch (e) {
        emit(ShopProductsError(e.toString()));
        emit(s);
      }
    }
  }

  Future<void> _onAddCustomColor(
      AddCustomColorEvent event, Emitter<ShopProductsState> emit) async {
    if (state is ShopProductsLoaded) {
      final s = state as ShopProductsLoaded;
      final Map<String, dynamic> config = Map.from(_customConfig);
      final List<String> currentColors = List<String>.from(config['colors'] ?? []);

      if (!currentColors.contains(event.newColorHex)) {
        currentColors.add(event.newColorHex);
      }
      config['colors'] = currentColors;

      try {
        await _saveShopProductConfig(event.shopId, config);
        _customConfig = config;
        emit(s.copyWith(customConfig: config));
      } catch (e) {
        emit(ShopProductsError(e.toString()));
        emit(s);
      }
    }
  }

  Future<void> _onLoadProductConfig(
      LoadProductConfigEvent event, Emitter<ShopProductsState> emit) async {
    if (state is ShopProductsLoaded) {
      final s = state as ShopProductsLoaded;
      try {
        _customConfig = await _getShopProductConfig(event.shopId);
        emit(s.copyWith(customConfig: _customConfig));
      } catch (_) {}
    }
  }

  List<ProductModel> _filterAndSearchList(
      List<ProductModel> list, String query, List<String> categories) {
    return list.where((product) {
      final matchesQuery =
          product.name.toLowerCase().contains(query.toLowerCase());
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
