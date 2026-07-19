import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/change_shop_password.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/delete_shop_auth_account.dart';
part 'shop_settings_event.dart';
part 'shop_settings_state.dart';

class ShopSettingsBloc extends Bloc<ShopSettingsEvent, ShopSettingsState> {
  final ChangeShopPassword changeShopPassword;
  final DeleteShopAuthAccount deleteShopAuthAccount;

  ShopSettingsBloc({
    required this.changeShopPassword,
    required this.deleteShopAuthAccount,
  }) : super(const ShopSettingsState()) {
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
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(isClearingData: false, isClearDataSuccess: true));
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

    on<TogglePushNotificationsEvent>((event, emit) {
      emit(state.copyWith(pushNotifications: event.value));
    });

    on<ToggleOrderAlertsEvent>((event, emit) {
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
