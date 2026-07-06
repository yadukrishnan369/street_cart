import 'package:flutter_bloc/flutter_bloc.dart';

class ShopOnboardingUiState {
  final int currentPage;

  const ShopOnboardingUiState({this.currentPage = 0});
}

class ShopOnboardingUiCubit extends Cubit<ShopOnboardingUiState> {
  ShopOnboardingUiCubit() : super(const ShopOnboardingUiState());

  void setPage(int index) {
    emit(ShopOnboardingUiState(currentPage: index));
  }
}
