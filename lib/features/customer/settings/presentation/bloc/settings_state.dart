abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Map<String, dynamic> settings;
  final bool hasLocationData;

  SettingsLoaded({required this.settings, required this.hasLocationData});
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError({required this.message});
}
