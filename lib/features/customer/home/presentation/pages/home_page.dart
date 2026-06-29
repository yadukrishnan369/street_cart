import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/profile/presentation/pages/edit_profile_page.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_bloc.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_event.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_state.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_event.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/shared/components/customer_search_bar.dart';
import 'package:street_cart/shared/components/customer_bottom_navigation.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/home_banner.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/categories_row.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/shops_list_section.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/complete_profile_modal.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/home_app_bar.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/trending_products_section.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_products_page.dart';
import 'package:street_cart/features/customer/products/presentation/pages/product_filter_page.dart';

class HomePage extends StatefulWidget {
  final bool showProfileModal;

  const HomePage({super.key, this.showProfileModal = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<DocumentSnapshot>? _blockListenerSubscription;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _setupBlockListener();
    if (widget.showProfileModal) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _showWelcomeModal();
        }
      });
    }
  }

  void _setupBlockListener() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _blockListenerSubscription = FirebaseFirestore.instance
          .collection('customers')
          .doc(currentUser.uid)
          .snapshots()
          .listen(
            (doc) {
              if (!doc.exists || doc.data()?['is_blocked'] == true) {
                if (mounted) {
                  context.read<AuthBloc>().add(LogoutRequested());
                }
              }
            },
            onError: (error) {
              if (mounted) {
                context.read<AuthBloc>().add(LogoutRequested());
              }
            },
          );
    }
  }

  @override
  void dispose() {
    _blockListenerSubscription?.cancel();
    super.dispose();
  }

  void _showWelcomeModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CompleteProfileModal(
        onMaybeLater: () => Navigator.pop(context),
        onCompleteProfile: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<ProfileBloc>(
                create: (context) => sl<ProfileBloc>()..add(FetchProfileData()),
                child: const EditProfilePage(),
              ),
            ),
          );
        },
      ),
    );
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
                final parts = currentAddress.split(',');
                if (parts.isNotEmpty) {
                  city = parts.first.trim();
                }
              }
            }

            return Scaffold(
              backgroundColor: CustomerAppColors.background,
              appBar: HomeAppBar(
                isLoading: isLoading,
                hasLocation: hasLocation,
                address: address,
              ),
              body: Column(
                children: [
                  CustomSearchBar(
                    hintText: "Search for 'Product' or 'Stores' in $city",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerProductsPage(
                            shouldFocusSearch: true,
                          ),
                        ),
                      );
                    },
                    onFilterTap: () async {
                      final cats = (homeState is HomeLoaded)
                          ? homeState.homeData.categories
                          : <String>[];

                      final result =
                          await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductFilterPage(
                            categories: cats,
                            selectedSort: 'Newest',
                            priceRange: const RangeValues(0, 10000),
                            selectedCategories: const {'All'},
                            selectedRating: null,
                          ),
                          fullscreenDialog: true,
                        ),
                      );

                      if (result != null && mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerProductsPage(
                              initialSelectedSort:
                                  result['selectedSort'] ?? 'Newest',
                              initialPriceRange:
                                  result['priceRange'] ??
                                  const RangeValues(0, 10000),
                              initialSelectedCategories: Set<String>.from(
                                result['selectedCategories'] ?? {'All'},
                              ),
                              initialSelectedRating: result['selectedRating'],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: CustomerAppColors.primary,
                      onRefresh: () async {
                        context.read<HomeBloc>().add(FetchHomeData());
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HomeBanner(
                              shops: homeState is HomeLoaded
                                  ? homeState.homeData.nearbyShops
                                  : const [],
                              products: homeState is HomeLoaded
                                  ? homeState.homeData.nearbyProducts
                                  : const [],
                            ),
                            if (isLoading)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 48.h),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: CustomerAppColors.primary,
                                  ),
                                ),
                              )
                            else if (homeState is HomeLoaded) ...[
                              CategoriesRow(
                                categories: homeState.homeData.categories,
                                selectedCategory: _selectedCategory,
                                onCategorySelected: (cat) {
                                  setState(() {
                                    _selectedCategory = cat;
                                  });
                                },
                              ),
                              ShopsListSection(shops: homeState.homeData.nearbyShops),
                              SizedBox(height: 16.h),
                              TrendingProductsSection(
                                products: homeState.homeData.nearbyProducts,
                                shops: homeState.homeData.nearbyShops,
                                selectedCategory: _selectedCategory,
                              ),
                            ],
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
