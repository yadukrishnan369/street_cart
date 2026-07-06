import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_bloc.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_event.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_state.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/performance_stats.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/weekly_sales_card.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/quick_actions.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/recent_orders_list.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/shared/components/shop_bottom_navigation.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/shop_support_drawer.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/shimmer/shop_home_shimmer.dart';
import 'package:street_cart/features/shop/home/presentation/utils/shop_home_helper.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  late ShopHomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = sl<ShopHomeBloc>();
    context.read<ShopAuthBloc>().add(ShopStatusSubscriptionRequested());
    _homeBloc.add(CheckFirstHomeVisitEvent());
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  void _triggerProfileCompletionDialog() {
    final authState = context.read<ShopAuthBloc>().state;
    ShopProfileModel? profile;
    if (authState is ShopStatusLoaded) {
      profile = authState.shop;
    }
    ShopHomeHelper.showProfileCompletionDialog(context, profile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ShopAuthBloc, ShopAuthState>(
            listener: (context, state) {
              if (state is ShopAuthInitial) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopLoginPage(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
          BlocListener<ShopHomeBloc, ShopHomeState>(
            listener: (context, state) {
              if (state is ShopHomeFirstVisitCheckCompleted) {
                if (state.isFirstVisit) {
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      _triggerProfileCompletionDialog();
                      _homeBloc.add(CompleteFirstHomeVisitEvent());
                    }
                  });
                }
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: ShopAppColors.background,
          drawer: const ShopSupportDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            leadingWidth: 70.w,
            leading: Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 10.w),
                    child: Center(
                      child: AppLogo(
                        size: 40,
                        backgroundColor: ShopAppColors.primary,
                        logoColor: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            title: BlocBuilder<ShopAuthBloc, ShopAuthState>(
              builder: (context, state) {
                String shopName = "My Shop";
                if (state is ShopStatusLoaded) {
                  shopName = state.shop?.shopName ?? "My Shop";
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shopName, style: ShopAppTextStyles.heading4),
                    Text(
                      'Street Cart Partner',
                      style: ShopAppTextStyles.labelBold,
                    ),
                  ],
                );
              },
            ),
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: ShopAppColors.textSecondary,
                      size: 26.sp,
                    ),
                    onPressed: () {
                      ShopHomeHelper.showLogoutConfirmation(context);
                    },
                  ),
                  Positioned(
                    right: 12.w,
                    top: 12.h,
                    child: Container(
                      height: 8.r,
                      width: 8.r,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.w),
            ],
          ),
          body: BlocBuilder<ShopHomeBloc, ShopHomeState>(
            builder: (context, state) {
              if (state is ShopHomeLoading || state is ShopHomeInitial) {
                return const ShopHomePageShimmer();
              }
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    const PerformanceStats(),
                    SizedBox(height: 20.h),
                    const WeeklySalesCard(),
                    SizedBox(height: 20.h),
                    QuickActions(
                      onAddProductTap: () {
                        final authState = context.read<ShopAuthBloc>().state;
                        if (authState is ShopStatusLoaded) {
                          final shopId = authState.shop?.uid ?? '';
                          ShopHomeHelper.onAddProductTap(context, shopId);
                        }
                      },
                      onEditProfileTap: () {
                        final authState = context.read<ShopAuthBloc>().state;
                        if (authState is ShopStatusLoaded) {
                          final profile = authState.shop;
                          if (profile != null) {
                            ShopHomeHelper.onEditProfileTap(context, profile);
                          }
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    const RecentOrdersList(),
                    SizedBox(height: 100.h),
                  ],
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
