import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'i_admin_revenue_remote_datasource.dart';

class AdminRevenueRemoteDataSourceImpl
    implements IAdminRevenueRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdminRevenueRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;
  // Get All Orders
  @override
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final snap = await _firestore.collection('orders').get();
      return snap.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch orders: $e');
    }
  }

  // Get All Shops
  @override
  Future<List<ShopProfileModel>> getAllShops() async {
    try {
      final snap = await _firestore.collection('shops').get();
      return snap.docs
          .map((doc) => ShopProfileModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch shops: $e');
    }
  }

  // Get All Products
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snap = await _firestore.collection('products').get();
      return snap.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch products: $e');
    }
  }

  // Get All Customers
  @override
  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      final snap = await _firestore.collection('customers').get();
      return snap.docs
          .map((doc) => CustomerModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch customers: $e');
    }
  }
}
