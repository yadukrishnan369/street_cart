abstract class AdminShopDetailEvent {}

class LoadShopDetailRequested extends AdminShopDetailEvent {
  final String shopId;

  LoadShopDetailRequested(this.shopId);
}

class ToggleShopSuspensionRequested extends AdminShopDetailEvent {
  final String shopId;
  final bool isSuspended;

  ToggleShopSuspensionRequested({
    required this.shopId,
    required this.isSuspended,
  });
}

class DeleteShopRequested extends AdminShopDetailEvent {
  final String shopId;

  DeleteShopRequested(this.shopId);
}
