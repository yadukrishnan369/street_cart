import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/core/utils/logger.dart';
import 'package:street_cart/features/customer/shops/domain/usecases/get_nearby_shops.dart';
import 'customer_shops_event.dart';
import 'customer_shops_state.dart';

// Customer Shops Bloc
class CustomerShopsBloc extends Bloc<CustomerShopsEvent, CustomerShopsState> {
  final GetNearbyShops getNearbyShops;
  final SharedPreferences _sharedPreferences;

  CustomerShopsBloc({
    required this.getNearbyShops,
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences,
       super(CustomerShopsInitial()) {
    on<FetchCustomerShops>(_onFetchCustomerShops);
    on<UpdateShopSearchQuery>(_onUpdateShopSearchQuery);
  }

  // Fetch nearby shops and default user delivery address
  Future<void> _onFetchCustomerShops(
    FetchCustomerShops event,
    Emitter<CustomerShopsState> emit,
  ) async {
    final locationEnabled =
        _sharedPreferences.getBool('locationServices') ?? false;
    if (!locationEnabled) {
      emit(CustomerShopsLocationDisabled());
      return;
    }

    emit(CustomerShopsLoading());
    try {
      final address =
          _sharedPreferences.getString('customer_address') ??
          _sharedPreferences.getString('address') ??
          _sharedPreferences.getString('location_address') ??
          'Your Location';

      final shops = await getNearbyShops();
      emit(CustomerShopsLoaded(shops: shops, locationText: address));
    } catch (e, stack) {
      AppLogger.error('Failed to fetch customer shops', e, stack);
      emit(CustomerShopsError(message: 'Failed to load shops.'));
    }
  }

  // Search Filter Handler
  void _onUpdateShopSearchQuery(
    UpdateShopSearchQuery event,
    Emitter<CustomerShopsState> emit,
  ) {
    if (state is CustomerShopsLoaded) {
      final current = state as CustomerShopsLoaded;
      emit(
        CustomerShopsLoaded(
          shops: current.shops,
          locationText: current.locationText,
          searchQuery: event.searchQuery,
        ),
      );
    }
  }
}
