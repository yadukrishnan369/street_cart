import 'package:cloud_firestore/cloud_firestore.dart';

class ShopNotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String type;
  final String? relatedId;

  ShopNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.type,
    this.relatedId,
  });

  factory ShopNotificationModel.fromMap(String id, Map<String, dynamic> map) {
    return ShopNotificationModel(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      isRead: map['is_read'] ?? false,
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: map['type'] ?? 'general',
      relatedId: map['related_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'is_read': isRead,
      'created_at': Timestamp.fromDate(createdAt),
      'type': type,
      'related_id': relatedId,
    };
  }
}
