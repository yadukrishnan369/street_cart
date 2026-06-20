import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class RequestLocationEvent extends LocationEvent {}

class SkipLocationEvent extends LocationEvent {}
