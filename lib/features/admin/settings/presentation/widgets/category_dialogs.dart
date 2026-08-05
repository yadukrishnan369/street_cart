import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_event.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/category_config_dialog.dart';

// Category Dialogs
class CategoryDialogs {
  static void showAdd({
    required BuildContext context,
    required AdminSettingsModel settings,
    required List<SizeGroupModel> allSizeGroups,
  }) {
    final settingsBloc = context.read<AdminSettingsBloc>();
    final productConfigBloc = context.read<AdminProductConfigBloc>();
    showDialog(
      context: context,
      builder: (dialogCtx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: settingsBloc),
          BlocProvider.value(value: productConfigBloc),
        ],
        child: CategoryConfigDialog(
          title: 'Add Business Configuration',
          description:
              'Configure a business category name, link product categories, and select matching size standards.',
          allSizeGroups: allSizeGroups,
          onConfirm: (dialogCtx, name, productCats, sizeGrps) {
            showDialog(
              context: context,
              builder: (confirmCtx) => CustomAlertDialog(
                title: 'Confirm Configuration',
                content:
                    'Are you sure you want to add this category configuration for "$name"?',
                secondaryActionLabel: 'Cancel',
                primaryActionLabel: 'Confirm',
                icon: Icons.add,
                iconColor: AdminAppColors.primaryColor,
                primaryActionColor: AdminAppColors.primaryColor,
                onPrimaryAction: () {
                  Navigator.pop(confirmCtx);
                  Navigator.pop(dialogCtx);
                  final newCategory = CategoryModel(
                    id: const Uuid().v4(),
                    name: name,
                    isVisible: true,
                    productCategories: productCats,
                    sizeGroups: sizeGrps,
                  );

                  final updatedBusiness = List<CategoryModel>.from(
                    settings.businessCategories,
                  )..add(newCategory);

                  context.read<AdminSettingsBloc>().add(
                    UpdateCategories(
                      productCategories: settings.productCategories,
                      businessCategories: updatedBusiness,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  static void showEdit({
    required BuildContext context,
    required AdminSettingsModel settings,
    required CategoryModel category,
    required List<SizeGroupModel> allSizeGroups,
  }) {
    final settingsBloc = context.read<AdminSettingsBloc>();
    final productConfigBloc = context.read<AdminProductConfigBloc>();
    showDialog(
      context: context,
      builder: (dialogCtx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: settingsBloc),
          BlocProvider.value(value: productConfigBloc),
        ],
        child: CategoryConfigDialog(
          title: 'Edit Business Configuration',
          description:
              'Update configuration details, add/remove sub product categories, and modify selected size groups.',
          initialCategory: category,
          allSizeGroups: allSizeGroups,
          onConfirm: (dialogCtx, name, productCats, sizeGrps) {
            showDialog(
              context: context,
              builder: (confirmCtx) => CustomAlertDialog(
                title: 'Confirm Edit',
                content:
                    'Are you sure you want to update configuration details for "$name"?',
                secondaryActionLabel: 'Cancel',
                primaryActionLabel: 'Confirm',
                icon: Icons.edit_outlined,
                iconColor: AdminAppColors.primaryColor,
                primaryActionColor: AdminAppColors.primaryColor,
                onPrimaryAction: () {
                  Navigator.pop(confirmCtx);
                  Navigator.pop(dialogCtx);

                  final updatedBusiness = settings.businessCategories.map((e) {
                    if (e.id == category.id) {
                      return e.copyWith(
                        name: name,
                        productCategories: productCats,
                        sizeGroups: sizeGrps,
                      );
                    }
                    return e;
                  }).toList();

                  context.read<AdminSettingsBloc>().add(
                    UpdateCategories(
                      productCategories: settings.productCategories,
                      businessCategories: updatedBusiness,
                    ),
                  );
                },
              ),
            );
          },
        ),
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
