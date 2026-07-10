import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/debouncer.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/orders/presentation/bloc/admin_orders_bloc.dart';
import 'package:street_cart/features/admin/orders/presentation/bloc/admin_orders_event.dart';
import 'package:street_cart/features/admin/orders/presentation/bloc/admin_orders_state.dart';
import 'package:street_cart/features/admin/orders/presentation/bloc/admin_orders_ui_cubit.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/orders_table_container.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/orders_tab_bar.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  static const int _perPage = 6;
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  AdminOrdersLoaded? _lastLoadedState;

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AdminOrdersBloc>()..add(LoadAdminOrders()),
        ),
        BlocProvider(create: (_) => AdminOrdersUiCubit()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocListener<AdminOrdersBloc, AdminOrdersState>(
            listener: (context, state) {
              if (state is AdminOrdersFailure) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            child: BlocBuilder<AdminOrdersUiCubit, AdminOrdersUiState>(
              builder: (context, uiState) {
                return BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
                  builder: (context, state) {
                    if (state is AdminOrdersLoaded) {
                      _lastLoadedState = state;
                    }

                    if (_lastLoadedState == null) {
                      if (state is AdminOrdersFailure) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Failed to load orders:\n${state.message}',
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
                                  context.read<AdminOrdersBloc>().add(
                                    LoadAdminOrders(),
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
                    final isLoading = state is AdminOrdersLoading;

                    final totalPages = AdminOrdersHelper.getTotalPages(
                      loadedState.orders.length,
                      _perPage,
                    );
                    final paginatedOrders =
                        AdminOrdersHelper.getPaginatedOrders(
                          orders: loadedState.orders,
                          currentPage: uiState.currentPage,
                          perPage: _perPage,
                        );

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
                              // Title & Subtitle
                              Text(
                                'Orders',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E1E2F),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Monitor customer orders across all shops in real-time.',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF8A8A9E),
                                ),
                              ),
                              SizedBox(height: 24.h),

                              OrdersTabBar(
                                activeTab: loadedState.activeTab,
                                onTabChanged: (index) {
                                  context
                                      .read<AdminOrdersUiCubit>()
                                      .resetPage();
                                  context.read<AdminOrdersBloc>().add(
                                    FilterTabChanged(index),
                                  );
                                },
                              ),
                              SizedBox(height: 24.h),

                              OrdersTableContainer(
                                orders: paginatedOrders,
                                shopNames: loadedState.shopNames,
                                customerNames: loadedState.customerNames,
                                isWide: isWide,
                                isLoading: isLoading,
                                searchController: _searchController,
                                debouncer: _debouncer,
                                currentPage: uiState.currentPage,
                                totalPages: totalPages,
                                perPage: _perPage,
                                onPageChanged: (page) {
                                  context.read<AdminOrdersUiCubit>().changePage(
                                    page,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
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
