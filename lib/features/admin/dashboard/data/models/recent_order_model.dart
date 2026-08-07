import 'package:equatable/equatable.dart';

class RecentOrderModel extends Equatable {
  final String id;
  final String customerName;
  final double amount;
  final String status;
  final String timeAgo;
  final List<RecentOrderItemModel> items;

  const RecentOrderModel({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.timeAgo,
    this.items = const [],
  });

  factory RecentOrderModel.fromMap(Map<String, dynamic> map, String id) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems
        .map(
          (item) => RecentOrderItemModel.fromMap(item as Map<String, dynamic>),
        )
        .toList();

    return RecentOrderModel(
      id: id,
      customerName: map['customer_name'] ?? map['customerName'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
      timeAgo: map['timeAgo'] ?? map['time_ago'] ?? '',
      items: itemsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customer_name': customerName,
      'amount': amount,
      'status': status,
      'time_ago': timeAgo,
      'items': items.map((i) => i.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, customerName, amount, status, timeAgo, items];
}

class RecentOrderItemModel extends Equatable {
  final String status;
  final String? returnStatus;

  const RecentOrderItemModel({required this.status, this.returnStatus});

  factory RecentOrderItemModel.fromMap(Map<String, dynamic> map) {
    return RecentOrderItemModel(
      status: map['status'] ?? '',
      returnStatus: map['return_status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'status': status, 'return_status': returnStatus};
  }

  @override
  List<Object?> get props => [status, returnStatus];
}
