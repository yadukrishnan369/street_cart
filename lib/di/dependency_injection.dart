import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// CORE
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/services/location_service.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/core/services/cloudinary_service.dart';
import 'package:street_cart/core/firebase/firebase_auth_service.dart';

// CUSTOMER - AUTH
import 'package:street_cart/features/customer/auth/data/datasource/auth_remote_datasource.dart';
import 'package:street_cart/features/customer/auth/data/datasource/auth_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/auth/data/repositories/auth_repository_impl.dart';
import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/delete_account.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/login.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/sign_up.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/sign_in_with_google.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/logout.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/send_password_reset_email.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/get_customer_profile.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/get_customer_data.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/update_customer_profile.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/change_password.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/check_email_password_user.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/send_email_verification.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/check_email_verification.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/finalize_sign_up.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';

// CUSTOMER - HOME
import 'package:street_cart/features/customer/home/data/datasources/home_remote_datasource.dart';
import 'package:street_cart/features/customer/home/data/datasources/home_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/home/data/repositories/home_repository_impl.dart';
import 'package:street_cart/features/customer/home/domain/repositories/i_home_repository.dart';
import 'package:street_cart/features/customer/home/domain/usecases/get_home_address.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_bloc.dart';

// CUSTOMER - PROFILE
import 'package:street_cart/features/customer/profile/data/datasources/profile_remote_datasource.dart';
import 'package:street_cart/features/customer/profile/data/datasources/profile_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/profile/data/repositories/profile_repository_impl.dart';
import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/get_profile_data.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/update_profile_data.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/upload_profile_image.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/remove_profile_image.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/get_addresses.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/add_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/update_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/delete_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/set_default_address.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';

// CUSTOMER - SETTINGS
import 'package:street_cart/features/customer/settings/data/datasources/settings_local_datasource.dart';
import 'package:street_cart/features/customer/settings/data/repositories/settings_repository_impl.dart';
import 'package:street_cart/features/customer/settings/domain/repositories/settings_repository.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/get_settings.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/update_setting.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';

// CUSTOMER - LOCATION
import 'package:street_cart/features/customer/location/data/datasource/location_datasource.dart';
import 'package:street_cart/features/customer/location/data/datasource/location_datasource_impl.dart';
import 'package:street_cart/features/customer/location/data/repositories/location_repository_impl.dart';
import 'package:street_cart/features/customer/location/domain/repositories/i_location_repository.dart';
import 'package:street_cart/features/customer/location/domain/usecases/request_location_and_save.dart';
import 'package:street_cart/features/customer/location/presentation/bloc/location_bloc.dart';

// CUSTOMER - ONBOARDING
import 'package:street_cart/features/customer/onboarding/data/datasource/onboarding_local_datasource.dart';
import 'package:street_cart/features/customer/onboarding/data/datasource/onboarding_local_datasource_impl.dart';
import 'package:street_cart/features/customer/onboarding/domain/repositories/i_onboarding_repository.dart';
import 'package:street_cart/features/customer/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:street_cart/features/customer/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:street_cart/features/customer/onboarding/presentation/bloc/onboarding_bloc.dart';

// CUSTOMER - SPLASH
import 'package:street_cart/features/customer/splash/data/datasources/splash_local_datasource.dart';
import 'package:street_cart/features/customer/splash/data/datasources/splash_local_datasource_impl.dart';
import 'package:street_cart/features/customer/splash/data/datasources/splash_remote_datasource.dart';
import 'package:street_cart/features/customer/splash/data/datasources/splash_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/splash/domain/repositories/i_splash_repository.dart';
import 'package:street_cart/features/customer/splash/data/repositories/splash_repository_impl.dart';
import 'package:street_cart/features/customer/splash/domain/usecases/check_app_status.dart';
import 'package:street_cart/features/customer/splash/presentation/bloc/splash_bloc.dart';

