import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/customer/theme_cubit.dart';
import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';
import 'package:street_cart/features/customer/location/domain/repositories/i_location_repository.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/get_settings.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/update_setting.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/get_customer_notification_preferences.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/save_customer_notification_preference.dart';
import 'settings_event.dart';
import 'settings_state.dart';

// Settings Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final UpdateSetting updateSetting;
  final ILocationRepository locationRepository;
  final IAuthRepository authRepository;
  final GetCustomerNotificationPreferences getCustomerNotificationPreferences;
  final SaveCustomerNotificationPreference saveCustomerNotificationPreference;

  SettingsBloc({
    required this.getSettings,
    required this.updateSetting,
    required this.locationRepository,
    required this.authRepository,
    required this.getCustomerNotificationPreferences,
    required this.saveCustomerNotificationPreference,
  }) : super(const SettingsInitial()) {
    on<FetchSettingsData>(_onFetchSettingsData);
    on<ToggleSetting>(_onToggleSetting);
    on<ToggleObscureDeletePassword>(_onToggleObscureDeletePassword);
    on<ToggleObscureCurrentPassword>(_onToggleObscureCurrentPassword);
    on<ToggleObscureNewPassword>(_onToggleObscureNewPassword);
    on<ToggleObscureConfirmPassword>(_onToggleObscureConfirmPassword);
    on<PerformClearData>(_onPerformClearData);
  }

  // Perform Clear Data
  Future<void> _onPerformClearData(
    PerformClearData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      SettingsClearingData(
        obscureDeletePassword: state.obscureDeletePassword,
        obscureCurrentPassword: state.obscureCurrentPassword,
        obscureNewPassword: state.obscureNewPassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
      ),
    );
    try {
      final prefs = sl<SharedPreferences>();
      await prefs.clear();
      await prefs.setBool('locationServices', false);
      await DefaultCacheManager().emptyCache();

      // Reset theme to light mode
      sl<ThemeCubit>().toggleTheme(false);

      emit(
        SettingsClearDataSuccess(
          obscureDeletePassword: state.obscureDeletePassword,
          obscureCurrentPassword: state.obscureCurrentPassword,
          obscureNewPassword: state.obscureNewPassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    } catch (e) {
      emit(
        SettingsError(
          message: 'Failed to clear data: $e',
          obscureDeletePassword: state.obscureDeletePassword,
          obscureCurrentPassword: state.obscureCurrentPassword,
          obscureNewPassword: state.obscureNewPassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    }
  }

  // Fetches settings configuration Data
  Future<void> _onFetchSettingsData(
    FetchSettingsData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      SettingsLoading(
        obscureDeletePassword: state.obscureDeletePassword,
        obscureCurrentPassword: state.obscureCurrentPassword,
        obscureNewPassword: state.obscureNewPassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
      ),
    );
    try {
      final settings = Map<String, dynamic>.from(await getSettings());
      bool hasLocationData = false;

      try {
        final prefs = await getCustomerNotificationPreferences();
        if (prefs.containsKey('generalNotificationsEnabled')) {
          final val = prefs['generalNotificationsEnabled']!;
          settings['generalNotifications'] = val;
          await updateSetting('generalNotifications', val);
        }
        if (prefs.containsKey('orderAlertsEnabled')) {
          final val = prefs['orderAlertsEnabled']!;
          settings['orderAlerts'] = val;
          await updateSetting('orderAlerts', val);
        }
      } catch (_) {}

      emit(
        SettingsLoaded(
          settings: settings,
          hasLocationData: hasLocationData,
          obscureDeletePassword: state.obscureDeletePassword,
          obscureCurrentPassword: state.obscureCurrentPassword,
          obscureNewPassword: state.obscureNewPassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    } catch (e) {
      emit(
        SettingsError(
          message: e.toString(),
          obscureDeletePassword: state.obscureDeletePassword,
          obscureCurrentPassword: state.obscureCurrentPassword,
          obscureNewPassword: state.obscureNewPassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
        ),
      );
    }
  }

  // Toggles location services
  Future<void> _onToggleSetting(
    ToggleSetting event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await updateSetting(event.key, event.value);

        if (event.key == 'generalNotifications') {
          await saveCustomerNotificationPreference(
            'generalNotificationsEnabled',
            event.value,
          );
        } else if (event.key == 'orderAlerts') {
          await saveCustomerNotificationPreference(
            'orderAlertsEnabled',
            event.value,
          );
        }

        if (event.key == 'locationServices') {
          if (event.value == true) {
            await locationRepository.requestAndSaveLocation();
          } else {
            await locationRepository.skipLocation();
          }
        }

        final updatedSettings = Map<String, dynamic>.from(
          currentState.settings,
        );
        updatedSettings[event.key] = event.value;
        emit(currentState.copyWith(settings: updatedSettings));
      } catch (e) {
        emit(
          SettingsError(
            message: "Failed to update setting: ${e.toString()}",
            obscureDeletePassword: state.obscureDeletePassword,
            obscureCurrentPassword: state.obscureCurrentPassword,
            obscureNewPassword: state.obscureNewPassword,
            obscureConfirmPassword: state.obscureConfirmPassword,
          ),
        );
        emit(currentState);
      }
    }
  }

  // Toggle password in Delete Account page
  void _onToggleObscureDeletePassword(
    ToggleObscureDeletePassword event,
    Emitter<SettingsState> emit,
  ) {
    if (state is SettingsLoaded) {
      final current = state as SettingsLoaded;
      emit(
        current.copyWith(obscureDeletePassword: !current.obscureDeletePassword),
      );
    } else if (state is SettingsInitial) {
      emit(
        SettingsInitial(obscureDeletePassword: !state.obscureDeletePassword),
      );
    }
  }

  // Toggle current password in change Password form
  void _onToggleObscureCurrentPassword(
    ToggleObscureCurrentPassword event,
    Emitter<SettingsState> emit,
  ) {
    if (state is SettingsLoaded) {
      final current = state as SettingsLoaded;
      emit(
        current.copyWith(
          obscureCurrentPassword: !current.obscureCurrentPassword,
        ),
      );
    } else if (state is SettingsInitial) {
      emit(
        SettingsInitial(obscureCurrentPassword: !state.obscureCurrentPassword),
      );
    }
  }

  // Toggle new password in change Password form
  void _onToggleObscureNewPassword(
    ToggleObscureNewPassword event,
    Emitter<SettingsState> emit,
  ) {
    if (state is SettingsLoaded) {
      final current = state as SettingsLoaded;
      emit(current.copyWith(obscureNewPassword: !current.obscureNewPassword));
    } else if (state is SettingsInitial) {
      emit(SettingsInitial(obscureNewPassword: !state.obscureNewPassword));
    }
  }

  // Toggle confirm password in change Password form
  void _onToggleObscureConfirmPassword(
    ToggleObscureConfirmPassword event,
    Emitter<SettingsState> emit,
  ) {
    if (state is SettingsLoaded) {
      final current = state as SettingsLoaded;
      emit(
        current.copyWith(
          obscureConfirmPassword: !current.obscureConfirmPassword,
        ),
      );
    } else if (state is SettingsInitial) {
      emit(
        SettingsInitial(obscureConfirmPassword: !state.obscureConfirmPassword),
      );
    }
  }
}
