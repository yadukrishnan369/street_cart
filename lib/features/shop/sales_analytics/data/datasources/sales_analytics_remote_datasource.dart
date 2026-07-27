import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/sales_analytics/data/datasources/i_sales_analytics_remote_datasource.dart';
export 'package:street_cart/features/shop/sales_analytics/data/datasources/i_sales_analytics_remote_datasource.dart';

class SalesAnalyticsRemoteDataSourceImpl
    implements ISalesAnalyticsRemoteDataSource {
  final FirebaseFirestore _firestore;

  SalesAnalyticsRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  // Get Shop Orders
  @override
  Future<List<OrderModel>> getShopOrders(String shopId) async {
    final snapshot = await _firestore.collection('orders').get();
    final allOrders = snapshot.docs.map((doc) {
      return OrderModel.fromMap(doc.data(), doc.id);
    }).toList();

    final shopOrders = allOrders.where((order) {
      return order.items.any((item) => item.shopId == shopId);
    }).toList();

    shopOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return shopOrders;
  }

  // Get Shop Products
  @override
  Future<List<ProductModel>> getShopProducts(String shopId) async {
    final snapshot = await _firestore
        .collection('products')
        .where('shop_id', isEqualTo: shopId)
        .get();
    return snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data(), doc.id);
    }).toList();
  }
}
