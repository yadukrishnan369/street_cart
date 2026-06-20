import 'package:equatable/equatable.dart';

abstract class AdminProfileEvent extends Equatable {
  const AdminProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdminProfile extends AdminProfileEvent {}

class UpdateAdminProfile extends AdminProfileEvent {
  final String fullName;

  const UpdateAdminProfile(this.fullName);

  @override
  List<Object?> get props => [fullName];
}
