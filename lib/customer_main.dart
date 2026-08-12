import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/apps/customer_app/customer_app.dart';
import 'package:street_cart/core/bloc/app_bloc_observer.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/firebase/firebase_initializer.dart';
import 'package:street_cart/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await FirebaseInitializer.init();
  await initDependencies();
  await NotificationService.instance.initialize();
  runApp(const CustomerApp());
}
