import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_images_section.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_basic_details_form.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_category_dropdown.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_size_selection.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_color_selection.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_submit_button.dart';

class AddEditProductFormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController offerPriceController;
  final TextEditingController descController;
  final TextEditingController stockController;
  final List<dynamic> images;
  final String selectedCategory;
  final List<String> categories;
  final String selectedSizeStandard;
  final List<String> sizeStandards;
  final List<String> availableSizes;
  final List<String> selectedSizes;
  final List<String> availableColors;
  final List<String> selectedColors;
  final bool isPublishing;
  final bool isEdit;
  final Function(int) onPickImage;
  final Function(int) onRemoveImage;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onSizeStandardChanged;
  final Function(String size, bool selected) onSizeChipSelected;
  final VoidCallback onAddSizePressed;
  final Function(String colorName, bool selected) onColorChipSelected;
  final VoidCallback onAddColorPressed;
  final VoidCallback onPublish;

  const AddEditProductFormContent({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.offerPriceController,
    required this.descController,
    required this.stockController,
    required this.images,
    required this.selectedCategory,
    required this.categories,
    required this.selectedSizeStandard,
    required this.sizeStandards,
    required this.availableSizes,
    required this.selectedSizes,
    required this.availableColors,
    required this.selectedColors,
    required this.isPublishing,
    required this.isEdit,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onCategoryChanged,
    required this.onSizeStandardChanged,
    required this.onSizeChipSelected,
    required this.onAddSizePressed,
    required this.onColorChipSelected,
    required this.onAddColorPressed,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImagesSection(
              images: images,
              onPickImage: onPickImage,
              onRemoveImage: onRemoveImage,
            ),
            SizedBox(height: 24.h),

            ProductBasicDetailsForm(
              nameController: nameController,
              priceController: priceController,
              offerPriceController: offerPriceController,
              descController: descController,
              stockController: stockController,
            ),
            SizedBox(height: 24.h),

            ProductCategoryDropdown(
              selectedCategory: selectedCategory,
              categories: categories,
              onChanged: onCategoryChanged,
            ),
            SizedBox(height: 24.h),

            ProductSizeSelection(
              selectedSizeStandard: selectedSizeStandard,
              sizeStandards: sizeStandards,
              availableSizes: availableSizes,
              selectedSizes: selectedSizes,
              onSizeStandardChanged: onSizeStandardChanged,
              onSizeChipSelected: onSizeChipSelected,
              onAddSizePressed: onAddSizePressed,
            ),
            SizedBox(height: 24.h),

            ProductColorSelection(
              availableColors: availableColors,
              selectedColors: selectedColors,
              onColorChipSelected: onColorChipSelected,
              onAddColorPressed: onAddColorPressed,
            ),
            SizedBox(height: 40.h),

            ProductSubmitButton(
              isPublishing: isPublishing,
              isEdit: isEdit,
              onPressed: onPublish,
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
