enum ShopOrderStatus {
  placed,
  processing,
  shipped,
  delivered,
  cancelled,
  returned,
  return_requested,
  unknown;

  static ShopOrderStatus fromString(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'pending':
      case 'placed':
        return ShopOrderStatus.placed;
      case 'processing':
        return ShopOrderStatus.processing;
      case 'packed':
      case 'shipped':
        return ShopOrderStatus.shipped;
      case 'delivered':
        return ShopOrderStatus.delivered;
      case 'cancelled':
        return ShopOrderStatus.cancelled;
      case 'returned':
        return ShopOrderStatus.returned;
      case 'return_requested':
        return ShopOrderStatus.return_requested;
      default:
        return ShopOrderStatus.unknown;
    }
  }

  String get value => name;
}
