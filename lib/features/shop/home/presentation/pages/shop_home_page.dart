import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/profile_setup_page.dart';
import 'package:street_cart/features/shop/home/data/datasource/shop_home_local_datasource.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/performance_stats.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/weekly_sales_card.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/quick_actions.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/recent_orders_list.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/profile_completion_modal.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/shared/components/shop_bottom_navigation.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/shop_support_drawer.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  @override
  void initState() {
    super.initState();
    // Subscribe to shop status to get shop name
    context.read<ShopAuthBloc>().add(ShopStatusSubscriptionRequested());

    // Check for first visit to show modal
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    final localDS = sl<IShopHomeLocalDataSource>();
    final isFirstVisit = await localDS.isFirstHomeVisit();

    if (isFirstVisit) {
      // Delay for 2 seconds as requested
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _showProfileCompletionDialog();
          localDS.setFirstHomeVisitFalse();
        }
      });
    }
  }

  void _showProfileCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProfileCompletionModal(
        onCompleteNow: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ShopProfileSetupPage(),
            ),
          );
        },
        onMaybeLater: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopAuthBloc, ShopAuthState>(
      listener: (context, state) {
        if (state is ShopAuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ShopLoginPage()),
            (route) => false,
          );
        }
      },
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
                    _showLogoutConfirmation();
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
        body: SingleChildScrollView(
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
              const QuickActions(),
              SizedBox(height: 20.h),
              const RecentOrdersList(),
              SizedBox(height: 100.h), // Bottom nav padding
            ],
          ),
        ),
        bottomNavigationBar: const ShopBottomNavigation(currentIndex: 0),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => ConfirmationModal(
        title: 'Logout',
        content: 'Are you sure you want to logout from your shop account?',
        confirmText: 'Yes, Logout',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(context);
          context.read<ShopAuthBloc>().add(ShopLogoutRequested());
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}
