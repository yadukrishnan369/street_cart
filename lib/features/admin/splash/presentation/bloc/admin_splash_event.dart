import 'package:equatable/equatable.dart';

abstract class AdminSplashEvent extends Equatable {
  const AdminSplashEvent();

  @override
  List<Object?> get props => [];
}

class CheckAdminSplashSessionEvent extends AdminSplashEvent {}
