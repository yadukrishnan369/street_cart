import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_theme_cubit.dart';
import 'package:street_cart/features/shop/splash/presentation/pages/shop_splash_page.dart';
import 'package:street_cart/core/services/notification_service.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_bloc.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_event.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_state.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_order_details_page.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              return BlocListener<ShopAuthBloc, ShopAuthState>(
                listenWhen: (previous, current) =>
                    previous.status != ShopAuthStatus.authenticated &&
                    current.status == ShopAuthStatus.authenticated,
                listener: (context, state) {
                  if (state.status == ShopAuthStatus.authenticated) {
                    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                    if (uid.isNotEmpty) {
                      NotificationService.instance.requestPermissions();
                      NotificationService.instance.saveTokenToFirestore(
                        uid,
                        'shop',
                      );
                      context.read<ShopNotificationsBloc>().add(
                        LoadShopNotificationsEvent(uid),
                      );
                    }
                  }
                },
                child: Builder(
                  builder: (context) {
                    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                    if (uid.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        NotificationService.instance.requestPermissions();
                        NotificationService.instance.saveTokenToFirestore(
                          uid,
                          'shop',
                        );
                        context.read<ShopNotificationsBloc>().add(
                          LoadShopNotificationsEvent(uid),
                        );
                      });
                    }
                    return BlocListener<
                      ShopNotificationsBloc,
                      ShopNotificationsState
                    >(
                      listenWhen: (previous, current) =>
                          previous.selectedOrder != current.selectedOrder ||
                          previous.status != current.status,
                      listener: (context, state) {
                        if (state.status ==
                                ShopNotificationsStatus.orderLoaded &&
                            state.selectedOrder != null) {
                          final authState = context.read<ShopAuthBloc>().state;
                          final shopId = authState.shop?.uid ?? '';
                          NotificationService.instance.navigatorKey.currentState
                              ?.push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: sl<ShopOrdersBloc>(),
                                    child: ShopOrderDetailsPage(
                                      order: state.selectedOrder!,
                                      shopId: shopId,
                                      isCancelledView: false,
                                    ),
                                  ),
                                ),
                              );
                          context.read<ShopNotificationsBloc>().add(
                            const ClearShopSelectedOrderEvent(),
                          );
                        } else if (state.status ==
                                ShopNotificationsStatus.orderError &&
                            state.errorMessage != null) {
                          CustomSnackBar.show(
                            NotificationService
                                .instance
                                .navigatorKey
                                .currentContext!,
                            message: state.errorMessage!,
                            isError: true,
                          );
                        }
                      },
                      child: MaterialApp(
                        navigatorKey: NotificationService.instance.navigatorKey,
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
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
