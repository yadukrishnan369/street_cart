import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/splash/domain/repositories/i_shop_splash_repository.dart';

abstract class ShopSplashState extends Equatable {
  const ShopSplashState();

  @override
  List<Object?> get props => [];
}

class ShopSplashInitial extends ShopSplashState {}

class ShopSplashLoading extends ShopSplashState {}

class ShopSplashLoaded extends ShopSplashState {
  final ShopAppStatus status;

  const ShopSplashLoaded(this.status);

  @override
  List<Object?> get props => [status];
}

class ShopSplashError extends ShopSplashState {
  final String message;

  const ShopSplashError(this.message);

  @override
  List<Object?> get props => [message];
}
