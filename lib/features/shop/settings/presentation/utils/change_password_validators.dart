class ChangePasswordValidators {
  // Validation for Current Password Field
  static String? validateCurrentPassword(String? val) {
    if (val == null || val.isEmpty) return 'Current password is required';
    return null;
  }

  // Validation for New Password Field
  static String? validateNewPassword(String? val) {
    if (val == null || val.isEmpty) return 'New password is required';
    if (val.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  // Validation for Confirm  Password Field
  static String? validateConfirmPassword(String? val, String newPassword) {
    if (val == null || val.isEmpty) return 'Confirm password is required';
    if (val != newPassword) return 'Passwords do not match';
    return null;
  }
}
