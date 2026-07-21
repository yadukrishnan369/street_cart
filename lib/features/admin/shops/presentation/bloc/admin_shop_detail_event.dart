// Base class
abstract class AdminShopDetailEvent {}

// Load Shop Detail Event
class LoadShopDetailRequested extends AdminShopDetailEvent {
  final String shopId;

  LoadShopDetailRequested(this.shopId);
}

// Toggle Shop Suspension Requested Event
class ToggleShopSuspensionRequested extends AdminShopDetailEvent {
  final String shopId;
  final bool isSuspended;

  ToggleShopSuspensionRequested({
    required this.shopId,
    required this.isSuspended,
  });
}

// Delete Shop Requested Event
class DeleteShopRequested extends AdminShopDetailEvent {
  final String shopId;

  DeleteShopRequested(this.shopId);
}

// Shop Product Filter Changed Event
class ShopProductFilterChanged extends AdminShopDetailEvent {
  final String filter;

  ShopProductFilterChanged(this.filter);
}

// Shop Product Page Changed Event
class ShopProductPageChanged extends AdminShopDetailEvent {
  /// The new 1-indexed page number.
  final int page;

  ShopProductPageChanged(this.page);
}
