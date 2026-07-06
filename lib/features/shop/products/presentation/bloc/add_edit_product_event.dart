import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_state.dart';

abstract class AddEditProductEvent {
  const AddEditProductEvent();
}

class InitFromProductEvent extends AddEditProductEvent {
  final ProductModel product;
  const InitFromProductEvent(this.product);
}

class InitDefaultsEvent extends AddEditProductEvent {
  final String defaultCategory;
  final String defaultSizeStandard;
  const InitDefaultsEvent({
    required this.defaultCategory,
    required this.defaultSizeStandard,
  });
}

class UpdateNameEvent extends AddEditProductEvent {
  final String name;
  const UpdateNameEvent(this.name);
}

class UpdateOriginalPriceEvent extends AddEditProductEvent {
  final String price;
  const UpdateOriginalPriceEvent(this.price);
}

class UpdateOfferPriceEvent extends AddEditProductEvent {
  final String offerPrice;
  const UpdateOfferPriceEvent(this.offerPrice);
}

class UpdateDescriptionEvent extends AddEditProductEvent {
  final String description;
  const UpdateDescriptionEvent(this.description);
}

class UpdateCategoryEvent extends AddEditProductEvent {
  final String category;
  const UpdateCategoryEvent(this.category);
}

class UpdateSizeStandardEvent extends AddEditProductEvent {
  final String sizeStandard;
  final List<String> newSizeKeys;
  const UpdateSizeStandardEvent({
    required this.sizeStandard,
    required this.newSizeKeys,
  });
}

class AddVariantEvent extends AddEditProductEvent {
  final VariantDraft draft;
  const AddVariantEvent(this.draft);
}

class UpdateVariantEvent extends AddEditProductEvent {
  final int index;
  final VariantDraft updated;
  const UpdateVariantEvent(this.index, this.updated);
}

class RemoveVariantEvent extends AddEditProductEvent {
  final int index;
  const RemoveVariantEvent(this.index);
}

class SetPublishingEvent extends AddEditProductEvent {
  final bool isPublishing;
  const SetPublishingEvent(this.isPublishing);
}

class SetErrorEvent extends AddEditProductEvent {
  final String message;
  const SetErrorEvent(this.message);
}

class ClearErrorEvent extends AddEditProductEvent {
  const ClearErrorEvent();
}
