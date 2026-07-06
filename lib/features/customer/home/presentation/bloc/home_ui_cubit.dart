import 'package:flutter_bloc/flutter_bloc.dart';

class HomeUiState {
  final String selectedCategory;

  const HomeUiState({required this.selectedCategory});
}

class HomeUiCubit extends Cubit<HomeUiState> {
  HomeUiCubit() : super(const HomeUiState(selectedCategory: 'All'));

  void selectCategory(String category) {
    emit(HomeUiState(selectedCategory: category));
  }
}
