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
import 'package:street_cart/features/shop/home/data/datasource/shop_home_local_datasource_impl.dart';

// SHOP - SETTINGS
import 'package:street_cart/features/shop/settings/domain/usecases/change_shop_password.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/delete_shop_auth_account.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';

// SHOP - ONBOARDING
import 'package:street_cart/features/shop/onboarding/data/datasource/shop_onboarding_local_datasource.dart';

// SHOP - HOME
import 'package:street_cart/features/shop/home/data/datasource/shop_home_local_datasource.dart';
import 'package:street_cart/features/shop/onboarding/data/datasource/shop_onboarding_local_datasource_impl.dart';

// SHOP - SPLASH
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_local_datasource.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_local_datasource_impl.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_remote_datasource.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_remote_datasource_impl.dart';
import 'package:street_cart/features/shop/splash/data/repositories/shop_splash_repository_impl.dart';
import 'package:street_cart/features/shop/splash/domain/repositories/i_shop_splash_repository.dart';
import 'package:street_cart/features/shop/splash/domain/usecases/check_shop_app_status.dart';

// SHOP - LOCATION
import 'package:street_cart/features/shop/location/data/datasource/shop_location_datasource.dart';
import 'package:street_cart/features/shop/location/data/datasource/shop_location_datasource_impl.dart';
import 'package:street_cart/features/shop/location/data/repositories/shop_location_repository_impl.dart';
import 'package:street_cart/features/shop/location/domain/repositories/i_shop_location_repository.dart';
import 'package:street_cart/features/shop/location/domain/usecases/request_shop_location_and_save.dart';

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

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initCore();

  // CUSTOMER
  _initCustomerAuth();
  _initCustomerHome();
  _initCustomerProfile();
  _initCustomerLocation();
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
  // _initAdminAuth();
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
}

// ================= SHOP ONBOARDING =================
Future<void> _initShopOnboarding() async {
  sl.registerLazySingleton<IShopOnboardingLocalDataSource>(
    () => ShopOnboardingLocalDataSourceImpl(sl()),
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
}

// ================= SHOP HOME =================
Future<void> _initShopHome() async {
  sl.registerLazySingleton<IShopHomeLocalDataSource>(
    () => ShopHomeLocalDataSourceImpl(sl()),
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

