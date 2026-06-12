class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number should contain only digits';
    }
    if (value.length < 10 || value.length > 10) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? validateAddressPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number should contain only digits';
    }
    if (value.length < 10 || value.length > 10) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? validateAddress1(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter address line 1';
    }
    return null;
  }

  static String? validateAddress2(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter address line 2';
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter city';
    }
    return null;
  }

  static String? validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter pincode';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Pincode should contain only digits';
    }
    if (value.length < 6 || value.length > 6) {
      return 'Enter a valid 6-digit pincode';
    }
    return null;
  }

  // Shop Specific Validators
  static String? validateShopName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Shop name is required';
    }
    if (value.length < 3) {
      return 'Shop name must be at least 3 characters';
    }
    return null;
  }

  static String? validateGST(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'GST number is required';
    }
    if (value.length != 15) {
    return 'GST number must be 15 characters';
  }
    final gstRegExp =
        RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$');
    if (!gstRegExp.hasMatch(value)) {
      return 'Enter a valid GST number';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a business category';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Shop description is required';
    }
    if (value.length < 20) {
      return 'Description should be at least 20 characters';
    }
    return null;
  }
}
