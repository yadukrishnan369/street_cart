import 'package:flutter_bloc/flutter_bloc.dart';

class ShopSignupUiState {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isVerificationSheetShowing;

  const ShopSignupUiState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isVerificationSheetShowing = false,
  });

  ShopSignupUiState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isVerificationSheetShowing,
  }) {
    return ShopSignupUiState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isVerificationSheetShowing:
          isVerificationSheetShowing ?? this.isVerificationSheetShowing,
    );
  }
}

class ShopSignupUiCubit extends Cubit<ShopSignupUiState> {
  ShopSignupUiCubit() : super(const ShopSignupUiState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  void setVerificationSheetShowing(bool showing) {
    emit(state.copyWith(isVerificationSheetShowing: showing));
  }
}
