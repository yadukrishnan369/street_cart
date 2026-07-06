import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginUiState {
  final bool isPasswordVisible;

  const ShopLoginUiState({this.isPasswordVisible = false});

  ShopLoginUiState copyWith({bool? isPasswordVisible}) {
    return ShopLoginUiState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}

class ShopLoginUiCubit extends Cubit<ShopLoginUiState> {
  ShopLoginUiCubit() : super(const ShopLoginUiState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }
}
