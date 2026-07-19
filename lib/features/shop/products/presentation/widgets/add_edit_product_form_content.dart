import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/constants/admin_constants.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_state.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_basic_details_form.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/variant_card.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/variant_form_sheet.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/add_edit_product_section_header.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/add_variant_button.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/overall_stock_display.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/publish_product_button.dart';
import 'package:street_cart/features/shop/products/presentation/utils/products_page_helper.dart';

// Add Edit Product Form Content
class AddEditProductFormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController offerPriceController;
  final TextEditingController descController;
  final List<String> categories;
  final Map<String, dynamic> customConfig;
  final bool isEdit;
  final VoidCallback onPublish;

  const AddEditProductFormContent({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.offerPriceController,
    required this.descController,
    required this.categories,
    required this.customConfig,
    required this.isEdit,
    required this.onPublish,
  });

  // Open variant form sheet
  void _openVariantSheet(
    BuildContext context, {
    VariantDraft? existing,
    int? editIndex,
    required String sizeStandard,
    required List<String> usedColors,
  }) {
    final bloc = context.read<AddEditProductBloc>();
    final allColors = ProductsPageHelper.getAvailableColors(customConfig);

    final Map<String, String> availableForSheet = {};
    allColors.forEach((name, hex) {
      if (editIndex != null || !usedColors.contains(name)) {
        availableForSheet[name] = hex;
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: VariantFormSheet(
          existingVariant: existing,
          availableColors: availableForSheet,
          availableSizes: ProductsPageHelper.getAvailableSizes(
            customConfig,
            sizeStandard,
          ),
          onSave: (draft) {
            if (editIndex != null) {
              bloc.add(UpdateVariantEvent(editIndex, draft));
            } else {
              bloc.add(AddVariantEvent(draft));
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditProductBloc, AddEditProductState>(
      builder: (context, state) {
        final bloc = context.read<AddEditProductBloc>();

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Details Form Section
                ProductBasicDetailsForm(
                  nameController: nameController,
                  priceController: priceController,
                  offerPriceController: offerPriceController,
                  descController: descController,
                  selectedCategory: state.category,
                  categories: categories,
                  selectedSizeStandard: state.sizeStandard,
                  sizeStandards: ProductsPageHelper.getSizeStandards(
                    customConfig,
                  ),
                  onCategoryChanged: (val) {
                    if (val != null) {
                      bloc.add(UpdateCategoryEvent(val));
                    }
                  },
                  onSizeStandardChanged: (val) {
                    if (val != null) {
                      bloc.add(
                        UpdateSizeStandardEvent(
                          sizeStandard: val,
                          newSizeKeys: ProductsPageHelper.getAvailableSizes(
                            customConfig,
                            val,
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 32.h),

                // Colors & Stock Section
                const AddEditProductSectionHeader(
                  icon: Icons.palette_outlined,
                  title: 'Product Variants',
                  subtitle:
                      'Add color variants with images and stock per size.',
                ),
                SizedBox(height: 16.h),

                // Variant cards
                if (state.variants.isNotEmpty) ...[
                  ...state.variants.asMap().entries.map((entry) {
                    final i = entry.key;
                    final v = entry.value;
                    return VariantCard(
                      variant: v,
                      index: i,
                      onEdit: () => _openVariantSheet(
                        context,
                        existing: v,
                        editIndex: i,
                        sizeStandard: state.sizeStandard,
                        usedColors: state.usedColorNames,
                      ),
                      onDelete: () => bloc.add(RemoveVariantEvent(i)),
                    );
                  }),
                  SizedBox(height: 4.h),
                ],

                // Add Variant button
                AddVariantButton(
                  onTap: () => _openVariantSheet(
                    context,
                    sizeStandard: state.sizeStandard.isNotEmpty
                        ? state.sizeStandard
                        : AdminConstants.defaultSizeStandards.first,
                    usedColors: state.usedColorNames,
                  ),
                  hasVariants: state.hasVariants,
                ),
                SizedBox(height: 24.h),

                // Overall Stock Quantity
                if (state.hasVariants) ...[
                  OverallStockDisplay(totalStock: state.totalStock),
                  SizedBox(height: 24.h),
                ],

                // Error message by variant validation
                if (state.errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: ShopAppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: ShopAppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: ShopAppColors.error,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            state.errorMessage!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ShopAppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],

                // Publish button
                PublishProductButton(
                  isPublishing: state.isPublishing,
                  isEdit: isEdit,
                  onPressed: onPublish,
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
