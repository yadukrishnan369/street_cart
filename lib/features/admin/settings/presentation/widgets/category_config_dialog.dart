import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_event.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_state.dart';

// Category Config Dialog
class CategoryConfigDialog extends StatefulWidget {
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

  const CategoryConfigDialog({
    super.key,
    required this.title,
    required this.description,
    required this.allSizeGroups,
    this.initialCategory,
    required this.onConfirm,
  });

  @override
  State<CategoryConfigDialog> createState() => _CategoryConfigDialogState();
}

class _CategoryConfigDialogState extends State<CategoryConfigDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _prodCatController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialCategory?.name ?? '',
    );
    _prodCatController = TextEditingController();

    // Initialize category form state
    context.read<AdminSettingsBloc>().add(
      InitCategoryForm(
        initialCategory: widget.initialCategory,
        allSizeGroups: widget.allSizeGroups,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _prodCatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: isDark ? AdminAppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isDark
              ? AdminAppColors.primaryColor
              : AdminAppColors.borderLight,
          width: 1,
        ),
      ),
      child: Container(
        width: 650.w,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.all(28.w),
        child: BlocBuilder<AdminSettingsBloc, AdminSettingsState>(
          builder: (context, state) {
            final bloc = context.read<AdminSettingsBloc>();

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AdminAppColors.darkTextPrimary
                        : AdminAppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                // Description
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark
                        ? AdminAppColors.darkTextSecondary
                        : const Color(0xFF8A8A9E),
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
                            color: isDark
                                ? AdminAppColors.darkTextPrimary
                                : AdminAppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        TextField(
                          controller: _nameController,
                          style: TextStyle(
                            color: isDark
                                ? AdminAppColors.darkTextPrimary
                                : AdminAppColors.textPrimary,
                          ),
                          onChanged: (val) =>
                              bloc.add(UpdateCategoryFormName(val)),
                          decoration: InputDecoration(
                            hintText: 'e.g. Footwear',
                            hintStyle: TextStyle(
                              color: isDark
                                  ? AdminAppColors.darkTextSecondary
                                  : const Color(0xFF8A8A9E),
                            ),
                            errorText: state.formNameError,
                            fillColor: isDark
                                ? AdminAppColors.darkInputBackground
                                : const Color(0xFFF9FAFC),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AdminAppColors.darkBorder
                                    : const Color(0xFFE8E7ED),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                color: AdminAppColors.primaryColor,
                                width: 1.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AdminAppColors.darkBorder
                                    : const Color(0xFFE8E7ED),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Product Categories (Subcategories)',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AdminAppColors.darkTextPrimary
                                : AdminAppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _prodCatController,
                                style: TextStyle(
                                  color: isDark
                                      ? AdminAppColors.darkTextPrimary
                                      : AdminAppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Add product category (e.g. Shoes)',
                                  hintStyle: TextStyle(
                                    color: isDark
                                        ? AdminAppColors.darkTextSecondary
                                        : const Color(0xFF8A8A9E),
                                  ),
                                  errorText: state.formProductCategoryError,
                                  fillColor: isDark
                                      ? AdminAppColors.darkInputBackground
                                      : const Color(0xFFF9FAFC),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: isDark
                                          ? AdminAppColors.darkBorder
                                          : const Color(0xFFE8E7ED),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: const BorderSide(
                                      color: AdminAppColors.primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: isDark
                                          ? AdminAppColors.darkBorder
                                          : const Color(0xFFE8E7ED),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                ),
                                onSubmitted: (val) {
                                  bloc.add(AddProductCategoryToForm(val));
                                  _prodCatController.clear();
                                },
                              ),
                            ),
                            SizedBox(width: 8.w),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AdminAppColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 14.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () {
                                bloc.add(
                                  AddProductCategoryToForm(
                                    _prodCatController.text,
                                  ),
                                );
                                _prodCatController.clear();
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                        if (state.formProductCategories.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 4.h,
                            children: List.generate(
                              state.formProductCategories.length,
                              (index) {
                                final cat = state.formProductCategories[index];
                                return Chip(
                                  label: Text(
                                    cat,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: isDark
                                          ? AdminAppColors.darkTextPrimary
                                          : AdminAppColors.textPrimary,
                                    ),
                                  ),
                                  backgroundColor: isDark
                                      ? AdminAppColors.darkInputBackground
                                      : Colors.grey[100],
                                  side: isDark
                                      ? BorderSide(
                                          color: AdminAppColors.darkBorder,
                                        )
                                      : BorderSide.none,
                                  onDeleted: () => bloc.add(
                                    RemoveProductCategoryFromForm(index),
                                  ),
                                  deleteIconColor: Colors.redAccent,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                );
                              },
                            ),
                          ),
                        ],
                        SizedBox(height: 16.h),

                        // Size Groups Selectable Chips
                        Text(
                          'Select Size Groups',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AdminAppColors.darkTextPrimary
                                : AdminAppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        if (state.formAvailableSizeGroups.isEmpty)
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
                            children: state.formAvailableSizeGroups.map((
                              group,
                            ) {
                              final name = group.name;
                              final isSelected = state.formSelectedSizeGroups
                                  .contains(name);
                              return FilterChip(
                                label: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark
                                              ? AdminAppColors.darkTextPrimary
                                              : AdminAppColors.textPrimary),
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: AdminAppColors.primaryColor,
                                checkmarkColor: Colors.white,
                                backgroundColor: isDark
                                    ? AdminAppColors.darkInputBackground
                                    : Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  side: BorderSide(
                                    color: isSelected
                                        ? AdminAppColors.primaryColor
                                        : (isDark
                                              ? AdminAppColors.darkBorder
                                              : Colors.transparent),
                                  ),
                                ),
                                onSelected: (_) =>
                                    bloc.add(ToggleSizeGroupInForm(name)),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Action Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDark
                              ? AdminAppColors.darkTextSecondary
                              : const Color(0xFF8A8A9E),
                        ),
                      ),
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
                        bloc.add(const ValidateCategoryForm());
                        final currentName = _nameController.text.trim();
                        if (currentName.isNotEmpty) {
                          widget.onConfirm(
                            context,
                            currentName,
                            state.formProductCategories,
                            state.formSelectedSizeGroups.toList(),
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
  }
}
