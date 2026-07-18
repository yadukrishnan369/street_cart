import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/payment/domain/repositories/i_payment_repository.dart';
import 'package:street_cart/features/customer/payment/data/datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements IPaymentRepository {
  final IPaymentRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  PaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<String> placeOrder({
    required List<CartItem> items,
    required AddressModel address,
    required String paymentMethod,
    required String paymentStatus,
    required double totalAmount,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return await remoteDataSource.placeOrder(
      items: items,
      address: address,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      totalAmount: totalAmount,
    );
  }
}
