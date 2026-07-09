enum CustomerOrderStatus {
  placed,
  processing,
  shipped,
  delivered,
  cancelled,
  unknown;

  static CustomerOrderStatus fromString(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'pending':
      case 'placed':
        return CustomerOrderStatus.placed;
      case 'processing':
        return CustomerOrderStatus.processing;
      case 'packed':
      case 'shipped':
        return CustomerOrderStatus.shipped;
      case 'delivered':
        return CustomerOrderStatus.delivered;
      case 'cancelled':
        return CustomerOrderStatus.cancelled;
      default:
        return CustomerOrderStatus.unknown;
    }
  }

  String get value => name;
}
