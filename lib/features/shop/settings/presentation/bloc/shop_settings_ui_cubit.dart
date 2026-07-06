import 'package:flutter_bloc/flutter_bloc.dart';

class ShopSettingsUiState {
  final bool appTheme;
  final bool pushNotifications;
  final bool orderAlerts;

  const ShopSettingsUiState({
    this.appTheme = false,
    this.pushNotifications = true,
    this.orderAlerts = false,
  });

  ShopSettingsUiState copyWith({
    bool? appTheme,
    bool? pushNotifications,
    bool? orderAlerts,
  }) {
    return ShopSettingsUiState(
      appTheme: appTheme ?? this.appTheme,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      orderAlerts: orderAlerts ?? this.orderAlerts,
    );
  }
}

class ShopSettingsUiCubit extends Cubit<ShopSettingsUiState> {
  ShopSettingsUiCubit() : super(const ShopSettingsUiState());

  void toggleAppTheme(bool val) => emit(state.copyWith(appTheme: val));
  void togglePushNotifications(bool val) =>
      emit(state.copyWith(pushNotifications: val));
  void toggleOrderAlerts(bool val) => emit(state.copyWith(orderAlerts: val));
}
