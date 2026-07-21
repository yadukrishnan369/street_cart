import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

abstract class AdminSettingsState {
  final String formName;
  final List<String> formProductCategories;
  final Set<String> formSelectedSizeGroups;
  final List<SizeGroupModel> formAvailableSizeGroups;
  final String? formNameError;
  final String? formProductCategoryError;
  final bool? draftEnableCod;
  final bool? draftEnableOnline;
  final String? percentageError;
  final String? currentPasswordError;
  final bool notifyNewShopAlert;
  final bool notifyNewOrderAlert;

  const AdminSettingsState({
    this.formName = '',
    this.formProductCategories = const [],
    this.formSelectedSizeGroups = const {},
    this.formAvailableSizeGroups = const [],
    this.formNameError,
    this.formProductCategoryError,
    this.draftEnableCod,
    this.draftEnableOnline,
    this.percentageError,
    this.currentPasswordError,
    this.notifyNewShopAlert = true,
    this.notifyNewOrderAlert = false,
  });
}

// Settings Initial State
class AdminSettingsInitial extends AdminSettingsState {}

// Settings Loading State
class AdminSettingsLoading extends AdminSettingsState {
  const AdminSettingsLoading({
    super.formName,
    super.formProductCategories,
    super.formSelectedSizeGroups,
    super.formAvailableSizeGroups,
    super.formNameError,
    super.formProductCategoryError,
    super.draftEnableCod,
    super.draftEnableOnline,
    super.percentageError,
    super.currentPasswordError,
    super.notifyNewShopAlert,
    super.notifyNewOrderAlert,
  });
}

// Settings Load Success State
class AdminSettingsLoadSuccess extends AdminSettingsState {
  final AdminSettingsModel settings;

  const AdminSettingsLoadSuccess(
    this.settings, {
    super.formName,
    super.formProductCategories,
    super.formSelectedSizeGroups,
    super.formAvailableSizeGroups,
    super.formNameError,
    super.formProductCategoryError,
    super.draftEnableCod,
    super.draftEnableOnline,
    super.percentageError,
    super.currentPasswordError,
    super.notifyNewShopAlert,
    super.notifyNewOrderAlert,
  });
}

// Settings Load Failure State
class AdminSettingsLoadFailure extends AdminSettingsState {
  final String message;

  const AdminSettingsLoadFailure(
    this.message, {
    super.formName,
    super.formProductCategories,
    super.formSelectedSizeGroups,
    super.formAvailableSizeGroups,
    super.formNameError,
    super.formProductCategoryError,
    super.draftEnableCod,
    super.draftEnableOnline,
    super.percentageError,
    super.currentPasswordError,
    super.notifyNewShopAlert,
    super.notifyNewOrderAlert,
  });
}

// Settings Action InProgress State
class AdminSettingsActionInProgress extends AdminSettingsState {
  final AdminSettingsModel settings;

  const AdminSettingsActionInProgress(
    this.settings, {
    super.formName,
    super.formProductCategories,
    super.formSelectedSizeGroups,
    super.formAvailableSizeGroups,
    super.formNameError,
    super.formProductCategoryError,
    super.draftEnableCod,
    super.draftEnableOnline,
    super.percentageError,
    super.currentPasswordError,
    super.notifyNewShopAlert,
    super.notifyNewOrderAlert,
  });
}

// Settings Action Success State
class AdminSettingsActionSuccess extends AdminSettingsState {
  final String message;
  final AdminSettingsModel settings;

  const AdminSettingsActionSuccess({
    required this.message,
    required this.settings,
    super.formName,
    super.formProductCategories,
    super.formSelectedSizeGroups,
    super.formAvailableSizeGroups,
    super.formNameError,
    super.formProductCategoryError,
    super.draftEnableCod,
    super.draftEnableOnline,
    super.percentageError,
    super.currentPasswordError,
    super.notifyNewShopAlert,
    super.notifyNewOrderAlert,
  });
}

// Settings Action Failure State
class AdminSettingsActionFailure extends AdminSettingsState {
  final String message;
  final AdminSettingsModel settings;

  const AdminSettingsActionFailure({
    required this.message,
    required this.settings,
    super.formName,
    super.formProductCategories,
    super.formSelectedSizeGroups,
    super.formAvailableSizeGroups,
    super.formNameError,
    super.formProductCategoryError,
    super.draftEnableCod,
    super.draftEnableOnline,
    super.percentageError,
    super.currentPasswordError,
    super.notifyNewShopAlert,
    super.notifyNewOrderAlert,
  });
}
