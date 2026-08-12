import 'package:flutter/material.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';

class AdminRouteHelper {
  static String getPageTitle(String route) {
    if (route.contains(RoutePaths.dashboard)) {
      return 'Dashboard';
    } else if (route.contains('/shops/')) {
      return 'Shop Details';
    } else if (route.contains(RoutePaths.shops)) {
      return 'Shop Management';
    } else if (route.contains('/customers/')) {
      return 'Customer Details Page';
    } else if (route.contains(RoutePaths.customers)) {
      return 'Customer Management';
    } else if (route.contains('/registrations/')) {
      return 'Shop Registration Details';
    } else if (route.contains(RoutePaths.registrations)) {
      return 'New Registrations';
    } else if (route.contains(RoutePaths.categories)) {
      return 'Categories';
    } else if (route.contains(RoutePaths.productConfig)) {
      return 'Product Configurations';
    } else if (route.contains(RoutePaths.settings)) {
      return 'Settings';
    } else if (route.contains(RoutePaths.profile)) {
      return 'Admin Profile';
    } else if (route.contains('/products/')) {
      return 'Product Details';
    } else if (route.contains(RoutePaths.products)) {
      return 'Product Management';
    } else if (route.contains('/orders/')) {
      return 'Order Details';
    } else if (route.contains(RoutePaths.orders)) {
      return 'Order Management';
    } else if (route.contains('/reviews/')) {
      return 'Review Details';
    } else if (route.contains(RoutePaths.reviews)) {
      return 'Reviews & Ratings';
    } else if (route.contains(RoutePaths.revenue)) {
      return 'Revenue';
    } else if (route.contains(RoutePaths.notifications)) {
      return 'Notifications';
    }
    return '';
  }

  static IconData getPageIcon(String route) {
    if (route.contains(RoutePaths.dashboard)) {
      return Icons.dashboard_outlined;
    } else if (route.contains('/shops/')) {
      return Icons.storefront_outlined;
    } else if (route.contains(RoutePaths.shops)) {
      return Icons.storefront_outlined;
    } else if (route.contains('/customers/')) {
      return Icons.people_alt_outlined;
    } else if (route.contains(RoutePaths.customers)) {
      return Icons.people_alt_outlined;
    } else if (route.contains('/registrations/')) {
      return Icons.assignment_outlined;
    } else if (route.contains(RoutePaths.registrations)) {
      return Icons.assignment_outlined;
    } else if (route.contains(RoutePaths.categories)) {
      return Icons.category_outlined;
    } else if (route.contains(RoutePaths.productConfig)) {
      return Icons.tune_outlined;
    } else if (route.contains(RoutePaths.settings)) {
      return Icons.settings_outlined;
    } else if (route.contains(RoutePaths.profile)) {
      return Icons.person_outline;
    } else if (route.contains('/products/')) {
      return Icons.inventory_2_outlined;
    } else if (route.contains(RoutePaths.products)) {
      return Icons.inventory_2_outlined;
    } else if (route.contains('/orders/')) {
      return Icons.assignment_outlined;
    } else if (route.contains(RoutePaths.orders)) {
      return Icons.shopping_cart_outlined;
    } else if (route.contains('/reviews/')) {
      return Icons.rate_review_outlined;
    } else if (route.contains(RoutePaths.reviews)) {
      return Icons.rate_review_outlined;
    } else if (route.contains(RoutePaths.revenue)) {
      return Icons.bar_chart_outlined;
    } else if (route.contains(RoutePaths.notifications)) {
      return Icons.notifications_none_outlined;
    }
    return Icons.circle;
  }
}
