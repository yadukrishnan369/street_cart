import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'cart_remote_datasource.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class CartRemoteDataSourceImpl implements ICartRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CartRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  CollectionReference _getCartCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    return _firestore.collection('customers').doc(user.uid).collection('cart');
  }

  // Fetch Cusotmer Cart Items
  @override
  Future<List<CartItem>> getCartItems() async {
    try {
      final snap = await _getCartCollection()
          .orderBy('added_at', descending: true)
          .get();

      return snap.docs
          .map(
            (doc) =>
                CartItem.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch cart items: $e');
    }
  }

  // Add to Cart
  @override
  Future<void> addToCart(CartItem item) async {
    try {
      final docRef = _getCartCollection().doc(item.id);
      await docRef.set(item.toMap());
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  // Remove Item From Cart
  @override
  Future<void> removeFromCart(String itemId) async {
    try {
      await _getCartCollection().doc(itemId).delete();
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  // Update the Item Quantity
  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      await _getCartCollection().doc(itemId).update({'quantity': quantity});
    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }

  // Remove All Items From Cart
  @override
  Future<void> clearCart() async {
    try {
      final snap = await _getCartCollection().get();
      if (snap.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (!doc.exists) {
        throw Exception('Product not found');
      }
      return ProductModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  @override
  Future<ShopProfileModel> getShopById(String shopId) async {
    try {
      final doc = await _firestore.collection('shops').doc(shopId).get();
      if (!doc.exists) {
        throw Exception('Shop not found');
      }
      return ShopProfileModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch shop: $e');
    }
  }
}
