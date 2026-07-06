import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProductsUiState {
  final int currentPage;

  const AdminProductsUiState({this.currentPage = 1});
}

class AdminProductsUiCubit extends Cubit<AdminProductsUiState> {
  AdminProductsUiCubit() : super(const AdminProductsUiState(currentPage: 1));

  void changePage(int page) {
    emit(AdminProductsUiState(currentPage: page));
  }

  void resetPage() {
    emit(const AdminProductsUiState(currentPage: 1));
  }
}
