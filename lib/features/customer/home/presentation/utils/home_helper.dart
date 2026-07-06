import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_event.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_state.dart';
import 'package:street_cart/features/customer/products/presentation/pages/product_filter_page.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_products_page.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_event.dart';
import 'package:street_cart/features/customer/profile/presentation/pages/edit_profile_page.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/complete_profile_modal.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class HomeHelper {
  static String getCityFromAddress(String? address) {
    if (address == null || address.isEmpty) return "Search";
    final parts = address.split(',');
    return parts.isNotEmpty ? parts.first.trim() : "Search";
  }

  static List<String> extractCategories(List<ProductModel> products) {
    return products.map((p) => p.category).toSet().toList();
  }

  static StreamSubscription<DocumentSnapshot>? setupBlockListener(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('customers')
          .doc(currentUser.uid)
          .snapshots()
          .listen((doc) {
        if (!doc.exists || doc.data()?['is_blocked'] == true) {
          if (context.mounted) {
            context.read<AuthBloc>().add(LogoutRequested());
          }
        }
      }, onError: (error) {
        if (context.mounted) {
          context.read<AuthBloc>().add(LogoutRequested());
        }
      });
    }
    return null;
  }

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

  static void navigateToFilter(BuildContext context, HomeState homeState) async {
    final cats = homeState is HomeLoaded
        ? extractCategories(homeState.homeData.nearbyProducts)
        : <String>[];

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFilterPage(
          allProducts: homeState is HomeLoaded ? homeState.homeData.nearbyProducts : <ProductModel>[],
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
            initialPriceRange: result['priceRange'] ?? const RangeValues(0, 10000),
            initialSelectedCategories: Set<String>.from(result['selectedCategories'] ?? {'All'}),
            initialSelectedRating: result['selectedRating'],
            initialSelectedColors: Set<String>.from(result['selectedColors'] ?? <String>{}),
            initialSelectedSizes: Set<String>.from(result['selectedSizes'] ?? <String>{}),
          ),
        ),
      );
    }
  }
}
