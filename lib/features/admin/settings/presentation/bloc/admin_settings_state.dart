import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

abstract class AdminSettingsState {
  const AdminSettingsState();
}

class AdminSettingsInitial extends AdminSettingsState {}

class AdminSettingsLoading extends AdminSettingsState {}

class AdminSettingsLoadSuccess extends AdminSettingsState {
  final AdminSettingsModel settings;

  const AdminSettingsLoadSuccess(this.settings);
}

class AdminSettingsLoadFailure extends AdminSettingsState {
  final String message;

  const AdminSettingsLoadFailure(this.message);
}

class AdminSettingsActionInProgress extends AdminSettingsState {
  final AdminSettingsModel settings;

  const AdminSettingsActionInProgress(this.settings);
}

class AdminSettingsActionSuccess extends AdminSettingsState {
  final String message;
  final AdminSettingsModel settings;

  const AdminSettingsActionSuccess({
    required this.message,
    required this.settings,
  });
}

class AdminSettingsActionFailure extends AdminSettingsState {
  final String message;
  final AdminSettingsModel settings;

  const AdminSettingsActionFailure({
    required this.message,
    required this.settings,
  });
}
