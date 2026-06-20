import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_event.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/add_edit_category_dialog.dart';

class CategoryDialogs {
  static List<String> _getExistingNames(AdminSettingsModel settings, bool isProductTab) {
    final list = isProductTab ? settings.productCategories : settings.businessCategories;
    return list.map((e) => e.name).toList();
  }

  static void showAdd({
    required BuildContext context,
    required AdminSettingsModel settings,
    required bool isProductTab,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AddEditCategoryDialog(
        title: 'Add New ${isProductTab ? "Product" : "Business"} Category',
        description:
            'Create a new category for your streetcart catalog. Ensure the category name is unique, clear, and easy for shops/customers to browse.',
        existingNames: _getExistingNames(settings, isProductTab),
        onConfirm: (name) {
          showDialog(
            context: context,
            builder: (confirmCtx) => CustomAlertDialog(
              title: 'Confirm Add Category',
              content: 'Are you sure you want to add the category "$name"?',
              secondaryActionLabel: 'Cancel',
              primaryActionLabel: 'Confirm',
              icon: Icons.add,
              iconColor: AdminAppColors.primaryColor,
              primaryActionColor: AdminAppColors.primaryColor,
              onPrimaryAction: () {
                Navigator.pop(confirmCtx);
                final newCategory = CategoryModel(
                  id: const Uuid().v4(),
                  name: name,
                  isVisible: true,
                );

                final updatedProducts = List<CategoryModel>.from(
                  settings.productCategories,
                );
                final updatedBusiness = List<CategoryModel>.from(
                  settings.businessCategories,
                );

                if (isProductTab) {
                  updatedProducts.add(newCategory);
                } else {
                  updatedBusiness.add(newCategory);
                }

                context.read<AdminSettingsBloc>().add(
                  UpdateCategories(
                    productCategories: updatedProducts,
                    businessCategories: updatedBusiness,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  static void showEdit({
    required BuildContext context,
    required AdminSettingsModel settings,
    required CategoryModel category,
  }) {
    // Edit can occur in either Product or Business tabs. Check which list it belongs to.
    final isProductTab = settings.productCategories.any((e) => e.id == category.id);
    showDialog(
      context: context,
      builder: (dialogCtx) => AddEditCategoryDialog(
        title: 'Edit Category',
        description:
            'Update the category name. This change will immediately apply globally across all matching catalog listings.',
        initialName: category.name,
        existingNames: _getExistingNames(settings, isProductTab),
        onConfirm: (name) {
          showDialog(
            context: context,
            builder: (confirmCtx) => CustomAlertDialog(
              title: 'Confirm Edit',
              content:
                  'Are you sure you want to update the category name to "$name"?',
              secondaryActionLabel: 'Cancel',
              primaryActionLabel: 'Confirm',
              icon: Icons.edit_outlined,
              iconColor: AdminAppColors.primaryColor,
              primaryActionColor: AdminAppColors.primaryColor,
              onPrimaryAction: () {
                Navigator.pop(confirmCtx);

                final updatedProducts = settings.productCategories.map((e) {
                  if (e.id == category.id) {
                    return e.copyWith(name: name);
                  }
                  return e;
                }).toList();

                final updatedBusiness = settings.businessCategories.map((e) {
                  if (e.id == category.id) {
                    return e.copyWith(name: name);
                  }
                  return e;
                }).toList();

                context.read<AdminSettingsBloc>().add(
                  UpdateCategories(
                    productCategories: updatedProducts,
                    businessCategories: updatedBusiness,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  static void showDelete({
    required BuildContext context,
    required AdminSettingsModel settings,
    required CategoryModel category,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Delete Category',
        content:
            'Are you sure you want to delete the category "${category.name}"?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Delete',
        icon: Icons.delete_outline,
        iconColor: AdminAppColors.errorColor,
        primaryActionColor: AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);

          final updatedProducts = List<CategoryModel>.from(
            settings.productCategories,
          )..removeWhere((e) => e.id == category.id);
          final updatedBusiness = List<CategoryModel>.from(
            settings.businessCategories,
          )..removeWhere((e) => e.id == category.id);

          context.read<AdminSettingsBloc>().add(
            UpdateCategories(
              productCategories: updatedProducts,
              businessCategories: updatedBusiness,
            ),
          );
        },
      ),
    );
  }

  static void showToggleVisibility({
    required BuildContext context,
    required AdminSettingsModel settings,
    required CategoryModel category,
    required bool newVisibility,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Toggle Visibility',
        content:
            'Are you sure you want to make the category "${category.name}" ${newVisibility ? "visible" : "hidden"}?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Confirm',
        icon: newVisibility
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        iconColor: AdminAppColors.primaryColor,
        primaryActionColor: AdminAppColors.primaryColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);

          final updatedProducts = settings.productCategories.map((e) {
            if (e.id == category.id) {
              return e.copyWith(isVisible: newVisibility);
            }
            return e;
          }).toList();

          final updatedBusiness = settings.businessCategories.map((e) {
            if (e.id == category.id) {
              return e.copyWith(isVisible: newVisibility);
            }
            return e;
          }).toList();

          context.read<AdminSettingsBloc>().add(
            UpdateCategories(
              productCategories: updatedProducts,
              businessCategories: updatedBusiness,
            ),
          );
        },
      ),
    );
  }
}
