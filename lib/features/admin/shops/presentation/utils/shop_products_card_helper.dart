import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_bloc.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_event.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_state.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

class ShopProductsCardHelper {
  // Generate Merchant ID
  static String generateMerchantId(ShopProfileModel shop) {
    final prefix = shop.shopName
        .substring(0, shop.shopName.length > 2 ? 2 : shop.shopName.length)
        .toUpperCase();
    final uidSlice = shop.uid
        .substring(0, shop.uid.length > 4 ? 4 : shop.uid.length)
        .toUpperCase();
    return '# $prefix-$uidSlice';
  }

  // Format Joined Date
  static String formatJoinedDate(ShopProfileModel shop) {
    return shop.createdAt != null
        ? DateFormatter.formatToReadableDate(shop.createdAt!)
        : 'Oct 12, 2023';
  }

  // Filter options
  static List<String> buildFilterOptions(List<ProductModel> products) {
    final categories = products.map((p) => p.category).toSet().toList()..sort();
    return [
      'All Products',
      'Active',
      'Disabled',
      'Out of Stock',
      ...categories,
    ];
  }

  // Returns the active filter
  static String resolveActiveFilter(
    String selectedFilter,
    List<String> filterOptions,
  ) {
    return filterOptions.contains(selectedFilter)
        ? selectedFilter
        : 'All Products';
  }

  // Product filtering
  static List<ProductModel> applyFilter(
    List<ProductModel> products,
    String activeFilter,
  ) {
    return products.where((p) {
      switch (activeFilter) {
        case 'All Products':
          return true;
        case 'Active':
          return !p.disabledByAdmin && p.isActive && p.stockQuantity > 0;
        case 'Disabled':
          return p.disabledByAdmin || (!p.isActive && p.stockQuantity > 0);
        case 'Out of Stock':
          return !p.disabledByAdmin && p.stockQuantity == 0;
        default:
          return p.category == activeFilter;
      }
    }).toList();
  }

  // Pagination Methods
  static int computeTotalPages(List<ProductModel> filteredProducts) {
    if (filteredProducts.isEmpty) return 1;
    return (filteredProducts.length / AdminShopDetailLoaded.itemsPerPage)
        .ceil();
  }

  static int resolveSafePage(int currentPage, int totalPages) {
    return currentPage.clamp(1, totalPages);
  }

  static List<ProductModel> paginate(
    List<ProductModel> filteredProducts,
    int safePage,
  ) {
    const itemsPerPage = AdminShopDetailLoaded.itemsPerPage;
    final startIndex = (safePage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(
      0,
      filteredProducts.length,
    );
    return filteredProducts.sublist(startIndex, endIndex);
  }

  // Formate price
  static String formatPrice(ProductModel product) {
    return product.offerPrice != null
        ? '₹${product.offerPrice!.toStringAsFixed(0)}'
        : '₹${product.originalPrice.toStringAsFixed(0)}';
  }

  // Format Stock
  static String formatStock(ProductModel product) {
    return product.stockQuantity == 0
        ? 'Out of Stock'
        : '${product.stockQuantity} in stock';
  }

  // Get Image URL
  static String getThumbnailUrl(ProductModel product) {
    return product.images.isNotEmpty ? product.images.first : '';
  }

  // Display status
  static ProductStatusStyle resolveStatus(ProductModel product) {
    final isOutOfStock = product.stockQuantity == 0;

    if (product.disabledByAdmin) {
      return ProductStatusStyle(
        label: 'Disabled',
        dotColor: AdminAppColors.errorColor,
        textColor: AdminAppColors.errorColor,
      );
    } else if (!product.isActive) {
      return ProductStatusStyle(
        label: 'Disabled',
        dotColor: const Color(0xFF8A8A9E),
        textColor: const Color(0xFF8A8A9E),
      );
    } else if (isOutOfStock) {
      return ProductStatusStyle(
        label: 'Out of Stock',
        dotColor: AdminAppColors.warningColor,
        textColor: AdminAppColors.warningColor,
      );
    } else {
      return ProductStatusStyle(
        label: 'Active',
        dotColor: AdminAppColors.successColor,
        textColor: AdminAppColors.successColor,
      );
    }
  }

  // Confirmation dialog confirm shop deletion
  static void confirmDelete(BuildContext context, ShopProfileModel shop) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Delete Shop',
        content: 'Are you sure you want to delete "${shop.shopName}"?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Delete',
        icon: Icons.delete_outline,
        iconColor: AdminAppColors.errorColor,
        primaryActionColor: AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          confirmDeleteSecondStep(context, shop);
        },
      ),
    );
  }

  // Second Confirmation for confirm shop deletion
  static void confirmDeleteSecondStep(
    BuildContext context,
    ShopProfileModel shop,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Permanently Delete Shop',
        content:
            'This action is irreversible. All profile data for '
            '"${shop.shopName}" will be permanently deleted. '
            'Do you want to proceed?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Permanently Delete',
        icon: Icons.warning_amber_outlined,
        iconColor: AdminAppColors.errorColor,
        primaryActionColor: AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          context.read<AdminShopDetailBloc>().add(
            DeleteShopRequested(shop.uid),
          );
        },
      ),
    );
  }

  // Confirmation dialog for suspension toggle
  static void confirmSuspensionToggle(BuildContext context, ShopProfileModel shop) {
    final isSuspended = shop.isSuspended;
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: isSuspended ? 'Activate Shop' : 'Suspend Shop',
        content:
            'Are you sure you want to ${isSuspended ? "activate" : "suspend"} "${shop.shopName}"?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: isSuspended ? 'Activate' : 'Suspend',
        icon: isSuspended
            ? Icons.play_circle_outline
            : Icons.pause_circle_outline,
        iconColor: isSuspended
            ? AdminAppColors.successColor
            : AdminAppColors.errorColor,
        primaryActionColor: isSuspended
            ? AdminAppColors.successColor
            : AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          context.read<AdminShopDetailBloc>().add(
            ToggleShopSuspensionRequested(
              shopId: shop.uid,
              isSuspended: !isSuspended,
            ),
          );
        },
      ),
    );
  }
}

// Simple value object
class ProductStatusStyle {
  final String label;
  final Color dotColor;
  final Color textColor;

  const ProductStatusStyle({
    required this.label,
    required this.dotColor,
    required this.textColor,
  });
}
