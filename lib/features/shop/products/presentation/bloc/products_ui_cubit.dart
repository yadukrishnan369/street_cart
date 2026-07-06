import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsUiState {
  final bool isSearching;

  const ProductsUiState({this.isSearching = false});

  ProductsUiState copyWith({bool? isSearching}) {
    return ProductsUiState(isSearching: isSearching ?? this.isSearching);
  }
}

class ProductsUiCubit extends Cubit<ProductsUiState> {
  ProductsUiCubit() : super(const ProductsUiState());

  void toggleSearch(bool isSearching) {
    emit(state.copyWith(isSearching: isSearching));
  }
}
