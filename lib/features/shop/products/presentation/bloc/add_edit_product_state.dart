import 'package:equatable/equatable.dart';

class VariantDraft extends Equatable {
  // Color name
  final String colorName;
  // Hex code, empty when using a named color
  final String colorHex;

  // Images
  final List<dynamic> images;

  // Size quantity
  final Map<String, int> sizes;

  const VariantDraft({
    required this.colorName,
    this.colorHex = '',
    this.images = const [],
    this.sizes = const {},
  });

  int get totalStock => sizes.values.fold(0, (a, b) => a + b);

  bool get hasAtLeastOneImage => images.isNotEmpty;

  VariantDraft copyWith({
    String? colorName,
    String? colorHex,
    List<dynamic>? images,
    Map<String, int>? sizes,
  }) => VariantDraft(
    colorName: colorName ?? this.colorName,
    colorHex: colorHex ?? this.colorHex,
    images: images ?? this.images,
    sizes: sizes ?? this.sizes,
  );

  @override
  List<Object?> get props => [colorName, colorHex, images, sizes];
}

class AddEditProductState extends Equatable {
  final String name;
  final String originalPrice;
  final String offerPrice;
  final String description;
  final String category;
  final String sizeStandard;
  final List<VariantDraft> variants;
  final bool isPublishing;
  final String? errorMessage;

  final VariantDraft? editingVariant;
  final bool isPickingImages;
  final String? variantErrorMessage;

  const AddEditProductState({
    this.name = '',
    this.originalPrice = '',
    this.offerPrice = '',
    this.description = '',
    this.category = '',
    this.sizeStandard = '',
    this.variants = const [],
    this.isPublishing = false,
    this.errorMessage,
    this.editingVariant,
    this.isPickingImages = false,
    this.variantErrorMessage,
  });

  int get totalStock => variants.fold(0, (s, v) => s + v.totalStock);
  bool get hasVariants => variants.isNotEmpty;

  List<String> get usedColorNames => variants.map((v) => v.colorName).toList();

  AddEditProductState copyWith({
    String? name,
    String? originalPrice,
    String? offerPrice,
    String? description,
    String? category,
    String? sizeStandard,
    List<VariantDraft>? variants,
    bool? isPublishing,
    String? errorMessage,
    bool clearError = false,
    VariantDraft? editingVariant,
    bool clearEditingVariant = false,
    bool? isPickingImages,
    String? variantErrorMessage,
    bool clearVariantError = false,
  }) => AddEditProductState(
    name: name ?? this.name,
    originalPrice: originalPrice ?? this.originalPrice,
    offerPrice: offerPrice ?? this.offerPrice,
    description: description ?? this.description,
    category: category ?? this.category,
    sizeStandard: sizeStandard ?? this.sizeStandard,
    variants: variants ?? this.variants,
    isPublishing: isPublishing ?? this.isPublishing,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    editingVariant: clearEditingVariant
        ? null
        : (editingVariant ?? this.editingVariant),
    isPickingImages: isPickingImages ?? this.isPickingImages,
    variantErrorMessage: clearVariantError
        ? null
        : (variantErrorMessage ?? this.variantErrorMessage),
  );

  @override
  List<Object?> get props => [
    name,
    originalPrice,
    offerPrice,
    description,
    category,
    sizeStandard,
    variants,
    isPublishing,
    errorMessage,
    editingVariant,
    isPickingImages,
    variantErrorMessage,
  ];
}
