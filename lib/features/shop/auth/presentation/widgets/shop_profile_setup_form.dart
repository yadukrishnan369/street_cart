import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/validators.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_categories_cubit.dart';
import 'package:street_cart/shared/widgets/custom_text_field.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ShopProfileSetupForm extends StatefulWidget {
  const ShopProfileSetupForm({super.key});

  @override
  State<ShopProfileSetupForm> createState() => _ShopProfileSetupFormState();
}

class _ShopProfileSetupFormState extends State<ShopProfileSetupForm> {
  final _descriptionController = TextEditingController();
  final _gstController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  String? _selectedCategory;
  File? _businessLicense;
  File? _ownerId;

  @override
  void dispose() {
    _descriptionController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isLicense) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isLicense) {
          _businessLicense = File(pickedFile.path);
        } else {
          _ownerId = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          Text(
            'Let Street Cart know about your shop for verification',
            textAlign: TextAlign.center,
            style: ShopAppTextStyles.heading2.copyWith(height: 1.2),
          ),
          SizedBox(height: 40.h),
          _buildFieldLabel('Business Category'),
          BlocBuilder<ShopCategoriesCubit, ShopCategoriesState>(
            builder: (context, state) {
              List<String> categories = [];
              bool isLoading = false;
              String? error;

              if (state is ShopCategoriesLoading) {
                isLoading = true;
              } else if (state is ShopCategoriesLoaded) {
                categories = state.categories;
              } else if (state is ShopCategoriesError) {
                error = state.message;
              }

              if (isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: ShopAppColors.primary,
                    ),
                  ),
                );
              }

              if (error != null) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    'Failed to load categories: $error',
                    style: ShopAppTextStyles.bodyMedium.copyWith(color: ShopAppColors.error),
                  ),
                );
              }

              return DropdownButtonFormField<String>(
                isExpanded: true,
                hint: Text(
                  'Select a category...',
                  style: ShopAppTextStyles.bodyMedium,
                ),
                value: _selectedCategory,
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
                  errorStyle: ShopAppTextStyles.bodySmall.copyWith(color: ShopAppColors.error),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: ShopAppColors.textSecondary,
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: ShopAppTextStyles.bodyMediumBold,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: Validators.validateCategory,
              );
            },
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            label: "Short Shop Description",
            controller: _descriptionController,
            hintText: 'Tell us about your products and what makes your shop unique...',
            maxLines: 4,
            validator: Validators.validateDescription,
            labelStyle: ShopAppTextStyles.bodyMediumBold,
            textStyle: ShopAppTextStyles.bodyMedium,
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(color: ShopAppColors.textTertiary),
            fillColor: ShopAppColors.surface,
            borderColor: ShopAppColors.border,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            label: "GST NUMBER",
            controller: _gstController,
            hintText: '22AAAAA0000A1Z5',
            validator: Validators.validateGST,
            labelStyle: ShopAppTextStyles.bodyMediumBold,
            textStyle: ShopAppTextStyles.bodyMedium,
            hintStyle: ShopAppTextStyles.bodyMedium.copyWith(color: ShopAppColors.textTertiary),
            fillColor: ShopAppColors.surface,
            borderColor: ShopAppColors.border,
            focusedBorderColor: ShopAppColors.primary,
          ),
          SizedBox(height: 32.h),
          _buildFieldLabel('REQUIRED DOCUMENTS'),
          _buildDocumentPicker(
            'Business License',
            'PDF, JPG or PNG (Max 5MB)',
            Icons.description_outlined,
            _businessLicense != null,
            () => _pickImage(true),
          ),
          SizedBox(height: 16.h),
          _buildDocumentPicker(
            'Owner ID',
            'National ID or Passport',
            Icons.badge_outlined,
            _ownerId != null,
            () => _pickImage(false),
          ),
          SizedBox(height: 48.h),
          BlocBuilder<ShopAuthBloc, ShopAuthState>(
            builder: (context, state) {
              return PrimaryButton(
                text: 'Save & Continue',
                isLoading: state is ShopAuthLoading,
                backgroundColor: ShopAppColors.primary,
                textStyle: ShopAppTextStyles.buttonText,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedCategory == null) {
                      CustomSnackBar.show(
                        context,
                        message: 'Please select a business category',
                      );
                      return;
                    }
                    if (_businessLicense == null || _ownerId == null) {
                      CustomSnackBar.show(
                        context,
                        message: 'Please upload required documents',
                      );
                      return;
                    }

                    context.read<ShopAuthBloc>().add(
                          ShopSetupProfileStarted(
                            category: _selectedCategory!,
                            description: _descriptionController.text.trim(),
                            gstNumber: _gstController.text.trim(),
                            businessLicenseFile: _businessLicense!,
                            ownerIdFile: _ownerId!,
                          ),
                        );
                  }
                },
              );
            },
          ),
          SizedBox(height: 32.h),
          Center(
            child: Text(
              'You can change these settings at any time in your shop dashboard.',
              textAlign: TextAlign.center,
              style: ShopAppTextStyles.bodySmall,
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: ShopAppTextStyles.bodyMediumBold,
      ),
    );
  }

  Widget _buildDocumentPicker(
    String title,
    String subtitle,
    IconData icon,
    bool isPicked,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: ShopAppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isPicked ? ShopAppColors.primary : ShopAppColors.border,
            width: isPicked ? 2 : 1.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: ShopAppColors.primary.withAlpha(20), // Replaced withOpacity(0.08)
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: ShopAppColors.primary, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ShopAppTextStyles.bodyMediumBold,
                  ),
                  Text(
                    subtitle,
                    style: ShopAppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              isPicked ? Icons.check_circle : Icons.add_circle_outline,
              size: 20.sp,
              color: isPicked ? ShopAppColors.primary : ShopAppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
