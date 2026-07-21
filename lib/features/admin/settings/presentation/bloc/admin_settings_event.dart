import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

abstract class AdminSettingsEvent extends Equatable {
  const AdminSettingsEvent();

  @override
  List<Object?> get props => [];
}

// Load Settings Event
class LoadAdminSettings extends AdminSettingsEvent {}

// Update Platform Commission Event
class UpdatePlatformCommission extends AdminSettingsEvent {
  final double percentage;

  const UpdatePlatformCommission(this.percentage);

  @override
  List<Object?> get props => [percentage];
}

// Update Payment Controls Event
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

// Update Admin Password Event
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

// Update Categories Event
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

// Init Category Form Event
class InitCategoryForm extends AdminSettingsEvent {
  final CategoryModel? initialCategory;
  final List<SizeGroupModel> allSizeGroups;

  const InitCategoryForm({this.initialCategory, required this.allSizeGroups});

  @override
  List<Object?> get props => [initialCategory, allSizeGroups];
}

// Update Category Form Name Event
class UpdateCategoryFormName extends AdminSettingsEvent {
  final String name;

  const UpdateCategoryFormName(this.name);

  @override
  List<Object?> get props => [name];
}

// Add Product Category to Form Event
class AddProductCategoryToForm extends AdminSettingsEvent {
  final String productCategory;

  const AddProductCategoryToForm(this.productCategory);

  @override
  List<Object?> get props => [productCategory];
}

// Remove Product Category From Form Event
class RemoveProductCategoryFromForm extends AdminSettingsEvent {
  final int index;

  const RemoveProductCategoryFromForm(this.index);

  @override
  List<Object?> get props => [index];
}

// Toggle Size Group In Form Event
class ToggleSizeGroupInForm extends AdminSettingsEvent {
  final String sizeGroupName;

  const ToggleSizeGroupInForm(this.sizeGroupName);

  @override
  List<Object?> get props => [sizeGroupName];
}

// Validate Category Form Event
class ValidateCategoryForm extends AdminSettingsEvent {
  const ValidateCategoryForm();
}

// Update Cod Toggle Event
class UpdateDraftCodToggle extends AdminSettingsEvent {
  final bool value;
  const UpdateDraftCodToggle(this.value);
  @override
  List<Object?> get props => [value];
}

// Update Online Toggle Event
class UpdateDraftOnlineToggle extends AdminSettingsEvent {
  final bool value;
  const UpdateDraftOnlineToggle(this.value);
  @override
  List<Object?> get props => [value];
}

// Set Percentage Error Event
class SetPercentageError extends AdminSettingsEvent {
  final String? error;
  const SetPercentageError(this.error);
  @override
  List<Object?> get props => [error];
}

// Set Current Password Error Event
class SetCurrentPasswordError extends AdminSettingsEvent {
  final String? error;
  const SetCurrentPasswordError(this.error);
  @override
  List<Object?> get props => [error];
}

// Toggle New Shop Alert Event
class ToggleNewShopAlert extends AdminSettingsEvent {
  final bool value;
  const ToggleNewShopAlert(this.value);
  @override
  List<Object?> get props => [value];
}

// Toggle New Order Alert Event
class ToggleNewOrderAlert extends AdminSettingsEvent {
  final bool value;
  const ToggleNewOrderAlert(this.value);
  @override
  List<Object?> get props => [value];
}
