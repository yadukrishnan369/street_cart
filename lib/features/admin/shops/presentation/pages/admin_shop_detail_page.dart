import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_bloc.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_event.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_state.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/admin_shop_detail_header_card.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/admin_shop_business_details_card.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/admin_shop_delivery_radius_card.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/admin_shop_verification_card.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/admin_shop_products_card.dart';
import 'package:street_cart/features/admin/shops/presentation/widgets/shimmer/admin_shop_detail_shimmer.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Admin Shop Detail Page
class AdminShopDetailPage extends StatelessWidget {
  final String shopId;

  const AdminShopDetailPage({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AdminShopDetailBloc>()..add(LoadShopDetailRequested(shopId)),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AdminShopDetailBloc, AdminShopDetailState>(
            listener: (context, state) {
              if (state is AdminShopDetailActionSuccess) {
                CustomSnackBar.show(context, message: state.message);
                if (state.message == 'Shop deleted successfully') {
                  context.pop(true);
                }
              } else if (state is AdminShopDetailError) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            builder: (context, state) {
              if (state is AdminShopDetailLoading ||
                  state is AdminShopDetailActionInProgress) {
                // Admin Shop Detail Shimmer
                return const AdminShopDetailShimmer();
              } else if (state is AdminShopDetailLoaded) {
                final shop = state.shop;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 32.h,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 800;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBackRow(context),
                          SizedBox(height: 16.h),
                          AdminShopDetailHeaderCard(shop: shop, isWide: isWide),
                          SizedBox(height: 32.h),
                          if (isWide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Admin Shop Business Details Card
                                Expanded(
                                  flex: 5,
                                  child: AdminShopBusinessDetailsCard(
                                    shop: shop,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                // Admin Shop Delivery Radius Card
                                Expanded(
                                  flex: 3,
                                  child: AdminShopDeliveryRadiusCard(
                                    shop: shop,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                // Admin Shop Verification Card
                                Expanded(
                                  flex: 3,
                                  child: AdminShopVerificationCard(shop: shop),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                // Admin Shop Business Details Card
                                AdminShopBusinessDetailsCard(shop: shop),
                                SizedBox(height: 24.h),
                                // Admin Shop Delivery Radius Card
                                AdminShopDeliveryRadiusCard(shop: shop),
                                SizedBox(height: 24.h),
                                // Admin Shop Verification Card
                                AdminShopVerificationCard(shop: shop),
                              ],
                            ),
                          SizedBox(height: 32.h),
                          // Admin Shop Products Card
                          AdminShopProductsCard(
                            products: state.products,
                            shopId: shop.uid,
                            selectedFilter: state.productFilter,
                            currentPage: state.productPage,
                          ),
                        ],
                      );
                    },
                  ),
                );
                // Error State
              } else if (state is AdminShopDetailError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load details:\n${state.message}',
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
                          context.read<AdminShopDetailBloc>().add(
                            LoadShopDetailRequested(shopId),
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
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBackRow(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(true),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_back,
            size: 16.sp,
            color: AdminAppColors.primaryColor,
          ),
          SizedBox(width: 8.w),
          Text(
            'Go Back',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AdminAppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
