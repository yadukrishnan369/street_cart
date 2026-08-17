import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_bloc.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_state.dart';
import 'package:street_cart/features/customer/products/presentation/pages/product_filter_page.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_products_page.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_event.dart';
import 'package:street_cart/features/customer/profile/presentation/pages/edit_profile_page.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/complete_profile_modal.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class HomeHelper {
  // Fetch city name from address parts
  static String getCityFromAddress(String? address) {
    if (address == null || address.isEmpty) return "Search";
    final parts = address.split(',');
    return parts.isNotEmpty ? parts.first.trim() : "Search";
  }

  // gets unique categories from product list
  static List<String> extractCategories(List<ProductModel> products) {
    return products.map((p) => p.category).toSet().toList();
  }

  // gets unique business categories from shop list
  static List<String> extractBusinessCategories(List<ShopProfileModel> shops) {
    return shops
        .map((s) => s.category)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
  }

  // display categories list for category row chips
  static List<String> getDisplayCategories(List<String> categories) {
    final filteredCategories = categories
        .where((c) => c.toLowerCase() != 'all')
        .toList();
    if (filteredCategories.isEmpty) {
      return [];
    }
    return filteredCategories.length > 1
        ? ['All', ...filteredCategories]
        : filteredCategories;
  }

  // filters list of products according to shop business category label
  static List<ProductModel> filterProductsByBusinessCategory({
    required List<ProductModel> products,
    required List<ShopProfileModel> shops,
    required String selectedCategory,
  }) {
    if (selectedCategory == 'All') {
      return products;
    }
    final shopCats = {for (final s in shops) s.uid: s.category.toLowerCase()};
    return products.where((p) {
      final shopCat = shopCats[p.shopId] ?? '';
      return shopCat == selectedCategory.toLowerCase();
    }).toList();
  }

  // sets up user blocked status change listeners
  static StreamSubscription<DocumentSnapshot>? setupBlockListener(
    BuildContext context,
  ) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('customers')
          .doc(currentUser.uid)
          .snapshots()
          .listen(
            (doc) {
              if (!doc.exists || doc.data()?['is_blocked'] == true) {
                if (context.mounted) {
                  context.read<AuthBloc>().add(LogoutRequested());
                }
              }
            },
            onError: (error) {
              if (context.mounted) {
                context.read<AuthBloc>().add(LogoutRequested());
              }
            },
          );
    }
    return null;
  }

  // displays complete profile alert modal dialog
  static void showWelcomeModal(BuildContext context) {
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

  // navigates to filter detail page
  static void navigateToFilter(
    BuildContext context,
    HomeState homeState,
  ) async {
    final cats = homeState is HomeLoaded
        ? extractCategories(homeState.homeData.nearbyProducts)
        : <String>[];

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFilterPage(
          allProducts: homeState is HomeLoaded
              ? homeState.homeData.nearbyProducts
              : <ProductModel>[],
          categories: cats,
          selectedSort: 'Newest',
          priceRange: const RangeValues(0, 10000),
          selectedCategories: const {'All'},
          selectedRating: null,
          selectedColors: const {},
          selectedSizes: const {},
        ),
        fullscreenDialog: true,
      ),
    );

    if (result != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerProductsPage(
            initialSelectedSort: result['selectedSort'] ?? 'Newest',
            initialPriceRange:
                result['priceRange'] ?? const RangeValues(0, 10000),
            initialSelectedCategories: Set<String>.from(
              result['selectedCategories'] ?? {'All'},
            ),
            initialSelectedRating: result['selectedRating'],
            initialSelectedColors: Set<String>.from(
              result['selectedColors'] ?? <String>{},
            ),
            initialSelectedSizes: Set<String>.from(
              result['selectedSizes'] ?? <String>{},
            ),
          ),
        ),
      );
    }
  }

  // calculates average discount and parses banner content
  static List<Map<String, dynamic>> getBanners({
    required List<ShopProfileModel> shops,
    required List<ProductModel> products,
  }) {
    final List<Map<String, dynamic>> dynamicBanners = [];

    for (final shop in shops) {
      final shopProducts = products.where((p) => p.shopId == shop.uid).toList();
      final offerProducts = shopProducts
          .where((p) => p.offerPrice != null && p.offerPrice! < p.originalPrice)
          .toList();

      if (offerProducts.length >= 5) {
        final discountPercents = offerProducts
            .map(
              (p) =>
                  ((p.originalPrice - p.offerPrice!) / p.originalPrice) * 100,
            )
            .toList();
        final averagePercent =
            discountPercents.reduce((a, b) => a + b) / discountPercents.length;

        dynamicBanners.add({
          'title': 'HOT DEAL AT ${shop.shopName.toUpperCase()}',
          'subtitle': shop.shopName,
          'discount': 'AVERAGE ${averagePercent.toStringAsFixed(0)}% OFF',
          'image': shop.profileImageUrl.isNotEmpty
              ? shop.profileImageUrl
              : 'assets/images/fallback_banner.jpg',
          'isAsset': shop.profileImageUrl.isEmpty,
          'shop': shop,
        });
      }
    }

    if (dynamicBanners.isNotEmpty) {
      return dynamicBanners;
    }

    return [
      {
        'title': 'COMMUNITY DEALS',
        'subtitle': 'Exciting Offers Coming Soon!',
        'discount': 'STAY TUNED',
        'image': 'assets/images/fallback_banner.jpg',
        'isAsset': true,
      },
    ];
  }

  // filters list of products according to selected category label
  static List<ProductModel> filterProductsByCategory({
    required List<ProductModel> products,
    required String selectedCategory,
  }) {
    return selectedCategory == 'All'
        ? products
        : products
              .where(
                (p) =>
                    p.category.toLowerCase() == selectedCategory.toLowerCase(),
              )
              .toList();
  }

  // sets up automatic scrolling timer for page view banners
  static Timer startBannerAutoScroll({
    required PageController pageController,
    required BuildContext context,
    required List<ShopProfileModel> shops,
    required List<ProductModel> products,
  }) {
    return Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (pageController.hasClients) {
        final totalBanners = getBanners(
          shops: shops,
          products: products,
        ).length;
        final currentPage = context.read<HomeBloc>().state.currentBannerPage;
        int nextPage = currentPage + 1;
        if (nextPage >= totalBanners) {
          nextPage = 0;
          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }
}
