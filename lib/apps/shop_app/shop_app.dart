import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/splash/presentation/pages/shop_splash_page.dart';
import 'package:street_cart/di/dependency_injection.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ShopAuthBloc>(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844), // iPhone 13/14 size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Street Cart Seller',
            theme: ThemeData(
              primaryColor: ShopAppColors.primary,
              scaffoldBackgroundColor: ShopAppColors.background,
              colorScheme: ColorScheme.fromSeed(
                seedColor: ShopAppColors.primary,
                primary: ShopAppColors.primary,
                secondary: ShopAppColors.border,
              ),
              appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
            ),
            home: const ShopSplashPage(),
          );
        },
      ),
    );
  }
}
