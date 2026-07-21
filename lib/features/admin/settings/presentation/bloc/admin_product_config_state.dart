import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

abstract class AdminProductConfigState extends Equatable {
  final bool isColorsTab;
  const AdminProductConfigState({this.isColorsTab = true});

  @override
  List<Object?> get props => [isColorsTab];
}

// Product Config Initial State
class ProductConfigInitial extends AdminProductConfigState {
  const ProductConfigInitial({super.isColorsTab = true});
}

// Product Config Loading State
class ProductConfigLoading extends AdminProductConfigState {
  const ProductConfigLoading({super.isColorsTab = true});
}

// Product Config Loaded State
class ProductConfigLoaded extends AdminProductConfigState {
  final ProductConfigModel config;
  const ProductConfigLoaded(this.config, {super.isColorsTab = true});

  @override
  List<Object?> get props => [config, isColorsTab];
}

// Product Config Action InProgress State
class ProductConfigActionInProgress extends AdminProductConfigState {
  final ProductConfigModel config;
  const ProductConfigActionInProgress(this.config, {super.isColorsTab = true});

  @override
  List<Object?> get props => [config, isColorsTab];
}

// Product Config Action Success State
class ProductConfigActionSuccess extends AdminProductConfigState {
  final String message;
  final ProductConfigModel config;
  const ProductConfigActionSuccess({
    required this.message,
    required this.config,
    super.isColorsTab = true,
  });

  @override
  List<Object?> get props => [message, config, isColorsTab];
}

// Product Config Action Failure State
class ProductConfigActionFailure extends AdminProductConfigState {
  final String message;
  final ProductConfigModel config;
  const ProductConfigActionFailure({
    required this.message,
    required this.config,
    super.isColorsTab = true,
  });

  @override
  List<Object?> get props => [message, config, isColorsTab];
}

// Product Config Load Failure State
class ProductConfigLoadFailure extends AdminProductConfigState {
  final String message;
  const ProductConfigLoadFailure(this.message, {super.isColorsTab = true});

  @override
  List<Object?> get props => [message, isColorsTab];
}
