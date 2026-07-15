import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/get_admin_settings.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_platform_commission.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_payment_controls.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/change_admin_password.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_categories.dart';
import 'admin_settings_event.dart';
import 'admin_settings_state.dart';

class AdminSettingsBloc extends Bloc<AdminSettingsEvent, AdminSettingsState> {
  final GetAdminSettings _getAdminSettings;
  final SavePlatformCommission _savePlatformCommission;
  final SavePaymentControls _savePaymentControls;
  final ChangeAdminPassword _changeAdminPassword;
  final SaveCategories _saveCategories;

  AdminSettingsModel _currentSettings = const AdminSettingsModel(
    commissionPercentage: 2.0,
    enableCod: true,
    enableOnline: true,
    productCategories: [],
    businessCategories: [],
  );

  AdminSettingsBloc({
    required GetAdminSettings getAdminSettings,
    required SavePlatformCommission savePlatformCommission,
    required SavePaymentControls savePaymentControls,
    required ChangeAdminPassword changeAdminPassword,
    required SaveCategories saveCategories,
  }) : _getAdminSettings = getAdminSettings,
       _savePlatformCommission = savePlatformCommission,
       _savePaymentControls = savePaymentControls,
       _changeAdminPassword = changeAdminPassword,
       _saveCategories = saveCategories,
       super(AdminSettingsInitial()) {
    on<LoadAdminSettings>(_onLoadAdminSettings);
    on<UpdatePlatformCommission>(_onUpdatePlatformCommission);
    on<UpdatePaymentControls>(_onUpdatePaymentControls);
    on<UpdateAdminPassword>(_onUpdateAdminPassword);
    on<UpdateCategories>(_onUpdateCategories);
  }

  Future<void> _onLoadAdminSettings(
    LoadAdminSettings event,
    Emitter<AdminSettingsState> emit,
  ) async {
    emit(AdminSettingsLoading());
    try {
      final settings = await _getAdminSettings();
      _currentSettings = settings;
      emit(AdminSettingsLoadSuccess(settings));
    } catch (e) {
      emit(AdminSettingsLoadFailure(e.toString()));
    }
  }

  Future<void> _onUpdatePlatformCommission(
    UpdatePlatformCommission event,
    Emitter<AdminSettingsState> emit,
  ) async {
    emit(AdminSettingsActionInProgress(_currentSettings));
    try {
      await _savePlatformCommission(event.percentage);
      _currentSettings = _currentSettings.copyWith(
        commissionPercentage: event.percentage,
      );
      emit(
        AdminSettingsActionSuccess(
          message: 'Platform commission updated successfully',
          settings: _currentSettings,
        ),
      );
    } catch (e) {
      emit(
        AdminSettingsActionFailure(
          message: e.toString(),
          settings: _currentSettings,
        ),
      );
    }
  }

  Future<void> _onUpdatePaymentControls(
    UpdatePaymentControls event,
    Emitter<AdminSettingsState> emit,
  ) async {
    emit(AdminSettingsActionInProgress(_currentSettings));
    try {
      await _savePaymentControls(
        enableCod: event.enableCod,
        enableOnline: event.enableOnline,
      );
      _currentSettings = _currentSettings.copyWith(
        enableCod: event.enableCod,
        enableOnline: event.enableOnline,
      );
      emit(
        AdminSettingsActionSuccess(
          message: 'Payment controls updated successfully',
          settings: _currentSettings,
        ),
      );
    } catch (e) {
      emit(
        AdminSettingsActionFailure(
          message: e.toString(),
          settings: _currentSettings,
        ),
      );
    }
  }

  Future<void> _onUpdateAdminPassword(
    UpdateAdminPassword event,
    Emitter<AdminSettingsState> emit,
  ) async {
    emit(AdminSettingsActionInProgress(_currentSettings));
    try {
      await _changeAdminPassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      emit(
        AdminSettingsActionSuccess(
          message: 'Password changed successfully',
          settings: _currentSettings,
        ),
      );
    } catch (e) {
      emit(
        AdminSettingsActionFailure(
          message: e.toString(),
          settings: _currentSettings,
        ),
      );
    }
  }

  Future<void> _onUpdateCategories(
    UpdateCategories event,
    Emitter<AdminSettingsState> emit,
  ) async {
    emit(AdminSettingsActionInProgress(_currentSettings));
    try {
      await _saveCategories(
        productCategories: event.productCategories,
        businessCategories: event.businessCategories,
      );
      _currentSettings = _currentSettings.copyWith(
        productCategories: event.productCategories,
        businessCategories: event.businessCategories,
      );
      emit(
        AdminSettingsActionSuccess(
          message: 'Categories updated successfully',
          settings: _currentSettings,
        ),
      );
    } catch (e) {
      emit(
        AdminSettingsActionFailure(
          message: e.toString(),
          settings: _currentSettings,
        ),
      );
    }
  }
}
