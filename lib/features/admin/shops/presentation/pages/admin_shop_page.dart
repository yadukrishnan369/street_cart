import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/debouncer.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_bloc.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_event.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_state.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/shop_metric_cards.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/shimmer/admin_shop_page_shimmer.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/shops_table_container.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shops_ui_cubit.dart';

class AdminShopPage extends StatefulWidget {
  const AdminShopPage({super.key});

  @override
  State<AdminShopPage> createState() => _AdminShopPageState();
}

class _AdminShopPageState extends State<AdminShopPage> {
  static const int _perPage = 6;
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  AdminShopLoaded? _lastLoadedState;

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
              sl<AdminShopBloc>()..add(LoadAdminShop(page: 1, limit: _perPage)),
        ),
        BlocProvider(create: (_) => AdminShopsUiCubit()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocListener<AdminShopBloc, AdminShopState>(
            listener: (context, state) {
              if (state is AdminShopActionSuccess) {
                CustomSnackBar.show(context, message: state.message);
              } else if (state is AdminShopError) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            child: BlocBuilder<AdminShopsUiCubit, AdminShopsUiState>(
              builder: (context, uiState) {
                return BlocBuilder<AdminShopBloc, AdminShopState>(
                  builder: (context, state) {
                    if (state is AdminShopLoaded) {
                      _lastLoadedState = state;
                    }

                    if (_lastLoadedState == null) {
                      if (state is AdminShopError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Failed to load shops:\n${state.message}',
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
                                  context.read<AdminShopBloc>().add(
                                    LoadAdminShop(
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
                      return const AdminShopPageShimmer();
                    }

                    final loadedState = _lastLoadedState!;
                    final isLoading = state is AdminShopLoading;

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
                              ShopMetricCards(
                                totalShops: loadedState.totalShops,
                                activeShops: loadedState.activeShops,
                                suspendedShops: loadedState.suspendedShops,
                                isWide: isWide,
                              ),
                              SizedBox(height: 32.h),
                              ShopsTableContainer(
                                state: loadedState,
                                isWide: isWide,
                                isLoading: isLoading,
                                searchController: _searchController,
                                debouncer: _debouncer,
                                currentPage: uiState.currentPage,
                                perPage: _perPage,
                                onPageChanged: (page) {
                                  context.read<AdminShopsUiCubit>().changePage(
                                    page,
                                  );
                                  context.read<AdminShopBloc>().add(
                                    LoadAdminShop(page: page, limit: _perPage),
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
