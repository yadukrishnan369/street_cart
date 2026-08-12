import 'package:street_cart/features/customer/notification/domain/repositories/i_customer_notifications_repository.dart';

class SendCustomerNotification {
  final ICustomerNotificationsRepository repository;

  SendCustomerNotification(this.repository);

  Future<void> sendOrderStatus({
    required String customerId,
    required String orderId,
    required String status,
  }) {
    return repository.sendOrderStatusNotification(
      customerId: customerId,
      orderId: orderId,
      status: status,
    );
  }

  Future<void> sendReturnStatus({
    required String customerId,
    required String orderId,
    required String returnStatus,
  }) {
    return repository.sendReturnStatusNotification(
      customerId: customerId,
      orderId: orderId,
      returnStatus: returnStatus,
    );
  }

  Future<void> sendRefundProcessed({
    required String customerId,
    required String orderId,
    required double refundAmount,
  }) {
    return repository.sendRefundProcessedNotification(
      customerId: customerId,
      orderId: orderId,
      refundAmount: refundAmount,
    );
  }

  Future<void> sendWishlistPriceDrop({
    required String customerId,
    required String productId,
    required String productName,
    required int percentOff,
  }) {
    return repository.sendWishlistPriceDropNotification(
      customerId: customerId,
      productId: productId,
      productName: productName,
      percentOff: percentOff,
    );
  }

  Future<void> sendWishlistRestock({
    required String customerId,
    required String productId,
    required String productName,
  }) {
    return repository.sendWishlistRestockNotification(
      customerId: customerId,
      productId: productId,
      productName: productName,
    );
  }

  Future<void> notifyWishlisted({
    required String productId,
    required String productName,
    required bool isPriceDrop,
    int percentOff = 0,
  }) {
    return repository.notifyWishlistedCustomers(
      productId: productId,
      productName: productName,
      isPriceDrop: isPriceDrop,
      percentOff: percentOff,
    );
  }

  Future<void> notifyCart({
    required String productId,
    required String productName,
    required int percentOff,
  }) {
    return repository.notifyCartCustomers(
      productId: productId,
      productName: productName,
      percentOff: percentOff,
    );
  }
}
