import 'package:flutter_bloc/flutter_bloc.dart';

class AdminLoginUiState {
  final bool obscurePassword;

  const AdminLoginUiState({this.obscurePassword = true});
}

class AdminLoginUiCubit extends Cubit<AdminLoginUiState> {
  AdminLoginUiCubit() : super(const AdminLoginUiState(obscurePassword: true));

  void toggleObscurePassword() {
    emit(AdminLoginUiState(obscurePassword: !state.obscurePassword));
  }
}
