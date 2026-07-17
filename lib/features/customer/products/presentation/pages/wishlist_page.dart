import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/shimmer/product_card_shimmer.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_state.dart';
import 'package:street_cart/shared/components/customer_bottom_navigation.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/wishlist_empty_state.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/wishlist_grid.dart';

// WishList Page
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(LoadWishlist());
  }

  // Confirmation for Clear WishList Items
  void _showClearWishlistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Clear Wishlist',
        content: 'Are you sure you want to remove all wishlist products?',
        primaryActionLabel: 'Clear',
        secondaryActionLabel: 'Cancel',
        icon: Icons.delete_sweep_outlined,
        iconColor: CustomerAppColors.error,
        primaryActionColor: CustomerAppColors.error,
        onPrimaryAction: () {
          context.read<WishlistBloc>().add(ClearAllWishlist());
          Navigator.pop(dialogCtx);
          CustomSnackBar.show(context, message: 'Wishlist cleared');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      appBar: AppBar(
        backgroundColor: CustomerAppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CustomerAppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: CustomerAppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              final hasItems =
                  state is WishlistLoaded && state.items.isNotEmpty;
              if (!hasItems) return const SizedBox();
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'clear_all') {
                    _showClearWishlistDialog(context);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'clear_all',
                    child: Text('Delete all'),
                  ),
                ],
                icon: const Icon(
                  Icons.more_vert,
                  color: CustomerAppColors.textPrimary,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const ProductCardShimmer(itemCount: 4);
          }

          if (state is WishlistError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  color: CustomerAppColors.error,
                  fontSize: 14,
                ),
              ),
            );
          }

          if (state is WishlistLoaded) {
            final items = state.items;

            if (items.isEmpty) {
              // Empty State
              return const WishlistEmptyState();
            }
            // Wish List Grid
            return WishlistGrid(items: items);
          }

          return const SizedBox();
        },
      ),
      bottomNavigationBar: const CustomerBottomNavigation(currentIndex: 0),
    );
  }
}
