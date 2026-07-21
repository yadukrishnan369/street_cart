import 'package:equatable/equatable.dart';

abstract class AdminProfileEvent extends Equatable {
  const AdminProfileEvent();

  @override
  List<Object?> get props => [];
}

// Load Admin Profile Event
class LoadAdminProfile extends AdminProfileEvent {}

// Update Admin Profile Event
class UpdateAdminProfile extends AdminProfileEvent {
  final String fullName;

  const UpdateAdminProfile(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

// Show Edit Overlay Event
class ShowEditOverlay extends AdminProfileEvent {
  const ShowEditOverlay();
}

// Hide Edit Overlay Event
class HideEditOverlay extends AdminProfileEvent {
  const HideEditOverlay();
}
