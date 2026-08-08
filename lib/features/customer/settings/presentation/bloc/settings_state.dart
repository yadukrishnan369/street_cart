abstract class SettingsState {
  final bool obscureDeletePassword;
  final bool obscureCurrentPassword;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;

  const SettingsState({
    this.obscureDeletePassword = true,
    this.obscureCurrentPassword = true,
    this.obscureNewPassword = true,
    this.obscureConfirmPassword = true,
  });
}

// Initial state
class SettingsInitial extends SettingsState {
  const SettingsInitial({
    super.obscureDeletePassword,
    super.obscureCurrentPassword,
    super.obscureNewPassword,
    super.obscureConfirmPassword,
  });
}

// Loading state
class SettingsLoading extends SettingsState {
  const SettingsLoading({
    super.obscureDeletePassword,
    super.obscureCurrentPassword,
    super.obscureNewPassword,
    super.obscureConfirmPassword,
  });
}

// Loaded state
class SettingsLoaded extends SettingsState {
  final Map<String, dynamic> settings;
  final bool hasLocationData;

  SettingsLoaded({
    required this.settings,
    required this.hasLocationData,
    super.obscureDeletePassword,
    super.obscureCurrentPassword,
    super.obscureNewPassword,
    super.obscureConfirmPassword,
  });

  SettingsLoaded copyWith({
    Map<String, dynamic>? settings,
    bool? hasLocationData,
    bool? obscureDeletePassword,
    bool? obscureCurrentPassword,
    bool? obscureNewPassword,
    bool? obscureConfirmPassword,
  }) {
    return SettingsLoaded(
      settings: settings ?? this.settings,
      hasLocationData: hasLocationData ?? this.hasLocationData,
      obscureDeletePassword:
          obscureDeletePassword ?? this.obscureDeletePassword,
      obscureCurrentPassword:
          obscureCurrentPassword ?? this.obscureCurrentPassword,
      obscureNewPassword: obscureNewPassword ?? this.obscureNewPassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }
}

// Error State
class SettingsError extends SettingsState {
  final String message;

  SettingsError({
    required this.message,
    super.obscureDeletePassword,
    super.obscureCurrentPassword,
    super.obscureNewPassword,
    super.obscureConfirmPassword,
  });
}

// Settings Clear Data In Progress State
class SettingsClearingData extends SettingsState {
  const SettingsClearingData({
    super.obscureDeletePassword,
    super.obscureCurrentPassword,
    super.obscureNewPassword,
    super.obscureConfirmPassword,
  });
}

// Settings Clear Data Success State
class SettingsClearDataSuccess extends SettingsState {
  const SettingsClearDataSuccess({
    super.obscureDeletePassword,
    super.obscureCurrentPassword,
    super.obscureNewPassword,
    super.obscureConfirmPassword,
  });
}
