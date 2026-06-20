import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/registrations_table.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/registrations_pagination.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_bloc.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_event.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_state.dart';

class AdminRegistrationsPage extends StatefulWidget {
  const AdminRegistrationsPage({super.key});

  @override
  State<AdminRegistrationsPage> createState() => _AdminRegistrationsPageState();
}

class _AdminRegistrationsPageState extends State<AdminRegistrationsPage> {
  int _currentPage = 1;
  static const int _perPage = 6;
  bool _anyChanges = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminRegistrationsBloc>()
        ..add(
          LoadPendingRegistrationsRequested(
            page: _currentPage,
            limit: _perPage,
          ),
        ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocBuilder<AdminRegistrationsBloc, AdminRegistrationsState>(
            builder: (context, state) {
              if (state is AdminRegistrationsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF7B2CBF),
                  ),
                );
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
                            _buildBackRow(context),
                            SizedBox(height: 24.h),
                            // Main Application Queue Container
                            _buildApplicationQueue(context, state),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is AdminRegistrationsLoadFailure) {
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
                      ElevatedButton(
                        onPressed: () {
                          context.read<AdminRegistrationsBloc>().add(
                            LoadPendingRegistrationsRequested(
                              page: _currentPage,
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

  Widget _buildBackRow(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(_anyChanges),
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

  Widget _buildApplicationQueue(
    BuildContext context,
    AdminRegistrationsLoadSuccess state,
  ) {
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
          // Header inside card
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

          // Table structure
          if (state.registrations.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      color: const Color(0xFF8A8A9E),
                      size: 64.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No pending applications now',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8A8A9E),
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
                  _anyChanges = true;
                  context.read<AdminRegistrationsBloc>().add(
                    LoadPendingRegistrationsRequested(
                      page: _currentPage,
                      limit: _perPage,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 24.h),
            RegistrationsPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              onPageChanged: (newPage) => _onPageChanged(context, newPage),
            ),
            SizedBox(height: 24.h),
          ],
        ],
      ),
    );
  }

  void _onPageChanged(BuildContext context, int newPage) {
    setState(() {
      _currentPage = newPage;
    });
    context.read<AdminRegistrationsBloc>().add(
      LoadPendingRegistrationsRequested(page: _currentPage, limit: _perPage),
    );
  }
}
