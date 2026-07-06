import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerShopsUiState {
  final String searchQuery;

  const CustomerShopsUiState({this.searchQuery = ''});
}

class CustomerShopsUiCubit extends Cubit<CustomerShopsUiState> {
  CustomerShopsUiCubit() : super(const CustomerShopsUiState(searchQuery: ''));

  void updateSearchQuery(String query) {
    emit(CustomerShopsUiState(searchQuery: query));
  }
}
