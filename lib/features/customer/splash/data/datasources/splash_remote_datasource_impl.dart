import 'package:firebase_auth/firebase_auth.dart';
import 'splash_remote_datasource.dart';

class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  @override
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}