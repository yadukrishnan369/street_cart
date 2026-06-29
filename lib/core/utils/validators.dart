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

  static String? validateShopPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 6 characters';
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
    final gstRegExp = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][1-9A-Z]Z[0-9A-Z]$',
    );
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

  // Admin Specific Validators
  static String? validateAdminPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_]').hasMatch(value)) {
    //   return 'Password must contain at least one special character';
    // }
    return null;
  }

  static String? adminValidatePercentage(String? value) {
    final percentage = double.tryParse(value ?? '');

    if (percentage == null) {
      return 'Please enter a valid number';
    }

    if (percentage < 0 || percentage > 100) {
      return 'Percentage must be between 0 and 100';
    }

    return null;
  }

  // Product Specific Validators
  static String? validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is mandatory';
    }
    return null;
  }

  static String? validateProductOriginalPrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mandatory';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Invalid number';
    }
    if (price <= 0) {
      return 'Must be greater than 0';
    }
    return null;
  }

  static String? validateProductOfferPrice(String? value, String? originalPriceStr) {
    if (value != null && value.trim().isNotEmpty) {
      final offerPrice = double.tryParse(value);
      if (offerPrice == null) {
        return 'Invalid number';
      }
      if (offerPrice <= 0) {
        return 'Must be greater than 0';
      }
      if (originalPriceStr != null && originalPriceStr.trim().isNotEmpty) {
        final originalPrice = double.tryParse(originalPriceStr);
        if (originalPrice != null && offerPrice >= originalPrice) {
          return 'Must be less than original price';
        }
      }
    }
    return null;
  }

  static String? validateProductDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is mandatory';
    }
    return null;
  }

  static String? validateProductStock(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Stock is mandatory';
    }
    if (int.tryParse(value) == null) {
      return 'Invalid integer';
    }
    return null;
  }
}
