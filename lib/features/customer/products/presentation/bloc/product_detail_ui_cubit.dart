import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class ProductDetailUiState {
  final String? selectedColor;
  final String? selectedSize;
  final String? variantWarningMessage;

  const ProductDetailUiState({
    this.selectedColor,
    this.selectedSize,
    this.variantWarningMessage,
  });

  ProductDetailUiState copyWith({
    String? selectedColor,
    String? selectedSize,
    String? Function()? variantWarningMessage,
  }) {
    return ProductDetailUiState(
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      variantWarningMessage:
          variantWarningMessage != null ? variantWarningMessage() : this.variantWarningMessage,
    );
  }
}

class ProductDetailUiCubit extends Cubit<ProductDetailUiState> {
  ProductDetailUiCubit() : super(const ProductDetailUiState());

  void init(ProductModel product, String? initialColor, String? initialSize) {
    final colors = product.allColors;
    final sizes = product.allSizes;

    bool hasSavedVariant = initialColor != null || initialSize != null;
    bool isSavedVariantAvailable = false;

    String? selectedColor;
    String? selectedSize;
    String? variantWarningMessage;

    if (hasSavedVariant) {
      if (initialColor != null && initialSize != null) {
        final hasColor = colors.contains(initialColor);
        final hasSize = sizes.contains(initialSize);
        final stock = product.stockForVariant(initialColor, initialSize);
        if (hasColor && hasSize && stock > 0) {
          selectedColor = initialColor;
          selectedSize = initialSize;
          isSavedVariantAvailable = true;
        }
      }

      if (!isSavedVariantAvailable) {
        variantWarningMessage =
            'The saved variant is unavailable. Please choose another available variant.';
      }
    }

    if (!isSavedVariantAvailable) {
      if (colors.isNotEmpty) {
        selectedColor = colors.first;
      }
      if (sizes.isNotEmpty) {
        selectedSize = sizes.first;
      }
    }

    emit(ProductDetailUiState(
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      variantWarningMessage: variantWarningMessage,
    ));
  }

  void selectColor(String color, ProductModel product) {
    final sizes = product.allSizes;
    final defaultSize = sizes.isNotEmpty ? sizes.first : null;
    emit(state.copyWith(
      selectedColor: color,
      selectedSize: defaultSize,
    ));
  }

  void selectSize(String size) {
    emit(state.copyWith(selectedSize: size));
  }
}
