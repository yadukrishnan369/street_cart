import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProfileUiState {
  final bool isEditing;

  const AdminProfileUiState({this.isEditing = false});
}

class AdminProfileUiCubit extends Cubit<AdminProfileUiState> {
  AdminProfileUiCubit() : super(const AdminProfileUiState(isEditing: false));

  void showEditOverlay() {
    emit(const AdminProfileUiState(isEditing: true));
  }

  void hideEditOverlay() {
    emit(const AdminProfileUiState(isEditing: false));
  }
}
