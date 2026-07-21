class ColorModel {
  final String id;
  final String name;
  final String hexCode;

  const ColorModel({
    required this.id,
    required this.name,
    required this.hexCode,
  });

  factory ColorModel.fromMap(Map<String, dynamic> map) {
    return ColorModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      hexCode: map['hex_code'] ?? '#000000',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'hex_code': hexCode};
  }

  ColorModel copyWith({String? id, String? name, String? hexCode}) {
    return ColorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      hexCode: hexCode ?? this.hexCode,
    );
  }
}

class SizeGroupModel {
  final String id;
  final String name;
  final List<String> sizes;

  const SizeGroupModel({
    required this.id,
    required this.name,
    this.sizes = const [],
  });

  factory SizeGroupModel.fromMap(Map<String, dynamic> map) {
    final rawSizes = map['sizes'] as List<dynamic>?;
    return SizeGroupModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      sizes: rawSizes != null ? rawSizes.map((e) => e.toString()).toList() : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'sizes': sizes};
  }

  SizeGroupModel copyWith({String? id, String? name, List<String>? sizes}) {
    return SizeGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sizes: sizes ?? this.sizes,
    );
  }
}

class ProductConfigModel {
  final List<ColorModel> colors;
  final List<SizeGroupModel> sizeGroups;

  const ProductConfigModel({
    this.colors = const [],
    this.sizeGroups = const [],
  });

  factory ProductConfigModel.fromMap(Map<String, dynamic> map) {
    final rawColors = map['colors'] as List<dynamic>?;
    final rawGroups = map['size_groups'] as List<dynamic>?;
    return ProductConfigModel(
      colors: rawColors != null
          ? rawColors
                .map(
                  (e) =>
                      ColorModel.fromMap(Map<String, dynamic>.from(e as Map)),
                )
                .toList()
          : [],
      sizeGroups: rawGroups != null
          ? rawGroups
                .map(
                  (e) => SizeGroupModel.fromMap(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'colors': colors.map((e) => e.toMap()).toList(),
      'size_groups': sizeGroups.map((e) => e.toMap()).toList(),
    };
  }

  ProductConfigModel copyWith({
    List<ColorModel>? colors,
    List<SizeGroupModel>? sizeGroups,
  }) {
    return ProductConfigModel(
      colors: colors ?? this.colors,
      sizeGroups: sizeGroups ?? this.sizeGroups,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final bool isVisible;
  final List<String> productCategories;
  final List<String> sizeGroups;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.isVisible,
    this.productCategories = const [],
    this.sizeGroups = const [],
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    final rawProdCats = map['product_categories'] as List<dynamic>?;
    final rawSizeGroups = map['size_groups'] as List<dynamic>?;
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isVisible: map['is_visible'] ?? true,
      productCategories: rawProdCats != null
          ? rawProdCats.map((e) => e.toString()).toList()
          : [],
      sizeGroups: rawSizeGroups != null
          ? rawSizeGroups.map((e) => e.toString()).toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_visible': isVisible,
      'product_categories': productCategories,
      'size_groups': sizeGroups,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    bool? isVisible,
    List<String>? productCategories,
    List<String>? sizeGroups,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isVisible: isVisible ?? this.isVisible,
      productCategories: productCategories ?? this.productCategories,
      sizeGroups: sizeGroups ?? this.sizeGroups,
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
              .map(
                (e) =>
                    CategoryModel.fromMap(Map<String, dynamic>.from(e as Map)),
              )
              .toList()
        : [];

    final List<CategoryModel> bCats = rawBusinessCats != null
        ? rawBusinessCats
              .map(
                (e) =>
                    CategoryModel.fromMap(Map<String, dynamic>.from(e as Map)),
              )
              .toList()
        : [];

    return AdminSettingsModel(
      commissionPercentage:
          (map['commission_percentage'] as num?)?.toDouble() ?? 2.0,
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
