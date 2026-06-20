import 'package:equatable/equatable.dart';

abstract class ShopHomeEvent extends Equatable {
  const ShopHomeEvent();

  @override
  List<Object?> get props => [];
}

class CheckFirstHomeVisitEvent extends ShopHomeEvent {}

class CompleteFirstHomeVisitEvent extends ShopHomeEvent {}
