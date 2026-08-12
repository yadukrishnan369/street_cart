import 'package:street_cart/features/shop/notification/domain/repositories/i_shop_notifications_repository.dart';

class SendShopNotification {
  final IShopNotificationsRepository repository;

  SendShopNotification(this.repository);
  Future<void> sendNewOrder({
    required String shopId,
    required String orderId,
    required int itemCount,
  }) {
    return repository.sendNewOrderNotification(
      shopId: shopId,
      orderId: orderId,
      itemCount: itemCount,
    );
  }

  Future<void> sendOrderCancelledByCustomer({
    required String shopId,
    required String orderId,
  }) {
    return repository.sendOrderCancelledByCustomerNotification(
      shopId: shopId,
      orderId: orderId,
    );
  }

  Future<void> sendReturnRequest({
    required String shopId,
    required String orderId,
  }) {
    return repository.sendReturnRequestNotification(
      shopId: shopId,
      orderId: orderId,
    );
  }

  Future<void> sendReview({
    required String shopId,
    required String productId,
    required String productName,
    required int rating,
  }) {
    return repository.sendReviewNotification(
      shopId: shopId,
      productId: productId,
      productName: productName,
      rating: rating,
    );
  }

  Future<void> sendApprovalStatus({
    required String shopId,
    required String shopName,
    required bool approved,
    String? rejectionReason,
  }) {
    return repository.sendApprovalStatusNotification(
      shopId: shopId,
      shopName: shopName,
      approved: approved,
      rejectionReason: rejectionReason,
    );
  }

  Future<void> sendCommissionUpdate({
    required String shopId,
    required double percentage,
  }) {
    return repository.sendCommissionUpdateNotification(
      shopId: shopId,
      percentage: percentage,
    );
  }
}
