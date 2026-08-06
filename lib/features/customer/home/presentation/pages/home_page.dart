import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_bloc.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_event.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_state.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/products_section.dart';
import 'package:street_cart/shared/components/customer_search_bar.dart';
import 'package:street_cart/shared/components/customer_bottom_navigation.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/home_banner.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/categories_row.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/shops_list_section.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/shimmer/home_page_shimmer.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/home_app_bar.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_products_page.dart';
import 'package:street_cart/features/customer/home/presentation/utils/home_helper.dart';

// Home Page
class HomePage extends StatefulWidget {
  final bool showProfileModal;
  const HomePage({super.key, this.showProfileModal = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<DocumentSnapshot>? _blockListenerSubscription;

  @override
  void initState() {
    super.initState();
    _blockListenerSubscription = HomeHelper.setupBlockListener(context);
    if (widget.showProfileModal) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) HomeHelper.showWelcomeModal(context);
      });
    }
  }

  @override
  void dispose() {
    _blockListenerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<HomeBloc>()..add(FetchHomeData()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial || state is AuthError) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, homeState) {
            bool isLoading =
                homeState is HomeLoading || homeState is HomeInitial;
            String? address;
            bool hasLocation = false;
            String city = "Search";

            if (homeState is HomeLoaded) {
              final currentAddress = homeState.homeData.address;
              if (currentAddress != null) {
                address = currentAddress;
                hasLocation = true;
                city = HomeHelper.getCityFromAddress(currentAddress);
              }
            }

            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: HomeAppBar(
                isLoading: isLoading,
                hasLocation: hasLocation,
                address: address,
              ),
              body: Column(
                children: [
                  CustomSearchBar(
                    readOnly: true,
                    hintText: "Search for 'Product' or 'Stores' in $city",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerProductsPage(
                            shouldFocusSearch: true,
                          ),
                        ),
                      );
                      if (context.mounted) {
                        FocusScope.of(context).unfocus();
                        context.read<HomeBloc>().add(FetchHomeData());
                      }
                    },
                    onFilterTap: () =>
                        HomeHelper.navigateToFilter(context, homeState),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: CustomerAppColors.primary,
                      onRefresh: () async {
                        final bloc = context.read<HomeBloc>();
                        bloc.add(ResetHome());
                        bloc.add(FetchHomeData());
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isLoading)
                              // Shimmer Section
                              const HomePageShimmer()
                            else ...[
                              // Home Banner Section
                              HomeBanner(
                                shops: homeState is HomeLoaded
                                    ? homeState.homeData.nearbyShops
                                    : const [],
                                products: homeState is HomeLoaded
                                    ? homeState.homeData.nearbyProducts
                                    : const [],
                              ),
                              if (homeState is HomeLoaded) ...[
                                // Category Row Section
                                CategoriesRow(
                                  categories:
                                      HomeHelper.extractBusinessCategories(
                                        homeState.homeData.nearbyShops,
                                      ),
                                  selectedCategory: homeState.selectedCategory,
                                  onCategorySelected: (cat) {
                                    context.read<HomeBloc>().add(
                                      SelectCategory(cat),
                                    );
                                  },
                                ),
                                // Shop List Section
                                ShopsListSection(
                                  shops: homeState.homeData.nearbyShops,
                                ),
                                SizedBox(height: 16.h),
                                // Products Section
                                ProductsSection(
                                  homeData: homeState.homeData,
                                  selectedCategory: homeState.selectedCategory,
                                ),
                              ],
                            ],
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Bottom Navigation Bar
              bottomNavigationBar: const CustomerBottomNavigation(
                currentIndex: 0,
              ),
            );
          },
        ),
      ),
    );
  }
}