// SHOP - AUTH
import 'package:street_cart/features/shop/auth/data/datasource/shop_auth_remote_datasource.dart';
import 'package:street_cart/features/shop/auth/data/datasource/shop_auth_remote_datasource_impl.dart';
import 'package:street_cart/features/shop/auth/data/repositories/shop_auth_repository_impl.dart';
import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/shop_login.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/shop_signup.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/setup_shop_profile.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_shop_status.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/shop_logout.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/send_shop_password_reset_email.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/send_shop_email_verification.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/check_shop_email_verification.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/finalize_shop_sign_up.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_business_categories.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_categories_cubit.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_shop_payment_settings.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_payment_settings_cubit.dart';
import 'package:street_cart/features/shop/home/data/datasource/shop_home_local_datasource_impl.dart';

// SHOP - SETTINGS
import 'package:street_cart/features/shop/settings/domain/usecases/change_shop_password.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/delete_shop_auth_account.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';

// SHOP - ONBOARDING
import 'package:street_cart/features/shop/onboarding/data/datasource/shop_onboarding_local_datasource.dart';
import 'package:street_cart/features/shop/onboarding/data/datasource/shop_onboarding_local_datasource_impl.dart';
import 'package:street_cart/features/shop/onboarding/domain/repositories/i_shop_onboarding_repository.dart';
import 'package:street_cart/features/shop/onboarding/data/repositories/shop_onboarding_repository_impl.dart';
import 'package:street_cart/features/shop/onboarding/domain/usecases/complete_shop_onboarding.dart';
import 'package:street_cart/features/shop/onboarding/presentation/bloc/shop_onboarding_bloc.dart';

// SHOP - HOME
import 'package:street_cart/features/shop/home/data/datasource/shop_home_local_datasource.dart';
import 'package:street_cart/features/shop/home/data/datasource/shop_home_local_datasource_impl.dart';
import 'package:street_cart/features/shop/home/domain/repositories/i_shop_home_repository.dart';
import 'package:street_cart/features/shop/home/data/repositories/shop_home_repository_impl.dart';
import 'package:street_cart/features/shop/home/domain/usecases/check_first_home_visit.dart';
import 'package:street_cart/features/shop/home/domain/usecases/complete_first_home_visit.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_bloc.dart';

// SHOP - SPLASH
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_local_datasource.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_local_datasource_impl.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_remote_datasource.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_remote_datasource_impl.dart';
import 'package:street_cart/features/shop/splash/data/repositories/shop_splash_repository_impl.dart';
import 'package:street_cart/features/shop/splash/domain/repositories/i_shop_splash_repository.dart';
import 'package:street_cart/features/shop/splash/domain/usecases/check_shop_app_status.dart';
import 'package:street_cart/features/shop/splash/presentation/bloc/shop_splash_bloc.dart';

// SHOP - LOCATION
import 'package:street_cart/features/shop/location/data/datasource/shop_location_datasource.dart';
import 'package:street_cart/features/shop/location/data/datasource/shop_location_datasource_impl.dart';
import 'package:street_cart/features/shop/location/data/repositories/shop_location_repository_impl.dart';
import 'package:street_cart/features/shop/location/domain/repositories/i_shop_location_repository.dart';
import 'package:street_cart/features/shop/location/domain/usecases/request_shop_location_and_save.dart';
import 'package:street_cart/features/shop/location/presentation/bloc/shop_location_bloc.dart';

// SHOP - PROFILE
import 'package:street_cart/features/shop/profile/data/datasources/shop_profile_remote_datasource.dart';
import 'package:street_cart/features/shop/profile/data/datasources/shop_profile_remote_datasource_impl.dart';
import 'package:street_cart/features/shop/profile/data/repositories/shop_profile_repository_impl.dart';
import 'package:street_cart/features/shop/profile/domain/repositories/i_shop_profile_repository.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/get_shop_profile_data.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/update_shop_profile_data.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/upload_shop_profile_image.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/remove_shop_profile_image.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';

