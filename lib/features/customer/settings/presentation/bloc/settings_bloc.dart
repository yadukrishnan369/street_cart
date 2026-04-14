import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';
import 'package:street_cart/features/customer/location/domain/repositories/i_location_repository.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/get_settings.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/update_setting.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final UpdateSetting updateSetting;
  final ILocationRepository locationRepository;
  final IAuthRepository authRepository;

  SettingsBloc({
    required this.getSettings,
    required this.updateSetting,
    required this.locationRepository,
    required this.authRepository,
  }) : super(SettingsInitial()) {
    on<FetchSettingsData>(_onFetchSettingsData);
    on<ToggleSetting>(_onToggleSetting);
  }

  Future<void> _onFetchSettingsData(
    FetchSettingsData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final settings = await getSettings();
      final user = FirebaseAuth.instance.currentUser;
      bool hasLocationData = false;

      if (user != null) {
        final profile = await authRepository.getCustomer(user.uid);
        // User has "allowed location once" if the location field exists in Firestore
        hasLocationData = profile?.locationName != null;
      }

      emit(
        SettingsLoaded(settings: settings, hasLocationData: hasLocationData),
      );
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onToggleSetting(
    ToggleSetting event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        // Update Local Storage
        await updateSetting(event.key, event.value);

        if (event.key == 'locationServices') {
          if (event.value == true) {
            // Turning ON - Fetch and save location
            await locationRepository.requestAndSaveLocation();
          } else {
            // Turning OFF - Set location_permission to false
            await locationRepository.skipLocation();
          }
        }

        final updatedSettings = Map<String, dynamic>.from(
          currentState.settings,
        );
        updatedSettings[event.key] = event.value;
        emit(
          SettingsLoaded(
            settings: updatedSettings,
            hasLocationData: currentState.hasLocationData,
          ),
        );
      } catch (e) {
        emit(
          SettingsError(message: "Failed to update setting: ${e.toString()}"),
        );
        emit(currentState);
      }
    }
  }
}
