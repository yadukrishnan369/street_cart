import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class AdminRegistrationDetailsState extends Equatable {
  const AdminRegistrationDetailsState();

  @override
  List<Object?> get props => [];
}

// Registration Details Initial State
class AdminRegistrationDetailsInitial extends AdminRegistrationDetailsState {}

// Registration Details Loading State
class AdminRegistrationDetailsLoading extends AdminRegistrationDetailsState {}

// Registration Details Load Success State
class AdminRegistrationDetailsLoadSuccess
    extends AdminRegistrationDetailsState {
  final ShopProfileModel shop;

  const AdminRegistrationDetailsLoadSuccess(this.shop);

  @override
  List<Object?> get props => [shop];
}

// Registration Details Load Failure State
class AdminRegistrationDetailsLoadFailure
    extends AdminRegistrationDetailsState {
  final String message;

  const AdminRegistrationDetailsLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Registration Action In Progress State
class AdminRegistrationActionInProgress extends AdminRegistrationDetailsState {}

class AdminRegistrationActionSuccess extends AdminRegistrationDetailsState {
  final String message;
  final bool approved;

  const AdminRegistrationActionSuccess(this.message, {required this.approved});

  @override
  List<Object?> get props => [message, approved];
}

// Registration Action Failure State
class AdminRegistrationActionFailure extends AdminRegistrationDetailsState {
  final String message;

  const AdminRegistrationActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
