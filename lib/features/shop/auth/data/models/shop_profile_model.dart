import 'package:cloud_firestore/cloud_firestore.dart';

class ShopProfileModel {
  final String uid;
  final String ownerName;
  final String shopName;
  final String email;
  final String category;
  final String description;
  final String gstNumber;
  final String businessLicenseUrl;
  final String ownerIdUrl;
  final bool isApproved;
  final bool isSuspended;
  final String role;
  final DateTime? createdAt;
  final bool isProfileCompleted;
  final String profileImageUrl;
  final String phone;
  final double deliveryRadius;
  final String fullAddress;
  final String landmark;
  final String city;
  final String pincode;
  final String district;
  final String state;
  final List<String> paymentMethods;
  final double? latitude;
  final double? longitude;
  final bool isRejected;
  final String rejectionReason;
  final bool isReRegistered;

  ShopProfileModel({
    required this.uid,
    required this.ownerName,
    required this.shopName,
    required this.email,
    required this.category,
    required this.description,
    required this.gstNumber,
    required this.businessLicenseUrl,
    required this.ownerIdUrl,
    required this.isApproved,
    this.isSuspended = false,
    required this.role,
    this.createdAt,
    required this.isProfileCompleted,
    required this.profileImageUrl,
    required this.phone,
    required this.deliveryRadius,
    required this.fullAddress,
    required this.landmark,
    required this.city,
    required this.pincode,
    required this.district,
    required this.state,
    required this.paymentMethods,
    this.latitude,
    this.longitude,
    this.isRejected = false,
    this.rejectionReason = '',
    this.isReRegistered = false,
  });

  factory ShopProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return ShopProfileModel(
      uid: id,
      ownerName: map['owner_name'] ?? '',
      shopName: map['shop_name'] ?? '',
      email: map['email'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      gstNumber: map['gst_number'] ?? '',
      businessLicenseUrl: map['business_license_url'] ?? '',
      ownerIdUrl: map['owner_id_url'] ?? '',
      isApproved: map['is_approved'] ?? false,
      isSuspended: map['is_suspended'] ?? false,
      role: map['role'] ?? 'shop',
      createdAt: (map['created_at'] as Timestamp?)?.toDate(),
      isProfileCompleted: map['is_profile_completed'] ?? false,
      profileImageUrl: map['profile_image_url'] ?? '',
      phone: map['phone'] ?? '',
      deliveryRadius: (map['delivery_radius'] as num?)?.toDouble() ?? 5.0,
      fullAddress: map['full_address'] ?? '',
      landmark: map['landmark'] ?? '',
      city: map['city'] ?? '',
      pincode: map['pincode'] ?? '',
      district: map['district'] ?? '',
      state: map['state'] ?? '',
      paymentMethods: List<String>.from(map['payment_methods'] ?? []),
      latitude: map['location'] != null
          ? (map['location']['latitude'] as num?)?.toDouble()
          : null,
      longitude: map['location'] != null
          ? (map['location']['longitude'] as num?)?.toDouble()
          : null,
      isRejected: map['is_rejected'] ?? false,
      rejectionReason: map['rejection_reason'] ?? '',
      isReRegistered: map['is_reregistered'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'owner_name': ownerName,
      'shop_name': shopName,
      'email': email,
      'category': category,
      'description': description,
      'gst_number': gstNumber,
      'business_license_url': businessLicenseUrl,
      'owner_id_url': ownerIdUrl,
      'is_approved': isApproved,
      'is_suspended': isSuspended,
      'role': role,
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'is_profile_completed': isProfileCompleted,
      'profile_image_url': profileImageUrl,
      'phone': phone,
      'delivery_radius': deliveryRadius,
      'full_address': fullAddress,
      'landmark': landmark,
      'city': city,
      'pincode': pincode,
      'district': district,
      'state': state,
      'payment_methods': paymentMethods,
      if (latitude != null && longitude != null)
        'location': {'latitude': latitude, 'longitude': longitude},
      'is_rejected': isRejected,
      'rejection_reason': rejectionReason,
      'is_reregistered': isReRegistered,
    };
  }

  ShopProfileModel copyWith({
    String? ownerName,
    String? shopName,
    String? email,
    String? category,
    String? description,
    String? gstNumber,
    String? businessLicenseUrl,
    String? ownerIdUrl,
    bool? isApproved,
    bool? isSuspended,
    String? role,
    DateTime? createdAt,
    bool? isProfileCompleted,
    String? profileImageUrl,
    String? phone,
    double? deliveryRadius,
    String? fullAddress,
    String? landmark,
    String? city,
    String? pincode,
    String? district,
    String? state,
    List<String>? paymentMethods,
    double? latitude,
    double? longitude,
    bool? isRejected,
    String? rejectionReason,
    bool? isReRegistered,
  }) {
    return ShopProfileModel(
      uid: uid,
      ownerName: ownerName ?? this.ownerName,
      shopName: shopName ?? this.shopName,
      email: email ?? this.email,
      category: category ?? this.category,
      description: description ?? this.description,
      gstNumber: gstNumber ?? this.gstNumber,
      businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
      ownerIdUrl: ownerIdUrl ?? this.ownerIdUrl,
      isApproved: isApproved ?? this.isApproved,
      isSuspended: isSuspended ?? this.isSuspended,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phone: phone ?? this.phone,
      deliveryRadius: deliveryRadius ?? this.deliveryRadius,
      fullAddress: fullAddress ?? this.fullAddress,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      district: district ?? this.district,
      state: state ?? this.state,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isRejected: isRejected ?? this.isRejected,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      isReRegistered: isReRegistered ?? this.isReRegistered,
    );
  }
}
