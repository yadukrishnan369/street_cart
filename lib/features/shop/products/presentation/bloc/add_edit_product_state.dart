import 'package:equatable/equatable.dart';


class VariantDraft extends Equatable {
  // Color name
  final String colorName;

  // Images each entry is either a newly picked or a existing Cloudinary URL
  final List<dynamic> images;

  // Size  quantity map
  final Map<String, int> sizes;

  const VariantDraft({
    required this.colorName,
    this.images = const [],
    this.sizes = const {},
  });

  int get totalStock => sizes.values.fold(0, (a, b) => a + b);

  bool get hasAtLeastOneImage => images.isNotEmpty;

  VariantDraft copyWith({
    String? colorName,
    List<dynamic>? images,
    Map<String, int>? sizes,
  }) => VariantDraft(
    colorName: colorName ?? this.colorName,
    images: images ?? this.images,
    sizes: sizes ?? this.sizes,
  );

  @override
  List<Object?> get props => [colorName, images, sizes];
}

// State

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
  });

  int get totalStock => variants.fold(0, (s, v) => s + v.totalStock);
  bool get hasVariants => variants.isNotEmpty;

  // All color names already used in variants to prevent duplicates
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
  ];
}
