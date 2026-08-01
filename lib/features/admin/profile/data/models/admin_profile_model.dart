class AdminProfileModel {
  final String uid;
  final String fullName;
  final String email;
  final String role;
  final DateTime? lastLogin;
  final DateTime? lastLogout;
  final int approvedShopsCount;
  final int ordersTrackedCount;
  final int reviewsCount;

  AdminProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    this.lastLogin,
    this.lastLogout,
    required this.approvedShopsCount,
    required this.ordersTrackedCount,
    required this.reviewsCount,
  });

  AdminProfileModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? role,
    DateTime? lastLogin,
    DateTime? lastLogout,
    int? approvedShopsCount,
    int? ordersTrackedCount,
    int? reviewsCount,
  }) {
    return AdminProfileModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      lastLogin: lastLogin ?? this.lastLogin,
      lastLogout: lastLogout ?? this.lastLogout,
      approvedShopsCount: approvedShopsCount ?? this.approvedShopsCount,
      ordersTrackedCount: ordersTrackedCount ?? this.ordersTrackedCount,
      reviewsCount: reviewsCount ?? this.reviewsCount,
    );
  }
}
