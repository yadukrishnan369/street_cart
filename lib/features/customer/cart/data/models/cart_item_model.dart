import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final String? selectedSize;
  final String? selectedColor;
  final double price;
  final int quantity;
  final String shopId;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    this.selectedSize,
    this.selectedColor,
    required this.price,
    required this.quantity,
    required this.shopId,
    required this.addedAt,
  });

  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    String? selectedSize,
    String? selectedColor,
    double? price,
    int? quantity,
    String? shopId,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      shopId: shopId ?? this.shopId,
      addedAt: addedAt ?? this.addedAt,
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
      'added_at': Timestamp.fromDate(addedAt),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, String docId) {
    return CartItem(
      id: docId,
      productId: map['product_id'] ?? '',
      productName: map['product_name'] ?? '',
      productImage: map['product_image'] ?? '',
      selectedSize: map['selected_size'],
      selectedColor: map['selected_color'],
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      shopId: map['shop_id'] ?? '',
      addedAt: (map['added_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
