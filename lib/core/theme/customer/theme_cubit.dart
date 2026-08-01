import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences sharedPreferences;

  ThemeCubit({required this.sharedPreferences})
    : super(
        (sharedPreferences.getBool('darkMode') ?? false)
            ? ThemeMode.dark
            : ThemeMode.light,
      );

  void toggleTheme(bool isDark) {
    sharedPreferences.setBool('darkMode', isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
