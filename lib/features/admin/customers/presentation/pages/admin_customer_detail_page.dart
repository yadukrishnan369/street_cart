import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_event.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_state.dart';
import 'package:street_cart/features/admin/customers/presentation/widgets/admin_customer_detail_header_card.dart';
import 'package:street_cart/features/admin/customers/presentation/widgets/admin_customer_contact_info_card.dart';
import 'package:street_cart/features/admin/customers/presentation/widgets/admin_customer_stats_card.dart';
import 'package:street_cart/features/admin/customers/presentation/widgets/admin_customer_past_orders_card.dart';
import 'package:street_cart/features/admin/customers/presentation/widgets/shimmer/admin_customer_detail_shimmer.dart';

// Admin Customer Detail Page
class AdminCustomerDetailPage extends StatelessWidget {
  final String customerId;

  const AdminCustomerDetailPage({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) =>
          sl<AdminCustomerDetailBloc>()
            ..add(LoadCustomerDetailRequested(customerId)),
      child: Scaffold(
        backgroundColor: isDark
            ? AdminAppColors.darkBackground
            : const Color(0xFFF9FAFC),
        body: SafeArea(
          child:
              BlocConsumer<AdminCustomerDetailBloc, AdminCustomerDetailState>(
                listener: (context, state) {
                  if (state is AdminCustomerDetailActionSuccess) {
                    CustomSnackBar.show(context, message: state.message);
                    if (state.message == 'Customer deleted successfully') {
                      context.pop(true);
                    }
                  } else if (state is AdminCustomerDetailError) {
                    CustomSnackBar.show(
                      context,
                      message: state.message,
                      isError: true,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AdminCustomerDetailLoading ||
                      state is AdminCustomerDetailActionInProgress) {
                    // Loading Shimmer
                    return const AdminCustomerDetailShimmer();
                  } else if (state is AdminCustomerDetailLoaded) {
                    final customer = state.customer;
                    final addresses = state.addresses;
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
                              // Admin Customer Detail Header Card
                              AdminCustomerDetailHeaderCard(customer: customer),
                              SizedBox(height: 32.h),
                              if (isWide)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      // Admin Customer Contact Info Card
                                      child: AdminCustomerContactInfoCard(
                                        customer: customer,
                                        addresses: addresses,
                                      ),
                                    ),
                                    SizedBox(width: 24.w),
                                    Expanded(
                                      flex: 5,
                                      // Admin Customer Stats Card
                                      child: AdminCustomerStatsCard(
                                        orders: state.orders,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    // Admin Customer Contact Info Card
                                    AdminCustomerContactInfoCard(
                                      customer: customer,
                                      addresses: addresses,
                                    ),
                                    SizedBox(height: 24.h),
                                    // Admin Customer Stats Card
                                    AdminCustomerStatsCard(
                                      orders: state.orders,
                                    ),
                                  ],
                                ),
                              SizedBox(height: 32.h),
                              // Admin Customer Past Orders Card
                              AdminCustomerPastOrdersCard(
                                orders: state.orders,
                                currentPage: state.currentPage,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else if (state is AdminCustomerDetailError) {
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
                              color: AdminAppColors.errorColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () {
                              context.read<AdminCustomerDetailBloc>().add(
                                LoadCustomerDetailRequested(customerId),
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
