import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_shop_status.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/setup_shop_profile.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/shop_login.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/shop_signup.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/shop_logout.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/send_shop_password_reset_email.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/send_shop_email_verification.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/check_shop_email_verification.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/finalize_shop_sign_up.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/delete_shop_auth_account.dart';
part 'shop_auth_event.dart';
part 'shop_auth_state.dart';

// BLOC
class ShopAuthBloc extends Bloc<ShopAuthEvent, ShopAuthState> {
  final ShopLogin _login;
  final ShopSignup _signUp;
  final SetupShopProfile _setupProfile;
  final GetShopStatus _getStatus;
  final ShopLogout _logout;
  final SendShopPasswordResetEmail _sendPasswordResetEmail;
  final SendShopEmailVerification _sendEmailVerification;
  final CheckShopEmailVerification _checkEmailVerification;
  final FinalizeShopSignUp _finalizeSignUp;
  final DeleteShopAuthAccount _deleteAccount;

  ShopAuthBloc({
    required ShopLogin login,
    required ShopSignup signUp,
    required SetupShopProfile setupProfile,
    required GetShopStatus getStatus,
    required ShopLogout logout,
    required SendShopPasswordResetEmail sendShopPasswordResetEmail,
    required SendShopEmailVerification sendShopEmailVerification,
    required CheckShopEmailVerification checkShopEmailVerification,
    required FinalizeShopSignUp finalizeShopSignUp,
    required DeleteShopAuthAccount deleteShopAuthAccount,
  })  : _login = login,
        _signUp = signUp,
        _setupProfile = setupProfile,
        _getStatus = getStatus,
        _logout = logout,
        _sendPasswordResetEmail = sendShopPasswordResetEmail,
        _sendEmailVerification = sendShopEmailVerification,
        _checkEmailVerification = checkShopEmailVerification,
        _finalizeSignUp = finalizeShopSignUp,
        _deleteAccount = deleteShopAuthAccount,
        super(ShopAuthInitial()) {
    on<ShopLoginStarted>(_onLogin);
    on<ShopSignupStarted>(_onSignup);
    on<ShopSetupProfileStarted>(_onSetupProfile);
    on<ShopStatusSubscriptionRequested>(_onStatusSubscription);
    on<ShopLogoutRequested>(_onLogout);
    on<ShopSendEmailVerificationEvent>(_onSendEmailVerification);
    on<ShopCheckEmailVerificationStatusEvent>(_onCheckEmailVerificationStatus);
    on<ShopVerificationCancelledEvent>(_onVerificationCancelled);
    on<ShopPasswordResetRequested>(_onPasswordResetRequested);
  }

  Future<void> _onLogin(ShopLoginStarted event, Emitter<ShopAuthState> emit) async {
    emit(ShopAuthLoading());
    try {
      await _login(email: event.email, password: event.password);
      emit(ShopAuthSuccess());
    } on ServerException catch (e) {
      emit(ShopAuthFailure(e.message));
    } on NetworkException catch (e) {
      emit(ShopAuthFailure(e.message));
    } catch (e) {
      emit(ShopAuthFailure("An unexpected error occurred. Please try again."));
    }
  }

  Future<void> _onSignup(ShopSignupStarted event, Emitter<ShopAuthState> emit) async {
    emit(ShopAuthLoading());
    try {
      await _signUp(
        email: event.email,
        password: event.password,
      );
      // Trigger verification email immediately
      add(ShopSendEmailVerificationEvent());
      emit(ShopAuthVerificationWaiting(
        ownerName: event.ownerName,
        shopName: event.shopName,
        email: event.email,
      ));
    } on ServerException catch (e) {
      emit(ShopAuthFailure(e.message));
    } on NetworkException catch (e) {
      emit(ShopAuthFailure(e.message));
    } catch (e) {
      emit(ShopAuthFailure("Failed to create account. Please try again."));
    }
  }

