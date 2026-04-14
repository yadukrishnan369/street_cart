import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:street_cart/apps/shop_app/shop_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ShopApp());
}
