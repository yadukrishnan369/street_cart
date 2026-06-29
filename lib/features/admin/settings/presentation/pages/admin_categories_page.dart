import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/empty_category_section.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_event.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_state.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/category_item_widget.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/category_tab_selector.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/category_header_section.dart';
import 'package:street_cart/features/admin/settings/presentation/widgets/category_dialogs.dart';

class AdminCategoriesPage extends StatefulWidget {
  const AdminCategoriesPage({super.key});

  @override
  State<AdminCategoriesPage> createState() => _AdminCategoriesPageState();
}

class _AdminCategoriesPageState extends State<AdminCategoriesPage> {
  bool _isProductTab = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminSettingsBloc>()..add(LoadAdminSettings()),
      child: Scaffold(
        backgroundColor: AdminAppColors.backgroundLight,
        body: BlocListener<AdminSettingsBloc, AdminSettingsState>(
          listener: (context, state) {
            if (state is AdminSettingsActionSuccess) {
              CustomSnackBar.show(context, message: state.message);
            } else if (state is AdminSettingsActionFailure) {
              CustomSnackBar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
          child: BlocBuilder<AdminSettingsBloc, AdminSettingsState>(
            builder: (context, state) {
              if (state is AdminSettingsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AdminAppColors.primaryColor,
                  ),
                );
              }

              if (state is AdminSettingsLoadFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load settings: ${state.message}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AdminAppColors.errorColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AdminSettingsBloc>().add(
                            LoadAdminSettings(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminAppColors.primaryColor,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final currentSettings = (state is AdminSettingsLoadSuccess)
                  ? state.settings
                  : (state is AdminSettingsActionSuccess)
                  ? state.settings
                  : (state is AdminSettingsActionFailure)
                  ? state.settings
                  : const AdminSettingsModel(
                      commissionPercentage: 2.0,
                      enableCod: true,
                      enableOnline: true,
                     );

              final categoriesList = _isProductTab
                  ? currentSettings.productCategories
                  : currentSettings.businessCategories;

              return Column(
                children: [
                  // Main Content Scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 150.w,
                          left: 80,
                          top: 32.h,
                          bottom: 32.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Back Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => context.pop(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        size: 16.sp,
                                        color: AdminAppColors.primaryColor,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Go Back',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AdminAppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // category count
                                _activeCategoryCount(categoriesList),
                              ],
                            ),

                            SizedBox(height: 24.h),

                            // Tab selectors
                            CategoryTabSelector(
                              isProductTab: _isProductTab,
                              onTabChanged: (val) =>
                                  setState(() => _isProductTab = val),
                            ),
                            SizedBox(height: 32.h),

                            // Catalog Title & Add button
                            CategoryHeaderSection(
                              isProductTab: _isProductTab,
                              onAddPressed: () => CategoryDialogs.showAdd(
                                context: context,
                                settings: currentSettings,
                                isProductTab: _isProductTab,
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // List of categories
                            if (categoriesList.isEmpty)
                              EmptyCategory()
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: categoriesList.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 12.h),
                                itemBuilder: (context, index) {
                                  final category = categoriesList[index];
                                  return CategoryItemWidget(
                                    category: category,
                                    onToggleVisibility: (val) {
                                      CategoryDialogs.showToggleVisibility(
                                        context: context,
                                        settings: currentSettings,
                                        category: category,
                                        newVisibility: val,
                                      );
                                    },
                                    onEdit: () => CategoryDialogs.showEdit(
                                      context: context,
                                      settings: currentSettings,
                                      category: category,
                                    ),
                                    onDelete: () => CategoryDialogs.showDelete(
                                      context: context,
                                      settings: currentSettings,
                                      category: category,
                                    ),
                                  );
                                },
                              ),

                            SizedBox(height: 24.h),
                            // category count
                            _activeCategoryCount(categoriesList),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Text _activeCategoryCount(List<CategoryModel> categoriesList) {
    return Text(
      'Showing ${categoriesList.where((e) => e.isVisible).length} active categories',
      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF8A8A9E)),
    );
  }
}
