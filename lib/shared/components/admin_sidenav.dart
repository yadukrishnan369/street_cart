import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';

// Admin Side nav
class AdminSidenav extends StatelessWidget {
  final String currentRoute;
  final String adminName;
  final String roleName;
  final Function(String route) onRouteSelected;
  final VoidCallback? onLogout;

  const AdminSidenav({
    super.key,
    required this.currentRoute,
    required this.adminName,
    required this.roleName,
    required this.onRouteSelected,
    this.onLogout,
  });
  // Get Admin Initial Name
  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'AD';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      final first = parts[0];
      final second = parts[1];
      if (first.isNotEmpty && second.isNotEmpty) {
        return (first[0] + second[0]).toUpperCase();
      }
    }
    if (name.trim().length > 1) {
      return name.trim().substring(0, 2).toUpperCase();
    }
    return name.trim().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(adminName);

    return Container(
      width: 260.w,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFF0EFF5), width: 1.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Logo & App Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D5FA),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: AppLogo(
                    backgroundColor: AdminAppColors.primaryColor,
                    logoColor: AdminAppColors.surfaceWhite,
                    size: 36,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Street Cart',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E1E2F),
                      ),
                    ),
                    Text(
                      'ADMIN PORTAL',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: const Color(0xFF8A8A9E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Navigation List
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    icon: Icons.grid_view_outlined,
                    label: 'Dashboard',
                    route: '/dashboard',
                  ),
                  _buildMenuItem(
                    icon: Icons.storefront_outlined,
                    label: 'Shops',
                    route: '/shops',
                  ),
                  _buildMenuItem(
                    icon: Icons.people_outline,
                    label: 'Customers',
                    route: '/customers',
                  ),
                  _buildMenuItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Products',
                    route: '/products',
                  ),
                  _buildMenuItem(
                    icon: Icons.shopping_cart_outlined,
                    label: 'Orders',
                    route: '/orders',
                  ),
                  _buildMenuItem(
                    icon: Icons.rate_review_outlined,
                    label: 'Reviews',
                    route: '/reviews',
                  ),
                  _buildMenuItem(
                    icon: Icons.bar_chart_outlined,
                    label: 'Revenue',
                    route: '/revenue',
                  ),
                  SizedBox(height: 12.h),
                  const Divider(color: Color(0xFFF0EFF5), height: 1),
                  SizedBox(height: 12.h),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    route: '/settings',
                  ),
                ],
              ),
            ),
          ),

          // Bottom profile badge
          const Divider(color: Color(0xFFF0EFF5), height: 1),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onRouteSelected('/profile'),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: AdminAppColors.primaryColor,
                          child: Text(
                            initials,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                adminName,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E1E2F),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                roleName,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF8A8A9E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (onLogout != null)
                  IconButton(
                    icon: Icon(
                      Icons.logout_outlined,
                      color: const Color(0xFF8A8A9E),
                      size: 18.sp,
                    ),
                    onPressed: onLogout,
                    tooltip: 'Logout',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String route,
  }) {
    final isSelected = currentRoute == route;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: InkWell(
        onTap: () => onRouteSelected(route),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF4EBFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AdminAppColors.primaryColor
                    : const Color(0xFF6C6C80),
                size: 20.sp,
              ),
              SizedBox(width: 16.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AdminAppColors.primaryColor
                      : const Color(0xFF6C6C80),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
