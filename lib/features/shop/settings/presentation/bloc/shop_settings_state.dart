abstract class ShopSettingsState {
  const ShopSettingsState();
}

class ShopSettingsInitial extends ShopSettingsState {}

class ShopSettingsLoading extends ShopSettingsState {}

class ChangePasswordSuccess extends ShopSettingsState {}

class DeleteAccountSuccess extends ShopSettingsState {}

class ShopSettingsFailure extends ShopSettingsState {
  final String message;

  const ShopSettingsFailure(this.message);
}
