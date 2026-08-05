import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences sharedPreferences;

  AdminThemeCubit({required this.sharedPreferences})
    : super(
        (sharedPreferences.getBool('adminDarkMode') ?? false)
            ? ThemeMode.dark
            : ThemeMode.light,
      );

  void toggleTheme(bool isDark) {
    sharedPreferences.setBool('adminDarkMode', isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
