part of 'shop_auth_bloc.dart';

abstract class ShopAuthEvent extends Equatable {
  const ShopAuthEvent();
  @override
  List<Object?> get props => [];
}

class ShopLoginStarted extends ShopAuthEvent {
  final String email;
  final String password;
  const ShopLoginStarted({required this.email, required this.password});
}

class ShopSignupStarted extends ShopAuthEvent {
  final String email;
  final String password;
  final String ownerName;
  final String shopName;
  const ShopSignupStarted({
    required this.email,
    required this.password,
    required this.ownerName,
    required this.shopName,
  });
}

class ShopSetupProfileStarted extends ShopAuthEvent {
  final String category;
  final String description;
  final String gstNumber;
  final File businessLicenseFile;
  final File ownerIdFile;
  const ShopSetupProfileStarted({
    required this.category,
    required this.description,
    required this.gstNumber,
    required this.businessLicenseFile,
    required this.ownerIdFile,
  });
}

class ShopStatusSubscriptionRequested extends ShopAuthEvent {}

class ShopLogoutRequested extends ShopAuthEvent {}

class ShopSendEmailVerificationEvent extends ShopAuthEvent {}

class ShopCheckEmailVerificationStatusEvent extends ShopAuthEvent {
  final String ownerName;
  final String shopName;
  final String email;

  const ShopCheckEmailVerificationStatusEvent({
    required this.ownerName,
    required this.shopName,
    required this.email,
  });

  @override
  List<Object?> get props => [ownerName, shopName, email];
}

class ShopVerificationCancelledEvent extends ShopAuthEvent {}

class ShopPasswordResetRequested extends ShopAuthEvent {
  final String email;
  const ShopPasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}
