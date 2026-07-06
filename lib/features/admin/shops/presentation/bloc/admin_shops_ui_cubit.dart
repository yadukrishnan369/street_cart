import 'package:flutter_bloc/flutter_bloc.dart';

class AdminShopsUiState {
  final int currentPage;

  const AdminShopsUiState({this.currentPage = 1});
}

class AdminShopsUiCubit extends Cubit<AdminShopsUiState> {
  AdminShopsUiCubit() : super(const AdminShopsUiState(currentPage: 1));

  void changePage(int page) {
    emit(AdminShopsUiState(currentPage: page));
  }
}
