import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/profile/data/models/admin_profile_model.dart';

abstract class AdminProfileState extends Equatable {
  const AdminProfileState();

  @override
  List<Object?> get props => [];
}

class AdminProfileInitial extends AdminProfileState {}

class AdminProfileLoading extends AdminProfileState {}

class AdminProfileLoaded extends AdminProfileState {
  final AdminProfileModel profile;

  const AdminProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class AdminProfileError extends AdminProfileState {
  final String message;

  const AdminProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
