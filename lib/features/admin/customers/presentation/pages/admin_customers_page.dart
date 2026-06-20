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

class AdminCustomersPage extends StatefulWidget {
  const AdminCustomersPage({super.key});

  @override
  State<AdminCustomersPage> createState() => _AdminCustomersPageState();
}

class _AdminCustomersPageState extends State<AdminCustomersPage> {
  int _currentPage = 1;
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
            ..add(LoadAdminCustomers(page: _currentPage, limit: _perPage)),
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
                                LoadAdminCustomers(
                                  page: _currentPage,
                                  limit: _perPage,
                                ),
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
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AdminAppColors.primaryColor,
                    ),
                  );
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
                          // Filters for All Customers, Active, Blocked
                          _buildFilterButtons(
                            context,
                            loadedState.statusFilter,
                          ),
                          SizedBox(height: 24.h),

                          // Table Container Component
                          CustomersTableContainer(
                            state: loadedState,
                            isWide: isWide,
                            isLoading: isLoading,
                            searchController: _searchController,
                            debouncer: _debouncer,
                            currentPage: _currentPage,
                            perPage: _perPage,
                            onPageChanged: (page) {
                              setState(() => _currentPage = page);
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

  Widget _buildFilterButtons(BuildContext context, String currentFilter) {
    final filters = ['All', 'Active', 'Blocked'];
    final labels = {
      'All': 'All Customers',
      'Active': 'Active',
      'Blocked': 'Blocked',
    };

    return Row(
      children: filters.map((filter) {
        final isSelected = currentFilter == filter;
        return Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: ChoiceChip(
            label: Text(
              labels[filter]!,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF6C6C80),
              ),
            ),
            selected: isSelected,
            selectedColor: AdminAppColors.primaryColor,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.r),
              side: BorderSide(
                color: isSelected
                    ? Colors.transparent
                    : const Color(0xFFE8E7ED),
                width: 1.2,
              ),
            ),
            onSelected: (val) {
              if (val) {
                setState(() => _currentPage = 1);
                context.read<AdminCustomersBloc>().add(
                  FilterCustomersStatusChanged(filter),
                );
              }
            },
            showCheckmark: false,
          ),
        );
      }).toList(),
    );
  }
}
