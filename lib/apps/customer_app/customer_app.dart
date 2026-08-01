import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/splash/presentation/pages/splash_page.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/theme_cubit.dart';
import 'customer_providers.dart';

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomerProviders(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Street Cart',
                themeMode: themeMode,
                theme: ThemeData(
                  brightness: Brightness.light,
                  primaryColor: CustomerAppColors.primary,
                  scaffoldBackgroundColor: CustomerAppColors.background,
                  cardColor: CustomerAppColors.surface,
                  dividerColor: CustomerAppColors.border,
                  fontFamily: 'Inter',
                  appBarTheme: const AppBarTheme(
                    backgroundColor: CustomerAppColors.background,
                    foregroundColor: CustomerAppColors.textPrimary,
                    elevation: 0,
                  ),
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: CustomerAppColors.primary,
                    brightness: Brightness.light,
                    surface: CustomerAppColors.surface,
                  ),
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: CustomerAppColors.primary,
                  scaffoldBackgroundColor: CustomerAppColors.darkBackground,
                  cardColor: CustomerAppColors.darkSurface,
                  dividerColor: CustomerAppColors.darkBorder,
                  fontFamily: 'Inter',
                  appBarTheme: const AppBarTheme(
                    backgroundColor: CustomerAppColors.darkBackground,
                    foregroundColor: CustomerAppColors.darkTextPrimary,
                    elevation: 0,
                  ),
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: CustomerAppColors.primary,
                    brightness: Brightness.dark,
                    surface: CustomerAppColors.darkSurface,
                  ),
                ),
                home: const SplashPage(),
              );
            },
          );
        },
      ),
    );
  }
}
