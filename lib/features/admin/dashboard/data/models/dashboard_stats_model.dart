import 'package:equatable/equatable.dart';
import 'new_registration_model.dart';
import 'recent_order_model.dart';

class DashboardStatsModel extends Equatable {
  final int totalShops;
  final int totalCustomers;
  final int totalOrders;
  final double totalRevenue;
  final List<NewRegistrationModel> newRegistrations;
  final List<RecentOrderModel> recentOrders;

  const DashboardStatsModel({
    required this.totalShops,
    required this.totalCustomers,
    required this.totalOrders,
    required this.totalRevenue,
    required this.newRegistrations,
    required this.recentOrders,
  });

  factory DashboardStatsModel.fromMap(Map<String, dynamic> map) {
    final newRegList = (map['newRegistrations'] as List?)
            ?.map((e) => NewRegistrationModel.fromMap(
                Map<String, dynamic>.from(e), e['id'] ?? ''))
            .toList() ??
        [];
    final recOrdList = (map['recentOrders'] as List?)
            ?.map((e) => RecentOrderModel.fromMap(
                Map<String, dynamic>.from(e), e['id'] ?? ''))
            .toList() ??
        [];

    return DashboardStatsModel(
      totalShops: map['totalShops'] ?? 0,
      totalCustomers: map['totalCustomers'] ?? 0,
      totalOrders: map['totalOrders'] ?? 0,
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      newRegistrations: newRegList,
      recentOrders: recOrdList,
    );
  }

  @override
  List<Object?> get props => [
        totalShops,
        totalCustomers,
        totalOrders,
        totalRevenue,
        newRegistrations,
        recentOrders,
      ];
}
