part of 'shop_auth_bloc.dart';

abstract class ShopAuthState extends Equatable {
  const ShopAuthState();
  @override
  List<Object?> get props => [];
}

class ShopAuthInitial extends ShopAuthState {}

class ShopAuthLoading extends ShopAuthState {}

class ShopAuthSuccess extends ShopAuthState {}

class ShopAuthFailure extends ShopAuthState {
  final String message;
  const ShopAuthFailure(this.message);
}

class ShopStatusLoaded extends ShopAuthState {
  final ShopProfileModel? shop;
  const ShopStatusLoaded(this.shop);
  @override
  List<Object?> get props => [shop];
}

class ShopAuthVerificationWaiting extends ShopAuthState {
  final String ownerName;
  final String shopName;
  final String email;
  final bool isResend;

  const ShopAuthVerificationWaiting({
    required this.ownerName,
    required this.shopName,
    required this.email,
    this.isResend = false,
  });

  @override
  List<Object?> get props => [ownerName, shopName, email, isResend];
}

class ShopAuthVerificationSuccess extends ShopAuthState {}

class ShopAuthPasswordResetSuccess extends ShopAuthState {}
