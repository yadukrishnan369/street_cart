import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/payment/domain/repositories/i_payment_repository.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/send_shop_notification.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/send_admin_notification.dart';

class PlaceCustomerOrder {
  final IPaymentRepository repository;
  final SendShopNotification sendShopNotification;
  final SendAdminNotification sendAdminNotification;

  PlaceCustomerOrder({
    required this.repository,
    required this.sendShopNotification,
    required this.sendAdminNotification,
  });

  Future<String> call({
    required List<CartItem> items,
    required AddressModel address,
    required String paymentMethod,
    required String paymentStatus,
    required double totalAmount,
  }) async {
    final result = await repository.placeOrder(
      items: items,
      address: address,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      totalAmount: totalAmount,
    );

    final String firstOrderId = result['firstOrderId'] ?? '';
    final Map<dynamic, dynamic> rawShopOrderIds = result['shopOrderIds'] ?? {};
    final Map<String, String> shopOrderIds = rawShopOrderIds.map(
      (k, v) => MapEntry(k.toString(), v.toString()),
    );

    // Trigger notification
    for (final shopId in shopOrderIds.keys) {
      final orderId = shopOrderIds[shopId]!;
      final shopItems = items.where((i) => i.shopId == shopId).toList();
      final itemCount = shopItems.fold<int>(0, (sum, i) => sum + i.quantity);
      final orderAmount = shopItems.fold<double>(
        0.0,
        (sum, i) => sum + (i.price * i.quantity),
      );
      // Send new order notification to shop
      try {
        await sendShopNotification.sendNewOrder(
          shopId: shopId,
          orderId: orderId,
          itemCount: itemCount,
        );
        // Send new order notification to admin
        await sendAdminNotification.sendNewOrder(
          orderId: orderId,
          amount: orderAmount,
        );
      } catch (_) {}
    }

    return firstOrderId;
  }
}
