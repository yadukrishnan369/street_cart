import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccountUiState {
  final bool obscurePassword;

  const DeleteAccountUiState({this.obscurePassword = true});

  DeleteAccountUiState copyWith({bool? obscurePassword}) {
    return DeleteAccountUiState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

class DeleteAccountUiCubit extends Cubit<DeleteAccountUiState> {
  DeleteAccountUiCubit() : super(const DeleteAccountUiState());

  void toggleObscurePassword() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
}
