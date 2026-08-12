import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/get_admin_settings.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_platform_commission.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_payment_controls.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/change_admin_password.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_categories.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/get_admin_notification_preferences.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_admin_notification_preference.dart';
import 'admin_settings_event.dart';
import 'admin_settings_state.dart';

class AdminSettingsBloc extends Bloc<AdminSettingsEvent, AdminSettingsState> {
  final GetAdminSettings _getAdminSettings;
  final SavePlatformCommission _savePlatformCommission;
  final SavePaymentControls _savePaymentControls;
  final ChangeAdminPassword _changeAdminPassword;
  final SaveCategories _saveCategories;
  final GetAdminNotificationPreferences _getAdminNotificationPreferences;
  final SaveAdminNotificationPreference _saveAdminNotificationPreference;

  AdminSettingsModel _currentSettings = const AdminSettingsModel(
    commissionPercentage: 2.0,
    enableCod: true,
    enableOnline: true,
    productCategories: [],
    businessCategories: [],
  );

  String _formName = '';
  List<String> _formProductCategories = const [];
  Set<String> _formSelectedSizeGroups = const {};
  List<SizeGroupModel> _formAvailableSizeGroups = const [];
  String? _formNameError;
  String? _formProductCategoryError;

  bool? _draftEnableCod;
  bool? _draftEnableOnline;
  String? _percentageError;

  String? _currentPasswordError;

  bool _notifyNewShopAlert = true;
  bool _notifyNewOrderAlert = false;

  AdminSettingsBloc({
    required GetAdminSettings getAdminSettings,
    required SavePlatformCommission savePlatformCommission,
    required SavePaymentControls savePaymentControls,
    required ChangeAdminPassword changeAdminPassword,
    required SaveCategories saveCategories,
    required GetAdminNotificationPreferences getAdminNotificationPreferences,
    required SaveAdminNotificationPreference saveAdminNotificationPreference,
  }) : _getAdminSettings = getAdminSettings,
       _savePlatformCommission = savePlatformCommission,
       _savePaymentControls = savePaymentControls,
       _changeAdminPassword = changeAdminPassword,
       _saveCategories = saveCategories,
       _getAdminNotificationPreferences = getAdminNotificationPreferences,
       _saveAdminNotificationPreference = saveAdminNotificationPreference,
       super(AdminSettingsInitial()) {
    on<LoadAdminSettings>(_onLoadAdminSettings);
    on<UpdatePlatformCommission>(_onUpdatePlatformCommission);
    on<UpdatePaymentControls>(_onUpdatePaymentControls);
    on<UpdateAdminPassword>(_onUpdateAdminPassword);
    on<UpdateCategories>(_onUpdateCategories);

    // Category form
    on<InitCategoryForm>(_onInitCategoryForm);
    on<UpdateCategoryFormName>(_onUpdateCategoryFormName);
    on<AddProductCategoryToForm>(_onAddProductCategoryToForm);
    on<RemoveProductCategoryFromForm>(_onRemoveProductCategoryFromForm);
    on<ToggleSizeGroupInForm>(_onToggleSizeGroupInForm);
    on<ValidateCategoryForm>(_onValidateCategoryForm);

    // Payment drafts
    on<UpdateDraftCodToggle>(_onUpdateDraftCodToggle);
    on<UpdateDraftOnlineToggle>(_onUpdateDraftOnlineToggle);
    on<SetPercentageError>(_onSetPercentageError);

    // Security
    on<SetCurrentPasswordError>(_onSetCurrentPasswordError);

    // Notifications
    on<ToggleNewShopAlert>(_onToggleNewShopAlert);
    on<ToggleNewOrderAlert>(_onToggleNewOrderAlert);
  }

  // emit load success for all fields
  void _emitLoaded(Emitter<AdminSettingsState> emit) {
    emit(
      AdminSettingsLoadSuccess(
        _currentSettings,
        formName: _formName,
        formProductCategories: _formProductCategories,
        formSelectedSizeGroups: _formSelectedSizeGroups,
        formAvailableSizeGroups: _formAvailableSizeGroups,
        formNameError: _formNameError,
        formProductCategoryError: _formProductCategoryError,
        draftEnableCod: _draftEnableCod,
        draftEnableOnline: _draftEnableOnline,
        percentageError: _percentageError,
        currentPasswordError: _currentPasswordError,
        notifyNewShopAlert: _notifyNewShopAlert,
        notifyNewOrderAlert: _notifyNewOrderAlert,
      ),
    );
  }

