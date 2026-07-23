import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';

class ProcessRefund {
  final IShopOrdersRepository repository;

  ProcessRefund(this.repository);

  Future<void> call(
    String orderId,
    double refundAmount,
    String refundStatus,
  ) async {
    return repository.processRefund(orderId, refundAmount, refundStatus);
  }
}
