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
