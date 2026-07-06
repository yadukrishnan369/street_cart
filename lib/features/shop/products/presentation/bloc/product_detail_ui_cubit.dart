import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class ProductDetailUiState {
  final ProductModel product;
  final String? selectedColor;
  final String? selectedSize;

  const ProductDetailUiState({
    required this.product,
    this.selectedColor,
    this.selectedSize,
  });

  ProductDetailUiState copyWith({
    ProductModel? product,
    String? selectedColor,
    bool clearColor = false,
    String? selectedSize,
    bool clearSize = false,
  }) {
    return ProductDetailUiState(
      product: product ?? this.product,
      selectedColor: clearColor ? null : (selectedColor ?? this.selectedColor),
      selectedSize: clearSize ? null : (selectedSize ?? this.selectedSize),
    );
  }
}

class ProductDetailUiCubit extends Cubit<ProductDetailUiState> {
  ProductDetailUiCubit(ProductModel product)
    : super(
        ProductDetailUiState(
          product: product,
          selectedColor: product.allColors.isNotEmpty
              ? product.allColors.first
              : null,
          selectedSize: product.allSizes.isNotEmpty
              ? product.allSizes.first
              : null,
        ),
      );

  void selectColor(String? color) {
    if (color == null) {
      emit(state.copyWith(clearColor: true));
    } else {
      emit(state.copyWith(selectedColor: color));
    }
  }

  void selectSize(String? size) {
    if (size == null) {
      emit(state.copyWith(clearSize: true));
    } else {
      emit(state.copyWith(selectedSize: size));
    }
  }

  void updateProduct(ProductModel product) {
    final color = product.allColors.contains(state.selectedColor)
        ? state.selectedColor
        : null;
    final size = product.allSizes.contains(state.selectedSize)
        ? state.selectedSize
        : null;

    emit(
      ProductDetailUiState(
        product: product,
        selectedColor:
            color ??
            (product.allColors.isNotEmpty ? product.allColors.first : null),
        selectedSize:
            size ??
            (product.allSizes.isNotEmpty ? product.allSizes.first : null),
      ),
    );
  }
}
