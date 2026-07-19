import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/constants/admin_constants.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/utils/image_picker_helper.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_state.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/category_filter_bottom_sheet.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class ProductsPageHelper {
  // Get Active Products
  static List<ProductModel> getActiveProducts(List<ProductModel> products) {
    return products.where((p) => p.stockQuantity > 0).toList();
  }

  // Get Out Of Stock Products
  static List<ProductModel> getOutOfStockProducts(List<ProductModel> products) {
    return products.where((p) => p.stockQuantity <= 0).toList();
  }

  // Extract Categories
  static List<String> extractCategories(List<ProductModel> products) {
    final productCats = products
        .map((p) => p.category)
        .where((cat) => cat.isNotEmpty)
        .toSet()
        .toList();
    return ['All', ...productCats];
  }

  // Show Category Filter Page
  static void showCategoryFilter(
    BuildContext context,
    ShopProductsBloc productsBloc,
    List<String> categories,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (modalContext) {
        return BlocProvider.value(
          value: productsBloc,
          child: CategoryFilterBottomSheet(
            productsBloc: productsBloc,
            categories: categories,
          ),
        );
      },
    );
  }

  // Confirmation for Product Delete
  static void confirmDelete({
    required BuildContext context,
    required String shopId,
    required ProductModel product,
    required ShopProductsBloc productsBloc,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Delete Product',
        content:
            'Are you sure you want to delete this product? This action cannot be undone.',
        confirmText: 'Delete',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          // Double confirmation
          showDialog(
            context: context,
            builder: (doubleConfirmContext) => ConfirmationModal(
              title: 'Confirm Deletion',
              content:
                  'Please confirm once more. Delete "${product.name}" permanently?',
              confirmText: 'Permanently Delete',
              confirmColor: ShopAppColors.error,
              onConfirm: () {
                Navigator.pop(doubleConfirmContext);
                productsBloc.add(DeleteProductEvent(shopId, product.id));
              },
              onCancel: () => Navigator.pop(doubleConfirmContext),
            ),
          );
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Calculate Stock Quantity
  static int calculateDisplayStock(
    ProductModel product,
    String? selectedColor,
    String? selectedSize,
  ) {
    if (!product.hasVariants) {
      return product.stockQuantity;
    }

    if (selectedColor != null && selectedSize != null) {
      return product.stockForVariant(selectedColor, selectedSize);
    } else if (selectedColor != null) {
      final variant = product.variants.firstWhere(
        (v) => v.colorName == selectedColor,
        orElse: () => product.variants.first,
      );
      return variant.totalStock;
    } else if (selectedSize != null) {
      return product.variants.fold(
        0,
        (sum, v) => sum + (v.sizes[selectedSize] ?? 0),
      );
    }
    return product.stockQuantity;
  }

  // Get Display Images
  static List<String> getDisplayImages(
    ProductModel product,
    String? selectedColor,
  ) {
    if (selectedColor != null) {
      return product.imagesForColor(selectedColor);
    }
    return product.displayImages;
  }

  // Get Updated Product
  static ProductModel? getUpdatedProduct(
    List<ProductModel> products,
    String productId,
  ) {
    final updatedList = products.where((p) => p.id == productId);
    return updatedList.isNotEmpty ? updatedList.first : null;
  }

  // Get Add Edit Categories
  static List<String> getAddEditCategories(
    ShopProductsState productsState,
    ProductModel? product,
  ) {
    Map<String, dynamic> customConfig = {};
    if (productsState.status == ShopProductsStatus.loaded) {
      customConfig = productsState.customConfig;
    }
    List<String> dynamicCategories = [];
    if (customConfig['allowed_categories'] != null) {
      dynamicCategories = List<String>.from(
        customConfig['allowed_categories'] as List,
      );
    }
    if (dynamicCategories.isEmpty) {
      dynamicCategories = List.from(AdminConstants.defaultProductCategories);
    }
    if (product != null && !dynamicCategories.contains(product.category)) {
      dynamicCategories.add(product.category);
    }
    return dynamicCategories;
  }

  // Initialize Add Edit Product Defaults
  static void initAddEditDefaults({
    required AddEditProductBloc bloc,
    required ShopProductsState productsState,
    required ProductModel? product,
  }) {
    if (product == null && productsState.status == ShopProductsStatus.loaded) {
      final customConfig = productsState.customConfig;
      if (bloc.state.category.isEmpty) {
        final sizeGroupsList = customConfig['size_groups'] as List<dynamic>?;
        String defaultSizeStandard = AdminConstants.defaultSizeStandards.first;
        if (sizeGroupsList != null && sizeGroupsList.isNotEmpty) {
          final Map<String, dynamic> groupMap = Map<String, dynamic>.from(
            sizeGroupsList.first as Map,
          );
          final name = groupMap['name']?.toString() ?? '';
          if (name.isNotEmpty) {
            defaultSizeStandard = name;
          }
        }
        bloc.add(
          InitDefaultsEvent(
            defaultCategory: AdminConstants.defaultProductCategories.first,
            defaultSizeStandard: defaultSizeStandard,
          ),
        );
      }
    }
  }

  // Publish Product
  static void publishProduct({
    required AddEditProductBloc bloc,
    required GlobalKey<FormState> formKey,
    required String shopId,
    required ProductModel? product,
    required ShopProductsBloc productsBloc,
    required String name,
    required String price,
    required String offerPrice,
    required String description,
  }) {
    bloc.add(UpdateNameEvent(name));
    bloc.add(UpdateOriginalPriceEvent(price));
    bloc.add(UpdateOfferPriceEvent(offerPrice));
    bloc.add(UpdateDescriptionEvent(description));

    final error = bloc.validate();
    if (error != null) {
      bloc.add(SetErrorEvent(error));
      return;
    }

    if (!formKey.currentState!.validate()) return;

    bloc.add(const SetPublishingEvent(true));
    bloc.add(const ClearErrorEvent());

    final productModel = bloc.buildProductModel(
      shopId,
      productId: product?.id ?? '',
    );
    final variantDrafts = bloc.buildVariantDrafts();

    if (product == null) {
      productsBloc.add(AddProductEvent(productModel, variantDrafts));
    } else {
      productsBloc.add(UpdateProductEvent(productModel, variantDrafts));
    }
  }

  // Pick Variant Images
  static Future<void> pickVariantImages(BuildContext context) async {
    final bloc = context.read<AddEditProductBloc>();
    bloc.add(const SetPickingImagesEvent(true));
    try {
      final files = await ImagePickerHelper.pickMultiImage(limit: 8);
      if (files.isNotEmpty) {
        bloc.add(UpdateDraftImagesEvent(List<dynamic>.from(files)));
      }
    } catch (_) {
    } finally {
      bloc.add(const SetPickingImagesEvent(false));
    }
  }

  // Save Variant
  static void saveVariant({
    required BuildContext context,
    required AddEditProductState state,
    required ValueChanged<VariantDraft> onSave,
  }) {
    final bloc = context.read<AddEditProductBloc>();
    bloc.add(const SetVariantErrorEvent(null));

    final draft = state.editingVariant;
    if (draft == null) return;

    if (draft.colorName.isEmpty) {
      bloc.add(const SetVariantErrorEvent('Please select a color.'));
      return;
    }
    if (draft.images.isEmpty) {
      bloc.add(
        const SetVariantErrorEvent('Add at least one image for this variant.'),
      );
      return;
    }

    final sizesMap = draft.sizes;
    if (sizesMap.isEmpty || sizesMap.values.every((qty) => qty == 0)) {
      bloc.add(
        const SetVariantErrorEvent(
          'Please enter a stock quantity for at least one size.',
        ),
      );
      return;
    }

    onSave(draft);
    Navigator.pop(context);
  }

  // Get Available Colors
  static Map<String, String> getAvailableColors(
    Map<String, dynamic> customConfig,
  ) {
    final Map<String, String> colors = {};
    if (customConfig['colors'] != null) {
      for (final c in customConfig['colors'] as List<dynamic>) {
        final Map<String, dynamic> colorMap = Map<String, dynamic>.from(
          c as Map,
        );
        final name = colorMap['name']?.toString() ?? '';
        final hex = colorMap['hex_code']?.toString() ?? '';
        if (name.isNotEmpty) {
          colors[name] = hex;
        }
      }
    }
    if (colors.isEmpty) {
      for (final name in AdminConstants.defaultProductColors) {
        colors[name] = '';
      }
    }
    return colors;
  }

  // Get Available Sizes
  static List<String> getAvailableSizes(
    Map<String, dynamic> customConfig,
    String sizeStandard,
  ) {
    if (customConfig['size_groups'] != null) {
      for (final g in customConfig['size_groups'] as List<dynamic>) {
        final Map<String, dynamic> groupMap = Map<String, dynamic>.from(
          g as Map,
        );
        if (groupMap['name']?.toString() == sizeStandard) {
          final rawSizes = groupMap['sizes'] as List<dynamic>?;
          if (rawSizes != null) {
            return rawSizes.map((e) => e.toString()).toList();
          }
        }
      }
    }
    return List<String>.from(
      AdminConstants.defaultProductSizes[sizeStandard] ?? [],
    );
  }

  // Get Size Standards
  static List<String> getSizeStandards(Map<String, dynamic> customConfig) {
    final list = <String>[];
    if (customConfig['size_groups'] != null) {
      for (final g in customConfig['size_groups'] as List<dynamic>) {
        final Map<String, dynamic> groupMap = Map<String, dynamic>.from(
          g as Map,
        );
        final name = groupMap['name']?.toString() ?? '';
        if (name.isNotEmpty && !list.contains(name)) {
          list.add(name);
        }
      }
    }
    if (list.isEmpty) {
      list.addAll(AdminConstants.defaultSizeStandards);
    }
    return list;
  }
}
