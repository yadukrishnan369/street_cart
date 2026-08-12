import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/shop/shop_theme_cubit.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/change_shop_password.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/delete_shop_auth_account.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/get_shop_notification_preferences.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/save_shop_notification_preference.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/get_shop_local_settings.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/update_shop_local_setting.dart';
part 'shop_settings_event.dart';
part 'shop_settings_state.dart';

class ShopSettingsBloc extends Bloc<ShopSettingsEvent, ShopSettingsState> {
  final ChangeShopPassword changeShopPassword;
  final DeleteShopAuthAccount deleteShopAuthAccount;
  final GetShopNotificationPreferences getShopNotificationPreferences;
  final SaveShopNotificationPreference saveShopNotificationPreference;
  final GetShopLocalSettings getShopLocalSettings;
  final UpdateShopLocalSetting updateShopLocalSetting;

  ShopSettingsBloc({
    required this.changeShopPassword,
    required this.deleteShopAuthAccount,
    required this.getShopNotificationPreferences,
    required this.saveShopNotificationPreference,
    required this.getShopLocalSettings,
    required this.updateShopLocalSetting,
    bool? pushNotifications,
    bool? orderAlerts,
  }) : super(
         ShopSettingsState(
           pushNotifications: pushNotifications ?? true,
           orderAlerts: orderAlerts ?? true,
         ),
       ) {
    on<FetchSettingsDataEvent>((event, emit) async {
      final localSettings = await getShopLocalSettings();
      bool generalVal = localSettings['generalNotifications'] ?? true;
      bool orderVal = localSettings['orderAlerts'] ?? true;

      // Emit cached values
      emit(
        state.copyWith(pushNotifications: generalVal, orderAlerts: orderVal),
      );

      try {
        final onlinePrefs = await getShopNotificationPreferences();
        bool changed = false;
        if (onlinePrefs.containsKey('generalNotificationsEnabled')) {
          final onlineGen = onlinePrefs['generalNotificationsEnabled']!;
          if (onlineGen != generalVal) {
            generalVal = onlineGen;
            await updateShopLocalSetting('generalNotifications', generalVal);
            changed = true;
          }
        }
        if (onlinePrefs.containsKey('orderAlertsEnabled')) {
          final onlineOrder = onlinePrefs['orderAlertsEnabled']!;
          if (onlineOrder != orderVal) {
            orderVal = onlineOrder;
            await updateShopLocalSetting('orderAlerts', orderVal);
            changed = true;
          }
        }
        if (changed) {
          emit(
            state.copyWith(
              pushNotifications: generalVal,
              orderAlerts: orderVal,
            ),
          );
        }
      } catch (_) {}
    });

    // Visible password events
    on<ToggleObscureCurrentEvent>((event, emit) {
      emit(state.copyWith(obscureCurrent: !state.obscureCurrent));
    });

    on<ToggleObscureNewEvent>((event, emit) {
      emit(state.copyWith(obscureNew: !state.obscureNew));
    });

    on<ToggleObscureConfirmEvent>((event, emit) {
      emit(state.copyWith(obscureConfirm: !state.obscureConfirm));
    });

    on<ToggleObscureDeletePasswordEvent>((event, emit) {
      emit(state.copyWith(obscureDeletePassword: !state.obscureDeletePassword));
    });

    // Clear Application Data Event
    on<PerformClearDataEvent>((event, emit) async {
      emit(
        state.copyWith(
          isClearingData: true,
          isClearDataSuccess: false,
          clearDataError: null,
        ),
      );
      try {
        final prefs = sl<SharedPreferences>();
        await prefs.clear();
        await DefaultCacheManager().emptyCache();

        // Reset theme to light mode
        sl<ShopThemeCubit>().toggleTheme(false);

        emit(
          state.copyWith(
            isClearingData: false,
            isClearDataSuccess: true,
            appTheme: false,
            pushNotifications: false,
            orderAlerts: false,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(isClearingData: false, clearDataError: e.toString()),
        );
      }
    });

    // Delivery radius update event
    on<UpdateDeliveryRadiusEvent>((event, emit) {
      emit(state.copyWith(deliveryRadius: event.radius));
    });

    // Shop settings toggle switches events
    on<ToggleAppThemeEvent>((event, emit) {
      emit(state.copyWith(appTheme: event.value));
    });

    on<TogglePushNotificationsEvent>((event, emit) async {
      await updateShopLocalSetting('generalNotifications', event.value);
      try {
        await saveShopNotificationPreference(
          'generalNotificationsEnabled',
          event.value,
        );
      } catch (_) {}
      emit(state.copyWith(pushNotifications: event.value));
    });

    on<ToggleOrderAlertsEvent>((event, emit) async {
      await updateShopLocalSetting('orderAlerts', event.value);
      try {
        await saveShopNotificationPreference('orderAlertsEnabled', event.value);
      } catch (_) {}
      emit(state.copyWith(orderAlerts: event.value));
    });

    // Account Change Password event
    on<ChangePasswordRequested>((event, emit) async {
      emit(state.copyWith(status: ShopSettingsStatus.loading));
      try {
        await changeShopPassword(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
        );
        emit(state.copyWith(status: ShopSettingsStatus.changePasswordSuccess));
      } catch (e) {
        emit(
          state.copyWith(
            status: ShopSettingsStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    // Account Deletion event
    on<DeleteAccountRequested>((event, emit) async {
      emit(state.copyWith(status: ShopSettingsStatus.loading));
      try {
        await deleteShopAuthAccount(event.password);
        emit(state.copyWith(status: ShopSettingsStatus.deleteAccountSuccess));
      } catch (e) {
        emit(
          state.copyWith(
            status: ShopSettingsStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }
}
