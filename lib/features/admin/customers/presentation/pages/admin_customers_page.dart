import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/debouncer.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_event.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_state.dart';
import 'package:street_cart/features/admin/customers/presentation/widgets/customers_table_container.dart';
import 'package:street_cart/features/admin/customers/presentation/widgets/shimmer/admin_customers_page_shimmer.dart';
import 'package:street_cart/features/admin/customers/presentation/widgets/customer_filter_buttons.dart';

// Admin Customers Page
class AdminCustomersPage extends StatefulWidget {
  const AdminCustomersPage({super.key});

  @override
  State<AdminCustomersPage> createState() => _AdminCustomersPageState();
}

class _AdminCustomersPageState extends State<AdminCustomersPage> {
  static const int _perPage = 7;
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  AdminCustomersLoaded? _lastLoadedState;

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AdminCustomersBloc>()
            ..add(LoadAdminCustomers(page: 1, limit: _perPage)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocListener<AdminCustomersBloc, AdminCustomersState>(
            listener: (context, state) {
              if (state is AdminCustomersActionSuccess) {
                CustomSnackBar.show(context, message: state.message);
              } else if (state is AdminCustomersError) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            child: BlocBuilder<AdminCustomersBloc, AdminCustomersState>(
              builder: (context, state) {
                if (state is AdminCustomersLoaded) {
                  _lastLoadedState = state;
                }
                if (state is AdminCustomersLoading &&
                    _lastLoadedState == null) {
                  // Loading Shimmer
                  return const AdminCustomersPageShimmer();
                }
                if (state is AdminCustomersInitial) {
                  return const AdminCustomersPageShimmer();
                }
                if (_lastLoadedState == null) {
                  if (state is AdminCustomersError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Failed to load customers:\n${state.message}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AdminAppColors.errorColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<AdminCustomersBloc>().add(
                                LoadAdminCustomers(page: 1, limit: _perPage),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AdminAppColors.primaryColor,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const AdminCustomersPageShimmer();
                }

                final loadedState = _lastLoadedState!;
                final isLoading = state is AdminCustomersLoading;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 40.w : 20.w,
                        vertical: 32.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top filter options chips
                          CustomerFilterButtons(
                            currentFilter: loadedState.statusFilter,
                          ),
                          SizedBox(height: 24.h),
                          // Customers Table
                          CustomersTableContainer(
                            state: loadedState,
                            isWide: isWide,
                            isLoading: isLoading,
                            searchController: _searchController,
                            debouncer: _debouncer,
                            perPage: _perPage,
                            onPageChanged: (page) {
                              context.read<AdminCustomersBloc>().add(
                                LoadAdminCustomers(page: page, limit: _perPage),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
