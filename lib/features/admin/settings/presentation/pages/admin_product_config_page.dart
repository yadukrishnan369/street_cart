import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_event.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_state.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/colors_tab.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/size_groups_tab.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/shimmer/admin_product_config_shimmer.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/config_tab_selector.dart';

// Admin Product Config Page
class AdminProductConfigPage extends StatelessWidget {
  const AdminProductConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AdminProductConfigBloc>()..add(LoadProductConfig()),
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AdminAppColors.darkBackground
            : AdminAppColors.backgroundLight,
        body: BlocConsumer<AdminProductConfigBloc, AdminProductConfigState>(
          listener: (context, state) {
            if (state is ProductConfigActionSuccess) {
              CustomSnackBar.show(context, message: state.message);
            } else if (state is ProductConfigActionFailure) {
              CustomSnackBar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            if (state is ProductConfigLoading) {
              // Product Config Shimmer
              return const AdminProductConfigShimmer();
            }
            // Error State
            if (state is ProductConfigLoadFailure) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.sp,
                      color: AdminAppColors.errorColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load configuration',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AdminAppColors.darkTextPrimary
                            : AdminAppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark
                            ? AdminAppColors.darkTextSecondary
                            : const Color(0xFF8A8A9E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AdminProductConfigBloc>().add(
                          LoadProductConfig(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminAppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  right: 150.w,
                  left: 80,
                  top: 32.h,
                  bottom: 40.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 4.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              size: 16.sp,
                              color: AdminAppColors.primaryColor,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Go Back',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AdminAppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AdminAppColors.primaryColor.withValues(
                                    alpha: 0.15,
                                  )
                                : const Color(0xFFF4EBFF),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            color: AdminAppColors.primaryColor,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              'Product Configurations',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AdminAppColors.darkTextPrimary
                                    : AdminAppColors.textPrimary,
                              ),
                            ),
                            // Subtitle
                            Text(
                              'Manage global colors and size groups for products.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AdminAppColors.darkTextSecondary
                                    : const Color(0xFF8A8A9E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    ConfigTabSelector(
                      isColorsTab: state.isColorsTab,
                      onTabChanged: (val) {
                        context.read<AdminProductConfigBloc>().add(
                          ChangeTab(isColorsTab: val),
                        );
                      },
                    ),
                    SizedBox(height: 32.h),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: state.isColorsTab
                          ? const ColorsTab(key: ValueKey('colors'))
                          : const SizeGroupsTab(key: ValueKey('sizes')),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
