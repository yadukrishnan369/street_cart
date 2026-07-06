import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccountUiState {
  final bool obscurePassword;

  const DeleteAccountUiState({this.obscurePassword = true});
}

class DeleteAccountUiCubit extends Cubit<DeleteAccountUiState> {
  DeleteAccountUiCubit() : super(const DeleteAccountUiState(obscurePassword: true));

  void toggleObscurePassword() {
    emit(DeleteAccountUiState(obscurePassword: !state.obscurePassword));
  }
}
