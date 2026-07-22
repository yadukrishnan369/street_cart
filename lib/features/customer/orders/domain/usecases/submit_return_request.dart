import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';

class SubmitReturnRequest {
  final IOrdersRepository repository;

  SubmitReturnRequest(this.repository);

  Future<void> call({
    required String orderId,
    required String itemId,
    required String reason,
    required String details,
  }) async {
    return await repository.submitReturnRequest(
      orderId: orderId,
      itemId: itemId,
      reason: reason,
      details: details,
    );
  }
}
