import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/components/admin_sidenav.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_event.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_bloc.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_state.dart';
import 'package:street_cart/core/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_bloc.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_state.dart';
import 'package:street_cart/core/router/admin/admin_route_helper.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _logout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        confirmText: 'Logout',
        confirmColor: AdminAppColors.primaryColor,
        surfaceColor: isDark ? AdminAppColors.darkSurface : Colors.white,
        onConfirm: () async {
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid != null) {
            await NotificationService.instance.deleteTokenFromFirestore(
              uid,
              'admin',
            );
          }
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext);
            context.read<AdminAuthBloc>().add(AdminLogoutRequested());
          }
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          backgroundColor: isDark
              ? AdminAppColors.darkBackground
              : AdminAppColors.backgroundLight,
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
    return AdminRouteHelper.getPageTitle(route);
  }

  IconData _getPageIcon(String route) {
    return AdminRouteHelper.getPageIcon(route);
  }

  Widget _buildTopbar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AdminAppColors.darkBorder : const Color(0xFFF0EFF5),
            width: 1.5,
          ),
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
                    color: isDark
                        ? AdminAppColors.darkTextPrimary
                        : AdminAppColors.textPrimary,
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
              if (widget.currentRoute.contains(RoutePaths.notifications) ||
                  widget.currentRoute.contains('/shops/') ||
                  widget.currentRoute.contains('/orders/') ||
                  widget.currentRoute.contains('/registrations/') ||
                  widget.currentRoute.contains('/reviews/') ||
                  widget.currentRoute.contains('/customers/'))
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 20.sp,
                      color: isDark
                          ? AdminAppColors.darkTextPrimary
                          : AdminAppColors.textPrimary,
                    ),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(RoutePaths.dashboard);
                      }
                    },
                  ),
                ),
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
                  color: isDark
                      ? AdminAppColors.darkTextPrimary
                      : AdminAppColors.textPrimary,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Notifications Bell Icon
          BlocBuilder<AdminNotificationsBloc, AdminNotificationsState>(
            builder: (context, state) {
              final unreadCount = state.unreadCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AdminAppColors.primaryColor.withValues(alpha: 0.15)
                          : const Color(0xFFF4EBFF),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.push(RoutePaths.notifications);
                      },
                      child: Icon(
                        Icons.notifications_none,
                        color: AdminAppColors.primaryColor,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      top: -4.r,
                      right: -4.r,
                      child: Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: const BoxDecoration(
                          color: AdminAppColors.errorColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.r,
                          minHeight: 16.r,
                        ),
                        child: Center(
                          child: Text(
                            unreadCount > 9 ? '9+' : '$unreadCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
