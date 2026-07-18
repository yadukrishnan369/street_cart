import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/customer/shops/presentation/bloc/shop_details_bloc.dart';
import 'package:street_cart/features/customer/shops/presentation/bloc/shop_details_event.dart';
import 'package:street_cart/features/customer/shops/presentation/widgets/shop_details_header.dart';
import 'package:street_cart/features/customer/shops/presentation/bloc/shop_details_state.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';
import 'package:street_cart/features/customer/shops/presentation/widgets/shop_products_grid.dart';

// Shop Details Page
class ShopDetailsPage extends StatelessWidget {
  final ShopProfileModel shop;

  const ShopDetailsPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ShopDetailsBloc>()..add(FetchShopProducts(shopId: shop.uid)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: CustomerAppColors.background,
            appBar: AppBar(
              backgroundColor: CustomerAppColors.background,
              elevation: 0,
              // Page Header
              title: Text(
                'Store Profile',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomerAppColors.textPrimary,
                ),
              ),
              centerTitle: true,
            ),
            body: BlocBuilder<ShopDetailsBloc, ShopDetailsState>(
              builder: (context, state) {
                if (state is ShopDetailsError) {
                  return AppErrorView(
                    message: state.message,
                    onRetry: () {
                      context.read<ShopDetailsBloc>().add(
                        FetchShopProducts(shopId: shop.uid),
                      );
                    },
                  );
                }
                return RefreshIndicator(
                  color: CustomerAppColors.primary,
                  onRefresh: () async {
                    context.read<ShopDetailsBloc>().add(
                      FetchShopProducts(shopId: shop.uid),
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        // Shop Details Header
                        ShopDetailsHeader(shop: shop),
                        SizedBox(height: 24.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            // Shop Products Section Header
                            child: Text(
                              'Featured Products',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: CustomerAppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Shop Products Grid
                        ShopProductsGrid(shop: shop),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
