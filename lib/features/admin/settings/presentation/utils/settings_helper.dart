import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_state.dart';

class SettingsHelper {
  static AdminSettingsModel? getSettings(AdminSettingsState state) {
    if (state is AdminSettingsLoadSuccess) return state.settings;
    if (state is AdminSettingsActionSuccess) return state.settings;
    if (state is AdminSettingsActionFailure) return state.settings;
    return null;
  }
}
