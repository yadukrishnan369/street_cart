import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationSuccess extends LocationState {
  final bool success;

  const LocationSuccess(this.success);

  @override
  List<Object?> get props => [success];
}

class LocationSkipped extends LocationState {}

class LocationFailure extends LocationState {
  final String message;

  const LocationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
