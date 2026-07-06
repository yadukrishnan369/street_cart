class AdminConstants {
  static const String bioTitle = 'Bio Section';
  static const String bioContent =
      'Super Admin responsible for maintaining platform integrity, overseeing shop verification processes, and monitoring overall system health to ensure a seamless hyperlocal experience. Dedicated to optimizing vendor workflows and maintaining high standards of customer satisfaction across all active market zones.';

  static const String aboutTitle = 'About Street Cart';
  static const String aboutContent =
      'Street Cart is a hyperlocal ecommerce platform designed to empower local vendors and connect them directly to their surrounding communities. Our mission is to digitize neighborhood commerce while preserving the personal touch of local shopping.';
  static const String aboutFooter = 'Driving local economy forward';

  // Product Configuration Defaults
  // Fallback values used when no data is configured/error happents by Admin.

  static const List<String> defaultProductCategories = [
    'Shirt',
    'T-Shirt',
    'Jeans',
    'Jacket',
    'Dress',
    'Footwear',
    'Accessories',
    'Other',
  ];

  static const List<String> defaultSizeStandards = [
    'Shirt',
    'Footwear',
    'Pants',
    'Custom',
  ];

  static const Map<String, List<String>> defaultProductSizes = {
    'Shirt': ['S', 'M', 'L', 'XL', 'XXL'],
    'Shoes': ['7', '8', '9', '10', '11'],
    'Pants': ['28', '30', '32', '34', '36'],
    'Custom': ['Free Size'],
  };

  static const List<String> defaultProductColors = [
    'Black',
    'Blue',
    'Red',
    'White',
    'Green',
  ];

  // Color Preset
  static const List<Map<String, String>> colorPresets = [
    {'name': 'Red', 'hex': '#F44336'},
    {'name': 'Pink', 'hex': '#E91E63'},
    {'name': 'Purple', 'hex': '#9C27B0'},
    {'name': 'Deep Purple', 'hex': '#673AB7'},
    {'name': 'Indigo', 'hex': '#3F51B5'},
    {'name': 'Blue', 'hex': '#2196F3'},
    {'name': 'Cyan', 'hex': '#00BCD4'},
    {'name': 'Teal', 'hex': '#009688'},
    {'name': 'Green', 'hex': '#4CAF50'},
    {'name': 'Yellow', 'hex': '#FFEB3B'},
    {'name': 'Orange', 'hex': '#FF9800'},
    {'name': 'Brown', 'hex': '#795548'},
    {'name': 'Grey', 'hex': '#9E9E9E'},
    {'name': 'Black', 'hex': '#212121'},
    {'name': 'White', 'hex': '#FFFFFF'},
    {'name': 'Navy', 'hex': '#1A237E'},
    {'name': 'Olive', 'hex': '#827717'},
    {'name': 'Maroon', 'hex': '#880E4F'},
  ];
}
