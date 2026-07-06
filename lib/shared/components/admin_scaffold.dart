import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/components/admin_sidenav.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_event.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_bloc.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_state.dart';

class AdminScaffold extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const AdminScaffold({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        confirmText: 'Logout',
        confirmColor: AdminAppColors.primaryColor,
        surfaceColor: Colors.white,
        onConfirm: () {
          Navigator.pop(dialogContext);
          context.read<AdminAuthBloc>().add(AdminLogoutRequested());
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminProfileBloc, AdminProfileState>(
      builder: (context, state) {
        String adminName = '...';
        String roleName = '...';
        if (state is AdminProfileLoaded) {
          adminName = state.profile.fullName;
          roleName = state.profile.role;
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AdminAppColors.backgroundLight,
          drawer: Drawer(
            child: AdminSidenav(
              currentRoute: widget.currentRoute,
              adminName: adminName,
              roleName: roleName,
              onRouteSelected: (route) {
                Navigator.pop(context);
                context.go(route);
              },
              onLogout: () => _logout(context),
            ),
          ),
          body: Row(
            children: [
              // Sidebar Desktop view
              LayoutBuilder(
                builder: (context, constraints) {
                  if (MediaQuery.of(context).size.width > 900) {
                    return AdminSidenav(
                      currentRoute: widget.currentRoute,
                      adminName: adminName,
                      roleName: roleName,
                      onRouteSelected: (route) {
                        context.go(route);
                      },
                      onLogout: () => _logout(context),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Main Content Area
              Expanded(
                child: Column(
                  children: [
                    // Top Bar
                    _buildTopbar(context),

                    // Content area
                    Expanded(child: widget.child),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getPageTitle(String route) {
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
    }
    return '';
  }

  IconData _getPageIcon(String route) {
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
    }
    return Icons.circle;
  }

  Widget _buildTopbar(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drawer menu button for small screens
          LayoutBuilder(
            builder: (context, constraints) {
              if (MediaQuery.of(context).size.width <= 900) {
                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 24.sp,
                    color: const Color(0xFF1E1E2F),
                  ),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          if (MediaQuery.of(context).size.width <= 900) SizedBox(width: 8.w),

          Row(
            children: [
              Icon(
                _getPageIcon(widget.currentRoute),
                size: 20.sp,
                color: AdminAppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                _getPageTitle(widget.currentRoute),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Notifications Bell Icon
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EBFF),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: InkWell(
              onTap: () {
                CustomSnackBar.show(context, message: 'No new notifications');
              },
              child: Icon(
                Icons.notifications_none,
                color: AdminAppColors.primaryColor,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
