import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/utils/logger.dart';
import 'package:street_cart/features/customer/shops/domain/usecases/get_customer_shop_products.dart';
import 'shop_details_event.dart';
import 'shop_details_state.dart';

// Shop Details Bloc
class ShopDetailsBloc extends Bloc<ShopDetailsEvent, ShopDetailsState> {
  final GetCustomerShopProducts getShopProducts;

  ShopDetailsBloc({required this.getShopProducts})
    : super(ShopDetailsInitial()) {
    on<FetchShopProducts>(_onFetchShopProducts);
  }
  // Fetch Shops Products
  Future<void> _onFetchShopProducts(
    FetchShopProducts event,
    Emitter<ShopDetailsState> emit,
  ) async {
    emit(ShopDetailsLoading());
    try {
      final products = await getShopProducts(event.shopId);
      emit(ShopDetailsLoaded(products: products));
    } catch (e, stack) {
      AppLogger.error(
        'Failed to fetch shop products for ${event.shopId}',
        e,
        stack,
      );
      emit(const ShopDetailsError(message: 'Failed to load products.'));
    }
  }
}
