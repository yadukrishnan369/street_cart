import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/profile_completion_modal.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/pages/edit_shop_profile_page.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/pages/add_edit_product_page.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class ShopHomeHelper {
  static void showProfileCompletionDialog(BuildContext context, ShopProfileModel? profile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ProfileCompletionModal(
        onCompleteNow: () {
          Navigator.pop(dialogContext);
          if (profile != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => sl<ShopProfileBloc>(),
                  child: EditShopProfilePage(profile: profile),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Loading profile details, please try again in a moment.',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        onMaybeLater: () => Navigator.pop(dialogContext),
      ),
    );
  }

  static void showLogoutConfirmation(BuildContext context) {
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

  static void onAddProductTap(BuildContext context, String shopId) {
    final productsBloc = sl<ShopProductsBloc>();
    productsBloc.add(LoadProductConfigEvent(shopId));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductPage(
          shopId: shopId,
          productsBloc: productsBloc,
        ),
      ),
    );
  }

  static void onEditProfileTap(BuildContext context, ShopProfileModel profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<ShopProfileBloc>(),
          child: EditShopProfilePage(profile: profile),
        ),
      ),
    );
  }
}
