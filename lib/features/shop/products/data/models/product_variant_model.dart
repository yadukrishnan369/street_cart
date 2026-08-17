class ProductVariantModel {
  final String colorName;
  final String colorHex; // hex code
  final List<String> images; // Cloudinary URLs
  final Map<String, int> sizes;

  const ProductVariantModel({
    required this.colorName,
    this.colorHex = '',
    required this.images,
    required this.sizes,
  });

  // Sum of quantities across all sizes for this variant
  int get totalStock => sizes.values.fold(0, (acc, qty) => acc + qty);

  factory ProductVariantModel.fromMap(Map<String, dynamic> map) {
    final rawSizes = (map['sizes'] as Map<String, dynamic>?) ?? {};
    return ProductVariantModel(
      colorName: (map['color_name'] as String?) ?? '',
      colorHex: (map['color_hex'] as String?) ?? '',
      images: List<String>.from(map['images'] ?? []),
      sizes: rawSizes.map(
        (k, v) => MapEntry(k, ((v) is int ? v : (v as num).toInt())),
      ),
    );
  }

  Map<String, dynamic> toMap() => {
    'color_name': colorName,
    'color_hex': colorHex,
    'images': images,
    'sizes': sizes,
    'total_stock': totalStock,
  };

  ProductVariantModel copyWith({
    String? colorName,
    String? colorHex,
    List<String>? images,
    Map<String, int>? sizes,
  }) => ProductVariantModel(
    colorName: colorName ?? this.colorName,
    colorHex: colorHex ?? this.colorHex,
    images: images ?? this.images,
    sizes: sizes ?? this.sizes,
  );

  @override
  String toString() =>
      'ProductVariantModel(colorName: $colorName, totalStock: $totalStock)';
}
