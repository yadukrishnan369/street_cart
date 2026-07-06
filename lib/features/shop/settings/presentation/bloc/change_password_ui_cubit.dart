import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordUiState {
  final bool obscureCurrent;
  final bool obscureNew;
  final bool obscureConfirm;

  const ChangePasswordUiState({
    this.obscureCurrent = true,
    this.obscureNew = true,
    this.obscureConfirm = true,
  });

  ChangePasswordUiState copyWith({
    bool? obscureCurrent,
    bool? obscureNew,
    bool? obscureConfirm,
  }) {
    return ChangePasswordUiState(
      obscureCurrent: obscureCurrent ?? this.obscureCurrent,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
    );
  }
}

class ChangePasswordUiCubit extends Cubit<ChangePasswordUiState> {
  ChangePasswordUiCubit() : super(const ChangePasswordUiState());

  void toggleObscureCurrent() =>
      emit(state.copyWith(obscureCurrent: !state.obscureCurrent));
  void toggleObscureNew() =>
      emit(state.copyWith(obscureNew: !state.obscureNew));
  void toggleObscureConfirm() =>
      emit(state.copyWith(obscureConfirm: !state.obscureConfirm));
}
