import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_bloc.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_event.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_state.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/registrations_table.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';

// Registrations Queue Card
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Section Title
                Text(
                  'PENDING APPLICATIONS',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: const Color(0xFF1E1E2F),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  // Total Pending Count
                  child: Text(
                    '${state.totalCount} Pending',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: AdminAppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (state.registrations.isEmpty)
            // Empty State
            Padding(
              padding: EdgeInsets.all(40.w),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 48.sp,
                      color: const Color(0xFFC4C4D4),
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
            // Registrations grid list
            RegistrationsTable(
              registrations: state.registrations,
              onReview: (reg) async {
                final refresh = await context.push(
                  RoutePaths.registrationDetails.replaceAll(':id', reg.id),
                );
                if (refresh == true && context.mounted) {
                  context.read<AdminRegistrationsBloc>().add(
                    const MarkRegistrationChangesRequested(),
                  );
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

            // Pagination
            AdminPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              onPageChanged: (newPage) {
                context.read<AdminRegistrationsBloc>().add(
                  ChangeRegistrationPageRequested(newPage),
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