  Future<void> _onSendEmailVerification(
      ShopSendEmailVerificationEvent event, Emitter<ShopAuthState> emit) async {
    try {
      await _sendEmailVerification();
      if (state is ShopAuthVerificationWaiting) {
        final currentState = state as ShopAuthVerificationWaiting;
        emit(ShopAuthVerificationWaiting(
          ownerName: currentState.ownerName,
          shopName: currentState.shopName,
          email: currentState.email,
          isResend: true,
        ));
      }
    } catch (e) {
      // Silent error for resend
    }
  }

  Future<void> _onCheckEmailVerificationStatus(
      ShopCheckEmailVerificationStatusEvent event, Emitter<ShopAuthState> emit) async {
    try {
      final isVerified = await _checkEmailVerification();
      if (isVerified) {
        // Finalize signed up by creating Firestore record
        await _finalizeSignUp(
          ownerName: event.ownerName,
          shopName: event.shopName,
          email: event.email,
        );
        emit(ShopAuthVerificationSuccess());
        emit(ShopAuthSuccess());
      }
    } on ServerException catch (e) {
      emit(ShopAuthFailure(e.message));
      emit(ShopAuthVerificationWaiting(
        ownerName: event.ownerName,
        shopName: event.shopName,
        email: event.email,
      ));
    } on NetworkException catch (e) {
      emit(ShopAuthFailure(e.message));
      emit(ShopAuthVerificationWaiting(
        ownerName: event.ownerName,
        shopName: event.shopName,
        email: event.email,
      ));
    } catch (e) {
      emit(ShopAuthFailure("Verification check failed. Please try again."));
      emit(ShopAuthVerificationWaiting(
        ownerName: event.ownerName,
        shopName: event.shopName,
        email: event.email,
      ));
    }
  }

  Future<void> _onVerificationCancelled(
      ShopVerificationCancelledEvent event, Emitter<ShopAuthState> emit) async {
    try {
      await _deleteAccount(null);
      emit(ShopAuthInitial());
    } catch (e) {
      emit(ShopAuthInitial());
    }
  }

  Future<void> _onPasswordResetRequested(
      ShopPasswordResetRequested event, Emitter<ShopAuthState> emit) async {
    emit(ShopAuthLoading());
    try {
      await _sendPasswordResetEmail(event.email);
      emit(ShopAuthPasswordResetSuccess());
    } on ServerException catch (e) {
      emit(ShopAuthFailure(e.message));
    } on NetworkException catch (e) {
      emit(ShopAuthFailure(e.message));
    } catch (e) {
      emit(ShopAuthFailure("Failed to send password reset email. Please try again."));
    }
  }

  Future<void> _onSetupProfile(ShopSetupProfileStarted event, Emitter<ShopAuthState> emit) async {
    emit(ShopAuthLoading());
    try {
      await _setupProfile(
        category: event.category,
        description: event.description,
        gstNumber: event.gstNumber,
        businessLicenseFile: event.businessLicenseFile,
        ownerIdFile: event.ownerIdFile,
      );
      emit(ShopAuthSuccess());
    } on ServerException catch (e) {
      emit(ShopAuthFailure(e.message));
    } on NetworkException catch (e) {
      emit(ShopAuthFailure(e.message));
    } catch (e) {
      emit(ShopAuthFailure("Failed to set up shop profile. Please try again."));
    }
  }

  Future<void> _onStatusSubscription(
      ShopStatusSubscriptionRequested event, Emitter<ShopAuthState> emit) async {
    await emit.forEach<ShopProfileModel?>(
      _getStatus(),
      onData: (shop) => ShopStatusLoaded(shop),
      onError: (e, _) {
        if (e.toString().contains('PERMISSION_DENIED') || e.toString().contains('permission-denied')) {
          return ShopAuthInitial();
        }
        return ShopAuthFailure("Failed to load shop details: ${e.toString()}");
      },
    );
  }

  Future<void> _onLogout(ShopLogoutRequested event, Emitter<ShopAuthState> emit) async {
    await _logout();
    emit(ShopAuthInitial());
  }
}

