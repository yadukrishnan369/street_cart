import 'package:cloud_firestore/cloud_firestore.dart';

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
  final List<String> sizes;
  final List<String> colors;
  final List<String> images;
  final DateTime? createdAt;
  final int salesCount;
  final bool isActive;
  final bool disabledByAdmin;

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
    required this.sizes,
    required this.colors,
    required this.images,
    this.createdAt,
    this.salesCount = 0,
    this.isActive = true,
    this.disabledByAdmin = false,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      shopId: map['shop_id'] ?? '',
      name: map['name'] ?? '',
      originalPrice: (map['original_price'] as num?)?.toDouble() ?? 0.0,
      offerPrice: (map['offer_price'] as num?)?.toDouble(),
      description: map['description'] ?? '',
      stockQuantity: (map['stock_quantity'] as num?)?.toInt() ?? 0,
      category: map['category'] ?? '',
      sizeStandard: map['size_standard'] ?? '',
      sizes: List<String>.from(map['sizes'] ?? []),
      colors: List<String>.from(map['colors'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      createdAt: (map['created_at'] as Timestamp?)?.toDate(),
      salesCount: (map['sales_count'] as num?)?.toInt() ?? 0,
      isActive: map['is_active'] ?? (((map['stock_quantity'] as num?)?.toInt() ?? 0) > 0),
      disabledByAdmin: map['disabled_by_admin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shop_id': shopId,
      'name': name,
      'original_price': originalPrice,
      'offer_price': offerPrice,
      'description': description,
      'stock_quantity': stockQuantity,
      'category': category,
      'size_standard': sizeStandard,
      'sizes': sizes,
      'colors': colors,
      'images': images,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'sales_count': salesCount,
      'is_active': isActive,
      'disabled_by_admin': disabledByAdmin,
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
    List<String>? sizes,
    List<String>? colors,
    List<String>? images,
    DateTime? createdAt,
    int? salesCount,
    bool? isActive,
    bool? disabledByAdmin,
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
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      salesCount: salesCount ?? this.salesCount,
      isActive: isActive ?? this.isActive,
      disabledByAdmin: disabledByAdmin ?? this.disabledByAdmin,
    );
  }
}
