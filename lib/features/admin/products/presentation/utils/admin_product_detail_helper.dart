import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_detail_bloc.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_detail_event.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class AdminProductDetailHelper {
  // Confirmation for Disable/Enable Product
  static void confirmDisable(
    BuildContext context,
    String productId,
    bool disable,
  ) {
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

  // Confirm Delete of Product
  static void confirmDelete(BuildContext context, String productId) {
    final bloc = context.read<AdminProductDetailBloc>();
    showDialog(
      context: context,
      builder: (dialogCtx) => ConfirmationModal(
        title: 'Delete Product?',
        content:
            'Are you sure you want to delete this product? This will permanently remove it from active business operations, but all historical orders, sales statistics, reviews, and financial records will be preserved. Proceed?',
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
                  'Confirming again: Delete this product? Existing sales and order records will remain unaffected. This cannot be undone.',
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
