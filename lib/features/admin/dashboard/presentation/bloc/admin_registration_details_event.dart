import 'package:equatable/equatable.dart';

abstract class AdminRegistrationDetailsEvent extends Equatable {
  const AdminRegistrationDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadShopDetailsRequested extends AdminRegistrationDetailsEvent {
  final String shopId;

  const LoadShopDetailsRequested(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

class ApproveShopRequested extends AdminRegistrationDetailsEvent {
  final String shopId;

  const ApproveShopRequested(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

class RejectShopRequested extends AdminRegistrationDetailsEvent {
  final String shopId;
  final String rejectionReason;

  const RejectShopRequested({required this.shopId, required this.rejectionReason});

  @override
  List<Object?> get props => [shopId, rejectionReason];
}
