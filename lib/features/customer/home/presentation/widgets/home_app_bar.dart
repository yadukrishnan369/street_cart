import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/location/presentation/pages/location_permission_page.dart';

// Home App Bar
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoading;
  final bool hasLocation;
  final String? address;

  const HomeAppBar({
    super.key,
    required this.isLoading,
    required this.hasLocation,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: isLoading
          ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : GestureDetector(
              onTap: hasLocation
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LocationPermissionPage(
                            isProfileCompleted: true,
                          ),
                        ),
                      );
                    },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: CustomerAppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivering to',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isDark
                              ? CustomerAppColors.darkTextSecondary
                              : CustomerAppColors.textSecondary,
                        ),
                      ),
                      Text(
                        hasLocation
                            ? (address ?? 'Unknown Location')
                            : 'Select precise location',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: hasLocation
                              ? (isDark
                                    ? CustomerAppColors.darkTextPrimary
                                    : CustomerAppColors.textPrimary)
                              : CustomerAppColors.primary,
                          decoration: hasLocation
                              ? TextDecoration.none
                              : TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: isDark
                ? CustomerAppColors.primary
                : CustomerAppColors.textPrimary,
          ),
          onPressed: () {
            // notification
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
