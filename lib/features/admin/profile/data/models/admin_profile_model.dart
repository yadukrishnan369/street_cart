class AdminProfileModel {
  final String uid;
  final String fullName;
  final String email;
  final String role;
  final DateTime? lastLogin;
  final DateTime? lastLogout;
  final int approvedShopsCount;

  AdminProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    this.lastLogin,
    this.lastLogout,
    required this.approvedShopsCount,
  });

  AdminProfileModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? role,
    DateTime? lastLogin,
    DateTime? lastLogout,
    int? approvedShopsCount,
  }) {
    return AdminProfileModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      lastLogin: lastLogin ?? this.lastLogin,
      lastLogout: lastLogout ?? this.lastLogout,
      approvedShopsCount: approvedShopsCount ?? this.approvedShopsCount,
    );
  }
}
