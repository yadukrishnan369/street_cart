import 'dart:async';
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
import 'package:street_cart/features/shop/auth/domain/usecases/get_business_categories.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/delete_shop_auth_account.dart';
part 'shop_auth_event.dart';
part 'shop_auth_state.dart';

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
  final GetBusinessCategories _getBusinessCategories;

  Timer? _countdownTimer;
  Timer? _pollingTimer;

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
    required GetBusinessCategories getBusinessCategories,
  }) : _login = login,
       _signUp = signUp,
       _setupProfile = setupProfile,
       _getStatus = getStatus,
       _logout = logout,
       _sendPasswordResetEmail = sendShopPasswordResetEmail,
       _sendEmailVerification = sendShopEmailVerification,
       _checkEmailVerification = checkShopEmailVerification,
       _finalizeSignUp = finalizeShopSignUp,
       _deleteAccount = deleteShopAuthAccount,
       _getBusinessCategories = getBusinessCategories,
       super(const ShopAuthState()) {
    on<ShopLoginStarted>(_onLogin);
    on<ShopSignupStarted>(_onSignup);
    on<ShopSetupProfileStarted>(_onSetupProfile);
    on<ShopStatusSubscriptionRequested>(_onStatusSubscription);
    on<ShopLogoutRequested>(_onLogout);
    on<ShopSendEmailVerificationEvent>(_onSendEmailVerification);
    on<ShopCheckEmailVerificationStatusEvent>(_onCheckEmailVerificationStatus);
    on<ShopVerificationCancelledEvent>(_onVerificationCancelled);
    on<ShopPasswordResetRequested>(_onPasswordResetRequested);

    // UI events handlers
    on<ShopTogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ShopToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
    on<ShopSetVerificationSheetShowing>(_onSetVerificationSheetShowing);
    on<ShopSelectCategory>(_onSelectCategory);
    on<ShopSelectBusinessLicense>(_onSelectBusinessLicense);
    on<ShopSelectOwnerId>(_onSelectOwnerId);
    on<ShopMarkProfileSetupNavigated>(_onMarkProfileSetupNavigated);

    // Categories and Verification Timers
    on<ShopLoadCategories>(_onLoadCategories);
    on<ShopStartVerificationTimer>(_onStartVerificationTimer);
    on<ShopVerificationTimerTicked>(_onVerificationTimerTicked);
  }

  // Login action
  Future<void> _onLogin(
    ShopLoginStarted event,
    Emitter<ShopAuthState> emit,
  ) async {
    emit(state.copyWith(status: ShopAuthStatus.loading));
    try {
      await _login(email: event.email, password: event.password);
      emit(state.copyWith(status: ShopAuthStatus.authenticated));
    } on ServerException catch (e) {
      emit(
        state.copyWith(status: ShopAuthStatus.failure, errorMessage: e.message),
      );
    } on NetworkException catch (e) {
      emit(
        state.copyWith(status: ShopAuthStatus.failure, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopAuthStatus.failure,
          errorMessage: "An unexpected error occurred. Please try again.",
        ),
      );
    }
  }

  // Signup action and verification link
  Future<void> _onSignup(
    ShopSignupStarted event,
    Emitter<ShopAuthState> emit,
  ) async {
    emit(state.copyWith(status: ShopAuthStatus.loading));
    try {
      await _signUp(email: event.email, password: event.password);
      // verification email
      add(ShopSendEmailVerificationEvent());
      emit(
        state.copyWith(
          status: ShopAuthStatus.verificationWaiting,
          ownerName: event.ownerName,
          shopName: event.shopName,
          email: event.email,
        ),
      );
      add(
        ShopStartVerificationTimer(
          ownerName: event.ownerName,
          shopName: event.shopName,
          email: event.email,
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(status: ShopAuthStatus.failure, errorMessage: e.message),
      );
    } on NetworkException catch (e) {
      emit(
        state.copyWith(status: ShopAuthStatus.failure, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopAuthStatus.failure,
          errorMessage: "Failed to create account. Please try again.",
        ),
      );
    }
  }

  // Sends email verification link
  Future<void> _onSendEmailVerification(
    ShopSendEmailVerificationEvent event,
    Emitter<ShopAuthState> emit,
  ) async {
    try {
      await _sendEmailVerification();
      emit(state.copyWith(isResend: true));
    } catch (e) {
      // error for resend
    }
  }

  // Checks if user verified email
  Future<void> _onCheckEmailVerificationStatus(
    ShopCheckEmailVerificationStatusEvent event,
    Emitter<ShopAuthState> emit,
  ) async {
    try {
      final isVerified = await _checkEmailVerification();
      if (isVerified) {
        _cancelTimers();
        // Finalize signed up by creating record
        await _finalizeSignUp(
          ownerName: event.ownerName,
          shopName: event.shopName,
          email: event.email,
        );
        emit(state.copyWith(status: ShopAuthStatus.verificationSuccess));
        emit(state.copyWith(status: ShopAuthStatus.authenticated));
      }
    } on ServerException catch (e) {
      emit(
        state.copyWith(status: ShopAuthStatus.failure, errorMessage: e.message),
      );
      emit(state.copyWith(status: ShopAuthStatus.verificationWaiting));
    } on NetworkException catch (e) {
      emit(
        state.copyWith(status: ShopAuthStatus.failure, errorMessage: e.message),
      );
      emit(state.copyWith(status: ShopAuthStatus.verificationWaiting));
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopAuthStatus.failure,
          errorMessage: "Verification check failed. Please try again.",
        ),
      );
      emit(state.copyWith(status: ShopAuthStatus.verificationWaiting));
    }
  }

  // Cancel verification process
  Future<void> _onVerificationCancelled(
    ShopVerificationCancelledEvent event,
    Emitter<ShopAuthState> emit,
  ) async {
    _cancelTimers();
    try {
      await _deleteAccount(null);
      emit(state.copyWith(status: ShopAuthStatus.initial));
    } catch (e) {
      emit(state.copyWith(status: ShopAuthStatus.initial));
    }
  }

  // Sends password reset link
  Future<void> _onPasswordResetRequested(
    ShopPasswordResetRequested event,
    Emitter<ShopAuthState> emit,
  ) async {
    emit(state.copyWith(status: ShopAuthStatus.loading));
    try {
      await _sendPasswordResetEmail(event.email);
      emit(state.copyWith(status: ShopAuthStatus.passwordResetSuccess));
    } on ServerException catch (e) {
      emit(
        state.copyWith(status: ShopAuthStatus.failure, errorMessage: e.message),
      );
    } on NetworkException catch (e) {
      emit(
        state.copyWith(status: ShopAuthStatus.failure, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopAuthStatus.failure,
          errorMessage:
              "Failed to send password reset email. Please try again.",
        ),
      );
    }
  }

  // Completes profile setup
  Future<void> _onSetupProfile(
    ShopSetupProfileStarted event,
    Emitter<ShopAuthState> emit,
  ) async {
    emit(state.copyWith(status: ShopAuthStatus.loading));
    try {
      await _setupProfile(
        category: event.category,
        description: event.description,
        gstNumber: event.gstNumber,
        businessLicenseFile: event.businessLicenseFile,
        ownerIdFile: event.ownerIdFile,
      );
      emit(state.copyWith(status: ShopAuthStatus.profileSetupSuccess));
      emit(state.copyWith(status: ShopAuthStatus.authenticated));
    } on ServerException catch (e) {
      emit(
        state.copyWith(status: ShopAuthStatus.failure, errorMessage: e.message),
      );
    } on NetworkException catch (e) {
      emit(
        state.copyWith(status: ShopAuthStatus.failure, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopAuthStatus.failure,
          errorMessage: "Failed to set up shop profile. Please try again.",
        ),
      );
    }
  }

  // Shop status
  Future<void> _onStatusSubscription(
    ShopStatusSubscriptionRequested event,
    Emitter<ShopAuthState> emit,
  ) async {
    await emit.forEach<ShopProfileModel?>(
      _getStatus(),
      onData: (shop) {
        if (shop == null || shop.isSuspended == true) {
          add(ShopLogoutRequested());
          return state.copyWith(status: ShopAuthStatus.initial, shop: null);
        }
        return state.copyWith(status: ShopAuthStatus.authenticated, shop: shop);
      },
      onError: (e, _) {
        if (e.toString().contains('PERMISSION_DENIED') ||
            e.toString().contains('permission-denied')) {
          add(ShopLogoutRequested());
          return state.copyWith(status: ShopAuthStatus.initial, shop: null);
        }
        return state.copyWith(
          status: ShopAuthStatus.failure,
          errorMessage: "Failed to load shop details: ${e.toString()}",
        );
      },
    );
  }

  // Logs out shop
  Future<void> _onLogout(
    ShopLogoutRequested event,
    Emitter<ShopAuthState> emit,
  ) async {
    _cancelTimers();
    await _logout();
    emit(state.copyWith(status: ShopAuthStatus.initial, shop: null));
  }

  // Password Visibility Toggles
  void _onTogglePasswordVisibility(
    ShopTogglePasswordVisibility event,
    Emitter<ShopAuthState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onToggleConfirmPasswordVisibility(
    ShopToggleConfirmPasswordVisibility event,
    Emitter<ShopAuthState> emit,
  ) {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  void _onSetVerificationSheetShowing(
    ShopSetVerificationSheetShowing event,
    Emitter<ShopAuthState> emit,
  ) {
    emit(state.copyWith(isVerificationSheetShowing: event.showing));
  }

  void _onSelectCategory(
    ShopSelectCategory event,
    Emitter<ShopAuthState> emit,
  ) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onSelectBusinessLicense(
    ShopSelectBusinessLicense event,
    Emitter<ShopAuthState> emit,
  ) {
    emit(state.copyWith(businessLicense: event.file));
  }

  void _onSelectOwnerId(ShopSelectOwnerId event, Emitter<ShopAuthState> emit) {
    emit(state.copyWith(ownerId: event.file));
  }

  void _onMarkProfileSetupNavigated(
    ShopMarkProfileSetupNavigated event,
    Emitter<ShopAuthState> emit,
  ) {
    emit(state.copyWith(isProfileSetupNavigated: true));
  }

  // Fetche business category list
  Future<void> _onLoadCategories(
    ShopLoadCategories event,
    Emitter<ShopAuthState> emit,
  ) async {
    emit(state.copyWith(categoriesLoading: true, categoriesError: null));
    try {
      final categories = await _getBusinessCategories();
      emit(state.copyWith(categories: categories, categoriesLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          categoriesError: e.toString().replaceAll('Exception: ', ''),
          categoriesLoading: false,
        ),
      );
    }
  }

  // Starts the polling and countdown
  void _onStartVerificationTimer(
    ShopStartVerificationTimer event,
    Emitter<ShopAuthState> emit,
  ) {
    _cancelTimers();
    emit(state.copyWith(secondsRemaining: 80));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentRemaining = state.secondsRemaining;
      if (currentRemaining > 0) {
        add(ShopVerificationTimerTicked(currentRemaining - 1));
      } else {
        add(ShopVerificationCancelledEvent());
      }
    });

    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      add(
        ShopCheckEmailVerificationStatusEvent(
          ownerName: event.ownerName,
          shopName: event.shopName,
          email: event.email,
        ),
      );
    });
  }

  // Updates Verification Timer
  void _onVerificationTimerTicked(
    ShopVerificationTimerTicked event,
    Emitter<ShopAuthState> emit,
  ) {
    emit(state.copyWith(secondsRemaining: event.secondsRemaining));
  }

  void _cancelTimers() {
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    _countdownTimer = null;
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    _cancelTimers();
    return super.close();
  }
}
