import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
  // _initShopAuth();

  // ADMIN
  // _initAdminAuth();
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

  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton<INetworkInfo>(() => NetworkInfoImpl(sl()));
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
