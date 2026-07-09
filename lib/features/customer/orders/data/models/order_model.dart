import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

class OrderModel {
  final String id;
  final String customerId;
  final List<OrderItemModel> items;
  final AddressModel deliveryAddress;
  final String paymentMethod;
  final String paymentStatus;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? processingAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.items,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.processingAt,
    this.shippedAt,
    this.deliveredAt,
  });

  // safely parse a Timestamp or String into DateTime
  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    // Parse created_at timestamp
    DateTime parsedDate = DateTime.now();
    if (map['created_at'] != null) {
      if (map['created_at'] is Timestamp) {
        parsedDate = (map['created_at'] as Timestamp).toDate();
      } else if (map['created_at'] is String) {
        parsedDate = DateTime.tryParse(map['created_at']) ?? DateTime.now();
      }
    }

    return OrderModel(
      id: docId,
      customerId: map['customer_id'] ?? '',
      items: (map['items'] as List<dynamic>? ?? [])
          .map(
            (item) => OrderItemModel.fromMap(Map<String, dynamic>.from(item)),
          )
          .toList(),
      deliveryAddress: AddressModel.fromMap(
        Map<String, dynamic>.from(map['delivery_address'] ?? {}),
        '',
      ),
      paymentMethod: map['payment_method'] ?? '',
      paymentStatus: map['payment_status'] ?? '',
      totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      createdAt: parsedDate,
      confirmedAt: _parseTimestamp(map['confirmed_at']),
      processingAt: _parseTimestamp(map['processing_at']),
      shippedAt: _parseTimestamp(map['shipped_at']),
      deliveredAt: _parseTimestamp(map['delivered_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'items': items.map((item) => item.toMap()).toList(),
      'delivery_address': deliveryAddress.toMap(),
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'total_amount': totalAmount,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
      if (confirmedAt != null) 'confirmed_at': Timestamp.fromDate(confirmedAt!),
      if (processingAt != null)
        'processing_at': Timestamp.fromDate(processingAt!),
      if (shippedAt != null) 'shipped_at': Timestamp.fromDate(shippedAt!),
      if (deliveredAt != null) 'delivered_at': Timestamp.fromDate(deliveredAt!),
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    List<OrderItemModel>? items,
    AddressModel? deliveryAddress,
    String? paymentMethod,
    String? paymentStatus,
    double? totalAmount,
    String? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? processingAt,
    DateTime? shippedAt,
    DateTime? deliveredAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      processingAt: processingAt ?? this.processingAt,
      shippedAt: shippedAt ?? this.shippedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }
}

class OrderItemModel {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final String? selectedSize;
  final String? selectedColor;
  final double price;
  final int quantity;
  final String shopId;
  final double adminCommission;
  final double vendorEarnings;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    this.selectedSize,
    this.selectedColor,
    required this.price,
    required this.quantity,
    required this.shopId,
    this.adminCommission = 0.0,
    this.vendorEarnings = 0.0,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      productName: map['product_name'] ?? '',
      productImage: map['product_image'] ?? '',
      selectedSize: map['selected_size'],
      selectedColor: map['selected_color'],
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      shopId: map['shop_id'] ?? '',
      adminCommission: (map['admin_commission'] as num?)?.toDouble() ?? 0.0,
      vendorEarnings: (map['vendor_earnings'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'selected_size': selectedSize,
      'selected_color': selectedColor,
      'price': price,
      'quantity': quantity,
      'shop_id': shopId,
      'admin_commission': adminCommission,
      'vendor_earnings': vendorEarnings,
    };
  }
}
