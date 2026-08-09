import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String profileImageUrl;
  final bool isBlocked;
  final int totalOrders;
  final DateTime? createdAt;
  final bool isDeleted;

  CustomerModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.isBlocked,
    required this.totalOrders,
    this.createdAt,
    this.isDeleted = false,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime? createdTime;
    final timestamp = map['created_at'] ?? map['createdAt'];
    if (timestamp is Timestamp) {
      createdTime = timestamp.toDate();
    } else if (timestamp is String) {
      createdTime = DateTime.tryParse(timestamp);
    }
    return CustomerModel(
      uid: docId,
      fullName: map['full_name'] ?? map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profileImageUrl: map['profile_image_url'] ?? map['profile_url'] ?? '',
      isBlocked: map['is_blocked'] ?? false,
      totalOrders: map['total_orders'] ?? 0,
      createdAt: createdTime,
      isDeleted: map['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'profile_image_url': profileImageUrl,
      'is_blocked': isBlocked,
      'total_orders': totalOrders,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'is_deleted': isDeleted,
    };
  }

  CustomerModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phone,
    String? profileImageUrl,
    bool? isBlocked,
    int? totalOrders,
    DateTime? createdAt,
    bool? isDeleted,
  }) {
    return CustomerModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isBlocked: isBlocked ?? this.isBlocked,
      totalOrders: totalOrders ?? this.totalOrders,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
