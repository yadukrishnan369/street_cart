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
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

class AdminRegistrationDetailsPage extends StatefulWidget {
  final String shopId;

  const AdminRegistrationDetailsPage({super.key, required this.shopId});

  @override
  State<AdminRegistrationDetailsPage> createState() =>
      _AdminRegistrationDetailsPageState();
}

class _AdminRegistrationDetailsPageState
    extends State<AdminRegistrationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AdminRegistrationDetailsBloc>()
            ..add(LoadShopDetailsRequested(widget.shopId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child:
              BlocConsumer<
                AdminRegistrationDetailsBloc,
                AdminRegistrationDetailsState
              >(
                listener: (context, state) {
                  if (state is AdminRegistrationActionSuccess) {
                    CustomSnackBar.show(context, message: state.message);
                    context.pop(
                      true,
                    ); // Return true to indicate a refresh is needed
                  } else if (state is AdminRegistrationActionFailure) {
                    CustomSnackBar.show(context, message: state.message);
                  }
                },
                builder: (context, state) {
                  if (state is AdminRegistrationDetailsLoading ||
                      state is AdminRegistrationActionInProgress) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AdminAppColors.primaryColor,
                      ),
                    );
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
                              // Top Shop Header Details Card
                              ShopDetailsHeaderCard(
                                shop: shop,
                                onApprove: () => _showApproveConfirmation(context, shop),
                                onReject: () => _showRejectConfirmation(context, shop),
                              ),
                              SizedBox(height: 32.h),

                              // Content Details Section
                              if (isWide)
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          BasicIdentityCard(shop: shop),
                                          SizedBox(height: 32.h),
                                          VerificationCard(shop: shop),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 32.w),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
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
                                    BasicIdentityCard(shop: shop),
                                    SizedBox(height: 32.h),
                                    ContactDetailsCard(shop: shop),
                                    SizedBox(height: 32.h),
                                    GstCard(shop: shop),
                                    SizedBox(height: 32.h),
                                    VerificationCard(shop: shop),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
                    );
                  } else if (state is AdminRegistrationDetailsLoadFailure) {
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
                          ElevatedButton(
                            onPressed: () {
                              context.read<AdminRegistrationDetailsBloc>().add(
                                LoadShopDetailsRequested(widget.shopId),
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

  void _showApproveConfirmation(BuildContext context, ShopProfileModel shop) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Approve Application',
        content:
            'Are you sure you want to approve "${shop.shopName}"? They will be allowed to access their Shop portal immediately.',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Approve',
        icon: Icons.check_circle_outline,
        iconColor: AdminAppColors.primaryColor,
        primaryActionColor: AdminAppColors.primaryColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          context.read<AdminRegistrationDetailsBloc>().add(
                ApproveShopRequested(shop.uid),
              );
        },
      ),
    );
  }

  void _showRejectConfirmation(BuildContext context, ShopProfileModel shop) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Reject Application',
        content:
            'Are you sure you want to reject "${shop.shopName}"? This will delete their registration profile permanently.',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Reject',
        icon: Icons.cancel_outlined,
        iconColor: AdminAppColors.errorColor,
        primaryActionColor: AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          context.read<AdminRegistrationDetailsBloc>().add(
                RejectShopRequested(shop.uid),
              );
        },
      ),
    );
  }
}
