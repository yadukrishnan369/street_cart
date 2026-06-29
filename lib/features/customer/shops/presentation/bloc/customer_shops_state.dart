import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class CustomerShopsState {}

class CustomerShopsInitial extends CustomerShopsState {}

class CustomerShopsLoading extends CustomerShopsState {}

class CustomerShopsLocationDisabled extends CustomerShopsState {}

class CustomerShopsLoaded extends CustomerShopsState {
  final List<ShopProfileModel> shops;
  final String locationText;
  CustomerShopsLoaded({required this.shops, required this.locationText});
}

class CustomerShopsError extends CustomerShopsState {
  final String message;
  CustomerShopsError({required this.message});
}
