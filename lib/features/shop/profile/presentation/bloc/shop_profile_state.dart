import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

// Enum - status of shop profile actions
enum ShopProfileStatus {
  initial,
  loading,
  loaded,
  updateSuccess,
  error,
  imageUploading,
  imageUploaded,
  imageRemoved,
  paymentSettingsLoading,
  paymentSettingsLoaded,
  paymentSettingsError,
}

class ShopProfileState extends Equatable {
  final ShopProfileStatus status;
  final String? message;
  final ShopProfileModel? profile;
  final String? imageUrl;
  final Map<String, bool>? paymentSettings;

  // Edit fields from Edit Shop Profile
  final int currentStep;
  final String? selectedCategory;
  final String? profileImageUrl;
  final String? businessLicenseUrl;
  final String? ownerIdUrl;
  final String? selectedDistrict;
  final String? selectedState;
  final List<String> selectedPaymentMethods;
  final bool isUploadingImage;
  final bool isUploadingLicense;
  final bool isUploadingOwnerId;

  const ShopProfileState({
    this.status = ShopProfileStatus.initial,
    this.message,
    this.profile,
    this.imageUrl,
    this.paymentSettings,
    this.currentStep = 1,
    this.selectedCategory,
    this.profileImageUrl,
    this.businessLicenseUrl,
    this.ownerIdUrl,
    this.selectedDistrict,
    this.selectedState,
    this.selectedPaymentMethods = const [],
    this.isUploadingImage = false,
    this.isUploadingLicense = false,
    this.isUploadingOwnerId = false,
  });

  ShopProfileState copyWith({
    ShopProfileStatus? status,
    String? message,
    ShopProfileModel? profile,
    String? imageUrl,
    Map<String, bool>? paymentSettings,
    int? currentStep,
    String? selectedCategory,
    String? profileImageUrl,
    String? businessLicenseUrl,
    String? ownerIdUrl,
    String? selectedDistrict,
    String? selectedState,
    List<String>? selectedPaymentMethods,
    bool? isUploadingImage,
    bool? isUploadingLicense,
    bool? isUploadingOwnerId,
  }) {
    return ShopProfileState(
      status: status ?? this.status,
      message: message ?? this.message,
      profile: profile ?? this.profile,
      imageUrl: imageUrl ?? this.imageUrl,
      paymentSettings: paymentSettings ?? this.paymentSettings,
      currentStep: currentStep ?? this.currentStep,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
      ownerIdUrl: ownerIdUrl ?? this.ownerIdUrl,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
      selectedState: selectedState ?? this.selectedState,
      selectedPaymentMethods:
          selectedPaymentMethods ?? this.selectedPaymentMethods,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      isUploadingLicense: isUploadingLicense ?? this.isUploadingLicense,
      isUploadingOwnerId: isUploadingOwnerId ?? this.isUploadingOwnerId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    profile,
    imageUrl,
    paymentSettings,
    currentStep,
    selectedCategory,
    profileImageUrl,
    businessLicenseUrl,
    ownerIdUrl,
    selectedDistrict,
    selectedState,
    selectedPaymentMethods,
    isUploadingImage,
    isUploadingLicense,
    isUploadingOwnerId,
  ];
}
