import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

class AdminCategoryFormState {
  final String name;
  final List<String> productCategories;
  final Set<String> selectedSizeGroups;
  final List<SizeGroupModel> availableSizeGroups;
  final String? nameError;
  final String? productCategoryError;

  const AdminCategoryFormState({
    required this.name,
    required this.productCategories,
    required this.selectedSizeGroups,
    required this.availableSizeGroups,
    this.nameError,
    this.productCategoryError,
  });

  AdminCategoryFormState copyWith({
    String? name,
    List<String>? productCategories,
    Set<String>? selectedSizeGroups,
    List<SizeGroupModel>? availableSizeGroups,
    String? nameError,
    String? productCategoryError,
  }) {
    return AdminCategoryFormState(
      name: name ?? this.name,
      productCategories: productCategories ?? this.productCategories,
      selectedSizeGroups: selectedSizeGroups ?? this.selectedSizeGroups,
      availableSizeGroups: availableSizeGroups ?? this.availableSizeGroups,
      nameError: nameError ?? this.nameError,
      productCategoryError: productCategoryError ?? this.productCategoryError,
    );
  }
}

class AdminCategoryFormCubit extends Cubit<AdminCategoryFormState> {
  AdminCategoryFormCubit({
    required List<SizeGroupModel> allSizeGroups,
    CategoryModel? initialCategory,
  }) : super(
         AdminCategoryFormState(
           name: initialCategory?.name ?? '',
           productCategories: initialCategory?.productCategories ?? [],
           selectedSizeGroups: Set<String>.from(
             initialCategory?.sizeGroups ?? [],
           ),
           availableSizeGroups: allSizeGroups,
         ),
       );

  void updateName(String val) {
    emit(
      state.copyWith(
        name: val,
        nameError: val.trim().isEmpty ? 'Category name is required' : null,
      ),
    );
  }

  void addProductCategory(String cat) {
    final cleaned = cat.trim();
    if (cleaned.isEmpty) return;
    if (state.productCategories.contains(cleaned)) {
      emit(state.copyWith(productCategoryError: 'Category already added'));
      return;
    }
    emit(
      state.copyWith(
        productCategories: [...state.productCategories, cleaned],
        productCategoryError: null,
      ),
    );
  }

  void removeProductCategory(int index) {
    final list = List<String>.from(state.productCategories);
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      emit(state.copyWith(productCategories: list));
    }
  }

  void toggleSizeGroup(String name) {
    final updated = Set<String>.from(state.selectedSizeGroups);
    if (updated.contains(name)) {
      updated.remove(name);
    } else {
      updated.add(name);
    }
    emit(state.copyWith(selectedSizeGroups: updated));
  }

  bool validate() {
    final nameValid = state.name.trim().isNotEmpty;
    emit(
      state.copyWith(nameError: nameValid ? null : 'Category name is required'),
    );
    return nameValid;
  }
}
