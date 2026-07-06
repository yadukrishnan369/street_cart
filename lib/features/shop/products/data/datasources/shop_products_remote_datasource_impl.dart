import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/core/services/cloudinary_service.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_variant_model.dart';
import 'package:street_cart/features/shop/products/data/models/variant_image_draft.dart';
import 'shop_products_remote_datasource.dart';

class ShopProductsRemoteDataSourceImpl
    implements IShopProductsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinaryService;

  ShopProductsRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required CloudinaryService cloudinaryService,
  }) : _firestore = firestore,
       _cloudinaryService = cloudinaryService;

  // Get Existing Products
  @override
  Stream<List<ProductModel>> getShopProducts(String shopId) {
    return _firestore
        .collection('products')
        .where('shop_id', isEqualTo: shopId)
        .snapshots()
        .map((snapshot) {
          final products = snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
              .toList();
          products.sort((a, b) {
            if (a.createdAt == null && b.createdAt == null) return 0;
            if (a.createdAt == null) return -1;
            if (b.createdAt == null) return 1;
            return b.createdAt!.compareTo(a.createdAt!);
          });
          return products;
        });
  }

  // Add new Products
  @override
  Future<void> addProduct(
    ProductModel product,
    List<VariantImageDraft> variantDrafts,
  ) async {
    try {
      final variants = await _uploadVariants(variantDrafts);
      final finalProduct = product.copyWith(variants: variants);
      await _firestore.collection('products').add(finalProduct.toMap());
    } catch (e) {
      throw ServerException('Failed to add product: $e');
    }
  }

  @override
  Future<void> updateProduct(
    ProductModel product,
    List<VariantImageDraft> variantDrafts,
  ) async {
    try {
      final variants = await _uploadVariants(variantDrafts);
      final finalProduct = product.copyWith(variants: variants);
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(finalProduct.toMap());
    } catch (e) {
      throw ServerException('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String shopId, String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw ServerException('Failed to delete product: $e');
    }
  }

  // Get Product Config filter categories and size groups based on shop's category
  @override
  Future<Map<String, dynamic>> getShopProductConfig(String shopId) async {
    try {
      //  Get the shop's profile to retrieve its registered business category
      final shopDoc = await _firestore.collection('shops').doc(shopId).get();
      final String shopCategory = (shopDoc.exists && shopDoc.data() != null)
          ? (shopDoc.data()!['category']?.toString() ?? '')
          : '';

      // Load configurations
      final catDoc = await _firestore.collection('config').doc('categories').get();
      final configDoc = await _firestore.collection('config').doc('product_config').get();

      List<String> allowedProductCats = [];
      List<String> allowedSizeGroups = [];

      if (catDoc.exists && catDoc.data() != null) {
        final rawBusinessCats = catDoc.data()!['business_categories'] as List<dynamic>?;
        if (rawBusinessCats != null) {
          for (final raw in rawBusinessCats) {
            final map = Map<String, dynamic>.from(raw as Map);
            final name = map['name']?.toString() ?? '';
            // If it matches the shop's business category, extract its children & size groups
            if (name.toLowerCase() == shopCategory.toLowerCase()) {
              final rawProds = map['product_categories'] as List<dynamic>?;
              final rawSizes = map['size_groups'] as List<dynamic>?;
              if (rawProds != null) {
                allowedProductCats = rawProds.map((e) => e.toString()).toList();
              }
              if (rawSizes != null) {
                allowedSizeGroups = rawSizes.map((e) => e.toString()).toList();
              }
              break;
            }
          }
        }
      }

      final Map<String, dynamic> result = {};
      if (configDoc.exists && configDoc.data() != null) {
        result.addAll(configDoc.data()!);
      }

      // Filter available size groups based on matching ones
      if (result['size_groups'] != null) {
        final List<dynamic> filteredGroups = [];
        for (final group in result['size_groups'] as List<dynamic>) {
          final groupMap = Map<String, dynamic>.from(group as Map);
          final groupName = groupMap['name']?.toString() ?? '';
          if (allowedSizeGroups.contains(groupName)) {
            filteredGroups.add(groupMap);
          }
        }
        result['size_groups'] = filteredGroups;
      }

      // Add dynamic allowed categories to map so it can be accessed in add_edit_product_page
      result['allowed_categories'] = allowedProductCats;

      return result;
    } catch (e) {
      throw ServerException('Failed to fetch product config from admin: $e');
    }
  }

  @override
  Future<void> saveShopProductConfig(
    String shopId,
    Map<String, dynamic> config,
  ) async {
    try {
      await _firestore
          .collection('shops')
          .doc(shopId)
          .collection('config')
          .doc('products_config')
          .set(config, SetOptions(merge: true));
    } catch (e) {
      throw ServerException('Failed to save shop product config: $e');
    }
  }

  Future<List<ProductVariantModel>> _uploadVariants(
    List<VariantImageDraft> drafts,
  ) async {
    final resolved = <ProductVariantModel>[];
    for (final draft in drafts) {
      final urls = <String>[];
      for (final item in draft.imagesOrFiles) {
        if (item is String) {
          urls.add(item);
        } else {
          final url = await _cloudinaryService.uploadImage(item);
          if (url != null) urls.add(url);
        }
      }
      resolved.add(
        ProductVariantModel(
          colorName: draft.colorName,
          images: urls,
          sizes: draft.sizes,
        ),
      );
    }
    return resolved;
  }
}
