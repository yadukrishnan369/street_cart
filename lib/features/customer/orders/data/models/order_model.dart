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
  final String? returnStatus;
  final String? returnReason;
  final String? returnDetails;
  final String? returnedItemId;
  final DateTime? returnedAt;
  final DateTime? returnConfirmedAt;
  final DateTime? returnPickedAt;
  final String? refundStatus;
  final DateTime? cancelledAt;
  final DateTime? refundedAt;
  final double? refundAmount;

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
    this.returnStatus,
    this.returnReason,
    this.returnDetails,
    this.returnedItemId,
    this.returnedAt,
    this.returnConfirmedAt,
    this.returnPickedAt,
    this.refundStatus,
    this.cancelledAt,
    this.refundedAt,
    this.refundAmount,
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
      returnStatus: map['return_status'],
      returnReason: map['return_reason'],
      returnDetails: map['return_details'],
      returnedItemId: map['returned_item_id'],
      returnedAt: _parseTimestamp(map['returned_at']),
      returnConfirmedAt: _parseTimestamp(map['return_confirmed_at']),
      returnPickedAt: _parseTimestamp(map['return_picked_at']),
      refundStatus: map['refund_status'],
      cancelledAt: _parseTimestamp(map['cancelled_at']),
      refundedAt: _parseTimestamp(map['refunded_at']),
      refundAmount: (map['refund_amount'] as num?)?.toDouble(),
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
      if (returnStatus != null) 'return_status': returnStatus,
      if (returnReason != null) 'return_reason': returnReason,
      if (returnDetails != null) 'return_details': returnDetails,
      if (returnedItemId != null) 'returned_item_id': returnedItemId,
      if (returnedAt != null) 'returned_at': Timestamp.fromDate(returnedAt!),
      if (returnConfirmedAt != null)
        'return_confirmed_at': Timestamp.fromDate(returnConfirmedAt!),
      if (returnPickedAt != null)
        'return_picked_at': Timestamp.fromDate(returnPickedAt!),
      if (refundStatus != null) 'refund_status': refundStatus,
      if (cancelledAt != null) 'cancelled_at': Timestamp.fromDate(cancelledAt!),
      if (refundedAt != null) 'refunded_at': Timestamp.fromDate(refundedAt!),
      if (refundAmount != null) 'refund_amount': refundAmount,
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
    String? returnStatus,
    String? returnReason,
    String? returnDetails,
    String? returnedItemId,
    DateTime? returnedAt,
    DateTime? returnConfirmedAt,
    DateTime? returnPickedAt,
    String? refundStatus,
    DateTime? cancelledAt,
    DateTime? refundedAt,
    double? refundAmount,
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
      returnStatus: returnStatus ?? this.returnStatus,
      returnReason: returnReason ?? this.returnReason,
      returnDetails: returnDetails ?? this.returnDetails,
      returnedItemId: returnedItemId ?? this.returnedItemId,
      returnedAt: returnedAt ?? this.returnedAt,
      returnConfirmedAt: returnConfirmedAt ?? this.returnConfirmedAt,
      returnPickedAt: returnPickedAt ?? this.returnPickedAt,
      refundStatus: refundStatus ?? this.refundStatus,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      refundedAt: refundedAt ?? this.refundedAt,
      refundAmount: refundAmount ?? this.refundAmount,
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
  final String? returnStatus;
  final String? returnReason;
  final String? returnDetails;
  final DateTime? returnedAt;
  final DateTime? returnConfirmedAt;
  final DateTime? returnPickedAt;
  final String? status;
  final String? refundStatus;

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
    this.returnStatus,
    this.returnReason,
    this.returnDetails,
    this.returnedAt,
    this.returnConfirmedAt,
    this.returnPickedAt,
    this.status,
    this.refundStatus,
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
      returnStatus: map['return_status'],
      returnReason: map['return_reason'],
      returnDetails: map['return_details'],
      returnedAt: map['returned_at'] != null
          ? (map['returned_at'] is Timestamp
                ? (map['returned_at'] as Timestamp).toDate()
                : DateTime.parse(map['returned_at'].toString()))
          : null,
      returnConfirmedAt: map['return_confirmed_at'] != null
          ? (map['return_confirmed_at'] is Timestamp
                ? (map['return_confirmed_at'] as Timestamp).toDate()
                : DateTime.parse(map['return_confirmed_at'].toString()))
          : null,
      returnPickedAt: map['return_picked_at'] != null
          ? (map['return_picked_at'] is Timestamp
                ? (map['return_picked_at'] as Timestamp).toDate()
                : DateTime.parse(map['return_picked_at'].toString()))
          : null,
      status: map['status'],
      refundStatus: map['refund_status'],
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
      'return_status': returnStatus,
      'return_reason': returnReason,
      'return_details': returnDetails,
      'returned_at': returnedAt,
      'return_confirmed_at': returnConfirmedAt,
      'return_picked_at': returnPickedAt,
      if (status != null) 'status': status,
      if (refundStatus != null) 'refund_status': refundStatus,
    };
  }
}
