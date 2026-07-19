part of 'shop_auth_bloc.dart';

// Base event class
abstract class ShopAuthEvent extends Equatable {
  const ShopAuthEvent();
  @override
  List<Object?> get props => [];
}

//  shop login start event
class ShopLoginStarted extends ShopAuthEvent {
  final String email;
  final String password;
  const ShopLoginStarted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// shop signup start event
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

  @override
  List<Object?> get props => [email, password, ownerName, shopName];
}

// shop profile setup event
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

  @override
  List<Object?> get props => [
    category,
    description,
    gstNumber,
    businessLicenseFile,
    ownerIdFile,
  ];
}

// start subscription to listen to shop profile status changes
class ShopStatusSubscriptionRequested extends ShopAuthEvent {}

// log out shop user
class ShopLogoutRequested extends ShopAuthEvent {}

// send an email verification link
class ShopSendEmailVerificationEvent extends ShopAuthEvent {}

// check verification status of email
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

// cancel the verification process
class ShopVerificationCancelledEvent extends ShopAuthEvent {}

// request a password reset email
class ShopPasswordResetRequested extends ShopAuthEvent {
  final String email;
  const ShopPasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}

// Toggles visibility of password fields
class ShopTogglePasswordVisibility extends ShopAuthEvent {}

// Toggles visibility of confirm password field
class ShopToggleConfirmPasswordVisibility extends ShopAuthEvent {}

class ShopSetVerificationSheetShowing extends ShopAuthEvent {
  final bool showing;
  const ShopSetVerificationSheetShowing(this.showing);

  @override
  List<Object?> get props => [showing];
}

// Selects business category
class ShopSelectCategory extends ShopAuthEvent {
  final String category;
  const ShopSelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}

// Selects business license
class ShopSelectBusinessLicense extends ShopAuthEvent {
  final File file;
  const ShopSelectBusinessLicense(this.file);

  @override
  List<Object?> get props => [file];
}

// Selects owner ID
class ShopSelectOwnerId extends ShopAuthEvent {
  final File file;
  const ShopSelectOwnerId(this.file);

  @override
  List<Object?> get props => [file];
}

// Mark setup screen navigation completed
class ShopMarkProfileSetupNavigated extends ShopAuthEvent {}

// Loads business categories
class ShopLoadCategories extends ShopAuthEvent {}

// Starts countdown timer for verification
class ShopStartVerificationTimer extends ShopAuthEvent {
  final String ownerName;
  final String shopName;
  final String email;

  const ShopStartVerificationTimer({
    required this.ownerName,
    required this.shopName,
    required this.email,
  });

  @override
  List<Object?> get props => [ownerName, shopName, email];
}

// event for the verification timer countdown
class ShopVerificationTimerTicked extends ShopAuthEvent {
  final int secondsRemaining;
  const ShopVerificationTimerTicked(this.secondsRemaining);

  @override
  List<Object?> get props => [secondsRemaining];
}
