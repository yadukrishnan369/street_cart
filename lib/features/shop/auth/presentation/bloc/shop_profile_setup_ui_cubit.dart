import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopProfileSetupUiState {
  final String? selectedCategory;
  final File? businessLicense;
  final File? ownerId;
  final bool isNavigated;

  const ShopProfileSetupUiState({
    this.selectedCategory,
    this.businessLicense,
    this.ownerId,
    this.isNavigated = false,
  });

  ShopProfileSetupUiState copyWith({
    String? selectedCategory,
    File? businessLicense,
    File? ownerId,
    bool? isNavigated,
  }) {
    return ShopProfileSetupUiState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      businessLicense: businessLicense ?? this.businessLicense,
      ownerId: ownerId ?? this.ownerId,
      isNavigated: isNavigated ?? this.isNavigated,
    );
  }
}

class ShopProfileSetupUiCubit extends Cubit<ShopProfileSetupUiState> {
  ShopProfileSetupUiCubit() : super(const ShopProfileSetupUiState());

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void selectBusinessLicense(File file) {
    emit(state.copyWith(businessLicense: file));
  }

  void selectOwnerId(File file) {
    emit(state.copyWith(ownerId: file));
  }

  void markNavigated() {
    emit(state.copyWith(isNavigated: true));
  }
}
