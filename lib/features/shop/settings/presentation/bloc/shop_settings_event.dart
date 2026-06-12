abstract class ShopSettingsEvent {
  const ShopSettingsEvent();
}

class ChangePasswordRequested extends ShopSettingsEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });
}

class DeleteAccountRequested extends ShopSettingsEvent {
  final String password;

  const DeleteAccountRequested({
    required this.password,
  });
}
