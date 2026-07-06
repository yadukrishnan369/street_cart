import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_detail_bloc.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_detail_event.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_detail_state.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/product_image_gallery.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/product_stats_row.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/product_description_section.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/product_listing_details_card.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/product_shop_info_card.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/product_detail_header.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/admin/products/presentation/widgets/shimmer/admin_product_detail_shimmer.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class AdminProductDetailPage extends StatelessWidget {
  final String productId;

  const AdminProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AdminProductDetailBloc>()
            ..add(LoadProductDetailRequested(productId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocConsumer<AdminProductDetailBloc, AdminProductDetailState>(
            listener: (context, state) {
              if (state is AdminProductDetailActionSuccess) {
                CustomSnackBar.show(context, message: state.message);
                if (state.message.contains('deleted')) {
                  context.pop(true);
                }
              } else if (state is AdminProductDetailError) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            builder: (context, state) {
              if (state is AdminProductDetailLoading ||
                  state is AdminProductDetailActionInProgress) {
                return const AdminProductDetailShimmer();
              } else if (state is AdminProductDetailLoaded) {
                final item = state.item;
                final p = item.product;
                final shopName = item.shopName;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 32.h,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 700;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBackRow(context),
                          SizedBox(height: 24.h),
                          ProductDetailHeader(
                            product: p,
                            onToggleDisable: () => _confirmDisable(
                              context,
                              p.id,
                              !p.disabledByAdmin,
                            ),
                            onDelete: () => _confirmDelete(context, p.id),
                          ),
                          SizedBox(height: 32.h),
                          if (isWide) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: ProductImageGallery(product: p),
                                ),
                                SizedBox(width: 32.w),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      ProductShopInfoCard(
                                        shopId: p.shopId,
                                        shopName: shopName,
                                        shopLocation: item.shopLocation,
                                      ),
                                      SizedBox(height: 24.h),
                                      ProductListingDetailsCard(
                                        product: p,
                                        commissionRate: item.commissionRate,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 750.w),
                                child: ProductStatsRow(product: p),
                              ),
                            ),
                            SizedBox(height: 32.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 750.w),
                                child: ProductDescriptionSection(product: p),
                              ),
                            ),
                          ] else ...[
                            ProductImageGallery(product: p),
                            SizedBox(height: 32.h),
                            ProductShopInfoCard(
                              shopId: p.shopId,
                              shopName: shopName,
                              shopLocation: item.shopLocation,
                            ),
                            SizedBox(height: 24.h),
                            ProductListingDetailsCard(
                              product: p,
                              commissionRate: item.commissionRate,
                            ),
                            SizedBox(height: 32.h),
                            ProductStatsRow(product: p),
                            SizedBox(height: 32.h),
                            ProductDescriptionSection(product: p),
                          ],
                        ],
                      );
                    },
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
      onTap: () {
        if (context.canPop()) {
          context.pop(true);
        } else {
          context.go('/products');
        }
      },
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

  void _confirmDisable(BuildContext context, String productId, bool disable) {
    final bloc = context.read<AdminProductDetailBloc>();
    showDialog(
      context: context,
      builder: (dialogCtx) => ConfirmationModal(
        title: disable ? 'Disable Product?' : 'Enable Product?',
        content: disable
            ? 'Are you sure you want to disable this product? This will product as disabled and prevent customers from purchasing it.'
            : 'Are you sure you want to enable this product? Customers will be able to see and purchase it.',
        confirmText: 'Continue',
        confirmColor: disable
            ? AdminAppColors.errorColor
            : AdminAppColors.successColor,
        onCancel: () => Navigator.pop(dialogCtx),
        onConfirm: () {
          Navigator.pop(dialogCtx);
          showDialog(
            context: context,
            builder: (secondCtx) => ConfirmationModal(
              title: 'Confirm to Disable',
              content: disable
                  ? 'Confirming again: Disable this item on all platforms?'
                  : 'Confirming again: Make this item active on all platforms?',
              confirmText: 'Yes, Confirm',
              confirmColor: disable
                  ? AdminAppColors.errorColor
                  : AdminAppColors.successColor,
              onCancel: () => Navigator.pop(secondCtx),
              onConfirm: () {
                Navigator.pop(secondCtx);
                bloc.add(
                  ToggleDisableProductRequested(
                    productId: productId,
                    disable: disable,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String productId) {
    final bloc = context.read<AdminProductDetailBloc>();
    showDialog(
      context: context,
      builder: (dialogCtx) => ConfirmationModal(
        title: 'Delete Product?',
        content:
            'Are you sure you want to delete this product? This action is permanent and cannot be undone.',
        confirmText: 'Continue',
        confirmColor: AdminAppColors.errorColor,
        onCancel: () => Navigator.pop(dialogCtx),
        onConfirm: () {
          Navigator.pop(dialogCtx);
          showDialog(
            context: context,
            builder: (secondCtx) => ConfirmationModal(
              title: 'Confirm to Delete',
              content:
                  'Confirming again: Delete this product permanently from Shop account?',
              confirmText: 'Yes, Delete',
              confirmColor: AdminAppColors.errorColor,
              onCancel: () => Navigator.pop(secondCtx),
              onConfirm: () {
                Navigator.pop(secondCtx);
                bloc.add(DeleteProductRequested(productId));
              },
            ),
          );
        },
      ),
    );
  }
}
