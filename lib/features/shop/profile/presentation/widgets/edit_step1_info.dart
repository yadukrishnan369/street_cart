import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'edit_profile_header.dart';

// Edit Step1 Info
class EditStep1Info extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController ownerNameController;
  final TextEditingController shopNameController;
  final TextEditingController descriptionController;
  final String? profileImageUrl;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final bool isUploadingImage;
  final String? selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onCategoryChanged;

  const EditStep1Info({
    super.key,
    required this.formKey,
    required this.ownerNameController,
    required this.shopNameController,
    required this.descriptionController,
    required this.profileImageUrl,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.isUploadingImage,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputFillColor = isDark
        ? ShopAppColors.darkInputBackground
        : ShopAppColors.surface;
    final inputBorderColor = isDark
        ? ShopAppColors.darkBorder
        : ShopAppColors.border;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit Shop Profile Header Section
          ShopEditProfileHeader(
            profileImageUrl: profileImageUrl,
            onPickImage: onPickImage,
            onRemoveImage: onRemoveImage,
            isUploading: isUploadingImage,
          ),
          SizedBox(height: 32.h),
          // Owner Name Field
          CustomTextField(
            label: "Shop Owner Name",
            controller: ownerNameController,
            hintText: 'Enter owner name',
            validator: Validators.validateName,
            prefixIcon: const Icon(
              Icons.person_2_outlined,
              color: ShopAppColors.primary,
            ),
            labelStyle: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
            ),
            textStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
            ),
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textTertiary,
            ),
            fillColor: inputFillColor,
            borderColor: inputBorderColor,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 20.h),
          // Shop Name Field
          CustomTextField(
            label: "Shop Name",
            controller: shopNameController,
            hintText: 'Enter shop name',
            validator: Validators.validateShopName,
            prefixIcon: const Icon(
              Icons.storefront,
              color: ShopAppColors.primary,
            ),
            labelStyle: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
            ),
            textStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
            ),
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textTertiary,
            ),
            fillColor: inputFillColor,
            borderColor: inputBorderColor,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            // Select Business Category Field
            child: Text(
              'Business Category',
              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextPrimary
                    : ShopAppColors.textPrimary,
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: selectedCategory,
            dropdownColor: isDark ? ShopAppColors.darkSurface : Colors.white,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              fillColor: inputFillColor,
              filled: true,
              prefixIcon: const Icon(
                Icons.category_outlined,
                color: ShopAppColors.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ShopAppColors.primary),
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textSecondary,
            ),
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(
                  category,
                  style: ShopAppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
            onChanged: onCategoryChanged,
          ),
          SizedBox(height: 20.h),
          // Shop Description Field
          CustomTextField(
            label: "Shop Description",
            controller: descriptionController,
            hintText: 'Describe your business',
            maxLines: 4,
            validator: Validators.validateDescription,
            prefixIcon: const Icon(
              Icons.description_outlined,
              color: ShopAppColors.primary,
            ),
            labelStyle: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
            ),
            textStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
            ),
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textTertiary,
            ),
            fillColor: inputFillColor,
            borderColor: inputBorderColor,
            focusedBorderColor: ShopAppColors.primary,
          ),
        ],
      ),
    );
  }
}
