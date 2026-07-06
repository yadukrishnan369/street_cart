import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingUiState {
  final int currentPage;

  const OnboardingUiState({required this.currentPage});
}

class OnboardingUiCubit extends Cubit<OnboardingUiState> {
  OnboardingUiCubit() : super(const OnboardingUiState(currentPage: 0));

  void setPage(int page) {
    emit(OnboardingUiState(currentPage: page));
  }
}
