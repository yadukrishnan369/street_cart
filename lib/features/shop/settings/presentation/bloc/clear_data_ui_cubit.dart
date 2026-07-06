import 'package:flutter_bloc/flutter_bloc.dart';

class ClearDataUiState {
  final bool isClearing;
  final bool isSuccess;
  final String? errorMessage;

  const ClearDataUiState({
    this.isClearing = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  ClearDataUiState copyWith({
    bool? isClearing,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return ClearDataUiState(
      isClearing: isClearing ?? this.isClearing,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

class ClearDataUiCubit extends Cubit<ClearDataUiState> {
  ClearDataUiCubit() : super(const ClearDataUiState());

  Future<void> performClearData() async {
    emit(state.copyWith(isClearing: true));
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isClearing: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isClearing: false, errorMessage: e.toString()));
    }
  }
}
