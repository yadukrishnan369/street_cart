class ProfileModel {
  final String fullName;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String locationName;

  ProfileModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.locationName,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profileImageUrl: map['profile_image_url'] ?? '',
      locationName: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'profile_image_url': profileImageUrl,
    };
  }

  ProfileModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? locationName,
  }) {
    return ProfileModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      locationName: locationName ?? this.locationName,
    );
  }
}
