import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class CustomerShopsState {}

// Initial Shops state
class CustomerShopsInitial extends CustomerShopsState {}

// Loading state
class CustomerShopsLoading extends CustomerShopsState {}

// Location Permissions/services Disabled State
class CustomerShopsLocationDisabled extends CustomerShopsState {}

// Shops Loaded State
class CustomerShopsLoaded extends CustomerShopsState {
  final List<ShopProfileModel> shops;
  final String locationText;

  final String searchQuery;

  CustomerShopsLoaded({
    required this.shops,
    required this.locationText,
    this.searchQuery = '',
  });
}

// Shop Error State
class CustomerShopsError extends CustomerShopsState {
  final String message;
  CustomerShopsError({required this.message});
}
