import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_edit_product_state.dart';

class AddEditProductUiCubit extends Cubit<AddEditProductState> {
  AddEditProductUiCubit() : super(const AddEditProductState());

  void updateName(String value) => emit(state.copyWith(name: value));
  void updateOriginalPrice(String value) =>
      emit(state.copyWith(originalPrice: value));
  void updateOfferPrice(String value) =>
      emit(state.copyWith(offerPrice: value));
  void updateDescription(String value) =>
      emit(state.copyWith(description: value));
  void updateCategory(String value) => emit(state.copyWith(category: value));
  void updateSizeStandard(String value) => emit(state.copyWith(sizeStandard: value));
}