  AdminSettingsActionInProgress _buildInProgress() =>
      AdminSettingsActionInProgress(
        _currentSettings,
        formName: _formName,
        formProductCategories: _formProductCategories,
        formSelectedSizeGroups: _formSelectedSizeGroups,
        formAvailableSizeGroups: _formAvailableSizeGroups,
        formNameError: _formNameError,
        formProductCategoryError: _formProductCategoryError,
        draftEnableCod: _draftEnableCod,
        draftEnableOnline: _draftEnableOnline,
        percentageError: _percentageError,
        currentPasswordError: _currentPasswordError,
        notifyNewShopAlert: _notifyNewShopAlert,
        notifyNewOrderAlert: _notifyNewOrderAlert,
      );

  AdminSettingsActionSuccess _buildSuccess(String message) =>
      AdminSettingsActionSuccess(
        message: message,
        settings: _currentSettings,
        formName: _formName,
        formProductCategories: _formProductCategories,
        formSelectedSizeGroups: _formSelectedSizeGroups,
        formAvailableSizeGroups: _formAvailableSizeGroups,
        formNameError: _formNameError,
        formProductCategoryError: _formProductCategoryError,
        draftEnableCod: _draftEnableCod,
        draftEnableOnline: _draftEnableOnline,
        percentageError: _percentageError,
        currentPasswordError: _currentPasswordError,
        notifyNewShopAlert: _notifyNewShopAlert,
        notifyNewOrderAlert: _notifyNewOrderAlert,
      );

  AdminSettingsActionFailure _buildFailure(String message) =>
      AdminSettingsActionFailure(
        message: message,
        settings: _currentSettings,
        formName: _formName,
        formProductCategories: _formProductCategories,
        formSelectedSizeGroups: _formSelectedSizeGroups,
        formAvailableSizeGroups: _formAvailableSizeGroups,
        formNameError: _formNameError,
        formProductCategoryError: _formProductCategoryError,
        draftEnableCod: _draftEnableCod,
        draftEnableOnline: _draftEnableOnline,
        percentageError: _percentageError,
        currentPasswordError: _currentPasswordError,
        notifyNewShopAlert: _notifyNewShopAlert,
        notifyNewOrderAlert: _notifyNewOrderAlert,
      );

  // Load Admin Settings
  Future<void> _onLoadAdminSettings(
    LoadAdminSettings event,
    Emitter<AdminSettingsState> emit,
  ) async {
    emit(
      AdminSettingsLoading(
        notifyNewShopAlert: _notifyNewShopAlert,
        notifyNewOrderAlert: _notifyNewOrderAlert,
      ),
    );
    try {
      final prefs = await _getAdminNotificationPreferences();
      _notifyNewShopAlert = prefs['registrationAlertsEnabled'] ?? true;
      _notifyNewOrderAlert = prefs['orderAlertsEnabled'] ?? true;
      final settings = await _getAdminSettings();
      _currentSettings = settings;
      _draftEnableCod = settings.enableCod;
      _draftEnableOnline = settings.enableOnline;
      _emitLoaded(emit);
    } catch (e) {
      emit(
        AdminSettingsLoadFailure(
          e.toString(),
          notifyNewShopAlert: _notifyNewShopAlert,
          notifyNewOrderAlert: _notifyNewOrderAlert,
        ),
      );
    }
  }

  // Update Platform Commission
  Future<void> _onUpdatePlatformCommission(
    UpdatePlatformCommission event,
    Emitter<AdminSettingsState> emit,
  ) async {
    emit(_buildInProgress());
    try {
      await _savePlatformCommission(event.percentage);
      _currentSettings = _currentSettings.copyWith(
        commissionPercentage: event.percentage,
      );
      _percentageError = null;
      emit(_buildSuccess('Platform commission updated successfully'));
    } catch (e) {
      emit(_buildFailure(e.toString()));
    }
  }

  // Update Payment Controls
  Future<void> _onUpdatePaymentControls(
    UpdatePaymentControls event,
    Emitter<AdminSettingsState> emit,
  ) async {
    emit(_buildInProgress());
    try {
      await _savePaymentControls(
        enableCod: event.enableCod,
        enableOnline: event.enableOnline,
      );
      _currentSettings = _currentSettings.copyWith(
        enableCod: event.enableCod,
        enableOnline: event.enableOnline,
      );
      emit(_buildSuccess('Payment controls updated successfully'));
    } catch (e) {
      emit(_buildFailure(e.toString()));
    }
  }

  // Update Admin Password
  Future<void> _onUpdateAdminPassword(
    UpdateAdminPassword event,
    Emitter<AdminSettingsState> emit,
  ) async {
    emit(_buildInProgress());
    try {
      await _changeAdminPassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      _currentPasswordError = null;
      emit(_buildSuccess('Password changed successfully'));
    } catch (e) {
      if (e.toString().contains('Incorrect current password')) {
        _currentPasswordError = 'Incorrect current password.';
      }
      emit(_buildFailure(e.toString()));
    }
  }

