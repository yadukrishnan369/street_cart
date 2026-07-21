import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/profile/data/models/admin_profile_model.dart';

abstract class AdminProfileState extends Equatable {
  const AdminProfileState();

  @override
  List<Object?> get props => [];
}

// Profile Initial State
class AdminProfileInitial extends AdminProfileState {}

// Profile Loading State
class AdminProfileLoading extends AdminProfileState {}

// Profile Loaded State
class AdminProfileLoaded extends AdminProfileState {
  final AdminProfileModel profile;
  final bool isEditing;

  const AdminProfileLoaded(this.profile, {this.isEditing = false});

  AdminProfileLoaded copyWith({AdminProfileModel? profile, bool? isEditing}) {
    return AdminProfileLoaded(
      profile ?? this.profile,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  List<Object?> get props => [profile, isEditing];
}

// Profile Error State
class AdminProfileError extends AdminProfileState {
  final String message;

  const AdminProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
