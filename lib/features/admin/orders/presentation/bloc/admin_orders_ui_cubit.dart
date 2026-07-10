import 'package:flutter_bloc/flutter_bloc.dart';

class AdminOrdersUiState {
  final int currentPage;

  AdminOrdersUiState({required this.currentPage});

  AdminOrdersUiState copyWith({int? currentPage}) {
    return AdminOrdersUiState(currentPage: currentPage ?? this.currentPage);
  }
}

class AdminOrdersUiCubit extends Cubit<AdminOrdersUiState> {
  AdminOrdersUiCubit() : super(AdminOrdersUiState(currentPage: 1));

  void changePage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void resetPage() {
    emit(state.copyWith(currentPage: 1));
  }
}
