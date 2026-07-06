import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/debouncer.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_bloc.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_event.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_state.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/product_metric_cards.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/products_table_container.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/shimmer/admin_products_page_shimmer.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_products_ui_cubit.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  static const int _perPage = 6;
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  AdminProductLoaded? _lastLoadedState;

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
          create: (context) =>
              sl<AdminProductBloc>()
                ..add(LoadAdminProducts(page: 1, limit: _perPage)),
        ),
        BlocProvider(create: (_) => AdminProductsUiCubit()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocListener<AdminProductBloc, AdminProductState>(
            listener: (context, state) {
              if (state is AdminProductError) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            child: BlocBuilder<AdminProductsUiCubit, AdminProductsUiState>(
              builder: (context, uiState) {
                return BlocBuilder<AdminProductBloc, AdminProductState>(
                  builder: (context, state) {
                    if (state is AdminProductLoaded) {
                      _lastLoadedState = state;
                    }

                    if (_lastLoadedState == null) {
                      if (state is AdminProductError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Failed to load products:\n${state.message}',
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
                                  context.read<AdminProductBloc>().add(
                                    LoadAdminProducts(
                                      page: uiState.currentPage,
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
                      return const AdminProductsPageShimmer();
                    }

                    final loadedState = _lastLoadedState!;
                    final isLoading = state is AdminProductLoading;

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
                              ProductMetricCards(
                                totalProducts: loadedState.totalProducts,
                                activeItems: loadedState.activeItems,
                                outOfStock: loadedState.outOfStock,
                                disabledItems: loadedState.disabledItems,
                                isWide: isWide,
                              ),
                              SizedBox(height: 32.h),
                              ProductsTableContainer(
                                state: loadedState,
                                isWide: isWide,
                                isLoading: isLoading,
                                searchController: _searchController,
                                debouncer: _debouncer,
                                currentPage: uiState.currentPage,
                                perPage: _perPage,
                                statusFilter: loadedState.statusFilter,
                                categoryFilter: loadedState.categoryFilter,
                                onPageChanged: (page) {
                                  context
                                      .read<AdminProductsUiCubit>()
                                      .changePage(page);
                                  context.read<AdminProductBloc>().add(
                                    LoadAdminProducts(
                                      page: page,
                                      limit: _perPage,
                                    ),
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
