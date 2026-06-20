class CategoryModel {
  final String id;
  final String name;
  final bool isVisible;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.isVisible,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isVisible: map['is_visible'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_visible': isVisible,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    bool? isVisible,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class AdminSettingsModel {
  final double commissionPercentage;
  final bool enableCod;
  final bool enableOnline;
  final List<CategoryModel> productCategories;
  final List<CategoryModel> businessCategories;

  const AdminSettingsModel({
    required this.commissionPercentage,
    required this.enableCod,
    required this.enableOnline,
    this.productCategories = const [],
    this.businessCategories = const [],
  });

  factory AdminSettingsModel.fromMap(Map<String, dynamic> map) {
    final rawProductCats = map['product_categories'] as List<dynamic>?;
    final rawBusinessCats = map['business_categories'] as List<dynamic>?;

    final List<CategoryModel> pCats = rawProductCats != null
        ? rawProductCats
            .map((e) => CategoryModel.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList()
        : [];

    final List<CategoryModel> bCats = rawBusinessCats != null
        ? rawBusinessCats
            .map((e) => CategoryModel.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList()
        : [];

    return AdminSettingsModel(
      commissionPercentage: (map['commission_percentage'] as num?)?.toDouble() ?? 2.0,
      enableCod: map['enable_cod'] ?? true,
      enableOnline: map['enable_online'] ?? true,
      productCategories: pCats,
      businessCategories: bCats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commission_percentage': commissionPercentage,
      'enable_cod': enableCod,
      'enable_online': enableOnline,
      'product_categories': productCategories.map((e) => e.toMap()).toList(),
      'business_categories': businessCategories.map((e) => e.toMap()).toList(),
    };
  }

  AdminSettingsModel copyWith({
    double? commissionPercentage,
    bool? enableCod,
    bool? enableOnline,
    List<CategoryModel>? productCategories,
    List<CategoryModel>? businessCategories,
  }) {
    return AdminSettingsModel(
      commissionPercentage: commissionPercentage ?? this.commissionPercentage,
      enableCod: enableCod ?? this.enableCod,
      enableOnline: enableOnline ?? this.enableOnline,
      productCategories: productCategories ?? this.productCategories,
      businessCategories: businessCategories ?? this.businessCategories,
    );
  }
}
