import 'package:go_router/go_router.dart';
import 'package:street_cart/features/admin/auth/presentation/pages/admin_login_page.dart';
import 'package:street_cart/features/admin/auth/presentation/pages/admin_forgot_password_page.dart';
import 'package:street_cart/shared/components/admin_scaffold.dart';
import 'package:street_cart/features/admin/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:street_cart/features/admin/dashboard/presentation/pages/admin_registrations_page.dart';
import 'package:street_cart/features/admin/dashboard/presentation/pages/admin_registration_details_page.dart';
import 'package:street_cart/features/admin/shops/presentation/pages/admin_shop_page.dart';
import 'package:street_cart/features/admin/shops/presentation/pages/admin_shop_detail_page.dart';
import 'package:street_cart/features/admin/customers/presentation/pages/admin_customers_page.dart';
import 'package:street_cart/features/admin/customers/presentation/pages/admin_customer_detail_page.dart';
import 'package:street_cart/features/admin/settings/presentation/pages/admin_settings_page.dart';
import 'package:street_cart/features/admin/settings/presentation/pages/admin_categories_page.dart';
import 'package:street_cart/features/admin/settings/presentation/pages/admin_product_config_page.dart';
import 'package:street_cart/features/admin/splash/presentation/pages/admin_splash_page.dart';
import 'package:street_cart/features/admin/profile/presentation/pages/admin_profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_bloc.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_event.dart';
import 'package:street_cart/features/admin/products/presentation/pages/admin_products_page.dart';
import 'package:street_cart/features/admin/products/presentation/pages/admin_product_detail_page.dart';
import 'package:street_cart/features/admin/orders/presentation/pages/admin_orders_page.dart';
import 'package:street_cart/features/admin/orders/presentation/pages/admin_order_detail_page.dart';
import 'package:street_cart/features/admin/reviews/presentation/pages/admin_reviews_page.dart';
import 'package:street_cart/features/admin/reviews/presentation/pages/admin_review_detail_page.dart';
import 'route_paths.dart';

class AdminRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: RoutePaths.splash,
      builder: (context, state) => const AdminSplashPage(),
    ),
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => const AdminLoginPage(),
    ),
    GoRoute(
      path: RoutePaths.forgotPassword,
      builder: (context, state) => const AdminForgotPasswordPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (context) => sl<AdminProfileBloc>()..add(LoadAdminProfile()),
          child: AdminScaffold(currentRoute: state.uri.path, child: child),
        );
      },
      routes: [
        GoRoute(
          path: RoutePaths.categories,
          builder: (context, state) => const AdminCategoriesPage(),
        ),
        GoRoute(
          path: RoutePaths.productConfig,
          builder: (context, state) => const AdminProductConfigPage(),
        ),
        GoRoute(
          path: RoutePaths.dashboard,
          builder: (context, state) => const AdminDashboardPage(),
        ),
        GoRoute(
          path: RoutePaths.registrations,
          builder: (context, state) => const AdminRegistrationsPage(),
        ),
        GoRoute(
          path: RoutePaths.registrationDetails,
          builder: (context, state) {
            final shopId = state.pathParameters['id'] ?? '';
            return AdminRegistrationDetailsPage(shopId: shopId);
          },
        ),
        GoRoute(
          path: RoutePaths.shops,
          builder: (context, state) => const AdminShopPage(),
        ),
        GoRoute(
          path: RoutePaths.shopDetails,
          builder: (context, state) {
            final shopId = state.pathParameters['id'] ?? '';
            return AdminShopDetailPage(shopId: shopId);
          },
        ),
        GoRoute(
          path: RoutePaths.customers,
          builder: (context, state) => const AdminCustomersPage(),
        ),
        GoRoute(
          path: RoutePaths.customerDetails,
          builder: (context, state) {
            final customerId = state.pathParameters['id'] ?? '';
            return AdminCustomerDetailPage(customerId: customerId);
          },
        ),
        GoRoute(
          path: RoutePaths.settings,
          builder: (context, state) => const AdminSettingsPage(),
        ),
        GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) => const AdminProfilePage(),
        ),
        GoRoute(
          path: RoutePaths.products,
          builder: (context, state) => const AdminProductsPage(),
        ),
        GoRoute(
          path: RoutePaths.productDetails,
          builder: (context, state) {
            final productId = state.pathParameters['id'] ?? '';
            return AdminProductDetailPage(productId: productId);
          },
        ),
        GoRoute(
          path: RoutePaths.orders,
          builder: (context, state) => const AdminOrdersPage(),
        ),
        GoRoute(
          path: RoutePaths.orderDetails,
          builder: (context, state) {
            final orderId = state.pathParameters['id'] ?? '';
            return AdminOrderDetailPage(orderId: orderId);
          },
        ),
        GoRoute(
          path: RoutePaths.reviews,
          builder: (context, state) => const AdminReviewsPage(),
        ),
        GoRoute(
          path: RoutePaths.reviewDetails,
          builder: (context, state) {
            final reviewId = state.pathParameters['id'] ?? '';
            return AdminReviewDetailPage(reviewId: reviewId);
          },
        ),
      ],
    ),
  ];
}