// ADMIN
import 'package:street_cart/features/admin/auth/data/datasource/admin_auth_remote_datasource.dart';
import 'package:street_cart/features/admin/auth/data/datasource/admin_auth_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/auth/domain/repositories/i_admin_auth_repository.dart';
import 'package:street_cart/features/admin/auth/data/repositories/admin_auth_repository_impl.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/admin_login.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/check_admin_session.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/admin_logout.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/send_admin_password_reset.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/confirm_admin_password_reset.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';

// ADMIN - SPLASH
import 'package:street_cart/features/admin/splash/domain/repositories/i_admin_splash_repository.dart';
import 'package:street_cart/features/admin/splash/data/repositories/admin_splash_repository_impl.dart';
import 'package:street_cart/features/admin/splash/domain/usecases/check_admin_splash_session.dart';
import 'package:street_cart/features/admin/splash/presentation/bloc/admin_splash_bloc.dart';

// ADMIN - DASHBOARD
import 'package:street_cart/features/admin/dashboard/data/datasources/admin_dashboard_remote_datasource.dart';
import 'package:street_cart/features/admin/dashboard/data/datasources/admin_dashboard_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/dashboard/domain/repositories/i_admin_dashboard_repository.dart';
import 'package:street_cart/features/admin/dashboard/data/repositories/admin_dashboard_repository_impl.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_dashboard_data.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_pending_registrations.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_pending_registrations_count.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_bloc.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_shop_details.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/approve_shop.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/reject_shop.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registration_details_bloc.dart';

// ADMIN - SETTINGS
import 'package:street_cart/features/admin/settings/data/datasources/admin_settings_remote_datasource.dart';
import 'package:street_cart/features/admin/settings/data/datasources/admin_settings_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/settings/domain/repositories/i_admin_settings_repository.dart';
import 'package:street_cart/features/admin/settings/data/repositories/admin_settings_repository_impl.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/get_admin_settings.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_platform_commission.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_payment_controls.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/change_admin_password.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_categories.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_bloc.dart';

// ADMIN - PROFILE
import 'package:street_cart/features/admin/profile/data/datasources/admin_profile_remote_datasource.dart';
import 'package:street_cart/features/admin/profile/data/datasources/admin_profile_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/profile/domain/repositories/i_admin_profile_repository.dart';
import 'package:street_cart/features/admin/profile/data/repositories/admin_profile_repository_impl.dart';
import 'package:street_cart/features/admin/profile/domain/usecases/get_admin_profile_data.dart';
import 'package:street_cart/features/admin/profile/domain/usecases/update_admin_profile_name.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_bloc.dart';

// ADMIN - SHOP
import 'package:street_cart/features/admin/shops/data/datasources/admin_shop_remote_datasource.dart';
import 'package:street_cart/features/admin/shops/domain/repositories/admin_shop_repository.dart';
import 'package:street_cart/features/admin/shops/data/repositories/admin_shop_repository_impl.dart';
import 'package:street_cart/features/admin/shops/domain/usecases/get_admin_shop.dart';
import 'package:street_cart/features/admin/shops/domain/usecases/get_admin_shop_details.dart';
import 'package:street_cart/features/admin/shops/domain/usecases/delete_shop.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_bloc.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_bloc.dart';
// ADMIN - CUSTOMERS
import 'package:street_cart/features/admin/customers/data/datasources/admin_customer_remote_datasource.dart';
import 'package:street_cart/features/admin/customers/domain/repositories/admin_customer_repository.dart';
import 'package:street_cart/features/admin/customers/data/repositories/admin_customer_repository_impl.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/get_admin_customers.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/toggle_customer_status.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/get_admin_customer_details.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/delete_customer.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initCore();

  // CUSTOMER
  _initCustomerAuth();
  _initCustomerHome();
  _initCustomerProfile();
  _initCustomerLocation();
  _initCustomerOnboarding();
  _initCustomerSplash();
  await _initCustomerSettings();

  // SHOP
  await _initShopAuth();
  await _initShopOnboarding();
  await _initShopLocation();
  await _initShopHome();
  await _initShopSplash();
  await _initShopProfile();
  await _initShopSettings();

  // ADMIN
  _initAdminAuth();
  _initAdminSplash();
  _initAdminDashboard();
  _initAdminSettings();
  _initAdminProfile();
  _initAdminShop();
  _initAdminCustomers();
}

