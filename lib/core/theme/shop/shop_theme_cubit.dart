import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences sharedPreferences;

  ShopThemeCubit({required this.sharedPreferences})
    : super(
        (sharedPreferences.getBool('shopDarkMode') ?? false)
            ? ThemeMode.dark
            : ThemeMode.light,
      );

  void toggleTheme(bool isDark) {
    sharedPreferences.setBool('shopDarkMode', isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
