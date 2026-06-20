import 'package:equatable/equatable.dart';
import '../../data/models/admin_settings_model.dart';

abstract class AdminSettingsEvent extends Equatable {
  const AdminSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdminSettings extends AdminSettingsEvent {}

class UpdatePlatformCommission extends AdminSettingsEvent {
  final double percentage;

  const UpdatePlatformCommission(this.percentage);

  @override
  List<Object?> get props => [percentage];
}

class UpdatePaymentControls extends AdminSettingsEvent {
  final bool enableCod;
  final bool enableOnline;

  const UpdatePaymentControls({
    required this.enableCod,
    required this.enableOnline,
  });

  @override
  List<Object?> get props => [enableCod, enableOnline];
}

class UpdateAdminPassword extends AdminSettingsEvent {
  final String currentPassword;
  final String newPassword;

  const UpdateAdminPassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class UpdateCategories extends AdminSettingsEvent {
  final List<CategoryModel> productCategories;
  final List<CategoryModel> businessCategories;

  const UpdateCategories({
    required this.productCategories,
    required this.businessCategories,
  });

  @override
  List<Object?> get props => [productCategories, businessCategories];
}