// ================= SHOP SPLASH =================
Future<void> _initShopSplash() async {
  sl.registerLazySingleton<IShopSplashLocalDataSource>(
    () => ShopSplashLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<IShopSplashRemoteDataSource>(
    () => ShopSplashRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<IShopSplashRepository>(
    () => ShopSplashRepositoryImpl(
      local: sl(),
      remote: sl(),
    ),
  );
  sl.registerLazySingleton(() => CheckShopAppStatus(sl()));

  sl.registerFactory(
    () => ShopSplashBloc(checkShopAppStatus: sl()),
  );
}

// ================= SHOP ONBOARDING =================
Future<void> _initShopOnboarding() async {
  sl.registerLazySingleton<IShopOnboardingLocalDataSource>(
    () => ShopOnboardingLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<IShopOnboardingRepository>(
    () => ShopOnboardingRepositoryImpl(local: sl()),
  );
  sl.registerLazySingleton(() => CompleteShopOnboarding(sl()));

  sl.registerFactory(
    () => ShopOnboardingBloc(completeShopOnboarding: sl()),
  );
}

// ================= SHOP LOCATION =================
Future<void> _initShopLocation() async {
  sl.registerLazySingleton<ShopLocationDataSource>(
    () => ShopLocationDataSourceImpl(
      locationService: sl(),
      firebaseAuth: sl(),
      firebaseFirestore: sl(),
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<IShopLocationRepository>(
    () => ShopLocationRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => RequestShopLocationAndSave(sl()));
  sl.registerLazySingleton(() => SkipShopLocation(sl()));

  sl.registerFactory(
    () => ShopLocationBloc(
      requestLocationAndSave: sl(),
      skipLocation: sl(),
    ),
  );
}

// ================= SHOP HOME =================
Future<void> _initShopHome() async {
  // Datasource
  sl.registerLazySingleton<IShopHomeLocalDataSource>(
    () => ShopHomeLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<IShopHomeRepository>(
    () => ShopHomeRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => CheckFirstHomeVisit(sl()));
  sl.registerLazySingleton(() => CompleteFirstHomeVisit(sl()));

  // Bloc
  sl.registerFactory(
    () => ShopHomeBloc(
      checkFirstHomeVisit: sl(),
      completeFirstHomeVisit: sl(),
    ),
  );
}

// ================= SHOP AUTH =================
Future<void> _initShopAuth() async {
  // Datasource
  sl.registerLazySingleton<IShopAuthRemoteDataSource>(
    () => ShopAuthRemoteDataSourceImpl(
      authService: sl(),
      firestore: sl(),
      cloudinaryService: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<IShopAuthRepository>(
    () => ShopAuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => ShopLogin(sl()));
  sl.registerLazySingleton(() => ShopSignup(sl()));
  sl.registerLazySingleton(() => SetupShopProfile(sl()));
  sl.registerLazySingleton(() => GetShopStatus(sl()));
  sl.registerLazySingleton(() => ShopLogout(sl()));
  sl.registerLazySingleton(() => SendShopPasswordResetEmail(sl()));
  sl.registerLazySingleton(() => SendShopEmailVerification(sl()));
  sl.registerLazySingleton(() => CheckShopEmailVerification(sl()));
  sl.registerLazySingleton(() => FinalizeShopSignUp(sl()));
  sl.registerLazySingleton(() => GetBusinessCategories(sl()));
  sl.registerLazySingleton(() => GetShopPaymentSettings(sl()));

  // Bloc
  sl.registerFactory(
    () => ShopAuthBloc(
      login: sl(),
      signUp: sl(),
      setupProfile: sl(),
      getStatus: sl(),
      logout: sl(),
      sendShopPasswordResetEmail: sl(),
      sendShopEmailVerification: sl(),
      checkShopEmailVerification: sl(),
      finalizeShopSignUp: sl(),
      deleteShopAuthAccount: sl(),
    ),
  );
  sl.registerFactory(
    () => ShopCategoriesCubit(getBusinessCategories: sl()),
  );
  sl.registerFactory(
    () => ShopPaymentSettingsCubit(getShopPaymentSettings: sl()),
  );
}

// ================= CORE =================
Future<void> _initCore() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  sl.registerLazySingleton(
    () => FirebaseAuthService(auth: sl(), googleSignIn: sl()),
  );

  sl.registerLazySingleton(() => CloudinaryService());
  sl.registerLazySingleton(() => LocationService());
  sl.registerLazySingleton(() => CommunicationService());

  sl.registerLazySingleton<INetworkInfo>(() => NetworkInfoImpl());
}

// ================= CUSTOMER AUTH =================
void _initCustomerAuth() {
  sl.registerLazySingleton<IAuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(authService: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => SendPasswordResetEmail(sl()));
  sl.registerLazySingleton(() => GetCustomerProfile(sl()));
  sl.registerLazySingleton(() => GetCustomerData(sl()));
  sl.registerLazySingleton(() => UpdateCustomerProfile(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => CheckEmailPasswordUser(sl()));
  sl.registerLazySingleton(() => DeleteAccount(sl()));
  sl.registerLazySingleton(() => SendEmailVerification(sl()));
  sl.registerLazySingleton(() => CheckEmailVerification(sl()));
  sl.registerLazySingleton(() => FinalizeSignUp(sl()));

  sl.registerFactory(
    () => AuthBloc(
      signUp: sl(),
      login: sl(),
      signInWithGoogle: sl(),
      logout: sl(),
      sendPasswordResetEmail: sl(),
      getCustomerProfile: sl(),
      updateCustomerProfile: sl(),
      changePassword: sl(),
      deleteAccount: sl(),
      sendEmailVerification: sl(),
      checkEmailVerification: sl(),
      finalizeSignUp: sl(),
    ),
  );
}

// ================= CUSTOMER HOME =================
void _initCustomerHome() {
  sl.registerLazySingleton<IHomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
      locationService: sl(),
    ),
  );

  sl.registerLazySingleton<IHomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetHomeAddress(sl()));

  sl.registerFactory(() => HomeBloc(getHomeAddress: sl()));
}

// ================= CUSTOMER PROFILE =================
void _initCustomerProfile() {
  sl.registerLazySingleton<IProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
      locationService: sl(),
      cloudinaryService: sl(),
    ),
  );

  sl.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetProfileData(sl()));
  sl.registerLazySingleton(() => UpdateProfileData(sl()));
  sl.registerLazySingleton(() => UploadProfileImage(sl()));
  sl.registerLazySingleton(() => RemoveProfileImage(sl()));

  sl.registerLazySingleton(() => GetAddresses(sl()));
  sl.registerLazySingleton(() => AddAddress(sl()));
  sl.registerLazySingleton(() => UpdateAddress(sl()));
  sl.registerLazySingleton(() => DeleteAddress(sl()));
  sl.registerLazySingleton(() => SetDefaultAddress(sl()));

  sl.registerFactory(
    () => ProfileBloc(
      getProfileData: sl(),
      updateProfileData: sl(),
      uploadProfileImage: sl(),
      removeProfileImage: sl(),
    ),
  );

  sl.registerFactory(
    () => AddressBloc(
      getAddresses: sl(),
      addAddress: sl(),
      updateAddress: sl(),
      deleteAddress: sl(),
      setDefaultAddress: sl(),
    ),
  );
}

// ================= CUSTOMER LOCATION =================
void _initCustomerLocation() {
  sl.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(
      locationService: sl(),
      firebaseAuth: sl(),
      firebaseFirestore: sl(),
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<ILocationRepository>(
    () => LocationRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton(() => RequestLocationAndSave(sl()));
  sl.registerLazySingleton(() => SkipLocation(sl()));

  sl.registerFactory(
    () => LocationBloc(
      requestLocationAndSave: sl(),
      skipLocation: sl(),
    ),
  );
}

// ================= CUSTOMER ONBOARDING =================
void _initCustomerOnboarding() {
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<IOnboardingRepository>(
    () => OnboardingRepositoryImpl(local: sl()),
  );

  sl.registerLazySingleton(() => CompleteOnboarding(sl()));

  sl.registerFactory(
    () => OnboardingBloc(completeOnboarding: sl()),
  );
}

// ================= CUSTOMER SPLASH =================
void _initCustomerSplash() {
  sl.registerLazySingleton<SplashLocalDataSource>(
    () => SplashLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SplashRemoteDataSource>(
    () => SplashRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ISplashRepository>(
    () => SplashRepositoryImpl(local: sl(), remote: sl()),
  );

  sl.registerLazySingleton(() => CheckAppStatus(sl()));

  sl.registerFactory(
    () => SplashBloc(checkAppStatus: sl()),
  );
}

// ================= CUSTOMER SETTINGS =================
Future<void> _initCustomerSettings() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<ISettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<ISettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => UpdateSetting(sl()));

  sl.registerFactory(
    () => SettingsBloc(
      getSettings: sl(),
      updateSetting: sl(),
      locationRepository: sl(),
      authRepository: sl(),
    ),
  );
}

// ================= SHOP PROFILE =================
Future<void> _initShopProfile() async {
  // Datasource
  sl.registerLazySingleton<IShopProfileRemoteDataSource>(
    () => ShopProfileRemoteDataSourceImpl(
      firestore: sl(),
      cloudinaryService: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<IShopProfileRepository>(
    () => ShopProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      auth: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetShopProfileData(sl()));
  sl.registerLazySingleton(() => UpdateShopProfileData(sl()));
  sl.registerLazySingleton(() => UploadShopProfileImage(sl()));
  sl.registerLazySingleton(() => RemoveShopProfileImage(sl()));

  // Bloc
  sl.registerFactory(
    () => ShopProfileBloc(
      getProfileData: sl(),
      updateProfileData: sl(),
      uploadProfileImage: sl(),
      removeProfileImage: sl(),
    ),
  );
}

// ================= SHOP SETTINGS =================
Future<void> _initShopSettings() async {
  sl.registerLazySingleton(() => ChangeShopPassword(sl()));
  sl.registerLazySingleton(() => DeleteShopAuthAccount(sl()));

  sl.registerFactory(
    () => ShopSettingsBloc(
      changeShopPassword: sl(),
      deleteShopAuthAccount: sl(),
    ),
  );
}

// ================= ADMIN AUTH =================
void _initAdminAuth() {
  // Datasource
  sl.registerLazySingleton<IAdminAuthRemoteDataSource>(
    () => AdminAuthRemoteDataSourceImpl(
      authService: sl(),
      firestore: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<IAdminAuthRepository>(
    () => AdminAuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AdminLogin(sl()));
  sl.registerLazySingleton(() => CheckAdminSession(sl()));
  sl.registerLazySingleton(() => AdminLogout(sl()));
  sl.registerLazySingleton(() => SendAdminPasswordReset(sl()));
  sl.registerLazySingleton(() => ConfirmAdminPasswordReset(sl()));

  // Bloc
  sl.registerFactory(
    () => AdminAuthBloc(
      loginUseCase: sl(),
      checkSessionUseCase: sl(),
      logoutUseCase: sl(),
      sendPasswordResetUseCase: sl(),
      confirmPasswordResetUseCase: sl(),
    ),
  );
}

// ================= ADMIN SPLASH =================
void _initAdminSplash() {
  // Repository
  sl.registerLazySingleton<IAdminSplashRepository>(
    () => AdminSplashRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CheckAdminSplashSession(sl()));

  // Bloc
  sl.registerFactory(
    () => AdminSplashBloc(checkAdminSplashSession: sl()),
  );
}

// ================= ADMIN DASHBOARD =================
void _initAdminDashboard() {
  // Datasource
  sl.registerLazySingleton<IAdminDashboardRemoteDataSource>(
    () => AdminDashboardRemoteDataSourceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<IAdminDashboardRepository>(
    () => AdminDashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Case
  sl.registerLazySingleton(() => GetDashboardData(sl()));
  sl.registerLazySingleton(() => GetPendingRegistrations(sl()));
  sl.registerLazySingleton(() => GetPendingRegistrationsCount(sl()));
  sl.registerLazySingleton(() => GetShopDetails(sl()));
  sl.registerLazySingleton(() => ApproveShop(sl()));
  sl.registerLazySingleton(() => RejectShop(sl()));

  // Bloc
  sl.registerFactory(
    () => AdminDashboardBloc(
      getDashboardData: sl(),
      firestore: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminRegistrationsBloc(
      getPendingRegistrations: sl(),
      getPendingRegistrationsCount: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminRegistrationDetailsBloc(
      getShopDetails: sl(),
      approveShop: sl(),
      rejectShop: sl(),
    ),
  );
}

// ================= ADMIN SETTINGS =================
void _initAdminSettings() {
  // Datasource
  sl.registerLazySingleton<IAdminSettingsRemoteDataSource>(
    () => AdminSettingsRemoteDataSourceImpl(
      firestore: sl(),
      authService: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<IAdminSettingsRepository>(
    () => AdminSettingsRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAdminSettings(sl()));
  sl.registerLazySingleton(() => SavePlatformCommission(sl()));
  sl.registerLazySingleton(() => SavePaymentControls(sl()));
  sl.registerLazySingleton(() => ChangeAdminPassword(sl()));
  sl.registerLazySingleton(() => SaveCategories(sl()));

  // Bloc
  sl.registerFactory(
    () => AdminSettingsBloc(
      getAdminSettings: sl(),
      savePlatformCommission: sl(),
      savePaymentControls: sl(),
      changeAdminPassword: sl(),
      saveCategories: sl(),
    ),
  );
}

// ================= ADMIN PROFILE =================
void _initAdminProfile() {
  // Datasource
  sl.registerLazySingleton<IAdminProfileRemoteDataSource>(
    () => AdminProfileRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<IAdminProfileRepository>(
    () => AdminProfileRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Usecase
  sl.registerLazySingleton(() => GetAdminProfileData(sl()));
  sl.registerLazySingleton(() => UpdateAdminProfileName(repository: sl()));

  // Bloc
  sl.registerFactory(
    () => AdminProfileBloc(
      getProfileData: sl(),
      updateProfileName: sl(),
    ),
  );
}

void _initAdminShop() {
  // Datasource
  sl.registerLazySingleton<IAdminShopRemoteDataSource>(
    () => AdminShopRemoteDataSourceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<IAdminShopRepository>(
    () => AdminShopRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAdminShop(sl()));
  sl.registerLazySingleton(() => ToggleShopSuspension(sl()));
  sl.registerLazySingleton(() => GetAdminShopDetails(sl()));
  sl.registerLazySingleton(() => DeleteShop(sl()));

  // Bloc
  sl.registerFactory(
    () => AdminShopBloc(
      getAdminShop: sl(),
      toggleShopSuspension: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminShopDetailBloc(
      getAdminShopDetails: sl(),
      toggleShopSuspension: sl(),
      deleteShop: sl(),
    ),
  );
}

void _initAdminCustomers() {
  // Datasource
  sl.registerLazySingleton<IAdminCustomerRemoteDataSource>(
    () => AdminCustomerRemoteDataSourceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<IAdminCustomerRepository>(
    () => AdminCustomerRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAdminCustomers(sl()));
  sl.registerLazySingleton(() => ToggleCustomerBlockStatus(sl()));
  sl.registerLazySingleton(() => GetAdminCustomerDetails(sl()));
  sl.registerLazySingleton(() => DeleteCustomer(sl()));

  // Bloc
  sl.registerFactory(
    () => AdminCustomersBloc(
      getAdminCustomers: sl(),
      toggleCustomerBlockStatus: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminCustomerDetailBloc(
      getCustomerDetails: sl(),
      toggleBlockStatus: sl(),
      deleteCustomer: sl(),
    ),
  );
}

