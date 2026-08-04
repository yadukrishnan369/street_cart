import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_bloc.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_event.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_state.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/performance_stats.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/weekly_sales_card.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/quick_actions.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/recent_orders_list.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/shop_home_app_bar.dart';
import 'package:street_cart/shared/components/shop_bottom_navigation.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/shop_support_drawer.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/shimmer/shop_home_shimmer.dart';
import 'package:street_cart/features/shop/home/presentation/utils/shop_home_helper.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Shop Home Page
class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  late ShopHomeBloc _homeBloc;
  String shopId = '';

  @override
  void initState() {
    super.initState();
    _homeBloc = sl<ShopHomeBloc>();
    context.read<ShopAuthBloc>().add(ShopStatusSubscriptionRequested());
    final authState = context.read<ShopAuthBloc>().state;
    if (authState.status == ShopAuthStatus.authenticated) {
      shopId = authState.shop?.uid ?? '';
      if (shopId.isNotEmpty) {
        if (_homeBloc.state is! ShopHomeDataLoaded) {
          _homeBloc.add(FetchShopHomeDataEvent(shopId));
          _homeBloc.add(CheckFirstHomeVisitEvent());
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: _homeBloc)],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ShopAuthBloc, ShopAuthState>(
            listener: (context, state) {
              if (state.status == ShopAuthStatus.initial) {
                shopId = '';
                // Navigate to Shop Login Page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopLoginPage(),
                  ),
                  (route) => false,
                );
              } else if (state.status == ShopAuthStatus.authenticated) {
                shopId = state.shop?.uid ?? '';
                if (shopId.isNotEmpty &&
                    _homeBloc.state is! ShopHomeDataLoaded) {
                  _homeBloc.add(FetchShopHomeDataEvent(shopId));
                  _homeBloc.add(CheckFirstHomeVisitEvent());
                }
              }
            },
          ),
          BlocListener<ShopHomeBloc, ShopHomeState>(
            listener: (context, state) {
              if (state is ShopHomeFirstVisitCheckCompleted) {
                if (state.isFirstVisit) {
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      final authState = context.read<ShopAuthBloc>().state;
                      ShopProfileModel? profile;
                      if (authState.status == ShopAuthStatus.authenticated) {
                        profile = authState.shop;
                      }
                      // Show Profile Completion
                      ShopHomeHelper.showProfileCompletionDialog(
                        context,
                        profile,
                      );
                      _homeBloc.add(CompleteFirstHomeVisitEvent());
                    }
                  });
                }
              } else if (state is ShopHomeError) {
                CustomSnackBar.show(
                  context,
                  message: state.message.replaceAll('Exception: ', ''),
                  isError: true,
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: const ShopSupportDrawer(),
          appBar: const ShopHomeAppBar(),
          body: BlocBuilder<ShopHomeBloc, ShopHomeState>(
            builder: (context, state) {
              if (state is ShopHomeLoading || state is ShopHomeInitial) {
                // Shop Page Shimmer
                return const ShopHomePageShimmer();
              }
              // Refresh Indicator
              return RefreshIndicator(
                color: ShopAppColors.primary,
                onRefresh: () async {
                  if (shopId.isNotEmpty) {
                    _homeBloc.add(FetchShopHomeDataEvent(shopId));
                  }
                  await Future.delayed(const Duration(milliseconds: 800));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      BlocBuilder<ShopAuthBloc, ShopAuthState>(
                        builder: (context, authState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Performace Stats
                              PerformanceStats(shopId: shopId),
                              SizedBox(height: 20.h),
                              // Weekly Sales Card
                              WeeklySalesCard(shopId: shopId),
                              SizedBox(height: 20.h),
                              // Quick Actions
                              QuickActions(
                                onAddProductTap: () {
                                  if (shopId.isNotEmpty) {
                                    ShopHomeHelper.onAddProductTap(
                                      context,
                                      shopId,
                                    );
                                  }
                                },
                                onViewOrdersTap: () {
                                  ShopHomeHelper.onViewOrdersTap(context);
                                },
                                onEditProfileTap: () {
                                  if (authState.status ==
                                      ShopAuthStatus.authenticated) {
                                    final profile = authState.shop;
                                    if (profile != null) {
                                      ShopHomeHelper.onEditProfileTap(
                                        context,
                                        profile,
                                      );
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 20.h),
                              // Recent Orders List
                              RecentOrdersList(shopId: shopId),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: const ShopBottomNavigation(currentIndex: 0),
        ),
      ),
    );
  }
}
