part of 'shop_settings_bloc.dart';

// Base class
abstract class ShopSettingsEvent extends Equatable {
  const ShopSettingsEvent();

  @override
  List<Object?> get props => [];
}

// Fetch Settings Data Event
class FetchSettingsDataEvent extends ShopSettingsEvent {}

//  Update Password Event
class ChangePasswordRequested extends ShopSettingsEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

// Delete Shop Account Event
class DeleteAccountRequested extends ShopSettingsEvent {
  final String password;

  const DeleteAccountRequested({required this.password});

  @override
  List<Object?> get props => [password];
}

// Visible toggles events for password input fields
class ToggleObscureCurrentEvent extends ShopSettingsEvent {}

class ToggleObscureNewEvent extends ShopSettingsEvent {}

class ToggleObscureConfirmEvent extends ShopSettingsEvent {}

class ToggleObscureDeletePasswordEvent extends ShopSettingsEvent {}

// Clear cache data Event
class PerformClearDataEvent extends ShopSettingsEvent {}

// Update delivery radius Event
class UpdateDeliveryRadiusEvent extends ShopSettingsEvent {
  final double radius;

  const UpdateDeliveryRadiusEvent(this.radius);

  @override
  List<Object?> get props => [radius];
}

// App Theme preference Event
class ToggleAppThemeEvent extends ShopSettingsEvent {
  final bool value;

  const ToggleAppThemeEvent(this.value);

  @override
  List<Object?> get props => [value];
}

// Push notifications preference Event
class TogglePushNotificationsEvent extends ShopSettingsEvent {
  final bool value;

  const TogglePushNotificationsEvent(this.value);

  @override
  List<Object?> get props => [value];
}

// Order Alert notification preference Event
class ToggleOrderAlertsEvent extends ShopSettingsEvent {
  final bool value;

  const ToggleOrderAlertsEvent(this.value);

  @override
  List<Object?> get props => [value];
}
