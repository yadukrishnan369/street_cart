import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/shimmer/admin_registrations_page_shimmer.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_bloc.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_event.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_state.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/registrations_queue_card.dart';

// Admin Registrations Page
class AdminRegistrationsPage extends StatelessWidget {
  static const int _perPage = 6;

  const AdminRegistrationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminRegistrationsBloc>()
        ..add(
          const LoadPendingRegistrationsRequested(page: 1, limit: _perPage),
        ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocBuilder<AdminRegistrationsBloc, AdminRegistrationsState>(
            builder: (context, state) {
              if (state is AdminRegistrationsLoading) {
                // Admin Registrations Page Shimmer
                return const AdminRegistrationsPageShimmer();
              } else if (state is AdminRegistrationsLoadSuccess) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 32.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBackRow(context, state.anyChanges),
                            SizedBox(height: 24.h),
                            // Registrations Queue Card
                            RegistrationsQueueCard(
                              state: state,
                              currentPage: state.currentPage,
                              limit: _perPage,
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is AdminRegistrationsLoadFailure) {
                // Error State
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load registrations:\n${state.message}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Button for Reload
                      ElevatedButton(
                        onPressed: () {
                          context.read<AdminRegistrationsBloc>().add(
                            LoadPendingRegistrationsRequested(
                              page: state.currentPage,
                              limit: _perPage,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B2CBF),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBackRow(BuildContext context, bool anyChanges) {
    return InkWell(
      onTap: () => context.pop(anyChanges),
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
            'Back to Dashboard',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AdminAppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
