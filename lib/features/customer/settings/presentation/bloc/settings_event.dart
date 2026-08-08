abstract class SettingsEvent {}

class FetchSettingsData extends SettingsEvent {}

// update/toggle Event
class ToggleSetting extends SettingsEvent {
  final String key;
  final bool value;

  ToggleSetting({required this.key, required this.value});
}

// Delete Account Form Toggle Password Event
class ToggleObscureDeletePassword extends SettingsEvent {}

// Change Passord Toggle Password Event
class ToggleObscureCurrentPassword extends SettingsEvent {}

// Change Passord, New Password Toggle Event
class ToggleObscureNewPassword extends SettingsEvent {}

// Change Passord, Confirm Password Toggle Event
class ToggleObscureConfirmPassword extends SettingsEvent {}

// Perform Clear Data Event
class PerformClearData extends SettingsEvent {}
