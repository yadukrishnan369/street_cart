import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_remote_datasource.dart';

class ShopSplashRemoteDataSourceImpl implements IShopSplashRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  ShopSplashRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  // Check, User Logged in or not
  @override
  Future<bool> isUserLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  // Get Current User ID
  @override
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  // Get Shop Profile
  @override
  Future<ShopProfileModel?> getShopProfile(String userId) async {
    final doc = await _firestore.collection('shops').doc(userId).get();
    if (doc.exists && doc.data() != null) {
      return ShopProfileModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }
}
