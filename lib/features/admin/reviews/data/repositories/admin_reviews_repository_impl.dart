import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/admin/reviews/data/datasources/admin_reviews_remote_datasource.dart';
import 'package:street_cart/features/admin/reviews/domain/repositories/i_admin_reviews_repository.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

class AdminReviewsRepositoryImpl implements IAdminReviewsRepository {
  final IAdminReviewsRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  AdminReviewsRepositoryImpl({
    required IAdminReviewsRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  Future<void> _checkConnection() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
  }

  @override
  Future<List<ReviewModel>> getReviews() async {
    await _checkConnection();
    return await _remoteDataSource.getAllReviews();
  }

  @override
  Future<void> toggleReviewVisibility(String id, bool isHidden) async {
    await _checkConnection();
    await _remoteDataSource.toggleReviewVisibility(id, isHidden);
  }

  @override
  Future<ReviewModel> getReviewDetails(String id) async {
    await _checkConnection();
    return await _remoteDataSource.getReviewById(id);
  }

  @override
  Future<void> deleteReview(String id) async {
    await _checkConnection();
    await _remoteDataSource.deleteReview(id);
  }

  @override
  Future<Map<String, String>> getProductNamesMap() async {
    await _checkConnection();
    final allProducts = await _remoteDataSource.getAllProducts();
    return {for (final p in allProducts) p.id: p.name};
  }

  @override
  Future<Map<String, String>> getShopNamesMap() async {
    await _checkConnection();
    final allShops = await _remoteDataSource.getAllShops();
    return {for (final s in allShops) s.uid: s.shopName};
  }
}
