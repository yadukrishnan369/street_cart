import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_state.dart';

abstract class AddEditProductEvent {
  const AddEditProductEvent();
}

// Init Product Event
class InitFromProductEvent extends AddEditProductEvent {
  final ProductModel product;
  const InitFromProductEvent(this.product);
}

// Init Defaults Event
class InitDefaultsEvent extends AddEditProductEvent {
  final String defaultCategory;
  final String defaultSizeStandard;
  const InitDefaultsEvent({
    required this.defaultCategory,
    required this.defaultSizeStandard,
  });
}

// Update Name Event
class UpdateNameEvent extends AddEditProductEvent {
  final String name;
  const UpdateNameEvent(this.name);
}

// Update Original Price Event
class UpdateOriginalPriceEvent extends AddEditProductEvent {
  final String price;
  const UpdateOriginalPriceEvent(this.price);
}

// Update Offer Price Event
class UpdateOfferPriceEvent extends AddEditProductEvent {
  final String offerPrice;
  const UpdateOfferPriceEvent(this.offerPrice);
}

// Update Description Event
class UpdateDescriptionEvent extends AddEditProductEvent {
  final String description;
  const UpdateDescriptionEvent(this.description);
}

// Update Category Event
class UpdateCategoryEvent extends AddEditProductEvent {
  final String category;
  const UpdateCategoryEvent(this.category);
}

// Update Size Standard Event
class UpdateSizeStandardEvent extends AddEditProductEvent {
  final String sizeStandard;
  final List<String> newSizeKeys;
  const UpdateSizeStandardEvent({
    required this.sizeStandard,
    required this.newSizeKeys,
  });
}

// Add Variant Event
class AddVariantEvent extends AddEditProductEvent {
  final VariantDraft draft;
  const AddVariantEvent(this.draft);
}

// Update Variant Event
class UpdateVariantEvent extends AddEditProductEvent {
  final int index;
  final VariantDraft updated;
  const UpdateVariantEvent(this.index, this.updated);
}

// Remove Variant Event
class RemoveVariantEvent extends AddEditProductEvent {
  final int index;
  const RemoveVariantEvent(this.index);
}

// Set Publishing Event
class SetPublishingEvent extends AddEditProductEvent {
  final bool isPublishing;
  const SetPublishingEvent(this.isPublishing);
}

// Set Error Event
class SetErrorEvent extends AddEditProductEvent {
  final String message;
  const SetErrorEvent(this.message);
}

// Clear Error Event
class ClearErrorEvent extends AddEditProductEvent {
  const ClearErrorEvent();
}

// Variant Draft editing events
class InitVariantDraftEvent extends AddEditProductEvent {
  final VariantDraft? existingVariant;
  final List<String> availableSizes;
  final Map<String, String> availableColors;
  const InitVariantDraftEvent({
    this.existingVariant,
    required this.availableSizes,
    required this.availableColors,
  });
}

// Update Draft Color Event
class UpdateDraftColorEvent extends AddEditProductEvent {
  final String colorName;
  const UpdateDraftColorEvent(this.colorName);
}

// Update Draft Images Event
class UpdateDraftImagesEvent extends AddEditProductEvent {
  final List<dynamic> images;
  const UpdateDraftImagesEvent(this.images);
}

// Update Draft Size Qty Event
class UpdateDraftSizeQtyEvent extends AddEditProductEvent {
  final String size;
  final int qty;
  const UpdateDraftSizeQtyEvent(this.size, this.qty);
}

// Set Picking Images Event
class SetPickingImagesEvent extends AddEditProductEvent {
  final bool value;
  const SetPickingImagesEvent(this.value);
}

// Set Variant Error Event
class SetVariantErrorEvent extends AddEditProductEvent {
  final String? message;
  const SetVariantErrorEvent(this.message);
}
