import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_category_form_cubit.dart';

class CategoryConfigDialog extends StatelessWidget {
  final String title;
  final String description;
  final List<SizeGroupModel> allSizeGroups;
  final CategoryModel? initialCategory;
  final Function(
    BuildContext dialogCtx,
    String name,
    List<String> productCategories,
    List<String> sizeGroups,
  )
  onConfirm;

  CategoryConfigDialog({
    super.key,
    required this.title,
    required this.description,
    required this.allSizeGroups,
    this.initialCategory,
    required this.onConfirm,
  });

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prodCatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = AdminCategoryFormCubit(
          allSizeGroups: allSizeGroups,
          initialCategory: initialCategory,
        );
        _nameController.text = cubit.state.name;
        return cubit;
      },
      child: Builder(
        builder: (context) {
          final cubit = context.read<AdminCategoryFormCubit>();
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Container(
              width: 650.w,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: EdgeInsets.all(28.w),
              child: BlocBuilder<AdminCategoryFormCubit, AdminCategoryFormState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E1E2F),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF8A8A9E),
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Business Category Name
                              Text(
                                'Business Category Name',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E1E2F),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              TextField(
                                controller: _nameController,
                                onChanged: cubit.updateName,
                                decoration: InputDecoration(
                                  hintText: 'e.g. Footwear',
                                  errorText: state.nameError,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // Product Categories input + Tag List
                              Text(
                                'Product Categories (Subcategories)',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E1E2F),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _prodCatController,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Add product category (e.g. Shoes)',
                                        errorText: state.productCategoryError,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 10.h,
                                        ),
                                      ),
                                      onSubmitted: (val) {
                                        cubit.addProductCategory(val);
                                        _prodCatController.clear();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AdminAppColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 14.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      cubit.addProductCategory(
                                        _prodCatController.text,
                                      );
                                      _prodCatController.clear();
                                    },
                                    child: const Text('Add'),
                                  ),
                                ],
                              ),
                              if (state.productCategories.isNotEmpty) ...[
                                SizedBox(height: 8.h),
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 4.h,
                                  children: List.generate(
                                    state.productCategories.length,
                                    (index) {
                                      final cat =
                                          state.productCategories[index];
                                      return Chip(
                                        label: Text(
                                          cat,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        backgroundColor: Colors.grey[100],
                                        onDeleted: () =>
                                            cubit.removeProductCategory(index),
                                        deleteIconColor: Colors.redAccent,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      );
                                    },
                                  ),
                                ),
                              ],
                              SizedBox(height: 16.h),

                              // Linked Size Groups Selectable Chips
                              Text(
                                'Select Size Groups',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E1E2F),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              if (state.availableSizeGroups.isEmpty)
                                Text(
                                  'No size groups configured. Create size groups in Product Configuration.',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.red[400],
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              else
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 4.h,
                                  children: state.availableSizeGroups.map((
                                    group,
                                  ) {
                                    final name = group.name;
                                    final isSelected = state.selectedSizeGroups
                                        .contains(name);
                                    return FilterChip(
                                      label: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      selected: isSelected,
                                      selectedColor:
                                          AdminAppColors.primaryColor,
                                      checkmarkColor: Colors.white,
                                      backgroundColor: Colors.grey[200],
                                      onSelected: (_) =>
                                          cubit.toggleSizeGroup(name),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Actions Block
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          SizedBox(width: 12.w),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AdminAppColors.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: () {
                              if (cubit.validate()) {
                                onConfirm(
                                  context,
                                  state.name.trim(),
                                  state.productCategories,
                                  state.selectedSizeGroups.toList(),
                                );
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
