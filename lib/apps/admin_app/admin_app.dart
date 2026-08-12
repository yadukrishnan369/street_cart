import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/router/admin/app_router.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_state.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_bloc.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_event.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_theme_cubit.dart';
import 'package:street_cart/core/services/notification_service.dart';

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  late final AdminAuthBloc _authBloc;
  late final AdminNotificationsBloc _notificationsBloc;
  late final AppRouter _appRouter;
  StreamSubscription? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AdminAuthBloc>();
    _notificationsBloc = sl<AdminNotificationsBloc>();
    _appRouter = AppRouter(_authBloc);

    // Initial setup if already logged in
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null && currentUserId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NotificationService.instance.requestPermissions();
        NotificationService.instance.saveTokenToFirestore(
          currentUserId,
          'admin',
        );
        _notificationsBloc.add(LoadAdminNotificationsEvent(currentUserId));
      });
    }

    // When the admin is authenticated, dispatch LoadAdminNotificationsEvent with the UID
    _authSubscription = _authBloc.stream.listen((state) {
      if (state is AdminAuthSuccess) {
        final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
        if (uid.isNotEmpty) {
          NotificationService.instance.requestPermissions();
          NotificationService.instance.saveTokenToFirestore(uid, 'admin');
          _notificationsBloc.add(LoadAdminNotificationsEvent(uid));
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _notificationsBloc.close();
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: sl<AdminThemeCubit>()),
        BlocProvider.value(value: _notificationsBloc),
      ],
      child: ScreenUtilInit(
        designSize: const Size(1280, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<AdminThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: 'Street Cart Admin',
                debugShowCheckedModeBanner: false,
                routerConfig: _appRouter.router,
                themeMode: themeMode,
                theme: ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.purple,
                  scaffoldBackgroundColor: const Color(0xFFF6F6F9),
                  primaryColor: AdminAppColors.primaryColor,
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primarySwatch: Colors.purple,
                  scaffoldBackgroundColor: AdminAppColors.darkBackground,
                  primaryColor: AdminAppColors.primaryColor,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
