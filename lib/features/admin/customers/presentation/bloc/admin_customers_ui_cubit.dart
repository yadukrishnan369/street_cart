import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCustomersUiState {
  final int currentPage;

  const AdminCustomersUiState({this.currentPage = 1});
}

class AdminCustomersUiCubit extends Cubit<AdminCustomersUiState> {
  AdminCustomersUiCubit() : super(const AdminCustomersUiState(currentPage: 1));

  void changePage(int page) {
    emit(AdminCustomersUiState(currentPage: page));
  }

  void resetPage() {
    emit(const AdminCustomersUiState(currentPage: 1));
  }
}
