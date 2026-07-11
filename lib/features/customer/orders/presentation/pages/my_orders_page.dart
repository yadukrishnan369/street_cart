import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_event.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_state.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/empty_orders_view.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/recent_orders_list.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/shimmer/customer_orders_shimmer.dart';
import 'package:street_cart/shared/components/customer_bottom_navigation.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersBloc>(
      create: (context) => sl<OrdersBloc>()..add(FetchOrders()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'My Orders',
            style: TextStyle(
              color: CustomerAppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomePage(),
                transitionDuration: Duration.zero,
              ),
            ),
          ),
        ),
        body: BlocConsumer<OrdersBloc, OrdersState>(
          listener: (context, state) {
            if (state is OrdersFailure) {
              CustomSnackBar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            if (state is OrdersLoading || state is OrdersInitial) {
              return const CustomerOrdersShimmer();
            }

            if (state is OrdersLoaded) {
              final orders = state.orders;
              if (orders.isEmpty) {
                return EmptyOrdersView(
                  onRefresh: () =>
                      context.read<OrdersBloc>().add(FetchOrders()),
                );
              }

              return RefreshIndicator(
                color: CustomerAppColors.primary,
                onRefresh: () async =>
                    context.read<OrdersBloc>().add(FetchOrders()),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recent Order list
                      RecentOrdersList(orders: orders),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: Text('Something went wrong.'));
          },
        ),
        bottomNavigationBar: const CustomerBottomNavigation(currentIndex: 3),
      ),
    );
  }
}
