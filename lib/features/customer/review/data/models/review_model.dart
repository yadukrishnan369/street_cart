import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final String customerImage;
  final String shopId;
  final String productId;
  final int rating;
  final String reviewText;
  final List<String> images;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerImage,
    required this.shopId,
    required this.productId,
    required this.rating,
    required this.reviewText,
    required this.images,
    required this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReviewModel(
      id: docId,
      customerId: map['customer_id'] ?? '',
      customerName: map['customer_name'] ?? '',
      customerImage: map['customer_image'] ?? '',
      shopId: map['shop_id'] ?? '',
      productId: map['product_id'] ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      reviewText: map['review_text'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      createdAt: (map['created_at'] is Timestamp)
          ? (map['created_at'] as Timestamp).toDate()
          : DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_image': customerImage,
      'shop_id': shopId,
      'product_id': productId,
      'rating': rating,
      'review_text': reviewText,
      'images': images,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  @override
  List<Object?> get props => [
    id,
    customerId,
    customerName,
    customerImage,
    shopId,
    productId,
    rating,
    reviewText,
    images,
    createdAt,
  ];
}
