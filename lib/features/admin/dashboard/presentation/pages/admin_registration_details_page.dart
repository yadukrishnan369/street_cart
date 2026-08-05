import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/shop_details_header_card.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/basic_identity_card.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/contact_details_card.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/gst_card.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/verification_card.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registration_details_bloc.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registration_details_event.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registration_details_state.dart';
import 'package:street_cart/features/admin/dashboard/presentation/utils/admin_dashboard_helper.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/shimmer/admin_registration_details_shimmer.dart';

// Admin Registration Details Page
class AdminRegistrationDetailsPage extends StatelessWidget {
  final String shopId;

  const AdminRegistrationDetailsPage({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AdminRegistrationDetailsBloc>()
            ..add(LoadShopDetailsRequested(shopId)),
      child: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Scaffold(
            backgroundColor: isDark
                ? AdminAppColors.darkBackground
                : const Color(0xFFF9FAFC),
            body: SafeArea(
              child:
                  BlocConsumer<
                    AdminRegistrationDetailsBloc,
                    AdminRegistrationDetailsState
                  >(
                    listener: (context, state) {
                      if (state is AdminRegistrationActionSuccess) {
                        CustomSnackBar.show(context, message: state.message);
                        context.pop(true);
                      } else if (state is AdminRegistrationActionFailure) {
                        CustomSnackBar.show(context, message: state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is AdminRegistrationDetailsLoading ||
                          state is AdminRegistrationActionInProgress) {
                        // Admin Registration Details Shimmer
                        return const AdminRegistrationDetailsShimmer();
                      } else if (state is AdminRegistrationDetailsLoadSuccess) {
                        final shop = state.shop;
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 32.h,
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth > 900;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBackRow(context),
                                  SizedBox(height: 16.h),
                                  // Shop Details Header Card
                                  ShopDetailsHeaderCard(
                                    shop: shop,
                                    onApprove: () =>
                                        AdminDashboardHelper.showApproveConfirmation(
                                          context,
                                          shop,
                                        ),
                                    onReject: () =>
                                        AdminDashboardHelper.showRejectConfirmation(
                                          context,
                                          shop,
                                        ),
                                  ),
                                  SizedBox(height: 32.h),
                                  if (isWide)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            children: [
                                              // Basic Identity Card
                                              BasicIdentityCard(shop: shop),
                                              SizedBox(height: 32.h),
                                              // Verification Card
                                              VerificationCard(shop: shop),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 32.w),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              // Contact Details Card
                                              ContactDetailsCard(shop: shop),
                                              SizedBox(height: 32.h),
                                              GstCard(shop: shop),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        // Basic Identity Card
                                        BasicIdentityCard(shop: shop),
                                        SizedBox(height: 32.h),
                                        // Contact Details Card
                                        ContactDetailsCard(shop: shop),
                                        SizedBox(height: 32.h),
                                        // Gst Card
                                        GstCard(shop: shop),
                                        SizedBox(height: 32.h),
                                        // Verification Card
                                        VerificationCard(shop: shop),
                                      ],
                                    ),
                                ],
                              );
                            },
                          ),
                        );
                      } else if (state is AdminRegistrationDetailsLoadFailure) {
                        // Error State
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Failed to load details:\n${state.message}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // Button for Reload
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<AdminRegistrationDetailsBloc>()
                                      .add(LoadShopDetailsRequested(shopId));
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
          );
        },
      ),
    );
  }

  Widget _buildBackRow(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
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
            'Back to Registrations',
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
