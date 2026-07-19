part of 'shop_auth_bloc.dart';

enum ShopAuthStatus {
  initial,
  loading,
  authenticated,
  failure,
  verificationWaiting,
  verificationSuccess,
  passwordResetSuccess,
}

class ShopAuthState extends Equatable {
  final ShopAuthStatus status;
  final String? errorMessage;

  // Login & Signup state
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isVerificationSheetShowing;

  // Profile Setup state
  final String? selectedCategory;
  final File? businessLicense;
  final File? ownerId;
  final bool isProfileSetupNavigated;

  // Business categories list
  final List<String> categories;
  final bool categoriesLoading;
  final String? categoriesError;

  // Verification countdown
  final int secondsRemaining;
  final bool isResend;
  final String? ownerName;
  final String? shopName;
  final String? email;

  // Authenticated Shop Info
  final ShopProfileModel? shop;

  const ShopAuthState({
    this.status = ShopAuthStatus.initial,
    this.errorMessage,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isVerificationSheetShowing = false,
    this.selectedCategory,
    this.businessLicense,
    this.ownerId,
    this.isProfileSetupNavigated = false,
    this.categories = const [],
    this.categoriesLoading = false,
    this.categoriesError,
    this.secondsRemaining = 80,
    this.isResend = false,
    this.ownerName,
    this.shopName,
    this.email,
    this.shop,
  });

  ShopAuthState copyWith({
    ShopAuthStatus? status,
    String? errorMessage,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isVerificationSheetShowing,
    String? selectedCategory,
    File? businessLicense,
    File? ownerId,
    bool? isProfileSetupNavigated,
    List<String>? categories,
    bool? categoriesLoading,
    String? categoriesError,
    int? secondsRemaining,
    bool? isResend,
    String? ownerName,
    String? shopName,
    String? email,
    ShopProfileModel? shop,
  }) {
    return ShopAuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isVerificationSheetShowing:
          isVerificationSheetShowing ?? this.isVerificationSheetShowing,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      businessLicense: businessLicense ?? this.businessLicense,
      ownerId: ownerId ?? this.ownerId,
      isProfileSetupNavigated:
          isProfileSetupNavigated ?? this.isProfileSetupNavigated,
      categories: categories ?? this.categories,
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      categoriesError: categoriesError ?? this.categoriesError,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isResend: isResend ?? this.isResend,
      ownerName: ownerName ?? this.ownerName,
      shopName: shopName ?? this.shopName,
      email: email ?? this.email,
      shop: shop ?? this.shop,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    isPasswordVisible,
    isConfirmPasswordVisible,
    isVerificationSheetShowing,
    selectedCategory,
    businessLicense,
    ownerId,
    isProfileSetupNavigated,
    categories,
    categoriesLoading,
    categoriesError,
    secondsRemaining,
    isResend,
    ownerName,
    shopName,
    email,
    shop,
  ];
}
