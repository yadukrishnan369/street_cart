import 'package:flutter_bloc/flutter_bloc.dart';

class SignupUiState {
  final bool isVerificationSheetShowing;

  const SignupUiState({this.isVerificationSheetShowing = false});
}

class SignupUiCubit extends Cubit<SignupUiState> {
  SignupUiCubit() : super(const SignupUiState(isVerificationSheetShowing: false));

  void setVerificationSheetShowing(bool showing) {
    emit(SignupUiState(isVerificationSheetShowing: showing));
  }
}
