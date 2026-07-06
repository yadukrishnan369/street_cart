import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/core/constants/profile_constants.dart';

class EditShopProfileUiState {
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

  const EditShopProfileUiState({
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

  EditShopProfileUiState copyWith({
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
    return EditShopProfileUiState(
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
}

class EditShopProfileUiCubit extends Cubit<EditShopProfileUiState> {
  EditShopProfileUiCubit(ShopProfileModel profile)
    : super(
        EditShopProfileUiState(
          selectedCategory: profile.category,
          profileImageUrl: profile.profileImageUrl,
          businessLicenseUrl: profile.businessLicenseUrl,
          ownerIdUrl: profile.ownerIdUrl,
          selectedDistrict:
              ProfileConstants.districts.contains(profile.district)
              ? profile.district
              : null,
          selectedState: ProfileConstants.states.contains(profile.state)
              ? profile.state
              : null,
          selectedPaymentMethods: List<String>.from(profile.paymentMethods),
        ),
      );

  void updateStep(int step) => emit(state.copyWith(currentStep: step));
  void updateCategory(String category) =>
      emit(state.copyWith(selectedCategory: category));
  void updateProfileImageUrl(String url) =>
      emit(state.copyWith(profileImageUrl: url));
  void updateBusinessLicenseUrl(String url) =>
      emit(state.copyWith(businessLicenseUrl: url));
  void updateOwnerIdUrl(String url) => emit(state.copyWith(ownerIdUrl: url));
  void updateDistrict(String? district) =>
      emit(state.copyWith(selectedDistrict: district));
  void updateState(String? selectedState) =>
      emit(state.copyWith(selectedState: selectedState));

  void updateUploadingImage(bool val) =>
      emit(state.copyWith(isUploadingImage: val));
  void updateUploadingLicense(bool val) =>
      emit(state.copyWith(isUploadingLicense: val));
  void updateUploadingOwnerId(bool val) =>
      emit(state.copyWith(isUploadingOwnerId: val));

  void togglePaymentMethod(String method, bool isSelected) {
    final list = List<String>.from(state.selectedPaymentMethods);
    if (isSelected) {
      if (!list.contains(method)) {
        list.add(method);
      }
    } else {
      list.remove(method);
    }
    emit(state.copyWith(selectedPaymentMethods: list));
  }
}
