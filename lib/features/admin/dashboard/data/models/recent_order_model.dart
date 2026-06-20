import 'package:equatable/equatable.dart';

class RecentOrderModel extends Equatable {
  final String id;
  final String customerName;
  final double amount;
  final String status;
  final String timeAgo;

  const RecentOrderModel({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.timeAgo,
  });

  factory RecentOrderModel.fromMap(Map<String, dynamic> map, String id) {
    return RecentOrderModel(
      id: id,
      customerName: map['customer_name'] ?? map['customerName'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
      timeAgo: map['timeAgo'] ?? map['time_ago'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customer_name': customerName,
      'amount': amount,
      'status': status,
      'time_ago': timeAgo,
    };
  }

  @override
  List<Object?> get props => [id, customerName, amount, status, timeAgo];
}
