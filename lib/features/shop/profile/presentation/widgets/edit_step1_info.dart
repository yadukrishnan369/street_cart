import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'edit_profile_header.dart';

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
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShopEditProfileHeader(
            profileImageUrl: profileImageUrl,
            onPickImage: onPickImage,
            onRemoveImage: onRemoveImage,
            isUploading: isUploadingImage,
          ),
          SizedBox(height: 32.h),
          CustomTextField(
            label: "Shop Owner Name",
            controller: ownerNameController,
            hintText: 'Enter owner name',
            validator: Validators.validateName,
            labelStyle: ShopAppTextStyles.bodyMediumBold,
            textStyle: ShopAppTextStyles.bodyMedium,
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.textTertiary,
            ),
            fillColor: ShopAppColors.surface,
            borderColor: ShopAppColors.border,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            label: "Shop Name",
            controller: shopNameController,
            hintText: 'Enter shop name',
            validator: Validators.validateShopName,
            labelStyle: ShopAppTextStyles.bodyMediumBold,
            textStyle: ShopAppTextStyles.bodyMedium,
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.textTertiary,
            ),
            fillColor: ShopAppColors.surface,
            borderColor: ShopAppColors.border,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              'Business Category',
              style: ShopAppTextStyles.bodyMediumBold,
            ),
          ),
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedCategory,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              fillColor: ShopAppColors.surface,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ShopAppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ShopAppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ShopAppColors.primary),
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: ShopAppColors.textSecondary,
            ),
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: ShopAppTextStyles.bodyMedium),
              );
            }).toList(),
            onChanged: onCategoryChanged,
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            label: "Shop Description",
            controller: descriptionController,
            hintText: 'Describe your business',
            maxLines: 4,
            validator: Validators.validateDescription,
            labelStyle: ShopAppTextStyles.bodyMediumBold,
            textStyle: ShopAppTextStyles.bodyMedium,
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.textTertiary,
            ),
            fillColor: ShopAppColors.surface,
            borderColor: ShopAppColors.border,
            focusedBorderColor: ShopAppColors.primary,
          ),
        ],
      ),
    );
  }
}
