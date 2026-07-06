import 'package:flutter_bloc/flutter_bloc.dart';

class AdminRegistrationsUiState {
  final int currentPage;
  final bool anyChanges;

  const AdminRegistrationsUiState({
    this.currentPage = 1,
    this.anyChanges = false,
  });

  AdminRegistrationsUiState copyWith({int? currentPage, bool? anyChanges}) {
    return AdminRegistrationsUiState(
      currentPage: currentPage ?? this.currentPage,
      anyChanges: anyChanges ?? this.anyChanges,
    );
  }
}

class AdminRegistrationsUiCubit extends Cubit<AdminRegistrationsUiState> {
  AdminRegistrationsUiCubit() : super(const AdminRegistrationsUiState());

  void changePage(int newPage) {
    emit(state.copyWith(currentPage: newPage));
  }

  void markChanges() {
    emit(state.copyWith(anyChanges: true));
  }
}
