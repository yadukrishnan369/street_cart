import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/data/models/variant_image_draft.dart';
import 'add_edit_product_event.dart';
import 'add_edit_product_state.dart';

class AddEditProductBloc
    extends Bloc<AddEditProductEvent, AddEditProductState> {
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

    // Variant Draft details events
    on<InitVariantDraftEvent>((event, emit) {
      final existing = event.existingVariant;
      final initialColor =
          existing?.colorName ??
          (event.availableColors.isNotEmpty
              ? event.availableColors.keys.first
              : '');
      final initialHex =
          existing?.colorHex ??
          (event.availableColors.isNotEmpty
              ? (event.availableColors[initialColor] ?? '')
              : '');
      final sizes = {
        for (final size in event.availableSizes)
          size: existing?.sizes[size] ?? 0,
      };
      emit(
        state.copyWith(
          editingVariant: VariantDraft(
            colorName: initialColor,
            colorHex: initialHex,
            images: List<dynamic>.from(existing?.images ?? []),
            sizes: sizes,
          ),
          variantErrorMessage: null,
        ),
      );
    });

    on<UpdateDraftColorEvent>((event, emit) {
      if (state.editingVariant != null) {
        emit(
          state.copyWith(
            editingVariant: state.editingVariant!.copyWith(
              colorName: event.colorName,
              colorHex: event.colorHex,
            ),
          ),
        );
      }
    });

    on<UpdateDraftImagesEvent>((event, emit) {
      if (state.editingVariant != null) {
        emit(
          state.copyWith(
            editingVariant: state.editingVariant!.copyWith(
              images: event.images,
            ),
          ),
        );
      }
    });
    // Update Draft Size Qty
    on<UpdateDraftSizeQtyEvent>((event, emit) {
      if (state.editingVariant != null) {
        final currentSizes = Map<String, int>.from(state.editingVariant!.sizes);
        currentSizes[event.size] = event.qty;
        emit(
          state.copyWith(
            editingVariant: state.editingVariant!.copyWith(sizes: currentSizes),
          ),
        );
      }
    });

    on<SetPickingImagesEvent>((event, emit) {
      emit(state.copyWith(isPickingImages: event.value));
    });

    on<SetVariantErrorEvent>((event, emit) {
      if (event.message == null) {
        emit(state.copyWith(clearVariantError: true));
      } else {
        emit(state.copyWith(variantErrorMessage: event.message));
      }
    });
  }
  // Init From Product
  void _onInitFromProduct(
    InitFromProductEvent event,
    Emitter<AddEditProductState> emit,
  ) {
    final product = event.product;
    final variants = product.variants
        .map(
          (v) => VariantDraft(
            colorName: v.colorName,
            colorHex: v.colorHex,
            images: List<dynamic>.from(v.images),
            sizes: Map<String, int>.from(v.sizes),
          ),
        )
        .toList();

    emit(
      state.copyWith(
        name: product.name,
        originalPrice: product.originalPrice.toString(),
        offerPrice: product.offerPrice?.toString() ?? '',
        description: product.description,
        category: product.category,
        sizeStandard: product.sizeStandard,
        variants: variants,
      ),
    );
  }

  // Init Defaults
  void _onInitDefaults(
    InitDefaultsEvent event,
    Emitter<AddEditProductState> emit,
  ) {
    emit(
      state.copyWith(
        category: event.defaultCategory,
        sizeStandard: event.defaultSizeStandard,
      ),
    );
  }

  // Update Name
  void _onUpdateName(UpdateNameEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(name: event.name));
  }

  // Update Original Price
  void _onUpdateOriginalPrice(
    UpdateOriginalPriceEvent event,
    Emitter<AddEditProductState> emit,
  ) {
    emit(state.copyWith(originalPrice: event.price));
  }

  // Update Offer Price
  void _onUpdateOfferPrice(
    UpdateOfferPriceEvent event,
    Emitter<AddEditProductState> emit,
  ) {
    emit(state.copyWith(offerPrice: event.offerPrice));
  }

  // Update Description
  void _onUpdateDescription(
    UpdateDescriptionEvent event,
    Emitter<AddEditProductState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  // Update Category
  void _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<AddEditProductState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  // Update Size Standard
  void _onUpdateSizeStandard(
    UpdateSizeStandardEvent event,
    Emitter<AddEditProductState> emit,
  ) {
    final updatedVariants = state.variants.map((v) {
      final newSizes = {for (final s in event.newSizeKeys) s: v.sizes[s] ?? 0};
      return v.copyWith(sizes: newSizes);
    }).toList();
    emit(
      state.copyWith(
        sizeStandard: event.sizeStandard,
        variants: updatedVariants,
      ),
    );
  }

  // Add new Varient
  void _onAddVariant(AddVariantEvent event, Emitter<AddEditProductState> emit) {
    final updated = [...state.variants, event.draft];
    emit(state.copyWith(variants: updated, clearError: true));
  }

  // Update Varient
  void _onUpdateVariant(
    UpdateVariantEvent event,
    Emitter<AddEditProductState> emit,
  ) {
    final list = List<VariantDraft>.from(state.variants);
    if (event.index >= 0 && event.index < list.length) {
      list[event.index] = event.updated;
      emit(state.copyWith(variants: list));
    }
  }

  // Remove Varient
  void _onRemoveVariant(
    RemoveVariantEvent event,
    Emitter<AddEditProductState> emit,
  ) {
    final list = List<VariantDraft>.from(state.variants);
    if (event.index >= 0 && event.index < list.length) {
      list.removeAt(event.index);
      emit(state.copyWith(variants: list));
    }
  }

  void _onSetPublishing(
    SetPublishingEvent event,
    Emitter<AddEditProductState> emit,
  ) {
    emit(state.copyWith(isPublishing: event.isPublishing));
  }

  void _onSetError(SetErrorEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(errorMessage: event.message, isPublishing: false));
  }

  void _onClearError(ClearErrorEvent event, Emitter<AddEditProductState> emit) {
    emit(state.copyWith(clearError: true));
  }

  // Build Product Model
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
            colorHex: v.colorHex,
            imagesOrFiles: List<dynamic>.from(v.images),
            sizes: Map<String, int>.from(v.sizes),
          ),
        )
        .toList();
  }

  // Product Validation
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
    }
    return null;
  }
}
