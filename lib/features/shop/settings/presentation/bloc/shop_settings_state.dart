part of 'shop_settings_bloc.dart';

// Enum settings operations Status
enum ShopSettingsStatus {
  initial,
  loading,
  changePasswordSuccess,
  deleteAccountSuccess,
  failure,
}

class ShopSettingsState extends Equatable {
  final ShopSettingsStatus status;
  final String? errorMessage;

  // Change password Visible toggles
  final bool obscureCurrent;
  final bool obscureNew;
  final bool obscureConfirm;

  // Delete account Visible toggle
  final bool obscureDeletePassword;

  // Clear data state
  final bool isClearingData;
  final bool isClearDataSuccess;
  final String? clearDataError;

  // Delivery radius
  final double deliveryRadius;

  // Shop settings toggles
  final bool appTheme;
  final bool pushNotifications;
  final bool orderAlerts;

  const ShopSettingsState({
    this.status = ShopSettingsStatus.initial,
    this.errorMessage,
    this.obscureCurrent = true,
    this.obscureNew = true,
    this.obscureConfirm = true,
    this.obscureDeletePassword = true,
    this.isClearingData = false,
    this.isClearDataSuccess = false,
    this.clearDataError,
    this.deliveryRadius = 5.0,
    this.appTheme = false,
    this.pushNotifications = true,
    this.orderAlerts = true,
  });

  ShopSettingsState copyWith({
    ShopSettingsStatus? status,
    String? errorMessage,
    bool? obscureCurrent,
    bool? obscureNew,
    bool? obscureConfirm,
    bool? obscureDeletePassword,
    bool? isClearingData,
    bool? isClearDataSuccess,
    String? clearDataError,
    double? deliveryRadius,
    bool? appTheme,
    bool? pushNotifications,
    bool? orderAlerts,
  }) {
    return ShopSettingsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      obscureCurrent: obscureCurrent ?? this.obscureCurrent,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      obscureDeletePassword:
          obscureDeletePassword ?? this.obscureDeletePassword,
      isClearingData: isClearingData ?? this.isClearingData,
      isClearDataSuccess: isClearDataSuccess ?? this.isClearDataSuccess,
      clearDataError: clearDataError ?? this.clearDataError,
      deliveryRadius: deliveryRadius ?? this.deliveryRadius,
      appTheme: appTheme ?? this.appTheme,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      orderAlerts: orderAlerts ?? this.orderAlerts,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    obscureCurrent,
    obscureNew,
    obscureConfirm,
    obscureDeletePassword,
    isClearingData,
    isClearDataSuccess,
    clearDataError,
    deliveryRadius,
    appTheme,
    pushNotifications,
    orderAlerts,
  ];
}