  // Update Categories
  Future<void> _onUpdateCategories(
    UpdateCategories event,
    Emitter<AdminSettingsState> emit,
  ) async {
    emit(_buildInProgress());
    try {
      await _saveCategories(
        productCategories: event.productCategories,
        businessCategories: event.businessCategories,
      );
      _currentSettings = _currentSettings.copyWith(
        productCategories: event.productCategories,
        businessCategories: event.businessCategories,
      );
      emit(_buildSuccess('Categories updated successfully'));
    } catch (e) {
      emit(_buildFailure(e.toString()));
    }
  }

  // Init Category Form
  void _onInitCategoryForm(
    InitCategoryForm event,
    Emitter<AdminSettingsState> emit,
  ) {
    _formName = event.initialCategory?.name ?? '';
    _formProductCategories = event.initialCategory?.productCategories ?? [];
    _formSelectedSizeGroups = Set<String>.from(
      event.initialCategory?.sizeGroups ?? [],
    );
    _formAvailableSizeGroups = event.allSizeGroups;
    _formNameError = null;
    _formProductCategoryError = null;
    _emitLoaded(emit);
  }

  // Update Category Form Name
  void _onUpdateCategoryFormName(
    UpdateCategoryFormName event,
    Emitter<AdminSettingsState> emit,
  ) {
    _formName = event.name;
    _formNameError = event.name.trim().isEmpty
        ? 'Category name is required'
        : null;
    _emitLoaded(emit);
  }

  // Add Product Category To Form
  void _onAddProductCategoryToForm(
    AddProductCategoryToForm event,
    Emitter<AdminSettingsState> emit,
  ) {
    final cleaned = event.productCategory.trim();
    if (cleaned.isEmpty) return;
    if (_formProductCategories.contains(cleaned)) {
      _formProductCategoryError = 'Category already added';
      _emitLoaded(emit);
      return;
    }
    _formProductCategories = [..._formProductCategories, cleaned];
    _formProductCategoryError = null;
    _emitLoaded(emit);
  }

  // Remove Product Category From Form
  void _onRemoveProductCategoryFromForm(
    RemoveProductCategoryFromForm event,
    Emitter<AdminSettingsState> emit,
  ) {
    final list = List<String>.from(_formProductCategories);
    if (event.index >= 0 && event.index < list.length) {
      list.removeAt(event.index);
      _formProductCategories = list;
      _emitLoaded(emit);
    }
  }

  // Toggle Size Group In Form
  void _onToggleSizeGroupInForm(
    ToggleSizeGroupInForm event,
    Emitter<AdminSettingsState> emit,
  ) {
    final updated = Set<String>.from(_formSelectedSizeGroups);
    updated.contains(event.sizeGroupName)
        ? updated.remove(event.sizeGroupName)
        : updated.add(event.sizeGroupName);
    _formSelectedSizeGroups = updated;
    _emitLoaded(emit);
  }

  // Validate Category Form
  void _onValidateCategoryForm(
    ValidateCategoryForm event,
    Emitter<AdminSettingsState> emit,
  ) {
    final nameValid = _formName.trim().isNotEmpty;
    _formNameError = nameValid ? null : 'Category name is required';
    _emitLoaded(emit);
  }

  // Update Cod Toggle
  void _onUpdateDraftCodToggle(
    UpdateDraftCodToggle event,
    Emitter<AdminSettingsState> emit,
  ) {
    _draftEnableCod = event.value;
    _emitLoaded(emit);
  }

  // Update Online Toggle
  void _onUpdateDraftOnlineToggle(
    UpdateDraftOnlineToggle event,
    Emitter<AdminSettingsState> emit,
  ) {
    _draftEnableOnline = event.value;
    _emitLoaded(emit);
  }

  // Set Percentage Error
  void _onSetPercentageError(
    SetPercentageError event,
    Emitter<AdminSettingsState> emit,
  ) {
    _percentageError = event.error;
    _emitLoaded(emit);
  }

  // Set Current Password Error
  void _onSetCurrentPasswordError(
    SetCurrentPasswordError event,
    Emitter<AdminSettingsState> emit,
  ) {
    _currentPasswordError = event.error;
    _emitLoaded(emit);
  }

  // Toggle New Shop Alert
  Future<void> _onToggleNewShopAlert(
    ToggleNewShopAlert event,
    Emitter<AdminSettingsState> emit,
  ) async {
    _notifyNewShopAlert = event.value;
    try {
      await _saveAdminNotificationPreference(
        'registrationAlertsEnabled',
        event.value,
      );
    } catch (_) {}
    _emitLoaded(emit);
  }

  // Toggle New Order Alert
  Future<void> _onToggleNewOrderAlert(
    ToggleNewOrderAlert event,
    Emitter<AdminSettingsState> emit,
  ) async {
    _notifyNewOrderAlert = event.value;
    try {
      await _saveAdminNotificationPreference('orderAlertsEnabled', event.value);
    } catch (_) {}
    _emitLoaded(emit);
  }
}
