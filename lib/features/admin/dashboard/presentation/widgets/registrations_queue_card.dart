import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_bloc.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_event.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_state.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_ui_cubit.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/registrations_table.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';

class RegistrationsQueueCard extends StatelessWidget {
  final AdminRegistrationsLoadSuccess state;
  final int currentPage;
  final int limit;

  const RegistrationsQueueCard({
    super.key,
    required this.state,
    required this.currentPage,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E2F).withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Application Pendings',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1E2F),
                  ),
                ),
                Text(
                  'Showing ${state.totalCount} pending applications',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8A8A9E),
                  ),
                ),
              ],
            ),
          ),
          if (state.registrations.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      color: AdminAppColors.primaryColor,
                      size: 64.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No pending applications now',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AdminAppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            RegistrationsTable(
              registrations: state.registrations,
              onReview: (reg) async {
                final refresh = await context.push(
                  RoutePaths.registrationDetails.replaceAll(':id', reg.id),
                );
                if (refresh == true && context.mounted) {
                  context.read<AdminRegistrationsUiCubit>().markChanges();
                  context.read<AdminRegistrationsBloc>().add(
                    LoadPendingRegistrationsRequested(
                      page: currentPage,
                      limit: limit,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 24.h),
            AdminPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              onPageChanged: (newPage) {
                context.read<AdminRegistrationsUiCubit>().changePage(newPage);
                context.read<AdminRegistrationsBloc>().add(
                  LoadPendingRegistrationsRequested(
                    page: newPage,
                    limit: limit,
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
          ],
        ],
      ),
    );
  }
}
