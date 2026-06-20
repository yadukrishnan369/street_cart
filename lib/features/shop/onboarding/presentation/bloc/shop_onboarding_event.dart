import 'package:equatable/equatable.dart';

abstract class ShopOnboardingEvent extends Equatable {
  const ShopOnboardingEvent();

  @override
  List<Object?> get props => [];
}

class CompleteShopOnboardingEvent extends ShopOnboardingEvent {}
