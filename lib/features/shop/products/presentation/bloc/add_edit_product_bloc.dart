import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/data/models/variant_image_draft.dart';
import 'add_edit_product_event.dart';
import 'add_edit_product_state.dart';

class AddEditProductBloc extends Bloc<AddEditProductEvent, AddEditProductState> {
  AddEditProductBloc() : super(const AddEditProductState()) {
    on<InitFromProductEvent>(_onInitFromProduct);
    on<InitDefaultsEvent>(_onInitDefaults);
    on<UpdateNameEvent>(_onUpdateName);
    on<UpdateOriginalPriceEvent>(_onUpdateOriginalPrice);
    on<UpdateOfferPriceEvent>(_onUpdateOfferPrice);
    on<UpdateDescriptionEvent>(_onUpdateDescription);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<UpdateSizeStandardEvent>(_onUpdateSizeStandard);
    on<AddVariantEvent>(_onAddVariant);
    on<UpdateVariantEvent>(_onUpdateVariant);
    on<RemoveVariantEvent>(_onRemoveVariant);
    on<SetPublishingEvent>(_onSetPublishing);
    on<SetErrorEvent>(_onSetError);
    on<ClearErrorEvent>(_onClearError);
  }

  void _onInitFromProduct(InitFromProductEvent event, Emitter<AddEditProductState> emit) {
    final product = event.product;
    final variants = product.variants
        .map(
          (v) => VariantDraft(
            colorName: v.colorName,
            images: List<dynamic>.from(v.images),
            sizes: Map<String, int>.from(v.sizes),
          ),
        )
        .toList();

    emit(state.copyWith(
      name: product.name,
      originalPrice: product.originalPrice.toString(),
      offerPrice: product.offerPrice?.toString() ?? '',
      description: product.description,
      category: product.category,
      sizeStandard: product.sizeStandard,
      variants: variants,
    ));
  }

  void _onInitDefaults(InitDefaultsEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(
      category: event.defaultCategory,
      sizeStandard: event.defaultSizeStandard,
    ));
  }

  void _onUpdateName(UpdateNameEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onUpdateOriginalPrice(UpdateOriginalPriceEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(originalPrice: event.price));
  }

  void _onUpdateOfferPrice(UpdateOfferPriceEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(offerPrice: event.offerPrice));
  }

  void _onUpdateDescription(UpdateDescriptionEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onUpdateCategory(UpdateCategoryEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(category: event.category));
  }

  void _onUpdateSizeStandard(UpdateSizeStandardEvent event, Emitter<AddEditProductState> emit) {
    final updatedVariants = state.variants.map((v) {
      final newSizes = {for (final s in event.newSizeKeys) s: v.sizes[s] ?? 0};
      return v.copyWith(sizes: newSizes);
    }).toList();
    emit(state.copyWith(sizeStandard: event.sizeStandard, variants: updatedVariants));
  }

  void _onAddVariant(AddVariantEvent event, Emitter<AddEditProductState> emit) {
    final updated = [...state.variants, event.draft];
    emit(state.copyWith(variants: updated, clearError: true));
  }

  void _onUpdateVariant(UpdateVariantEvent event, Emitter<AddEditProductState> emit) {
    final list = List<VariantDraft>.from(state.variants);
    if (event.index >= 0 && event.index < list.length) {
      list[event.index] = event.updated;
      emit(state.copyWith(variants: list));
    }
  }

  void _onRemoveVariant(RemoveVariantEvent event, Emitter<AddEditProductState> emit) {
    final list = List<VariantDraft>.from(state.variants);
    if (event.index >= 0 && event.index < list.length) {
      list.removeAt(event.index);
      emit(state.copyWith(variants: list));
    }
  }

  void _onSetPublishing(SetPublishingEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(isPublishing: event.isPublishing));
  }

  void _onSetError(SetErrorEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(errorMessage: event.message, isPublishing: false));
  }

  void _onClearError(ClearErrorEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(clearError: true));
  }

  ProductModel buildProductModel(String shopId, {String productId = ''}) {
    final totalStock = state.totalStock;
    return ProductModel(
      id: productId,
      shopId: shopId,
      name: state.name.trim(),
      originalPrice: double.tryParse(state.originalPrice) ?? 0.0,
      offerPrice: state.offerPrice.trim().isNotEmpty
          ? double.tryParse(state.offerPrice)
          : null,
      description: state.description.trim(),
      stockQuantity: totalStock,
      category: state.category,
      sizeStandard: state.sizeStandard,
      variants: const [], // filled by datasource after upload
      isActive: totalStock > 0,
      createdAt: DateTime.now(),
    );
  }

  List<VariantImageDraft> buildVariantDrafts() {
    return state.variants
        .map(
          (v) => VariantImageDraft(
            colorName: v.colorName,
            imagesOrFiles: List<dynamic>.from(v.images),
            sizes: Map<String, int>.from(v.sizes),
          ),
        )
        .toList();
  }

  String? validate() {
    if (state.name.trim().isEmpty) return 'Product name is required.';
    if (state.originalPrice.trim().isEmpty ||
        double.tryParse(state.originalPrice) == null) {
      return 'Enter a valid original price.';
    }
    final offer = state.offerPrice.trim();
    if (offer.isNotEmpty) {
      final offerVal = double.tryParse(offer);
      final origVal = double.tryParse(state.originalPrice) ?? 0;
      if (offerVal == null || offerVal >= origVal) {
        return 'Offer price must be less than the original price.';
      }
    }
    if (state.description.trim().isEmpty) return 'Description is required.';
    if (state.variants.isEmpty) return 'Add at least one color variant.';
    for (final v in state.variants) {
      if (v.images.isEmpty) {
        return 'Add at least one image for the "${v.colorName}" variant.';
      }
      if (v.sizes.isEmpty || v.sizes.values.every((qty) => qty == 0)) {
        return 'Set stock quantity for at least one size in the "${v.colorName}" variant.';
      }
    }
    return null;
  }
}
