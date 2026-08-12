import 'package:go_router/go_router.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_state.dart';
import 'package:street_cart/core/services/notification_service.dart';
import 'admin_routes.dart';
import 'route_paths.dart';
import 'router_refresh.dart';

class AppRouter {
  final AdminAuthBloc authBloc;
  late final GoRouterRefreshStream refreshStream;

  AppRouter(this.authBloc) {
    refreshStream = GoRouterRefreshStream(authBloc.stream);
  }

  late final GoRouter router = GoRouter(
    navigatorKey: NotificationService.instance.navigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: refreshStream,
    redirect: (context, state) {
      final authState = authBloc.state;
      final path = state.uri.path;
      final isLoggingIn = path == RoutePaths.login;
      final isSplash = path == RoutePaths.splash;

      if (authState is AdminAuthInitial) {
        if (!isSplash) {
          return RoutePaths.splash;
        }
        return null;
      }

      if (authState is AdminAuthLoading) {
        return null;
      }

      if (authState is AdminAuthSuccess) {
        if (isLoggingIn || isSplash) {
          return RoutePaths.dashboard;
        }
      } else if (authState is AdminUnauthenticated ||
          authState is AdminAuthFailure) {
        final isForgotPassword = path == RoutePaths.forgotPassword;
        if (!isLoggingIn && !isForgotPassword) {
          return RoutePaths.login;
        }
      }
      return null;
    },
    routes: AdminRoutes.routes,
  );

  void dispose() {
    refreshStream.dispose();
  }
}
