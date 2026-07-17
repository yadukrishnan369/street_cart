import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_event.dart';

// Refresh Indicator for Fetch Product
class ProductsRefreshIndicator extends StatelessWidget {
  final Widget child;
  final VoidCallback? onRefreshStarted;

  const ProductsRefreshIndicator({
    super.key,
    required this.child,
    this.onRefreshStarted,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: CustomerAppColors.primary,
      onRefresh: () async {
        if (onRefreshStarted != null) {
          onRefreshStarted!();
        }
        context.read<CustomerProductsBloc>().add(
          FetchCustomerProducts(
            initialSearchQuery: "",
            initialSelectedSort: "Newest",
            initialPriceRange: const RangeValues(0, 10000),
            initialSelectedCategories: const {'All'},
            initialSelectedRating: null,
            initialSelectedColors: const {},
            initialSelectedSizes: const {},
          ),
        );
      },
      child: child,
    );
  }
}
