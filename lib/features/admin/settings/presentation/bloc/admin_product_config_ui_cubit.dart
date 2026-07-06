import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProductConfigUiState {
  final bool isColorsTab;

  const AdminProductConfigUiState({this.isColorsTab = true});
}

class AdminProductConfigUiCubit extends Cubit<AdminProductConfigUiState> {
  AdminProductConfigUiCubit()
    : super(const AdminProductConfigUiState(isColorsTab: true));

  void setColorsTab() {
    emit(const AdminProductConfigUiState(isColorsTab: true));
  }

  void setSizesTab() {
    emit(const AdminProductConfigUiState(isColorsTab: false));
  }
}
