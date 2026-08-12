import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/splash/presentation/pages/splash_page.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/theme_cubit.dart';
import 'package:street_cart/core/services/notification_service.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_bloc.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_event.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_state.dart';
import 'package:street_cart/features/customer/orders/presentation/pages/order_details_page.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_product_detail_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              return BlocListener<AuthBloc, AuthState>(
                listenWhen: (previous, current) =>
                    previous is! AuthSuccess && current is AuthSuccess,
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                    if (uid.isNotEmpty) {
                      NotificationService.instance.saveTokenToFirestore(
                        uid,
                        'customer',
                      );
                      context.read<CustomerNotificationsBloc>().add(
                        LoadNotificationsEvent(uid),
                      );
                    }
                  }
                },
                child: Builder(
                  builder: (context) {
                    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                    if (uid.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        NotificationService.instance.saveTokenToFirestore(
                          uid,
                          'customer',
                        );
                        context.read<CustomerNotificationsBloc>().add(
                          LoadNotificationsEvent(uid),
                        );
                      });
                    }
                    return BlocListener<
                      CustomerNotificationsBloc,
                      CustomerNotificationsState
                    >(
                      listenWhen: (previous, current) =>
                          previous.selectedOrder != current.selectedOrder ||
                          previous.selectedProduct != current.selectedProduct ||
                          previous.status != current.status,
                      listener: (context, state) {
                        if (state.status ==
                                CustomerNotificationsStatus.orderLoaded &&
                            state.selectedOrder != null) {
                          final notifId = state.selectedNotificationId;
                          NotificationService.instance.navigatorKey.currentState
                              ?.push(
                                MaterialPageRoute(
                                  builder: (_) => OrderDetailsPage(
                                    order: state.selectedOrder!,
                                  ),
                                ),
                              )
                              .then((_) {
                                if (notifId != null) {
                                  context.read<CustomerNotificationsBloc>().add(
                                    MarkAsReadEvent(
                                      userId: state.userId,
                                      notificationId: notifId,
                                    ),
                                  );
                                }
                              });
                          context.read<CustomerNotificationsBloc>().add(
                            const ClearSelectedOrderEvent(),
                          );
                        } else if (state.status ==
                                CustomerNotificationsStatus.productLoaded &&
                            state.selectedProduct != null &&
                            state.selectedShop != null) {
                          final notifId = state.selectedNotificationId;
                          NotificationService.instance.navigatorKey.currentState
                              ?.push(
                                MaterialPageRoute(
                                  builder: (_) => CustomerProductDetailPage(
                                    product: state.selectedProduct!,
                                    shop: state.selectedShop!,
                                  ),
                                ),
                              )
                              .then((_) {
                                if (notifId != null) {
                                  context.read<CustomerNotificationsBloc>().add(
                                    MarkAsReadEvent(
                                      userId: state.userId,
                                      notificationId: notifId,
                                    ),
                                  );
                                }
                              });
                          context.read<CustomerNotificationsBloc>().add(
                            const ClearSelectedProductEvent(),
                          );
                        } else if ((state.status ==
                                    CustomerNotificationsStatus.orderError ||
                                state.status ==
                                    CustomerNotificationsStatus.productError) &&
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
                          scaffoldBackgroundColor:
                              CustomerAppColors.darkBackground,
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
