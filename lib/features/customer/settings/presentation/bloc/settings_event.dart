abstract class SettingsEvent {}

class FetchSettingsData extends SettingsEvent {}

class ToggleSetting extends SettingsEvent {
  final String key;
  final bool value;

  ToggleSetting({required this.key, required this.value});
}
