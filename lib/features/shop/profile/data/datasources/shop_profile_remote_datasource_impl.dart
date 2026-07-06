import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/services/cloudinary_service.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'shop_profile_remote_datasource.dart';

class ShopProfileRemoteDataSourceImpl implements IShopProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinaryService;

  ShopProfileRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required CloudinaryService cloudinaryService,
  }) : _firestore = firestore,
       _cloudinaryService = cloudinaryService;

  @override
  Future<ShopProfileModel?> getShopProfile(String userId) async {
    try {
      final doc = await _firestore.collection('shops').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return ShopProfileModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw ServerException('Failed to fetch shop profile: $e');
    }
  }

  @override
  Future<void> updateShopProfile({
    required String userId,
    required ShopProfileModel data,
  }) async {
    try {
      await _firestore.collection('shops').doc(userId).update(data.toMap());
    } catch (e) {
      throw ServerException('Failed to update shop profile: $e');
    }
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final url = await _cloudinaryService.uploadImage(imageFile);
      if (url == null) {
        throw ServerException('Failed to upload image. URL returned null.');
      }
      return url;
    } catch (e) {
      throw ServerException('Failed to upload profile image: $e');
    }
  }

  @override
  Future<void> removeProfileImage(String userId) async {
    try {
      await _firestore.collection('shops').doc(userId).update({
        'profile_image_url': '',
      });
    } catch (e) {
      throw ServerException('Failed to remove profile image: $e');
    }
  }
}
