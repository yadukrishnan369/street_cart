import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'admin_dashboard_remote_datasource.dart';
import 'package:street_cart/features/admin/dashboard/data/models/dashboard_stats_model.dart';
import 'package:street_cart/features/admin/dashboard/data/models/new_registration_model.dart';
import 'package:street_cart/features/admin/dashboard/data/models/recent_order_model.dart';

class AdminDashboardRemoteDataSourceImpl
    implements IAdminDashboardRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdminDashboardRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      int shopsCount = 0;
      int customersCount = 0;
      const double revenue = 582000.0;

      final shopsSnap = await _firestore
          .collection('shops')
          .where('is_approved', isEqualTo: true)
          .get();
      shopsCount = shopsSnap.docs.length;

      final customersSnap = await _firestore.collection('customers').get();
      customersCount = customersSnap.docs
          .where((doc) => doc.data()['is_blocked'] != true)
          .length;

      List<NewRegistrationModel> newRegistrations = [];
      final pendingQuery = await _firestore
          .collection('shops')
          .where('is_approved', isEqualTo: false)
          .get();
      if (pendingQuery.docs.isNotEmpty) {
        newRegistrations = pendingQuery.docs
            .where((doc) => doc.data()['is_rejected'] != true)
            .map((doc) {
              final data = doc.data();
              final shopName = data['shop_name'] ?? 'Unknown Shop';
              final category = data['category'] ?? 'New Merchant';
              final timestamp = data['created_at'] as Timestamp?;
              final timeAgoStr = timestamp != null
                  ? _calculateTimeAgo(timestamp.toDate())
                  : 'Recently';
              return NewRegistrationModel(
                id: doc.id,
                shopName: shopName,
                address: '$category • $timeAgoStr',
                timeAgo: timeAgoStr,
                createdAt: timestamp?.toDate(),
                isReRegistered: data['is_reregistered'] ?? false,
              );
            })
            .toList();

        // Sort - latest registrations first
        newRegistrations.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return b.createdAt!.compareTo(a.createdAt!);
        });

        // Limit to only last 3 registrations
        if (newRegistrations.length > 3) {
          newRegistrations = newRegistrations.sublist(0, 3);
        }
      }

      // Fetch total orders count and recent orders
      final ordersSnap = await _firestore.collection('orders').get();
      final totalOrdersCount = ordersSnap.docs.length;

      // raw order details sorted by created_at descending
      final allOrders = ordersSnap.docs.map((doc) {
        final data = doc.data();
        DateTime parsedDate = DateTime.now();
        if (data['created_at'] != null) {
          if (data['created_at'] is Timestamp) {
            parsedDate = (data['created_at'] as Timestamp).toDate();
          } else if (data['created_at'] is String) {
            parsedDate =
                DateTime.tryParse(data['created_at']) ?? DateTime.now();
          }
        }
        return {
          'id': doc.id,
          'customer_id': data['customer_id'] ?? '',
          'amount': (data['total_amount'] as num?)?.toDouble() ?? 0.0,
          'status': data['status'] ?? 'pending',
          'createdAt': parsedDate,
          'deliveryAddress': data['delivery_address'] ?? {},
        };
      }).toList();

      // Sort by newest first
      allOrders.sort(
        (a, b) =>
            (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime),
      );

      // Limit to first 4 orders
      final recentOrdersRaw = allOrders.take(4).toList();
      final List<RecentOrderModel> recentOrders = [];

      for (final rawOrder in recentOrdersRaw) {
        final customerId = rawOrder['customer_id'] as String;
        String customerAccountName = 'Unknown Customer';

        if (customerId.isNotEmpty) {
          final custDoc = await _firestore
              .collection('customers')
              .doc(customerId)
              .get();
          if (custDoc.exists && custDoc.data() != null) {
            customerAccountName =
                custDoc.data()?['full_name'] ??
                custDoc.data()?['name'] ??
                'Unknown Customer';
          }
        }

        final createdDate = rawOrder['createdAt'] as DateTime;
        final timeAgoStr = _calculateTimeAgo(createdDate);

        recentOrders.add(
          RecentOrderModel(
            id: rawOrder['id'] as String,
            customerName: customerAccountName,
            amount: rawOrder['amount'] as double,
            status: rawOrder['status'] as String,
            timeAgo: timeAgoStr,
          ),
        );
      }

      return DashboardStatsModel(
        totalShops: shopsCount,
        totalCustomers: customersCount,
        totalOrders: totalOrdersCount,
        totalRevenue: revenue,
        newRegistrations: newRegistrations,
        recentOrders: recentOrders,
      );
    } catch (e) {
      throw Exception('Failed to fetch dashboard stats: $e');
    }
  }

  String _calculateTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()}m ago';
    } else if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Future<List<NewRegistrationModel>> getPendingRegistrations({
    required int page,
    required int limit,
  }) async {
    try {
      final query = await _firestore
          .collection('shops')
          .where('is_approved', isEqualTo: false)
          .get();

      final filteredDocs = query.docs.where(
        (doc) => doc.data()['is_rejected'] != true,
      );

      final sortedDocs = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
        filteredDocs,
      );
      sortedDocs.sort((a, b) {
        final aTime = a.data()['created_at'] as Timestamp?;
        final bTime = b.data()['created_at'] as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      final allPending = sortedDocs.map((doc) {
        final data = doc.data();
        final shopName = data['shop_name'] ?? 'Unknown Shop';
        final category = data['category'] ?? 'New Merchant';
        final timestamp = data['created_at'] as Timestamp?;
        final timeAgoStr = timestamp != null
            ? _calculateTimeAgo(timestamp.toDate())
            : 'Recently';
        return NewRegistrationModel(
          id: doc.id,
          shopName: shopName,
          address: '$category • $timeAgoStr',
          timeAgo: timeAgoStr,
          createdAt: timestamp?.toDate(),
          isReRegistered: data['is_reregistered'] ?? false,
        );
      }).toList();

      final startIndex = (page - 1) * limit;
      if (startIndex >= allPending.length) {
        return [];
      }
      final endIndex = startIndex + limit > allPending.length
          ? allPending.length
          : startIndex + limit;
      return allPending.sublist(startIndex, endIndex);
    } catch (e) {
      throw Exception('Failed to get pending registrations: $e');
    }
  }

  @override
  Future<int> getPendingRegistrationsCount() async {
    try {
      final query = await _firestore
          .collection('shops')
          .where('is_approved', isEqualTo: false)
          .get();
      final filteredDocs = query.docs.where(
        (doc) => doc.data()['is_rejected'] != true,
      );
      return filteredDocs.length;
    } catch (e) {
      throw Exception('Failed to get pending registrations count: $e');
    }
  }

  @override
  Future<ShopProfileModel> getShopDetails(String shopId) async {
    try {
      final doc = await _firestore.collection('shops').doc(shopId).get();
      if (!doc.exists) {
        throw Exception('Shop not found');
      }
      return ShopProfileModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get shop details: $e');
    }
  }

  @override
  Future<void> approveShop(String shopId) async {
    try {
      await _firestore.collection('shops').doc(shopId).update({
        'is_approved': true,
      });
    } catch (e) {
      throw Exception('Failed to approve shop: $e');
    }
  }

  @override
  Future<void> rejectShop(String shopId, String rejectionReason) async {
    try {
      await _firestore.collection('shops').doc(shopId).update({
        'is_approved': false,
        'is_rejected': true,
        'rejection_reason': rejectionReason,
        'is_reregistered': false,
      });
    } catch (e) {
      throw Exception('Failed to reject shop: $e');
    }
  }
}
