import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

abstract class AdminProductConfigState extends Equatable {
  const AdminProductConfigState();

  @override
  List<Object?> get props => [];
}

class ProductConfigInitial extends AdminProductConfigState {}

class ProductConfigLoading extends AdminProductConfigState {}

class ProductConfigLoaded extends AdminProductConfigState {
  final ProductConfigModel config;
  const ProductConfigLoaded(this.config);

  @override
  List<Object?> get props => [config];
}

class ProductConfigActionInProgress extends AdminProductConfigState {
  final ProductConfigModel config;
  const ProductConfigActionInProgress(this.config);

  @override
  List<Object?> get props => [config];
}

class ProductConfigActionSuccess extends AdminProductConfigState {
  final String message;
  final ProductConfigModel config;
  const ProductConfigActionSuccess({
    required this.message,
    required this.config,
  });

  @override
  List<Object?> get props => [message, config];
}

class ProductConfigActionFailure extends AdminProductConfigState {
  final String message;
  final ProductConfigModel config;
  const ProductConfigActionFailure({
    required this.message,
    required this.config,
  });

  @override
  List<Object?> get props => [message, config];
}

class ProductConfigLoadFailure extends AdminProductConfigState {
  final String message;
  const ProductConfigLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
