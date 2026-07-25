import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_variant_model.dart';

class ProductModel {
  final String id;
  final String shopId;
  final String name;
  final double originalPrice;
  final double? offerPrice;
  final String description;
  final int stockQuantity;
  final String category;
  final String sizeStandard;

  final List<ProductVariantModel> variants;

  final List<String> sizes;
  final List<String> colors;
  final List<String> images;

  final DateTime? createdAt;
  final int salesCount;
  final bool isActive;
  final bool disabledByAdmin;
  final double rating;
  final int reviewsCount;

  ProductModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.originalPrice,
    this.offerPrice,
    required this.description,
    required this.stockQuantity,
    required this.category,
    required this.sizeStandard,
    this.variants = const [],
    this.sizes = const [],
    this.colors = const [],
    this.images = const [],
    this.createdAt,
    this.salesCount = 0,
    this.isActive = true,
    this.disabledByAdmin = false,
    this.rating = 0.0,
    this.reviewsCount = 0,
  });

  // Returns true when this product uses the new variant
  bool get hasVariants => variants.isNotEmpty;

  // All distinct color names across variants
  List<String> get allColors => hasVariants
      ? variants
            .where(
              (v) =>
                  v.sizes.values.any((qty) => qty > 0) || v.images.isNotEmpty,
            )
            .map((v) => v.colorName)
            .toList()
      : colors;

  // All distinct size keys across variants
  List<String> get allSizes {
    if (!hasVariants) return sizes;
    final Set<String> s = {};
    for (final v in variants) {
      for (final entry in v.sizes.entries) {
        if (entry.value > 0) {
          s.add(entry.key);
        }
      }
    }
    return s.toList();
  }

  // The display images
  List<String> get displayImages =>
      hasVariants ? (variants.first.images) : images;

  // Union of all distinct images across all variants
  List<String> get allImages {
    if (!hasVariants) return images;
    final Set<String> imgSet = {};
    for (final v in variants) {
      imgSet.addAll(v.images);
    }
    return imgSet.toList();
  }

  // Images for a specific color in the new variant
  List<String> imagesForColor(String colorName) {
    if (!hasVariants) return images;
    final v = variants.firstWhere(
      (v) => v.colorName == colorName,
      orElse: () => variants.first,
    );
    return v.images;
  }

  // Stock quantity for a specific color + size combination
  int stockForVariant(String colorName, String size) {
    if (!hasVariants) return stockQuantity;
    final v = variants.firstWhere(
      (v) => v.colorName == colorName,
      orElse: () =>
          ProductVariantModel(colorName: colorName, images: [], sizes: {}),
    );
    return v.sizes[size] ?? 0;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    // Read variants first
    final variantList = (map['variants'] as List<dynamic>? ?? [])
        .map((v) => ProductVariantModel.fromMap(v as Map<String, dynamic>))
        .toList();

    // Auto-compute stock from variants if present, else use stored value
    final storedStock = (map['stock_quantity'] as num?)?.toInt() ?? 0;
    final computedStock = variantList.isNotEmpty
        ? variantList.fold(0, (s, v) => s + v.totalStock)
        : storedStock;

    return ProductModel(
      id: docId,
      shopId: map['shop_id'] ?? '',
      name: map['name'] ?? '',
      originalPrice: (map['original_price'] as num?)?.toDouble() ?? 0.0,
      offerPrice: (map['offer_price'] as num?)?.toDouble(),
      description: map['description'] ?? '',
      stockQuantity: computedStock,
      category: map['category'] ?? '',
      sizeStandard: map['size_standard'] ?? '',
      variants: variantList,
      sizes: List<String>.from(map['sizes'] ?? []),
      colors: List<String>.from(map['colors'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      createdAt: (map['created_at'] as Timestamp?)?.toDate(),
      salesCount: (map['sales_count'] as num?)?.toInt() ?? 0,
      isActive: map['is_active'] ?? (computedStock > 0),
      disabledByAdmin: map['disabled_by_admin'] ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (map['reviews_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    final totalStock = hasVariants
        ? variants.fold(0, (s, v) => s + v.totalStock)
        : stockQuantity;
    return {
      'shop_id': shopId,
      'name': name,
      'original_price': originalPrice,
      'offer_price': offerPrice,
      'description': description,
      'stock_quantity': totalStock,
      'category': category,
      'size_standard': sizeStandard,
      'variants': variants.map((v) => v.toMap()).toList(),
      'sizes': hasVariants ? allSizes : sizes,
      'colors': hasVariants ? allColors : colors,
      'images': hasVariants ? displayImages : images,
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'sales_count': salesCount,
      'is_active': totalStock > 0,
      'disabled_by_admin': disabledByAdmin,
      'rating': rating,
      'reviews_count': reviewsCount,
    };
  }

  ProductModel copyWith({
    String? id,
    String? shopId,
    String? name,
    double? originalPrice,
    double? offerPrice,
    String? description,
    int? stockQuantity,
    String? category,
    String? sizeStandard,
    List<ProductVariantModel>? variants,
    List<String>? sizes,
    List<String>? colors,
    List<String>? images,
    DateTime? createdAt,
    int? salesCount,
    bool? isActive,
    bool? disabledByAdmin,
    double? rating,
    int? reviewsCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      originalPrice: originalPrice ?? this.originalPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      description: description ?? this.description,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      category: category ?? this.category,
      sizeStandard: sizeStandard ?? this.sizeStandard,
      variants: variants ?? this.variants,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      salesCount: salesCount ?? this.salesCount,
      isActive: isActive ?? this.isActive,
      disabledByAdmin: disabledByAdmin ?? this.disabledByAdmin,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
    );
  }
}
