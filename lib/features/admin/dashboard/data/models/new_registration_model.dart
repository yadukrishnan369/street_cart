import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewRegistrationModel extends Equatable {
  final String id;
  final String shopName;
  final String address;
  final String timeAgo;
  final DateTime? createdAt;

  const NewRegistrationModel({
    required this.id,
    required this.shopName,
    required this.address,
    required this.timeAgo,
    this.createdAt,
  });

  factory NewRegistrationModel.fromMap(Map<String, dynamic> map, String id) {
    final timestamp = map['created_at'] as Timestamp?;
    return NewRegistrationModel(
      id: id,
      shopName: map['shop_name'] ?? map['shopName'] ?? '',
      address: map['address'] ?? '',
      timeAgo: map['timeAgo'] ?? map['time_ago'] ?? '',
      createdAt: timestamp?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shop_name': shopName,
      'address': address,
      'time_ago': timeAgo,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  @override
  List<Object?> get props => [id, shopName, address, timeAgo, createdAt];
}
