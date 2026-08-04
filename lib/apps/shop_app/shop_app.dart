import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_theme_cubit.dart';
import 'package:street_cart/features/shop/splash/presentation/pages/shop_splash_page.dart';
import 'shop_providers.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShopProviders(
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ShopThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Street Cart Seller',
                themeMode: themeMode,
                theme: ThemeData(
                  brightness: Brightness.light,
                  primaryColor: ShopAppColors.primary,
                  scaffoldBackgroundColor: ShopAppColors.background,
                  cardColor: ShopAppColors.surface,
                  dividerColor: ShopAppColors.border,
                  fontFamily: 'Inter',
                  appBarTheme: const AppBarTheme(
                    backgroundColor: ShopAppColors.background,
                    foregroundColor: ShopAppColors.textPrimary,
                    elevation: 0,
                    centerTitle: true,
                  ),
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: ShopAppColors.primary,
                    brightness: Brightness.light,
                    primary: ShopAppColors.primary,
                    secondary: ShopAppColors.border,
                    surface: ShopAppColors.surface,
                  ),
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: ShopAppColors.primary,
                  scaffoldBackgroundColor: ShopAppColors.darkBackground,
                  cardColor: ShopAppColors.darkSurface,
                  dividerColor: ShopAppColors.darkBorder,
                  fontFamily: 'Inter',
                  appBarTheme: const AppBarTheme(
                    backgroundColor: ShopAppColors.darkBackground,
                    foregroundColor: ShopAppColors.darkTextPrimary,
                    elevation: 0,
                    centerTitle: true,
                  ),
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: ShopAppColors.primary,
                    brightness: Brightness.dark,
                    primary: ShopAppColors.primary,
                    secondary: ShopAppColors.darkBorder,
                    surface: ShopAppColors.darkSurface,
                  ),
                ),
                home: const ShopSplashPage(),
              );
            },
          );
        },
      ),
    );
  }
}
