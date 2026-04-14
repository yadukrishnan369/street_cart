import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/splash/presentation/pages/splash_page.dart';
import 'package:street_cart/core/theme/customer/Customer_app_colors.dart';
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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Street Cart',
            theme: ThemeData(
              primaryColor: CustomerAppColors.primary,
              scaffoldBackgroundColor: CustomerAppColors.background,
              fontFamily: 'Inter',
              colorScheme: ColorScheme.fromSeed(
                seedColor: CustomerAppColors.primary,
              ),
            ),
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
