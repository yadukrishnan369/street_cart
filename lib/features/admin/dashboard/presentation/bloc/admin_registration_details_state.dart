import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class AdminRegistrationDetailsState extends Equatable {
  const AdminRegistrationDetailsState();

  @override
  List<Object?> get props => [];
}

class AdminRegistrationDetailsInitial extends AdminRegistrationDetailsState {}

class AdminRegistrationDetailsLoading extends AdminRegistrationDetailsState {}

class AdminRegistrationDetailsLoadSuccess extends AdminRegistrationDetailsState {
  final ShopProfileModel shop;

  const AdminRegistrationDetailsLoadSuccess(this.shop);

  @override
  List<Object?> get props => [shop];
}

class AdminRegistrationDetailsLoadFailure extends AdminRegistrationDetailsState {
  final String message;

  const AdminRegistrationDetailsLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminRegistrationActionInProgress extends AdminRegistrationDetailsState {}

class AdminRegistrationActionSuccess extends AdminRegistrationDetailsState {
  final String message;
  final bool approved;

  const AdminRegistrationActionSuccess(this.message, {required this.approved});

  @override
  List<Object?> get props => [message, approved];
}

class AdminRegistrationActionFailure extends AdminRegistrationDetailsState {
  final String message;

  const AdminRegistrationActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
