import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/location/presentation/pages/location_permission_page.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_state.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/profile/presentation/pages/edit_profile_page.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_bloc.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_event.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_state.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_event.dart';

// UI Components
import 'package:street_cart/shared/components/customer_search_bar.dart';
import 'package:street_cart/shared/components/customer_bottom_navigation.dart';
import 'package:street_cart/shared/components/customer_product_card.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/home_banner.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/categories_row.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/shops_list_section.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/complete_profile_modal.dart';

class HomePage extends StatefulWidget {
  final bool showProfileModal;

  const HomePage({super.key, this.showProfileModal = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.showProfileModal) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _showWelcomeModal();
        }
      });
    }
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
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(FetchHomeData()),
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
              address = homeState.address;
              hasLocation = address != null;
              if (hasLocation) {
                // Determine city name from string dynamically
                final parts = address.split(',');
                if (parts.isNotEmpty) {
                  city = parts.first.trim();
                }
              }
            }

            return Scaffold(
              backgroundColor: CustomerAppColors.background,
              appBar: AppBar(
                backgroundColor: CustomerAppColors.background,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : GestureDetector(
                        onTap: hasLocation
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const LocationPermissionPage(
                                      isProfileCompleted: true,
                                    ),
                                  ),
                                );
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: CustomerAppColors.primary,
                            ),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivering to',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  hasLocation
                                      ? (address ?? 'Unknown Location')
                                      : 'Select precise location',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: hasLocation
                                        ? Colors.black87
                                        : CustomerAppColors.primary,
                                    decoration: hasLocation
                                        ? TextDecoration.none
                                        : TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      // Future notification center
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSearchBar(
                      hintText: "Search for 'Shirts' or 'Stores' in $city",
                    ),
                    const HomeBanner(),
                    const CategoriesRow(),
                    const ShopsListSection(),
                    SizedBox(height: 16.h),
                    _buildTrendingSection(),
                    SizedBox(height: 24.h),
                  ],
                ),
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

  Widget _buildTrendingSection() {
    // Dummy products data
    final products = [
      {
        'brand': 'KOZHIKODE FASHION HUB',
        'title': 'Linen Shirt',
        'price': '₹1,299',
        'image':
            'https://images.unsplash.com/photo-1596755094514-f87e32f85e23?w=400&fit=crop',
      },
      {
        'brand': 'METRO MEN\'S FASHION',
        'title': 'Classic Blue Shirt',
        'price': '₹2,499',
        'image':
            'https://plus.unsplash.com/premium_photo-1678128956947-0648210340ed?w=400&fit=crop',
      },
      {
        'brand': 'KOZHIKODE FASHION HUB',
        'title': 'Cotton Polo',
        'price': '₹3,200',
        'image':
            'https://images.unsplash.com/photo-1628151568212-0941ab2b7572?w=400&fit=crop',
      },
      {
        'brand': 'TRENDY GENTS FASHION',
        'title': 'Urban Denim Jacket',
        'price': '₹1,850',
        'image':
            'https://images.unsplash.com/photo-1495105787522-5334e1507722?w=400&fit=crop',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending in Kozhikode',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // since it's inside SingleChildScrollView
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75, // adjust for card proportions
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                imageUrl: product['image']!,
                brand: product['brand']!,
                title: product['title']!,
                price: product['price']!,
              );
            },
          ),
        ),
      ],
    );
  }
}
